import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:inspecao_campo/core/network/osrm_service.dart';
import 'package:inspecao_campo/features/auth/domain/entities/user.dart';
import 'package:inspecao_campo/features/auth/domain/repositories/auth_repository.dart';
import 'package:inspecao_campo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:inspecao_campo/features/auth/presentation/bloc/auth_event.dart';
import 'package:inspecao_campo/features/auth/presentation/bloc/auth_state.dart';
import 'package:inspecao_campo/features/map/presentation/pages/map_page.dart';
import 'package:inspecao_campo/features/work_orders/domain/entities/work_order.dart';
import 'package:inspecao_campo/features/work_orders/domain/repositories/work_orders_repository.dart';
import 'package:inspecao_campo/features/work_orders/domain/usecases/get_work_orders.dart';
import 'package:inspecao_campo/features/work_orders/presentation/bloc/work_orders_bloc.dart';
import 'package:inspecao_campo/features/work_orders/presentation/bloc/work_orders_event.dart';
import 'package:inspecao_campo/features/work_orders/presentation/bloc/work_orders_state.dart';

const _geolocatorChannel = MethodChannel('flutter.baseflow.com/geolocator');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('shows the map fallback and GPS feedback when service is off', (
    tester,
  ) async {
    final harness = await _mountMap(
      tester,
      FakeGeolocatorChannel(serviceEnabled: false),
    );

    expect(find.byType(FlutterMap), findsOneWidget);
    expect(
      tester.widget<FlutterMap>(find.byType(FlutterMap)).options.initialCenter,
      MapPage.joaoPessoaCenter,
    );
    expect(
      find.text('Ative o serviço de localização para usar o GPS.'),
      findsOneWidget,
    );

    await harness.dispose(tester);
  });

  testWidgets('uses the granted GPS permission and displays the location', (
    tester,
  ) async {
    final geolocator = FakeGeolocatorChannel(permission: 2);
    final harness = await _mountMap(tester, geolocator);

    expect(geolocator.currentPositionRequests, 1);
    expect(find.byIcon(Icons.my_location_rounded), findsNWidgets(2));

    await harness.dispose(tester);
  });

  testWidgets('shows feedback when GPS permission is denied', (tester) async {
    final geolocator = FakeGeolocatorChannel(
      permission: 0,
      requestedPermission: 0,
    );
    final harness = await _mountMap(tester, geolocator);

    expect(geolocator.permissionRequests, 1);
    expect(geolocator.currentPositionRequests, 0);
    expect(find.text('Permissão de localização negada.'), findsOneWidget);

    await harness.dispose(tester);
  });

  testWidgets('opens app settings after permanently denied GPS permission', (
    tester,
  ) async {
    final geolocator = FakeGeolocatorChannel(permission: 1);
    final harness = await _mountMap(tester, geolocator);

    expect(find.text('Abrir Configurações'), findsOneWidget);
    await tester.tap(find.text('Abrir Configurações'));
    await tester.pump(const Duration(milliseconds: 500));

    expect(geolocator.openSettingsRequests, 1);

    await harness.dispose(tester);
  });

  testWidgets('only admins can open the create-work-order dialog', (
    tester,
  ) async {
    final adminHarness = await _mountMap(
      tester,
      FakeGeolocatorChannel(permission: 2),
      role: 'admin',
    );
    final adminMap = tester.widget<FlutterMap>(find.byType(FlutterMap));
    expect(adminMap.options.onTap, isNotNull);

    await tester.tapAt(tester.getCenter(find.byType(FlutterMap)));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Nova ordem de serviço'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(1), 'Nova OS no mapa');
    await tester.tap(find.text('Salvar'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(adminHarness.repository.savedOrders, hasLength(1));
    expect(adminHarness.repository.savedOrders.single.title, 'Nova OS no mapa');

    await adminHarness.dispose(tester);

    final technicianHarness = await _mountMap(
      tester,
      FakeGeolocatorChannel(permission: 2),
      role: 'field_technician',
    );
    final technicianMap = tester.widget<FlutterMap>(find.byType(FlutterMap));
    expect(technicianMap.options.onTap, isNull);

    await tester.tapAt(tester.getCenter(find.byType(FlutterMap)));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Nova ordem de serviço'), findsNothing);

    await technicianHarness.dispose(tester);
  });

  testWidgets(
    'selects a work order, shows nearest and draws a straight route',
    (tester) async {
      final order = _workOrder(
        id: 'wo-1',
        code: 'OS-001',
        title: 'Inspecionar poste',
        latitude: -7.11,
        longitude: -34.84,
      );
      final harness = await _mountMap(
        tester,
        FakeGeolocatorChannel(permission: 2),
        workOrders: [order],
      );

      expect(find.text('Mais próxima: OS-001'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.location_on_rounded));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Copiar coordenadas'), findsOneWidget);

      await tester.ensureVisible(find.text('Traçar Rota'));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.text('Traçar Rota'));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(PolylineLayer), findsOneWidget);
      expect(find.textContaining('Rota direta:'), findsOneWidget);
      expect(find.text('Mais próxima: OS-001'), findsOneWidget);
      final routeLayer = tester.widget<PolylineLayer>(
        find.byType(PolylineLayer),
      );
      expect(routeLayer.polylines.single.points, hasLength(2));

      await harness.dispose(tester);
    },
  );

  testWidgets('draws the detailed street route returned by OSRM', (
    tester,
  ) async {
    final order = _workOrder(
      id: 'wo-1',
      code: 'OS-001',
      title: 'Inspecionar poste',
      latitude: -7.11,
      longitude: -34.84,
    );
    final harness = await _mountMap(
      tester,
      FakeGeolocatorChannel(permission: 2),
      workOrders: [order],
      osrmClient: _FakeHttpClient(
        http.Response(
          jsonEncode({
            'code': 'Ok',
            'routes': [
              {
                'distance': 3200,
                'duration': 600,
                'geometry': {
                  'coordinates': [
                    [-34.845, -7.1195],
                    [-34.843, -7.115],
                    [-34.84, -7.11],
                  ],
                },
              },
            ],
          }),
          200,
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.location_on_rounded));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.ensureVisible(find.text('Traçar Rota'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.text('Traçar Rota'));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.textContaining('Rota viária: 3.2 km • 10 min'), findsOneWidget);
    final routeLayer = tester.widget<PolylineLayer>(find.byType(PolylineLayer));
    expect(routeLayer.polylines.single.points, hasLength(3));

    await harness.dispose(tester);
  });
}

Future<_MapHarness> _mountMap(
  WidgetTester tester,
  FakeGeolocatorChannel geolocator, {
  String role = 'field_technician',
  List<WorkOrder> workOrders = const [],
  http.Client? osrmClient,
}) async {
  tester.view.physicalSize = const Size(800, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(_geolocatorChannel, geolocator.handle);

  final repository = FakeWorkOrdersRepository(workOrders);
  final osrmService = OsrmService(
    client: osrmClient ?? _FakeHttpClient(null, error: true),
  );
  final workOrdersBloc = WorkOrdersBloc(GetWorkOrdersUseCase(repository));
  final workOrdersLoaded = workOrdersBloc.stream.firstWhere(
    (state) => state is WorkOrdersLoadedState,
  );
  workOrdersBloc.add(FetchWorkOrdersEvent());
  final authBloc = AuthBloc(repository: FakeAuthRepository(role));
  final authSucceeded = authBloc.stream.firstWhere(
    (state) => state is AuthSuccessState,
  );
  authBloc.add(
    const LoginSubmittedEvent(email: 'user@example.com', password: 'test'),
  );
  await Future.wait([workOrdersLoaded, authSucceeded]);

  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: authBloc),
        BlocProvider<WorkOrdersBloc>.value(value: workOrdersBloc),
      ],
      child: MaterialApp(home: MapPage(osrmService: osrmService)),
    ),
  );
  await tester.pump(const Duration(milliseconds: 500));

  return _MapHarness(authBloc, workOrdersBloc, repository, osrmService);
}

class _MapHarness {
  const _MapHarness(
    this.authBloc,
    this.workOrdersBloc,
    this.repository,
    this.osrmService,
  );

  final AuthBloc authBloc;
  final WorkOrdersBloc workOrdersBloc;
  final FakeWorkOrdersRepository repository;
  final OsrmService osrmService;

  Future<void> dispose(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.runAsync(() async {
      await authBloc.close();
      await workOrdersBloc.close();
      osrmService.close();
    });
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_geolocatorChannel, null);
  }
}

class _FakeHttpClient extends http.BaseClient {
  _FakeHttpClient(this.response, {this.error = false});

  final http.Response? response;
  final bool error;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (error) {
      throw http.ClientException('OSRM unavailable');
    }
    final value = response!;
    return http.StreamedResponse(
      Stream.value(utf8.encode(value.body)),
      value.statusCode,
      headers: value.headers,
    );
  }
}

class FakeGeolocatorChannel {
  FakeGeolocatorChannel({
    this.serviceEnabled = true,
    this.permission = 2,
    this.requestedPermission = 2,
  });

  final bool serviceEnabled;
  final int permission;
  final int requestedPermission;
  int permissionRequests = 0;
  int currentPositionRequests = 0;
  int openSettingsRequests = 0;

  Future<Object?> handle(MethodCall call) async {
    switch (call.method) {
      case 'isLocationServiceEnabled':
        return serviceEnabled;
      case 'checkPermission':
        return permission;
      case 'requestPermission':
        permissionRequests++;
        return requestedPermission;
      case 'getCurrentPosition':
        currentPositionRequests++;
        return Position(
          longitude: -34.845,
          latitude: -7.1195,
          timestamp: DateTime(2026),
          accuracy: 5,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        ).toJson();
      case 'openAppSettings':
        openSettingsRequests++;
        return true;
      default:
        throw PlatformException(
          code: 'unimplemented',
          message: 'Unexpected Geolocator method: ${call.method}',
        );
    }
  }
}

class FakeWorkOrdersRepository implements WorkOrdersRepository {
  FakeWorkOrdersRepository(List<WorkOrder> orders) : orders = [...orders];

  final List<WorkOrder> orders;
  final List<WorkOrder> savedOrders = [];

  @override
  Future<List<WorkOrder>> getWorkOrders() async => orders;

  @override
  Future<void> syncRemoteOrders() async {}

  @override
  Future<void> saveLocalWorkOrder(WorkOrder workOrder) async {
    savedOrders.add(workOrder);
    orders.add(workOrder);
  }

  @override
  Stream<List<WorkOrder>> watchWorkOrders({
    String status = 'all',
    String query = '',
  }) {
    return Stream.value(
      orders.where((order) {
        final matchesStatus = status == 'all' || order.status == status;
        final normalizedQuery = query.toLowerCase();
        final matchesQuery =
            normalizedQuery.isEmpty ||
            order.code.toLowerCase().contains(normalizedQuery) ||
            order.title.toLowerCase().contains(normalizedQuery);
        return matchesStatus && matchesQuery;
      }).toList(),
    );
  }
}

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository(this.role);

  final String role;

  @override
  Future<AuthSession> login(String email, String password) async {
    return AuthSession(
      accessToken: 'test-token',
      user: User(id: 'user-1', name: 'Test User', email: email, role: role),
    );
  }

  @override
  Future<AuthSession?> restoreSession() async => null;

  @override
  Future<void> logout() async {}
}

WorkOrder _workOrder({
  required String id,
  required String code,
  required String title,
  required double latitude,
  required double longitude,
}) {
  final now = DateTime(2026);
  return WorkOrder(
    id: id,
    code: code,
    title: title,
    description: '',
    address: 'João Pessoa',
    priority: 'high',
    status: 'open',
    latitude: latitude,
    longitude: longitude,
    scheduledAt: now,
    updatedAt: now,
  );
}

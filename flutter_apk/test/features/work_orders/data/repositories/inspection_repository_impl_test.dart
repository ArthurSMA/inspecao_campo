import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inpecao_campo/features/work_orders/data/database/work_orders_database.dart';
import 'package:inpecao_campo/features/work_orders/data/datasources/inspection_remote_data_source.dart';
import 'package:inpecao_campo/features/work_orders/data/models/inspection_model.dart';
import 'package:inpecao_campo/features/work_orders/data/repositories/inspection_repository_impl.dart';
import 'package:inpecao_campo/features/work_orders/data/services/network_connectivity_service.dart';
import 'package:inpecao_campo/features/work_orders/domain/entities/inspection.dart';

void main() {
  late AppDatabase database;
  late _FakeInspectionRemoteDataSource remoteDataSource;
  late _FakeConnectivityService connectivityService;
  late InspectionRepositoryImpl repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    remoteDataSource = _FakeInspectionRemoteDataSource();
    connectivityService = _FakeConnectivityService();
    repository = InspectionRepositoryImpl(
      remoteDataSource: remoteDataSource,
      database: database,
      connectivityService: connectivityService,
    );
  });

  tearDown(() async {
    await database.close();
    await connectivityService.controller.close();
  });

  test(
    'atomically queues and marks a successfully uploaded inspection',
    () async {
      connectivityService.connected = true;
      await repository.savePending(_inspection('client-1'));

      await repository.syncPendingInspections();

      final saved = await database.getInspectionByClientId('client-1');
      expect(saved?.status, Inspection.statusSynced);
      expect(saved?.serverId, 'server-client-1');
      expect(await database.getQueuedInspections(), isEmpty);
      expect(remoteDataSource.submittedClientIds, ['client-1']);
    },
  );

  test('does not queue or upload draft inspections', () async {
    connectivityService.connected = true;
    await repository.saveDraft(_inspection('client-draft'));

    await repository.syncPendingInspections();

    final saved = await database.getInspectionByClientId('client-draft');
    expect(saved?.status, Inspection.statusDraft);
    expect(await database.getQueuedInspections(), isEmpty);
    expect(remoteDataSource.submittedClientIds, isEmpty);
  });

  test(
    'keeps failed inspection queued with its error for a later retry',
    () async {
      connectivityService.connected = true;
      final requestOptions = RequestOptions(path: '/inspections');
      remoteDataSource.error = DioException(
        requestOptions: requestOptions,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 503,
          data: {'message': 'Service unavailable'},
        ),
      );
      await repository.savePending(_inspection('client-failed'));

      await repository.syncPendingInspections();

      final saved = await database.getInspectionByClientId('client-failed');
      expect(saved?.status, Inspection.statusFailed);
      expect(saved?.errorMessage, 'Service unavailable (HTTP 503)');
      expect(
        (await database.getQueuedInspections()).single.clientId,
        'client-failed',
      );

      remoteDataSource.error = null;
      await repository.retryInspection('client-failed');

      final retried = await database.getInspectionByClientId('client-failed');
      expect(retried?.status, Inspection.statusSynced);
      expect(remoteDataSource.submittedClientIds, [
        'client-failed',
        'client-failed',
      ]);
      expect(await database.getQueuedInspections(), isEmpty);
    },
  );

  test(
    'does not upload offline and sends the accumulated queue when online',
    () async {
      await repository.savePending(_inspection('client-a'));
      await repository.savePending(_inspection('client-b'));

      await repository.syncPendingInspections();
      expect(remoteDataSource.submittedClientIds, isEmpty);
      expect((await database.getQueuedInspections()).length, 2);

      connectivityService.connected = true;
      await repository.syncPendingInspections();

      expect(remoteDataSource.submittedClientIds, ['client-a', 'client-b']);
      expect(await database.getQueuedInspections(), isEmpty);
    },
  );
}

Inspection _inspection(String clientId) {
  return Inspection(
    id: clientId,
    clientId: clientId,
    workOrderId: 'wo-1',
    observation: 'Inspection detail',
    latitude: -7.1,
    longitude: -34.8,
    capturedAt: DateTime.utc(2026),
    createdAt: DateTime.utc(2026),
    photoPath: '/tmp/$clientId.jpg',
    status: Inspection.statusPending,
  );
}

class _FakeInspectionRemoteDataSource implements InspectionRemoteDataSource {
  final List<String> submittedClientIds = [];
  Object? error;

  @override
  Future<List<InspectionModel>> fetchInspections() async => [];

  @override
  Future<InspectionModel> submitInspection(InspectionModel inspection) async {
    submittedClientIds.add(inspection.clientId);
    if (error case final Object submitError) {
      throw submitError;
    }

    return InspectionModel(
      id: 'server-${inspection.clientId}',
      clientId: inspection.clientId,
      workOrderId: inspection.workOrderId,
      observation: inspection.observation,
      condition: inspection.condition,
      latitude: inspection.latitude,
      longitude: inspection.longitude,
      capturedAt: inspection.capturedAt,
      createdAt: inspection.createdAt,
      photoPath: inspection.photoPath,
      photoUrl: '/uploads/${inspection.clientId}.jpg',
      syncedAt: DateTime.now(),
      status: Inspection.statusSynced,
      serverId: 'server-${inspection.clientId}',
    );
  }
}

class _FakeConnectivityService implements NetworkConnectivityService {
  final StreamController<List<ConnectivityResult>> controller =
      StreamController<List<ConnectivityResult>>.broadcast();
  bool connected = false;

  @override
  Stream<List<ConnectivityResult>> get changes => controller.stream;

  @override
  Future<bool> get isConnected async => connected;
}

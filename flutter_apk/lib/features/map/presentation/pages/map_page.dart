import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'package:inspecao_campo/core/network/osrm_service.dart';
import 'package:inspecao_campo/core/presentation/widgets/app_header.dart';
import 'package:inspecao_campo/core/presentation/widgets/bottom_nav_bar.dart';
import 'package:inspecao_campo/core/utils/colors.dart';
import 'package:inspecao_campo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:inspecao_campo/features/auth/presentation/bloc/auth_event.dart';
import 'package:inspecao_campo/features/auth/presentation/bloc/auth_state.dart';
import 'package:inspecao_campo/features/work_orders/domain/entities/work_order.dart';
import 'package:inspecao_campo/features/work_orders/presentation/bloc/work_orders_bloc.dart';
import 'package:inspecao_campo/features/work_orders/presentation/bloc/work_orders_event.dart';
import 'package:inspecao_campo/features/work_orders/presentation/bloc/work_orders_state.dart';
import 'package:inspecao_campo/features/work_orders/presentation/pages/work_orders_page.dart';

import '../../../../core/utils/map_work_order_utils.dart';
import '../widgets/map_priority_filter.dart';
import '../widgets/map_work_order_details_sheet.dart';
import '../widgets/map_work_order_dialog.dart';
import '../widgets/work_orders_map_view.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key, this.osrmService});

  static const LatLng joaoPessoaCenter = LatLng(-7.1195, -34.8450);

  final OsrmService? osrmService;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  late final OsrmService _osrmService;
  late final bool _ownsOsrmService;

  LatLng? _userLocation;
  List<LatLng> _routePoints = const [];
  String _priorityFilter = 'all';
  String? _routeDistance;
  String? _routeDuration;
  bool _isRoadRoute = false;
  bool _isLoadingLocation = true;
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();
    _ownsOsrmService = widget.osrmService == null;
    _osrmService = widget.osrmService ?? OsrmService();
    unawaited(_loadCurrentLocation(showFeedback: true));
  }

  Future<void> _loadCurrentLocation({bool showFeedback = false}) async {
    if (!mounted) {
      return;
    }
    setState(() => _isLoadingLocation = true);

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!mounted) {
        return;
      }
      if (!serviceEnabled) {
        if (showFeedback) {
          _showMessage('Ative o serviço de localização para usar o GPS.');
        }
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (!mounted) {
        return;
      }
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (!mounted) {
        return;
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (showFeedback) {
          if (permission == LocationPermission.deniedForever) {
            _showLocationSettingsMessage();
          } else {
            _showMessage('Permissão de localização negada.');
          }
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      if (!mounted) {
        return;
      }

      final location = LatLng(position.latitude, position.longitude);
      setState(() => _userLocation = location);
      if (_mapReady) {
        _mapController.move(location, 14);
      }
    } on TimeoutException {
      if (mounted && showFeedback) {
        _showMessage('O GPS demorou demais para responder. Tente novamente.');
      }
    } on PermissionDeniedException {
      if (mounted && showFeedback) {
        _showMessage('Permissão de localização negada.');
      }
    } catch (_) {
      if (mounted && showFeedback) {
        _showMessage('Não foi possível obter a localização atual.');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingLocation = false);
      }
    }
  }

  void _showLocationSettingsMessage() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Permissão de localização necessária'),
        content: const Text(
          'A permissão foi negada permanentemente. Ative-a nas configurações '
          'do aplicativo para usar o GPS.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Agora não'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              unawaited(_openAppSettings());
            },
            child: const Text('Abrir Configurações'),
          ),
        ],
      ),
    );
  }

  Future<void> _openAppSettings() async {
    try {
      final opened = await Geolocator.openAppSettings();
      if (mounted && !opened) {
        _showMessage('Não foi possível abrir as configurações do aplicativo.');
      }
    } catch (_) {
      if (mounted) {
        _showMessage('Não foi possível abrir as configurações do aplicativo.');
      }
    }
  }

  void _onMapReady() {
    _mapReady = true;
    final location = _userLocation;
    if (location != null) {
      _mapController.move(location, 14);
    }
  }

  List<WorkOrder> _filterOrders(List<WorkOrder> orders) {
    final query = _searchController.text.trim().toLowerCase().replaceFirst(
      RegExp(r'^#'),
      '',
    );
    return orders
        .where((order) {
          final matchesPriority =
              _priorityFilter == 'all' ||
              order.priority.toLowerCase() == _priorityFilter;
          final matchesSearch =
              query.isEmpty ||
              order.code.toLowerCase().contains(query) ||
              order.title.toLowerCase().contains(query);
          return matchesPriority && matchesSearch;
        })
        .toList(growable: false);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _showWorkOrderDetails(WorkOrder order) {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) => MapWorkOrderDetailsSheet(
        workOrder: order,
        onCopyCoordinates: () => _copyCoordinates(sheetContext, order),
        onRouteRequested: () {
          Navigator.pop(sheetContext);
          unawaited(_drawRoute(order));
        },
      ),
    );
  }

  Future<void> _copyCoordinates(
    BuildContext sheetContext,
    WorkOrder order,
  ) async {
    await Clipboard.setData(
      ClipboardData(text: '${order.latitude}, ${order.longitude}'),
    );
    if (!mounted || !sheetContext.mounted) {
      return;
    }
    Navigator.pop(sheetContext);
    _showMessage('Coordenadas copiadas.');
  }

  Future<void> _drawRoute(WorkOrder order) async {
    var origin = _userLocation;
    if (origin == null) {
      await _loadCurrentLocation(showFeedback: true);
      if (!mounted) {
        return;
      }
      origin = _userLocation;
    }
    if (origin == null) {
      return;
    }

    final destination = LatLng(order.latitude, order.longitude);
    final route = await _osrmService.getRoute(
      origin: origin,
      destination: destination,
    );
    if (!mounted) {
      return;
    }

    if (route != null) {
      setState(() {
        _routePoints = route.points;
        _routeDistance =
            '${(route.distanceMeters / 1000).toStringAsFixed(1)} km';
        _routeDuration = _formatDuration(route.durationSeconds);
        _isRoadRoute = true;
      });
      _fitRouteCamera();
      return;
    }

    final distanceMeters = MapWorkOrderUtils.distanceInMeters(
      origin,
      destination,
    );
    final estimatedMinutes = (distanceMeters / 1000 / 30 * 60).ceil();

    setState(() {
      _routePoints = [origin!, destination];
      _routeDistance = '${(distanceMeters / 1000).toStringAsFixed(1)} km';
      _routeDuration = '$estimatedMinutes min';
      _isRoadRoute = false;
    });
    _fitRouteCamera();
  }

  String _formatDuration(double durationSeconds) {
    final duration = Duration(seconds: durationSeconds.round());
    if (duration.inHours > 0) {
      return '${duration.inHours} h ${duration.inMinutes.remainder(60)} min';
    }
    return '${duration.inMinutes} min';
  }

  void _fitRouteCamera() {
    if (_mapReady) {
      _mapController.fitCamera(
        CameraFit.coordinates(
          coordinates: _routePoints,
          padding: const EdgeInsets.fromLTRB(56, 100, 56, 110),
        ),
      );
    }
  }

  Future<void> _createWorkOrder(LatLng location) async {
    final details = await MapWorkOrderDialog.show(context, location);
    if (details == null || !mounted) {
      return;
    }

    final now = DateTime.now();
    final order = WorkOrder(
      id: 'local-${now.microsecondsSinceEpoch}',
      code: 'OS-${now.millisecondsSinceEpoch}',
      title: details.title,
      description: details.notes ?? '',
      address: 'Localização selecionada no mapa',
      priority: details.priority,
      status: 'open',
      latitude: location.latitude,
      longitude: location.longitude,
      scheduledAt: now,
      updatedAt: now,
      notes: details.notes,
    );

    context.read<WorkOrdersBloc>().add(SaveLocalWorkOrderEvent(order));
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).popUntil((route) => route.isFirst);
      case 2:
        Navigator.of(
          context,
        ).push(MaterialPageRoute<void>(builder: (_) => const WorkOrdersPage()));
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    _searchController.dispose();
    if (_ownsOsrmService) {
      _osrmService.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthSuccessState ? authState.user : null;
    final isAdmin = user?.role == 'admin';

    return BlocListener<WorkOrdersBloc, WorkOrdersState>(
      listenWhen: (_, current) => current is WorkOrdersErrorState,
      listener: (context, state) {
        if (state is WorkOrdersErrorState) {
          _showMessage(state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.bgLight,
        body: SafeArea(
          child: Column(
            children: [
              AppHeader(
                title: 'Mapa de Serviços',
                userName: user?.name ?? 'Usuário',
                userRole: user?.role ?? 'Técnico de campo',
                onLogout: () => context.read<AuthBloc>().add(LogoutEvent()),
                onSync: () => context.read<WorkOrdersBloc>().add(
                  RefreshWorkOrdersEvent(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Buscar por código ou título',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchController.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.close_rounded),
                          ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                  ),
                ),
              ),
              MapPriorityFilter(
                selectedPriority: _priorityFilter,
                onPrioritySelected: (priority) {
                  setState(() => _priorityFilter = priority);
                },
              ),
              if (isAdmin)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'Toque no mapa para cadastrar uma OS',
                    style: TextStyle(color: AppColors.muted, fontSize: 12),
                  ),
                ),
              Expanded(
                child: BlocBuilder<WorkOrdersBloc, WorkOrdersState>(
                  buildWhen: (previous, current) => previous != current,
                  builder: (context, state) {
                    final orders = state is WorkOrdersLoadedState
                        ? _filterOrders(state.orders)
                        : const <WorkOrder>[];
                    final location = _userLocation;
                    final nearest = location == null
                        ? null
                        : MapWorkOrderUtils.nearest(
                            workOrders: orders,
                            origin: location,
                          );

                    return WorkOrdersMapView(
                      mapController: _mapController,
                      initialCenter: MapPage.joaoPessoaCenter,
                      orders: orders,
                      nearestOrder: nearest,
                      userLocation: location,
                      routePoints: _routePoints,
                      routeDistance: _routeDistance,
                      routeDuration: _routeDuration,
                      isRoadRoute: _isRoadRoute,
                      isLoadingLocation: _isLoadingLocation,
                      isLoadingOrders: state is WorkOrdersLoadingState,
                      isAdmin: isAdmin,
                      onMapReady: _onMapReady,
                      onOrderSelected: _showWorkOrderDetails,
                      onCreateWorkOrder: _createWorkOrder,
                      onRouteRequested: _drawRoute,
                      onLocationRequested: () {
                        _loadCurrentLocation(showFeedback: true);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavBar(
          selectedIndex: 1,
          onDestinationSelected: _handleNavigation,
        ),
      ),
    );
  }
}

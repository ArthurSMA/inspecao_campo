import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'package:inpecao_campo/core/presentation/widgets/app_header.dart';
import 'package:inpecao_campo/core/presentation/widgets/bottom_nav_bar.dart';
import 'package:inpecao_campo/core/utils/colors.dart';
import 'package:inpecao_campo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:inpecao_campo/features/auth/presentation/bloc/auth_event.dart';
import 'package:inpecao_campo/features/auth/presentation/bloc/auth_state.dart';
import 'package:inpecao_campo/features/work_orders/domain/entities/work_order.dart';
import 'package:inpecao_campo/features/work_orders/presentation/bloc/work_orders_bloc.dart';
import 'package:inpecao_campo/features/work_orders/presentation/bloc/work_orders_event.dart';
import 'package:inpecao_campo/features/work_orders/presentation/bloc/work_orders_state.dart';
import 'package:inpecao_campo/features/work_orders/presentation/pages/work_orders_page.dart';

import '../../utils/map_work_order_utils.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  static const LatLng joaoPessoaCenter = LatLng(-7.1195, -34.8450);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  LatLng? _userLocation;
  List<LatLng> _routePoints = const [];
  String _priorityFilter = 'all';
  String? _routeDistance;
  String? _routeDuration;
  bool _isLoadingLocation = true;
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();
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

  Color _priorityColor(String priority) {
    return switch (priority.toLowerCase()) {
      'high' => AppColors.danger,
      'medium' => AppColors.warning,
      _ => AppColors.success,
    };
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _selectOrder(WorkOrder order) {
    _showWorkOrderDetails(order);
  }

  void _showWorkOrderDetails(WorkOrder order) {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.code,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                order.title,
                style: const TextStyle(
                  color: AppColors.darkText,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                order.address,
                style: const TextStyle(color: AppColors.bodyText, fontSize: 13),
              ),
              const SizedBox(height: 12),
              Text(
                'Lat ${order.latitude.toStringAsFixed(6)} • '
                'Long ${order.longitude.toStringAsFixed(6)}',
                style: const TextStyle(color: AppColors.muted, fontSize: 12),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => _copyCoordinates(sheetContext, order),
                  icon: const Icon(Icons.copy_rounded),
                  label: const Text('Copiar coordenadas'),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    unawaited(_drawRoute(order));
                  },
                  icon: const Icon(Icons.alt_route_rounded),
                  label: const Text('Traçar Rota'),
                ),
              ),
            ],
          ),
        ),
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
    final distanceMeters = MapWorkOrderUtils.distanceInMeters(
      origin,
      destination,
    );
    final estimatedMinutes = (distanceMeters / 1000 / 30 * 60).ceil();

    setState(() {
      _routePoints = [origin!, destination];
      _routeDistance = '${(distanceMeters / 1000).toStringAsFixed(1)} km';
      _routeDuration = '$estimatedMinutes min';
    });
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
    final titleController = TextEditingController();
    final notesController = TextEditingController();
    var priority = 'medium';

    final details =
        await showDialog<({String title, String? notes, String priority})>(
          context: context,
          builder: (dialogContext) => StatefulBuilder(
            builder: (context, setDialogState) => AlertDialog(
              title: const Text('Nova ordem de serviço'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      autofocus: true,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(labelText: 'Título'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: priority,
                      decoration: const InputDecoration(
                        labelText: 'Prioridade',
                      ),
                      items: const [
                        DropdownMenuItem(value: 'high', child: Text('Alta')),
                        DropdownMenuItem(value: 'medium', child: Text('Média')),
                        DropdownMenuItem(value: 'low', child: Text('Baixa')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() => priority = value);
                        }
                      },
                    ),
                    TextField(
                      controller: notesController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Observações (opcional)',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${location.latitude.toStringAsFixed(6)}, '
                      '${location.longitude.toStringAsFixed(6)}',
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    if (title.isEmpty) {
                      return;
                    }
                    Navigator.pop(dialogContext, (
                      title: title,
                      notes: notesController.text.trim().isEmpty
                          ? null
                          : notesController.text.trim(),
                      priority: priority,
                    ));
                  },
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ),
        );

    titleController.dispose();
    notesController.dispose();
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
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _priorityChip('Todas', 'all'),
                    _priorityChip('Alta', 'high'),
                    _priorityChip('Média', 'medium'),
                    _priorityChip('Baixa', 'low'),
                  ],
                ),
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

                    return Stack(
                      children: [
                        FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: MapPage.joaoPessoaCenter,
                            initialZoom: 12,
                            onMapReady: _onMapReady,
                            onTap: isAdmin
                                ? (_, point) => _createWorkOrder(point)
                                : null,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName:
                                  'com.orbytis.inspecao_campo',
                            ),
                            RichAttributionWidget(
                              attributions: const [
                                TextSourceAttribution(
                                  'OpenStreetMap contributors',
                                ),
                              ],
                            ),
                            if (_routePoints.length == 2)
                              PolylineLayer(
                                polylines: [
                                  Polyline(
                                    points: _routePoints,
                                    color: AppColors.primary,
                                    strokeWidth: 4,
                                  ),
                                ],
                              ),
                            MarkerLayer(
                              markers: [
                                for (final order in orders)
                                  Marker(
                                    point: LatLng(
                                      order.latitude,
                                      order.longitude,
                                    ),
                                    width: 44,
                                    height: 44,
                                    child: IconButton(
                                      onPressed: () => _selectOrder(order),
                                      padding: EdgeInsets.zero,
                                      icon: Icon(
                                        Icons.location_on_rounded,
                                        color: _priorityColor(order.priority),
                                        size: 38,
                                      ),
                                    ),
                                  ),
                                if (location != null)
                                  Marker(
                                    point: location,
                                    width: 36,
                                    height: 36,
                                    child: const Icon(
                                      Icons.my_location_rounded,
                                      color: AppColors.primary,
                                      size: 28,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Material(
                            elevation: 4,
                            color: Colors.white,
                            shape: const CircleBorder(),
                            child: IconButton(
                              tooltip: 'Minha localização',
                              onPressed: _isLoadingLocation
                                  ? null
                                  : () => _loadCurrentLocation(
                                      showFeedback: true,
                                    ),
                              icon: _isLoadingLocation
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.my_location_rounded,
                                      color: AppColors.primary,
                                    ),
                            ),
                          ),
                        ),
                        if (nearest != null)
                          Positioned(
                            left: 12,
                            right: 12,
                            bottom: 48,
                            child: Card(
                              child: ListTile(
                                leading: Icon(
                                  Icons.near_me_rounded,
                                  color: _priorityColor(nearest.priority),
                                ),
                                title: Text('Mais próxima: ${nearest.code}'),
                                subtitle: Text(nearest.title),
                                trailing: IconButton(
                                  tooltip: 'Traçar rota',
                                  onPressed: () => _drawRoute(nearest),
                                  icon: const Icon(Icons.alt_route_rounded),
                                ),
                                onTap: () => _selectOrder(nearest),
                              ),
                            ),
                          ),
                        if (_routeDistance != null)
                          Positioned(
                            top: 68,
                            left: 12,
                            right: 64,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  'Rota direta: $_routeDistance • '
                                  '$_routeDuration a 30 km/h',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (state is WorkOrdersLoadingState)
                          const Center(child: CircularProgressIndicator()),
                      ],
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

  Widget _priorityChip(String label, String value) {
    final selected = _priorityFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        selectedColor: AppColors.primary,
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: selected ? Colors.white : AppColors.darkText,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        onSelected: (_) => setState(() => _priorityFilter = value),
      ),
    );
  }
}

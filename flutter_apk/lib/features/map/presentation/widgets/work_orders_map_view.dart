import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:inpecao_campo/core/utils/colors.dart';
import 'package:inpecao_campo/features/work_orders/domain/entities/work_order.dart';

class WorkOrdersMapView extends StatelessWidget {
  const WorkOrdersMapView({
    super.key,
    required this.mapController,
    required this.initialCenter,
    required this.orders,
    required this.nearestOrder,
    required this.userLocation,
    required this.routePoints,
    required this.routeDistance,
    required this.routeDuration,
    required this.isLoadingLocation,
    required this.isLoadingOrders,
    required this.isAdmin,
    required this.onMapReady,
    required this.onOrderSelected,
    required this.onCreateWorkOrder,
    required this.onRouteRequested,
    required this.onLocationRequested,
  });

  final MapController mapController;
  final LatLng initialCenter;
  final List<WorkOrder> orders;
  final WorkOrder? nearestOrder;
  final LatLng? userLocation;
  final List<LatLng> routePoints;
  final String? routeDistance;
  final String? routeDuration;
  final bool isLoadingLocation;
  final bool isLoadingOrders;
  final bool isAdmin;
  final VoidCallback onMapReady;
  final ValueChanged<WorkOrder> onOrderSelected;
  final ValueChanged<LatLng> onCreateWorkOrder;
  final ValueChanged<WorkOrder> onRouteRequested;
  final VoidCallback onLocationRequested;

  Color _priorityColor(String priority) {
    return switch (priority.toLowerCase()) {
      'high' => AppColors.danger,
      'medium' => AppColors.warning,
      _ => AppColors.success,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: initialCenter,
            initialZoom: 12,
            onMapReady: onMapReady,
            onTap: isAdmin ? (_, point) => onCreateWorkOrder(point) : null,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.orbytis.inspecao_campo',
            ),
            const RichAttributionWidget(
              attributions: [
                TextSourceAttribution('OpenStreetMap contributors'),
              ],
            ),
            if (routePoints.length == 2)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: routePoints,
                    color: AppColors.primary,
                    strokeWidth: 4,
                  ),
                ],
              ),
            MarkerLayer(
              markers: [
                for (final order in orders)
                  Marker(
                    point: LatLng(order.latitude, order.longitude),
                    width: 44,
                    height: 44,
                    child: IconButton(
                      onPressed: () => onOrderSelected(order),
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.location_on_rounded,
                        color: _priorityColor(order.priority),
                        size: 38,
                      ),
                    ),
                  ),
                if (userLocation case final location?)
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
              onPressed: isLoadingLocation ? null : onLocationRequested,
              icon: isLoadingLocation
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(
                      Icons.my_location_rounded,
                      color: AppColors.primary,
                    ),
            ),
          ),
        ),
        if (nearestOrder case final order?)
          Positioned(
            left: 12,
            right: 12,
            bottom: 48,
            child: Card(
              child: ListTile(
                leading: Icon(
                  Icons.near_me_rounded,
                  color: _priorityColor(order.priority),
                ),
                title: Text('Mais próxima: ${order.code}'),
                subtitle: Text(order.title),
                trailing: IconButton(
                  tooltip: 'Traçar rota',
                  onPressed: () => onRouteRequested(order),
                  icon: const Icon(Icons.alt_route_rounded),
                ),
                onTap: () => onOrderSelected(order),
              ),
            ),
          ),
        if (routeDistance case final distance?)
          Positioned(
            top: 68,
            left: 12,
            right: 64,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Rota direta: $distance • $routeDuration a 30 km/h',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        if (isLoadingOrders) const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}

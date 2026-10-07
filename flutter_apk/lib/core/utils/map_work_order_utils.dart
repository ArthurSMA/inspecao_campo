import 'package:latlong2/latlong.dart';

import '../../features/work_orders/domain/entities/work_order.dart';

class MapWorkOrderUtils {
  const MapWorkOrderUtils._();

  static const Distance _distance = Distance();

  static WorkOrder? nearest({
    required List<WorkOrder> workOrders,
    required LatLng origin,
  }) {
    if (workOrders.isEmpty) {
      return null;
    }

    WorkOrder? nearestOrder;
    var shortestDistance = double.infinity;
    for (final order in workOrders) {
      final distance = _distance.as(
        LengthUnit.Meter,
        origin,
        LatLng(order.latitude, order.longitude),
      );
      if (distance < shortestDistance) {
        shortestDistance = distance;
        nearestOrder = order;
      }
    }

    return nearestOrder;
  }

  static double distanceInMeters(LatLng first, LatLng second) {
    return _distance.as(LengthUnit.Meter, first, second);
  }
}

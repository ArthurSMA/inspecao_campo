import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:inspecao_campo/core/utils/map_work_order_utils.dart';
import 'package:inspecao_campo/features/work_orders/domain/entities/work_order.dart';

void main() {
  WorkOrder order(String id, double latitude, double longitude) {
    return WorkOrder(
      id: id,
      code: id,
      title: id,
      description: '',
      address: '',
      priority: 'low',
      status: 'open',
      latitude: latitude,
      longitude: longitude,
      scheduledAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );
  }

  test('returns the work order nearest to the current location', () {
    final nearest = MapWorkOrderUtils.nearest(
      workOrders: [order('far', -7.2, -34.9), order('near', -7.12, -34.846)],
      origin: const LatLng(-7.1195, -34.845),
    );

    expect(nearest?.id, 'near');
  });

  test('returns null when there are no work orders', () {
    final nearest = MapWorkOrderUtils.nearest(
      workOrders: const [],
      origin: const LatLng(-7.1195, -34.845),
    );

    expect(nearest, isNull);
  });
}

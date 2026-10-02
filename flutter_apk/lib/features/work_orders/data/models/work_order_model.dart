import 'package:inpecao_campo/core/utils/geo_utils.dart';

import '../../domain/entities/work_order.dart';

class WorkOrderModel extends WorkOrder {
  const WorkOrderModel({
    required super.id,
    required super.code,
    required super.title,
    required super.description,
    required super.address,
    required super.priority,
    required super.status,
    required super.latitude,
    required super.longitude,
    required super.scheduledAt,
    required super.updatedAt,
    super.notes,
  });

  factory WorkOrderModel.fromJson(Map<String, dynamic> json) {
    return WorkOrderModel(
      id: json['id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      address: json['address'] as String? ?? '',
      priority: json['priority'] as String? ?? 'low',
      status: json['status'] as String? ?? 'open',
      latitude: GeoUtils.safeDouble(
        json['latitude'],
        fallback: GeoUtils.defaultLatitude,
      ),
      longitude: GeoUtils.safeDouble(
        json['longitude'],
        fallback: GeoUtils.defaultLongitude,
      ),
      scheduledAt: DateTime.tryParse(json['scheduledAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
      notes: json['notes'] as String?,
    );
  }
}

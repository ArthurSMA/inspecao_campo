import '../../domain/entities/work_order.dart';

class WorkOrderModel extends WorkOrder {
  WorkOrderModel({
    required super.id,
    required super.title,
    required super.description,
    required super.status,
  });

  factory WorkOrderModel.fromJson(Map<String, dynamic> json) {
    return WorkOrderModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'Pendente',
    );
  }
}

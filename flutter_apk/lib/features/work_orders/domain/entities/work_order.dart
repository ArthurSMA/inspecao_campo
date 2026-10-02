import 'package:equatable/equatable.dart';

class WorkOrder extends Equatable {
  final String id;
  final String code;
  final String title;
  final String description;
  final String address;
  final String priority;
  final String status;
  final double latitude;
  final double longitude;
  final DateTime scheduledAt;
  final DateTime updatedAt;
  final String? notes;

  const WorkOrder({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.address,
    required this.priority,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.scheduledAt,
    required this.updatedAt,
    this.notes,
  });

  @override
  List<Object?> get props => [
    id,
    code,
    title,
    description,
    address,
    priority,
    status,
    latitude,
    longitude,
    scheduledAt,
    updatedAt,
    notes,
  ];
}

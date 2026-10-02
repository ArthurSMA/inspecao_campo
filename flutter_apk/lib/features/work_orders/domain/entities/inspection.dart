import 'package:equatable/equatable.dart';

class Inspection extends Equatable {
  const Inspection({
    required this.id,
    required this.clientId,
    required this.workOrderId,
    required this.observation,
    required this.latitude,
    required this.longitude,
    required this.capturedAt,
    required this.createdAt,
    this.condition,
    this.photoPath,
    this.photoUrl,
    this.syncedAt,
    this.status = statusDraft,
    this.errorMessage,
    this.serverId,
  });

  static const String statusDraft = 'draft';
  static const String statusPending = 'pending';
  static const String statusSynced = 'synced';
  static const String statusFailed = 'failed';

  final String id;
  final String clientId;
  final String workOrderId;
  final String observation;
  final String? condition;
  final double latitude;
  final double longitude;
  final DateTime capturedAt;
  final DateTime createdAt;
  final String? photoPath;
  final String? photoUrl;
  final DateTime? syncedAt;
  final String status;
  final String? errorMessage;
  final String? serverId;

  Inspection copyWith({
    String? id,
    String? clientId,
    String? workOrderId,
    String? observation,
    String? condition,
    double? latitude,
    double? longitude,
    DateTime? capturedAt,
    DateTime? createdAt,
    String? photoPath,
    String? photoUrl,
    DateTime? syncedAt,
    String? status,
    String? errorMessage,
    String? serverId,
  }) {
    return Inspection(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      workOrderId: workOrderId ?? this.workOrderId,
      observation: observation ?? this.observation,
      condition: condition ?? this.condition,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      capturedAt: capturedAt ?? this.capturedAt,
      createdAt: createdAt ?? this.createdAt,
      photoPath: photoPath ?? this.photoPath,
      photoUrl: photoUrl ?? this.photoUrl,
      syncedAt: syncedAt ?? this.syncedAt,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      serverId: serverId ?? this.serverId,
    );
  }

  @override
  List<Object?> get props => [
    id,
    clientId,
    workOrderId,
    observation,
    condition,
    latitude,
    longitude,
    capturedAt,
    createdAt,
    photoPath,
    photoUrl,
    syncedAt,
    status,
    errorMessage,
    serverId,
  ];
}

import '../../domain/entities/inspection.dart';

class InspectionModel extends Inspection {
  const InspectionModel({
    required super.id,
    required super.clientId,
    required super.workOrderId,
    required super.observation,
    required super.latitude,
    required super.longitude,
    required super.capturedAt,
    required super.createdAt,
    super.condition,
    super.photoPath,
    super.photoUrl,
    super.syncedAt,
    super.status = Inspection.statusDraft,
    super.errorMessage,
    super.serverId,
  });

  factory InspectionModel.fromJson(Map<String, dynamic> json) {
    final latitude = json['latitude'];
    final longitude = json['longitude'];
    final capturedAt = json['capturedAt'];
    final syncedAt = json['syncedAt'];

    return InspectionModel(
      id: (json['id'] ?? '').toString(),
      clientId: (json['clientId'] ?? '').toString(),
      workOrderId: (json['workOrderId'] ?? '').toString(),
      observation: (json['observation'] ?? '').toString(),
      condition: json['condition']?.toString(),
      latitude: latitude is num ? latitude.toDouble() : 0,
      longitude: longitude is num ? longitude.toDouble() : 0,
      capturedAt: DateTime.tryParse(capturedAt?.toString() ?? '') ?? DateTime.now(),
      createdAt: DateTime.now(),
      photoUrl: json['photoUrl']?.toString(),
      syncedAt: syncedAt == null ? null : DateTime.tryParse(syncedAt.toString()),
      status: Inspection.statusSynced,
      serverId: (json['id'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientId': clientId,
      'workOrderId': workOrderId,
      'observation': observation,
      'condition': condition,
      'latitude': latitude,
      'longitude': longitude,
      'capturedAt': capturedAt.toIso8601String(),
      'photoUrl': photoUrl,
      'syncedAt': syncedAt?.toIso8601String(),
      'status': status,
      'serverId': serverId,
    };
  }
}

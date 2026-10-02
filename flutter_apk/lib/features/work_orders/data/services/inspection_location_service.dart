import 'package:geolocator/geolocator.dart';

import 'package:inpecao_campo/core/utils/geo_utils.dart';

enum InspectionLocationStatus { success, permissionDenied, unavailable }

class InspectionLocationCapture {
  const InspectionLocationCapture({
    required this.latitude,
    required this.longitude,
    required this.capturedAt,
    required this.distanceMeters,
    required this.isNearTarget,
    required this.status,
    required this.message,
  });

  final double latitude;
  final double longitude;
  final DateTime capturedAt;
  final double distanceMeters;
  final bool isNearTarget;
  final InspectionLocationStatus status;
  final String message;

  String get coordinateSummary =>
      GeoUtils.formatCoordinate(latitude, longitude);
}

class InspectionLocationService {
  static Future<InspectionLocationCapture> captureCurrentLocation({
    required double targetLatitude,
    required double targetLongitude,
    double thresholdMeters = GeoUtils.defaultProximityThresholdMeters,
  }) async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return InspectionLocationCapture(
        latitude: targetLatitude,
        longitude: targetLongitude,
        capturedAt: DateTime.now(),
        distanceMeters: GeoUtils.distanceInMeters(
          fromLatitude: GeoUtils.defaultLatitude,
          fromLongitude: GeoUtils.defaultLongitude,
          toLatitude: targetLatitude,
          toLongitude: targetLongitude,
        ),
        isNearTarget: false,
        status: InspectionLocationStatus.permissionDenied,
        message: 'Permissão de localização negada. Ative o GPS para registrar a inspeção.',
      );
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      final distanceMeters = GeoUtils.distanceInMeters(
        fromLatitude: position.latitude,
        fromLongitude: position.longitude,
        toLatitude: targetLatitude,
        toLongitude: targetLongitude,
      );

      final isNearTarget = distanceMeters <= thresholdMeters;
      final message = isNearTarget
          ? 'Localização validada no ponto da OS.'
          : 'Atenção: você está ${GeoUtils.formatDistance(distanceMeters)} do ponto da OS.';

      return InspectionLocationCapture(
        latitude: position.latitude,
        longitude: position.longitude,
        capturedAt: DateTime.now(),
        distanceMeters: distanceMeters,
        isNearTarget: isNearTarget,
        status: InspectionLocationStatus.success,
        message: message,
      );
    } catch (_) {
      return InspectionLocationCapture(
        latitude: GeoUtils.defaultLatitude,
        longitude: GeoUtils.defaultLongitude,
        capturedAt: DateTime.now(),
        distanceMeters: GeoUtils.distanceInMeters(
          fromLatitude: GeoUtils.defaultLatitude,
          fromLongitude: GeoUtils.defaultLongitude,
          toLatitude: targetLatitude,
          toLongitude: targetLongitude,
        ),
        isNearTarget: false,
        status: InspectionLocationStatus.unavailable,
        message: 'Não foi possível capturar a localização. Use o ponto padrão de João Pessoa/PB.',
      );
    }
  }
}

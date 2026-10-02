import 'package:geolocator/geolocator.dart';

class GeoUtils {
  static const double defaultLatitude = -7.1188;
  static const double defaultLongitude = -34.8816;
  static const double defaultProximityThresholdMeters = 200;

  static double safeDouble(
    dynamic value, {
    double fallback = defaultLatitude,
  }) {
    if (value == null) {
      return fallback;
    }

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed != null) {
        return parsed;
      }
    }

    return fallback;
  }

  static String formatCoordinate(double latitude, double longitude) {
    return 'Lat: ${latitude.toStringAsFixed(6)}, Long: ${longitude.toStringAsFixed(6)}';
  }

  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()} m';
    }

    return '${(meters / 1000).toStringAsFixed(2)} km';
  }

  static double distanceInMeters({
    required double fromLatitude,
    required double fromLongitude,
    required double toLatitude,
    required double toLongitude,
  }) {
    return Geolocator.distanceBetween(
      fromLatitude,
      fromLongitude,
      toLatitude,
      toLongitude,
    );
  }

  static bool isNearTarget({
    required double fromLatitude,
    required double fromLongitude,
    required double targetLatitude,
    required double targetLongitude,
    double thresholdMeters = defaultProximityThresholdMeters,
  }) {
    final distance = distanceInMeters(
      fromLatitude: fromLatitude,
      fromLongitude: fromLongitude,
      toLatitude: targetLatitude,
      toLongitude: targetLongitude,
    );

    return distance <= thresholdMeters;
  }
}

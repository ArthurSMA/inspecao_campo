import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class OsrmRoute {
  const OsrmRoute({
    required this.points,
    required this.distanceMeters,
    required this.durationSeconds,
  });

  final List<LatLng> points;
  final double distanceMeters;
  final double durationSeconds;
}

class OsrmService {
  OsrmService({http.Client? client}) : _client = client ?? http.Client();

  static final Uri _baseUri = Uri.https(
    'router.project-osrm.org',
    '/route/v1/driving',
  );
  static const Duration _timeout = Duration(seconds: 10);

  final http.Client _client;

  Future<OsrmRoute?> getRoute({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final uri = _baseUri.replace(
      path:
          '${_baseUri.path}/${origin.longitude},${origin.latitude};'
          '${destination.longitude},${destination.latitude}',
      queryParameters: const {'overview': 'full', 'geometries': 'geojson'},
    );

    try {
      final response = await _client.get(uri).timeout(_timeout);
      if (response.statusCode != 200) {
        return null;
      }

      final payload = jsonDecode(response.body);
      if (payload is! Map<String, dynamic> || payload['code'] != 'Ok') {
        return null;
      }

      final routes = payload['routes'];
      if (routes is! List || routes.isEmpty || routes.first is! Map) {
        return null;
      }

      final route = routes.first as Map;
      final geometry = route['geometry'];
      final coordinates = geometry is Map ? geometry['coordinates'] : null;
      final distance = route['distance'];
      final duration = route['duration'];
      if (coordinates is! List || distance is! num || duration is! num) {
        return null;
      }

      final points = <LatLng>[];
      for (final coordinate in coordinates) {
        if (coordinate is! List ||
            coordinate.length < 2 ||
            coordinate[0] is! num ||
            coordinate[1] is! num) {
          return null;
        }
        points.add(
          LatLng(
            (coordinate[1] as num).toDouble(),
            (coordinate[0] as num).toDouble(),
          ),
        );
      }

      if (points.isEmpty) {
        return null;
      }

      return OsrmRoute(
        points: points,
        distanceMeters: distance.toDouble(),
        durationSeconds: duration.toDouble(),
      );
    } on Exception {
      return null;
    }
  }

  void close() => _client.close();
}

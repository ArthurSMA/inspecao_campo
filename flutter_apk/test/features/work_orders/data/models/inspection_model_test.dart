import 'package:flutter_test/flutter_test.dart';
import 'package:inspecao_campo/features/work_orders/data/models/inspection_model.dart';
import 'package:inspecao_campo/features/work_orders/domain/entities/inspection.dart';

void main() {
  group('InspectionModel', () {
    test('creates a synced inspection from API payload', () {
      final model = InspectionModel.fromJson({
        'id': 'insp_9001',
        'clientId': '550e8400-e29b-41d4-a716-446655440000',
        'workOrderId': 'wo_1001',
        'observation': 'Poste ok, pequena oxidação na base.',
        'condition': 'regular',
        'photoUrl': '/uploads/insp_9001.jpg',
        'latitude': -7.1197,
        'longitude': -34.8451,
        'capturedAt': '2026-07-26T15:10:00.000Z',
        'syncedAt': '2026-07-26T15:12:00.000Z',
      });

      expect(model.status, Inspection.statusSynced);
      expect(model.clientId, '550e8400-e29b-41d4-a716-446655440000');
      expect(model.photoUrl, '/uploads/insp_9001.jpg');
      expect(model.latitude, -7.1197);
      expect(model.longitude, -34.8451);
    });
  });
}

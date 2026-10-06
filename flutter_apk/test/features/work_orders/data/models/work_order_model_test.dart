import 'package:flutter_test/flutter_test.dart';
import 'package:inspecao_campo/features/work_orders/data/models/work_order_model.dart';

void main() {
  test('maps work order fields from the API response', () {
    final workOrder = WorkOrderModel.fromJson({
      'id': 'wo_1001',
      'code': 'OS-2026-001',
      'title': 'Inspeção de poste',
      'description': 'Verificar conexões aparentes.',
      'address': 'Rua das Acácias, 120 — João Pessoa/PB',
      'priority': 'high',
      'status': 'open',
      'latitude': -7.1195,
      'longitude': -34.845,
      'scheduledAt': '2026-07-28T13:00:00.000Z',
      'updatedAt': '2026-07-26T12:00:00.000Z',
      'notes': 'Cliente relatou oscilação noturna.',
    });

    expect(workOrder.id, 'wo_1001');
    expect(workOrder.code, 'OS-2026-001');
    expect(workOrder.address, 'Rua das Acácias, 120 — João Pessoa/PB');
    expect(workOrder.priority, 'high');
    expect(workOrder.status, 'open');
    expect(workOrder.latitude, -7.1195);
    expect(workOrder.longitude, -34.845);
    expect(workOrder.scheduledAt, DateTime.parse('2026-07-28T13:00:00.000Z'));
    expect(workOrder.updatedAt, DateTime.parse('2026-07-26T12:00:00.000Z'));
    expect(workOrder.notes, 'Cliente relatou oscilação noturna.');
  });

  test('allows notes to be absent from the work order response', () {
    final workOrder = WorkOrderModel.fromJson({
      'id': 'wo_1001',
      'code': 'OS-2026-001',
      'title': 'Inspeção de poste',
      'description': 'Verificar conexões aparentes.',
      'address': 'Rua das Acácias, 120 — João Pessoa/PB',
      'priority': 'high',
      'status': 'open',
      'latitude': -7.1195,
      'longitude': -34.845,
      'scheduledAt': '2026-07-28T13:00:00.000Z',
      'updatedAt': '2026-07-26T12:00:00.000Z',
    });

    expect(workOrder.notes, isNull);
  });
}

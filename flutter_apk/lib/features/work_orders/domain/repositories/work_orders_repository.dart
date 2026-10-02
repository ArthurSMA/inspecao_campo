import '../entities/work_order.dart';

abstract class WorkOrdersRepository {
  Future<List<WorkOrder>> getWorkOrders();
  Future<void> syncRemoteOrders();
  Stream<List<WorkOrder>> watchWorkOrders({String status = 'all', String query = ''});
}

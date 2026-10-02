import '../entities/work_order.dart';

abstract class WorkOrdersRepository {
  Future<List<WorkOrder>> getWorkOrders();
}

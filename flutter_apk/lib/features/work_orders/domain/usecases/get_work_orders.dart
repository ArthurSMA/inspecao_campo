import '../entities/work_order.dart';
import '../repositories/work_orders_repository.dart';

class GetWorkOrdersUseCase {
  final WorkOrdersRepository repository;

  GetWorkOrdersUseCase(this.repository);

  Future<List<WorkOrder>> call() async {
    return await repository.getWorkOrders();
  }
}

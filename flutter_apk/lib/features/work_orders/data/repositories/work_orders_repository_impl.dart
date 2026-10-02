import '../../domain/entities/work_order.dart';
import '../../domain/repositories/work_orders_repository.dart';
import '../datasources/work_orders_remote_data_source.dart';

class WorkOrdersRepositoryImpl implements WorkOrdersRepository {
  final WorkOrdersRemoteDataSource remoteDataSource;

  WorkOrdersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<WorkOrder>> getWorkOrders() async {
    return await remoteDataSource.fetchWorkOrders();
  }
}

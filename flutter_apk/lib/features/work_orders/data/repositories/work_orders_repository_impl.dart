import '../../domain/entities/work_order.dart' as domain;
import '../../domain/repositories/work_orders_repository.dart';
import '../database/work_orders_database.dart';
import '../datasources/work_orders_remote_data_source.dart';

class WorkOrdersRepositoryImpl implements WorkOrdersRepository {
  final WorkOrdersRemoteDataSource remoteDataSource;
  final AppDatabase database;

  WorkOrdersRepositoryImpl({
    required this.remoteDataSource,
    AppDatabase? database,
  }) : database = database ?? AppDatabase();

  @override
  Future<List<domain.WorkOrder>> getWorkOrders() async {
    final localOrders = await database.getWorkOrders();
    if (localOrders.isNotEmpty) {
      return localOrders;
    }

    await syncRemoteOrders();
    return database.getWorkOrders();
  }

  @override
  Future<void> syncRemoteOrders() async {
    final remoteOrders = await remoteDataSource.fetchWorkOrders();
    await database.saveWorkOrders(remoteOrders);
  }

  @override
  Stream<List<domain.WorkOrder>> watchWorkOrders({String status = 'all', String query = ''}) {
    return database.watchWorkOrders(status: status, query: query);
  }
}

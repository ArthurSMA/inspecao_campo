import 'package:dio/dio.dart';

import '../models/work_order_model.dart';

abstract class WorkOrdersRemoteDataSource {
  Future<List<WorkOrderModel>> fetchWorkOrders();
}

class WorkOrdersRemoteDataSourceImpl implements WorkOrdersRemoteDataSource {
  final Dio dio;

  WorkOrdersRemoteDataSourceImpl(this.dio);

  @override
  Future<List<WorkOrderModel>> fetchWorkOrders() async {
    final response = await dio.get('/work-orders');
    final list = response.data as List;
    return list.map((json) => WorkOrderModel.fromJson(json)).toList();
  }
}

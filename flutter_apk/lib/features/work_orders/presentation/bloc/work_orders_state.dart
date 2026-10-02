import '../../domain/entities/work_order.dart';

abstract class WorkOrdersState {}

class WorkOrdersInitialState extends WorkOrdersState {}

class WorkOrdersLoadingState extends WorkOrdersState {}

class WorkOrdersLoadedState extends WorkOrdersState {
  final List<WorkOrder> orders;
  WorkOrdersLoadedState(this.orders);
}

class WorkOrdersErrorState extends WorkOrdersState {
  final String message;
  WorkOrdersErrorState(this.message);
}

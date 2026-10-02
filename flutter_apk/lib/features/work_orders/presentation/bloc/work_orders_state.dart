import 'package:equatable/equatable.dart';

import '../../domain/entities/work_order.dart';

abstract class WorkOrdersState extends Equatable {
  const WorkOrdersState();

  @override
  List<Object?> get props => [];
}

class WorkOrdersInitialState extends WorkOrdersState {}

class WorkOrdersLoadingState extends WorkOrdersState {}

class WorkOrdersLoadedState extends WorkOrdersState {
  final List<WorkOrder> orders;

  const WorkOrdersLoadedState(this.orders);

  @override
  List<Object?> get props => [orders];
}

class WorkOrdersErrorState extends WorkOrdersState {
  final String message;

  const WorkOrdersErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

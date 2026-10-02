import '../../domain/entities/work_order.dart' as domain;

abstract class WorkOrdersEvent {}

class FetchWorkOrdersEvent extends WorkOrdersEvent {}

class RefreshWorkOrdersEvent extends WorkOrdersEvent {}

class FilterByStatusEvent extends WorkOrdersEvent {
  final String status;

  FilterByStatusEvent(this.status);
}

class SearchWorkOrdersEvent extends WorkOrdersEvent {
  final String query;

  SearchWorkOrdersEvent(this.query);
}

class WorkOrdersUpdatedEvent extends WorkOrdersEvent {
  final List<domain.WorkOrder> orders;

  WorkOrdersUpdatedEvent(this.orders);
}

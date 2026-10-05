import 'package:equatable/equatable.dart';

import '../../domain/entities/inspection.dart';

abstract class InspectionEvent extends Equatable {
  const InspectionEvent();

  @override
  List<Object?> get props => const [];
}

class LoadInspectionHistoryEvent extends InspectionEvent {}

class FilterInspectionHistoryEvent extends InspectionEvent {
  const FilterInspectionHistoryEvent(this.status);

  final String status;

  @override
  List<Object?> get props => [status];
}

class InspectionHistoryUpdatedEvent extends InspectionEvent {
  const InspectionHistoryUpdatedEvent(this.inspections);

  final List<Inspection> inspections;

  @override
  List<Object?> get props => [inspections];
}

class ConnectivityMonitoringErrorEvent extends InspectionEvent {
  const ConnectivityMonitoringErrorEvent(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class SaveDraftInspectionEvent extends InspectionEvent {
  const SaveDraftInspectionEvent(this.inspection);

  final Inspection inspection;

  @override
  List<Object?> get props => [inspection];
}

class SavePendingInspectionEvent extends InspectionEvent {
  const SavePendingInspectionEvent(this.inspection);

  final Inspection inspection;

  @override
  List<Object?> get props => [inspection];
}

class MarkInspectionPendingEvent extends InspectionEvent {
  const MarkInspectionPendingEvent(this.clientId);

  final String clientId;

  @override
  List<Object?> get props => [clientId];
}

class SyncPendingInspectionsEvent extends InspectionEvent {}

class RetryInspectionEvent extends InspectionEvent {
  const RetryInspectionEvent(this.clientId);

  final String clientId;

  @override
  List<Object?> get props => [clientId];
}

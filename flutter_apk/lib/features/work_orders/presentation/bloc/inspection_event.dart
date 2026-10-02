import 'package:equatable/equatable.dart';

import '../../domain/entities/inspection.dart';

abstract class InspectionEvent extends Equatable {
  const InspectionEvent();

  @override
  List<Object?> get props => const [];
}

class LoadInspectionHistoryEvent extends InspectionEvent {}

class SaveDraftInspectionEvent extends InspectionEvent {
  const SaveDraftInspectionEvent(this.inspection);

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

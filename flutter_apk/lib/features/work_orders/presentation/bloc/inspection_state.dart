import 'package:equatable/equatable.dart';

import '../../domain/entities/inspection.dart';

abstract class InspectionState extends Equatable {
  const InspectionState();

  @override
  List<Object?> get props => const [];
}

class InspectionInitialState extends InspectionState {}

class InspectionLoadingState extends InspectionState {}

class InspectionLoadedState extends InspectionState {
  const InspectionLoadedState(this.inspections);

  final List<Inspection> inspections;

  @override
  List<Object?> get props => [inspections];
}

class InspectionErrorState extends InspectionState {
  const InspectionErrorState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class InspectionActionCompletedState extends InspectionState {
  const InspectionActionCompletedState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/inspection_repository.dart';
import 'inspection_event.dart';
import 'inspection_state.dart';

class InspectionBloc extends Bloc<InspectionEvent, InspectionState> {
  InspectionBloc(this._repository) : super(InspectionInitialState()) {
    on<LoadInspectionHistoryEvent>(_onLoadInspectionHistory);
    on<SaveDraftInspectionEvent>(_onSaveDraftInspection);
    on<MarkInspectionPendingEvent>(_onMarkInspectionPending);
    on<SyncPendingInspectionsEvent>(_onSyncPendingInspections);
    on<RetryInspectionEvent>(_onRetryInspection);
  }

  final InspectionRepository _repository;

  Future<void> _onLoadInspectionHistory(
    LoadInspectionHistoryEvent event,
    Emitter<InspectionState> emit,
  ) async {
    emit(InspectionLoadingState());

    try {
      final inspections = await _repository.getInspectionHistory();
      emit(InspectionLoadedState(inspections));
    } catch (error) {
      emit(InspectionErrorState(error.toString()));
    }
  }

  Future<void> _onSaveDraftInspection(
    SaveDraftInspectionEvent event,
    Emitter<InspectionState> emit,
  ) async {
    emit(InspectionLoadingState());

    try {
      await _repository.saveDraft(event.inspection);
      final inspections = await _repository.getInspectionHistory();
      emit(InspectionLoadedState(inspections));
    } catch (error) {
      emit(InspectionErrorState(error.toString()));
    }
  }

  Future<void> _onMarkInspectionPending(
    MarkInspectionPendingEvent event,
    Emitter<InspectionState> emit,
  ) async {
    try {
      await _repository.markPending(event.clientId);
      final inspections = await _repository.getInspectionHistory();
      emit(InspectionLoadedState(inspections));
    } catch (error) {
      emit(InspectionErrorState(error.toString()));
    }
  }

  Future<void> _onSyncPendingInspections(
    SyncPendingInspectionsEvent event,
    Emitter<InspectionState> emit,
  ) async {
    emit(InspectionLoadingState());

    try {
      await _repository.syncPendingInspections();
      final inspections = await _repository.getInspectionHistory();
      emit(InspectionLoadedState(inspections));
    } catch (error) {
      emit(InspectionErrorState(error.toString()));
    }
  }

  Future<void> _onRetryInspection(
    RetryInspectionEvent event,
    Emitter<InspectionState> emit,
  ) async {
    emit(InspectionLoadingState());

    try {
      await _repository.retryInspection(event.clientId);
      final inspections = await _repository.getInspectionHistory();
      emit(InspectionLoadedState(inspections));
    } catch (error) {
      emit(InspectionErrorState(error.toString()));
    }
  }
}

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/services/network_connectivity_service.dart';
import '../../domain/entities/inspection.dart';
import '../../domain/repositories/inspection_repository.dart';
import '../../domain/usecases/process_sync_queue.dart';
import '../../domain/usecases/retry_failed_sync.dart';
import 'inspection_event.dart';
import 'inspection_state.dart';

class InspectionBloc extends Bloc<InspectionEvent, InspectionState> {
  InspectionBloc(
    this._repository, {
    NetworkConnectivityService? connectivityService,
  }) : _connectivityService =
           connectivityService ?? NetworkConnectivityServiceImpl(),
       _processSyncQueue = ProcessSyncQueueUseCase(_repository),
       _retryFailedSync = RetryFailedSyncUseCase(_repository),
       super(InspectionInitialState()) {
    on<LoadInspectionHistoryEvent>(_onLoadInspectionHistory);
    on<FilterInspectionHistoryEvent>(_onFilterInspectionHistory);
    on<InspectionHistoryUpdatedEvent>(
      (event, emit) => emit(InspectionLoadedState(event.inspections)),
    );
    on<ConnectivityMonitoringErrorEvent>(
      (event, emit) => emit(InspectionErrorState(event.message)),
    );
    on<SaveDraftInspectionEvent>(_onSaveDraftInspection);
    on<SavePendingInspectionEvent>(_onSavePendingInspection);
    on<MarkInspectionPendingEvent>(_onMarkInspectionPending);
    on<SyncPendingInspectionsEvent>(_onSyncPendingInspections);
    on<RetryInspectionEvent>(_onRetryInspection);
    _connectivitySubscription = _connectivityService.changes.listen(
      _onConnectivityChanged,
      onError: (Object error) =>
          add(ConnectivityMonitoringErrorEvent(error.toString())),
    );
  }

  final InspectionRepository _repository;
  final ProcessSyncQueueUseCase _processSyncQueue;
  final RetryFailedSyncUseCase _retryFailedSync;
  final NetworkConnectivityService _connectivityService;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  StreamSubscription<List<Inspection>>? _historySubscription;
  String _historyStatus = 'all';
  bool _wasConnected = false;

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final isConnected = results.any(
      (result) => result != ConnectivityResult.none,
    );
    if (isConnected && !_wasConnected) {
      add(SyncPendingInspectionsEvent());
    }
    _wasConnected = isConnected;
  }

  Future<void> _onLoadInspectionHistory(
    LoadInspectionHistoryEvent event,
    Emitter<InspectionState> emit,
  ) async {
    emit(InspectionLoadingState());
    _historyStatus = 'all';

    try {
      await _watchInspectionHistory();
    } catch (error) {
      emit(InspectionErrorState(error.toString()));
    }
  }

  Future<void> _onFilterInspectionHistory(
    FilterInspectionHistoryEvent event,
    Emitter<InspectionState> emit,
  ) async {
    _historyStatus = event.status;
    await _watchInspectionHistory();
  }

  Future<void> _watchInspectionHistory() async {
    await _historySubscription?.cancel();
    _historySubscription = _repository
        .watchInspectionHistory(status: _historyStatus)
        .listen(
          (inspections) => add(InspectionHistoryUpdatedEvent(inspections)),
          onError: (Object error) =>
              add(ConnectivityMonitoringErrorEvent(error.toString())),
        );
  }

  Future<void> _onSaveDraftInspection(
    SaveDraftInspectionEvent event,
    Emitter<InspectionState> emit,
  ) async {
    emit(InspectionLoadingState());

    try {
      await _repository.saveDraft(event.inspection);
      emit(const InspectionActionCompletedState('draft'));
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
      final inspections = await _repository.getInspectionHistory(
        status: _historyStatus,
      );
      emit(InspectionLoadedState(inspections));
    } catch (error) {
      emit(InspectionErrorState(error.toString()));
    }
  }

  Future<void> _onSavePendingInspection(
    SavePendingInspectionEvent event,
    Emitter<InspectionState> emit,
  ) async {
    try {
      await _repository.savePending(event.inspection);
      await _processSyncQueue();
      emit(const InspectionActionCompletedState('pending'));
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
      await _processSyncQueue();
      final inspections = await _repository.getInspectionHistory(
        status: _historyStatus,
      );
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
      await _retryFailedSync(event.clientId);
      final inspections = await _repository.getInspectionHistory(
        status: _historyStatus,
      );
      emit(InspectionLoadedState(inspections));
    } catch (error) {
      emit(InspectionErrorState(error.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _connectivitySubscription?.cancel();
    await _historySubscription?.cancel();
    return super.close();
  }
}

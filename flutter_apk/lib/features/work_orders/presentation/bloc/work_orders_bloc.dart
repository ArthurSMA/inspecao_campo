import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/work_order.dart' as domain;
import '../../domain/repositories/work_orders_repository.dart';
import '../../domain/usecases/get_work_orders.dart';
import 'work_orders_event.dart';
import 'work_orders_state.dart';

class WorkOrdersBloc extends Bloc<WorkOrdersEvent, WorkOrdersState> {
  final GetWorkOrdersUseCase getWorkOrders;
  final WorkOrdersRepository repository;
  StreamSubscription<List<domain.WorkOrder>>? _subscription;
  final List<Completer<void>> _refreshCompleters = [];

  String _status = 'all';
  String _query = '';
  String? _offlineWarning;

  WorkOrdersBloc(this.getWorkOrders)
    : repository = getWorkOrders.repository,
      super(WorkOrdersInitialState()) {
    on<FetchWorkOrdersEvent>(_onFetchWorkOrders);
    on<RefreshWorkOrdersEvent>(_onRefreshWorkOrders);
    on<FilterByStatusEvent>(_onFilterByStatus);
    on<SearchWorkOrdersEvent>(_onSearchWorkOrders);
    on<WorkOrdersUpdatedEvent>(_onWorkOrdersUpdated);
    on<SaveLocalWorkOrderEvent>(_onSaveLocalWorkOrder);
  }

  Future<void> _onFetchWorkOrders(
    FetchWorkOrdersEvent event,
    Emitter<WorkOrdersState> emit,
  ) async {
    emit(WorkOrdersLoadingState());

    try {
      await repository.syncRemoteOrders();
      final localOrders = await repository.getWorkOrders();
      _offlineWarning = null;
      emit(WorkOrdersLoadedState(localOrders));
      await _listenToLocalStream();
    } catch (error) {
      await _emitOfflineOrError(error, emit);
    }
  }

  Future<void> _onRefreshWorkOrders(
    RefreshWorkOrdersEvent event,
    Emitter<WorkOrdersState> emit,
  ) async {
    emit(WorkOrdersLoadingState());
    try {
      await repository.syncRemoteOrders();
      final localOrders = await repository.getWorkOrders();
      _offlineWarning = null;
      emit(WorkOrdersLoadedState(localOrders));
      await _listenToLocalStream();
    } catch (error) {
      await _emitOfflineOrError(error, emit);
    } finally {
      if (_refreshCompleters.isNotEmpty) {
        final completer = _refreshCompleters.removeAt(0);
        if (!completer.isCompleted) completer.complete();
      }
    }
  }

  Future<void> refreshWorkOrders() {
    final completer = Completer<void>();
    _refreshCompleters.add(completer);
    add(RefreshWorkOrdersEvent());
    return completer.future;
  }

  Future<void> _emitOfflineOrError(
    Object error,
    Emitter<WorkOrdersState> emit,
  ) async {
    try {
      final cachedOrders = await repository.watchWorkOrders().first;
      final localOrders = await repository
          .watchWorkOrders(status: _status, query: _query)
          .first;
      if (cachedOrders.isEmpty) {
        _offlineWarning = null;
        emit(
          const WorkOrdersErrorState(
            'Não foi possível carregar as ordens de serviço. Verifique a conexão e tente novamente.',
          ),
        );
        return;
      }

      _offlineWarning = 'Sem conexão com o servidor. Exibindo ordens salvas neste dispositivo.';
      emit(WorkOrdersLoadedState(localOrders, offlineWarning: _offlineWarning));
      await _listenToLocalStream();
    } catch (_) {
      _offlineWarning = null;
      emit(WorkOrdersErrorState(error.toString()));
    }
  }

  Future<void> _onFilterByStatus(
    FilterByStatusEvent event,
    Emitter<WorkOrdersState> emit,
  ) async {
    _status = event.status;
    await _listenToLocalStream();
  }

  Future<void> _onSearchWorkOrders(
    SearchWorkOrdersEvent event,
    Emitter<WorkOrdersState> emit,
  ) async {
    _query = event.query;
    await _listenToLocalStream();
  }

  Future<void> _listenToLocalStream() async {
    await _subscription?.cancel();
    _subscription = repository
        .watchWorkOrders(status: _status, query: _query)
        .listen(
          (orders) => add(WorkOrdersUpdatedEvent(orders)),
          onError: (Object error) {
            addError(error);
          },
        );
  }

  Future<void> _onWorkOrdersUpdated(
    WorkOrdersUpdatedEvent event,
    Emitter<WorkOrdersState> emit,
  ) async {
    emit(WorkOrdersLoadedState(event.orders, offlineWarning: _offlineWarning));
  }

  Future<void> _onSaveLocalWorkOrder(
    SaveLocalWorkOrderEvent event,
    Emitter<WorkOrdersState> emit,
  ) async {
    try {
      await repository.saveLocalWorkOrder(event.workOrder);
      if (_subscription == null) {
        await _listenToLocalStream();
      }
    } catch (_) {
      emit(WorkOrdersErrorState('Não foi possível salvar a ordem localmente'));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

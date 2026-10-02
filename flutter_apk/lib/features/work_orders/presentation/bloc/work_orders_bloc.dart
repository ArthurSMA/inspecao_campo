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

  String _status = 'all';
  String _query = '';

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
    } catch (_) {
      final localOrders = await repository.getWorkOrders();
      emit(WorkOrdersLoadedState(localOrders));
      await _listenToLocalStream();
      return;
    }

    final localOrders = await repository.getWorkOrders();
    emit(WorkOrdersLoadedState(localOrders));
    await _listenToLocalStream();
  }

  Future<void> _onRefreshWorkOrders(
    RefreshWorkOrdersEvent event,
    Emitter<WorkOrdersState> emit,
  ) async {
    emit(WorkOrdersLoadingState());
    try {
      await repository.syncRemoteOrders();
    } catch (_) {
      final localOrders = await repository.getWorkOrders();
      emit(WorkOrdersErrorState('Falha ao sincronizar ordens de serviço'));
      emit(WorkOrdersLoadedState(localOrders));
      return;
    }

    final localOrders = await repository.getWorkOrders();
    emit(WorkOrdersLoadedState(localOrders));
    await _listenToLocalStream();
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
          onError: (_) {
            add(WorkOrdersUpdatedEvent(const []));
          },
        );
  }

  Future<void> _onWorkOrdersUpdated(
    WorkOrdersUpdatedEvent event,
    Emitter<WorkOrdersState> emit,
  ) async {
    emit(WorkOrdersLoadedState(event.orders));
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
      await _listenToLocalStream();
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

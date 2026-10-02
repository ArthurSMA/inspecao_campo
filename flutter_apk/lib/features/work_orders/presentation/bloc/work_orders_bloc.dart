import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_work_orders.dart';
import 'work_orders_event.dart';
import 'work_orders_state.dart';

class WorkOrdersBloc extends Bloc<WorkOrdersEvent, WorkOrdersState> {
  final GetWorkOrdersUseCase getWorkOrders;

  WorkOrdersBloc(this.getWorkOrders) : super(WorkOrdersInitialState()) {
    on<FetchWorkOrdersEvent>(_onFetchWorkOrders);
  }

  Future<void> _onFetchWorkOrders(
    FetchWorkOrdersEvent event,
    Emitter<WorkOrdersState> emit,
  ) async {
    emit(WorkOrdersLoadingState());
    try {
      final orders = await getWorkOrders();
      emit(WorkOrdersLoadedState(orders));
    } catch (e) {
      emit(WorkOrdersErrorState('Falha ao carregar ordens de serviço'));
    }
  }
}

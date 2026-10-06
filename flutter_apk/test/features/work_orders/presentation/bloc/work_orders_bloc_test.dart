import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:inspecao_campo/features/work_orders/domain/entities/work_order.dart';
import 'package:inspecao_campo/features/work_orders/domain/repositories/work_orders_repository.dart';
import 'package:inspecao_campo/features/work_orders/domain/usecases/get_work_orders.dart';
import 'package:inspecao_campo/features/work_orders/presentation/bloc/work_orders_bloc.dart';
import 'package:inspecao_campo/features/work_orders/presentation/bloc/work_orders_event.dart';
import 'package:inspecao_campo/features/work_orders/presentation/bloc/work_orders_state.dart';

void main() {
  test('keeps cached work orders and warns when remote sync fails', () async {
    final repository = _FakeWorkOrdersRepository([_workOrder]);
    repository.syncError = Exception('offline');
    final bloc = WorkOrdersBloc(GetWorkOrdersUseCase(repository));
    addTearDown(bloc.close);

    final loaded = bloc.stream.firstWhere(
      (state) => state is WorkOrdersLoadedState,
    );
    bloc.add(FetchWorkOrdersEvent());
    final state = await loaded;

    expect(state, isA<WorkOrdersLoadedState>());
    final loadedState = state as WorkOrdersLoadedState;
    expect(loadedState.orders, [_workOrder]);
    expect(loadedState.offlineWarning, contains('Sem conexão'));
  });

  test(
    'emits and retains an error when sync fails without cached data',
    () async {
      final repository = _FakeWorkOrdersRepository([]);
      repository.syncError = Exception('offline');
      final bloc = WorkOrdersBloc(GetWorkOrdersUseCase(repository));
      addTearDown(bloc.close);

      final error = bloc.stream.firstWhere(
        (state) => state is WorkOrdersErrorState,
      );
      bloc.add(FetchWorkOrdersEvent());
      final state = await error;

      expect(state, isA<WorkOrdersErrorState>());
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state, same(state));
    },
  );

  test(
    'refresh future completes after the final BLoC state is emitted',
    () async {
      final repository = _FakeWorkOrdersRepository([_workOrder]);
      final syncCompleter = Completer<void>();
      repository.syncCompleter = syncCompleter;
      final bloc = WorkOrdersBloc(GetWorkOrdersUseCase(repository));
      addTearDown(bloc.close);

      final loading = bloc.stream.firstWhere(
        (state) => state is WorkOrdersLoadingState,
      );
      final refresh = bloc.refreshWorkOrders();
      var completed = false;
      unawaited(refresh.then((_) => completed = true));
      await loading;
      await Future<void>.delayed(Duration.zero);
      expect(completed, isFalse);

      syncCompleter.complete();
      await refresh;

      expect(bloc.state, isA<WorkOrdersLoadedState>());
    },
  );
}

final _workOrder = WorkOrder(
  id: 'wo-1',
  code: 'OS-001',
  title: 'Inspecionar poste',
  description: '',
  address: 'Rua A',
  priority: 'high',
  status: 'open',
  latitude: -7.1,
  longitude: -34.8,
  scheduledAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

class _FakeWorkOrdersRepository implements WorkOrdersRepository {
  _FakeWorkOrdersRepository(this.orders);

  final List<WorkOrder> orders;
  Object? syncError;
  Completer<void>? syncCompleter;

  @override
  Future<List<WorkOrder>> getWorkOrders() async => orders;

  @override
  Future<void> syncRemoteOrders() async {
    if (syncCompleter case final completer?) {
      await completer.future;
    }
    if (syncError case final error?) {
      throw error;
    }
  }

  @override
  Future<void> saveLocalWorkOrder(WorkOrder workOrder) async {
    orders.add(workOrder);
  }

  @override
  Stream<List<WorkOrder>> watchWorkOrders({
    String status = 'all',
    String query = '',
  }) => Stream.value(orders);
}

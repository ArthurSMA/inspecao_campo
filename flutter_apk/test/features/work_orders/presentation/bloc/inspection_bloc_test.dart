import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inspecao_campo/features/work_orders/data/services/network_connectivity_service.dart';
import 'package:inspecao_campo/features/work_orders/domain/entities/inspection.dart';
import 'package:inspecao_campo/features/work_orders/domain/repositories/inspection_repository.dart';
import 'package:inspecao_campo/features/work_orders/presentation/bloc/inspection_bloc.dart';

void main() {
  test('syncs pending inspections when connectivity is restored', () async {
    final connectivity = _FakeConnectivityService();
    final repository = _FakeInspectionRepository();
    final bloc = InspectionBloc(repository, connectivityService: connectivity);
    addTearDown(() async {
      await bloc.close();
      await connectivity.controller.close();
    });

    connectivity.controller.add([ConnectivityResult.none]);
    await Future<void>.delayed(Duration.zero);
    connectivity.controller.add([ConnectivityResult.wifi]);

    await repository.syncCalled.future.timeout(const Duration(seconds: 1));
    expect(repository.syncCalls, 1);
  });
}

class _FakeConnectivityService implements NetworkConnectivityService {
  final StreamController<List<ConnectivityResult>> controller =
      StreamController<List<ConnectivityResult>>.broadcast();

  @override
  Stream<List<ConnectivityResult>> get changes => controller.stream;

  @override
  Future<bool> get isConnected async => false;
}

class _FakeInspectionRepository implements InspectionRepository {
  final Completer<void> syncCalled = Completer<void>();
  int syncCalls = 0;

  @override
  Future<List<Inspection>> getInspectionHistory({
    String status = 'all',
  }) async => [];

  @override
  Stream<List<Inspection>> watchInspectionHistory({String status = 'all'}) =>
      const Stream.empty();

  @override
  Future<void> markPending(String clientId) async {}

  @override
  Future<void> retryInspection(String clientId) async {}

  @override
  Future<void> saveDraft(Inspection inspection) async {}

  @override
  Future<void> savePending(Inspection inspection) async {}

  @override
  Future<void> syncPendingInspections() async {
    syncCalls++;
    if (!syncCalled.isCompleted) {
      syncCalled.complete();
    }
  }
}

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:inspecao_campo/core/connectivity/internet_connection_service.dart';
import 'package:inspecao_campo/features/work_orders/domain/entities/inspection.dart';
import 'package:inspecao_campo/features/work_orders/domain/repositories/inspection_repository.dart';
import 'package:inspecao_campo/features/work_orders/presentation/bloc/inspection_bloc.dart';

void main() {
  test('syncs pending inspections when connectivity is restored', () async {
    final internetConnection = _FakeInternetConnectionService();
    final repository = _FakeInspectionRepository();
    final bloc = InspectionBloc(
      repository,
      internetConnectionService: internetConnection,
    );
    addTearDown(() async {
      await bloc.close();
      await internetConnection.controller.close();
    });

    internetConnection.controller.add(false);
    await Future<void>.delayed(Duration.zero);
    internetConnection.controller.add(true);

    await repository.syncCalled.future.timeout(const Duration(seconds: 1));
    expect(repository.syncCalls, 1);
  });
}

class _FakeInternetConnectionService implements InternetConnectionService {
  final StreamController<bool> controller = StreamController<bool>.broadcast();

  @override
  Stream<bool> get status => controller.stream;

  @override
  Future<bool> get hasInternetAccess async => false;
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

import '../repositories/inspection_repository.dart';

class ProcessSyncQueueUseCase {
  const ProcessSyncQueueUseCase(this._repository);

  final InspectionRepository _repository;

  Future<void> call() => _repository.syncPendingInspections();
}

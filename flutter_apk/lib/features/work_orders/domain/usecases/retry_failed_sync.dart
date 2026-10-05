import '../repositories/inspection_repository.dart';

class RetryFailedSyncUseCase {
  const RetryFailedSyncUseCase(this._repository);

  final InspectionRepository _repository;

  Future<void> call(String clientId) => _repository.retryInspection(clientId);
}

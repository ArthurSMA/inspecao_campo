import '../entities/inspection.dart';

abstract class InspectionRepository {
  Future<List<Inspection>> getInspectionHistory({String status = 'all'});
  Stream<List<Inspection>> watchInspectionHistory({String status = 'all'});
  Future<void> saveDraft(Inspection inspection);
  Future<void> savePending(Inspection inspection);
  Future<void> markPending(String clientId);
  Future<void> syncPendingInspections();
  Future<void> retryInspection(String clientId);
}

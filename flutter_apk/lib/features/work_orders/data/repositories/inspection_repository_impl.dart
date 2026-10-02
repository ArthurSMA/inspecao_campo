import '../../domain/entities/inspection.dart';
import '../../domain/repositories/inspection_repository.dart';
import '../database/work_orders_database.dart';
import '../datasources/inspection_remote_data_source.dart';
import '../models/inspection_model.dart';

class InspectionRepositoryImpl implements InspectionRepository {
  InspectionRepositoryImpl({
    required this.remoteDataSource,
    AppDatabase? database,
  }) : database = database ?? AppDatabase();

  final InspectionRemoteDataSource remoteDataSource;
  final AppDatabase database;

  @override
  Future<List<Inspection>> getInspectionHistory({String status = 'all'}) {
    return database.getInspections(status: status);
  }

  @override
  Stream<List<Inspection>> watchInspectionHistory({String status = 'all'}) {
    return database.watchInspections(status: status);
  }

  @override
  Future<void> saveDraft(Inspection inspection) async {
    final draftInspection = inspection.copyWith(
      status: Inspection.statusDraft,
      errorMessage: null,
      syncedAt: null,
    );
    await database.saveInspection(draftInspection);
  }

  @override
  Future<void> markPending(String clientId) async {
    final inspection = await database.getInspectionByClientId(clientId);
    if (inspection == null) {
      return;
    }

    await database.updateInspectionStatus(
      clientId,
      status: Inspection.statusPending,
      errorMessage: null,
    );
  }

  @override
  Future<void> syncPendingInspections() async {
    final pendingList = await database.getInspections(status: Inspection.statusPending);
    final failedList = await database.getInspections(status: Inspection.statusFailed);
    final items = [...pendingList, ...failedList];

    for (final inspection in items) {
      try {
        final remoteInspection = await remoteDataSource.submitInspection(
          InspectionModel(
            id: inspection.id,
            clientId: inspection.clientId,
            workOrderId: inspection.workOrderId,
            observation: inspection.observation,
            condition: inspection.condition,
            latitude: inspection.latitude,
            longitude: inspection.longitude,
            capturedAt: inspection.capturedAt,
            createdAt: inspection.createdAt,
            photoPath: inspection.photoPath,
            photoUrl: inspection.photoUrl,
            syncedAt: inspection.syncedAt,
            status: inspection.status,
            errorMessage: inspection.errorMessage,
            serverId: inspection.serverId,
          ),
        );

        await database.updateInspectionStatus(
          inspection.clientId,
          status: Inspection.statusSynced,
          serverId: remoteInspection.serverId,
          syncedAt: remoteInspection.syncedAt ?? DateTime.now(),
          errorMessage: null,
          photoUrl: remoteInspection.photoUrl,
        );
      } catch (error) {
        await database.updateInspectionStatus(
          inspection.clientId,
          status: Inspection.statusFailed,
          errorMessage: error.toString(),
        );
      }
    }
  }

  @override
  Future<void> retryInspection(String clientId) async {
    final inspection = await database.getInspectionByClientId(clientId);
    if (inspection == null) {
      return;
    }

    await database.updateInspectionStatus(
      clientId,
      status: Inspection.statusPending,
      errorMessage: null,
    );
    await syncPendingInspections();
  }
}

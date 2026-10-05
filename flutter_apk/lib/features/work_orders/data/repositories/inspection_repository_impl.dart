import 'package:dio/dio.dart';

import '../../domain/entities/inspection.dart';
import '../../domain/repositories/inspection_repository.dart';
import '../database/work_orders_database.dart';
import '../datasources/inspection_remote_data_source.dart';
import '../models/inspection_model.dart';
import '../services/network_connectivity_service.dart';

class InspectionRepositoryImpl implements InspectionRepository {
  InspectionRepositoryImpl({
    required this.remoteDataSource,
    AppDatabase? database,
    NetworkConnectivityService? connectivityService,
  }) : database = database ?? AppDatabase(),
       connectivityService =
           connectivityService ?? NetworkConnectivityServiceImpl();

  final InspectionRemoteDataSource remoteDataSource;
  final AppDatabase database;
  final NetworkConnectivityService connectivityService;
  Future<void>? _activeSync;

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
    await database.saveDraftInspection(draftInspection);
  }

  @override
  Future<void> savePending(Inspection inspection) async {
    final pendingInspection = inspection.copyWith(
      status: Inspection.statusPending,
      errorMessage: null,
      syncedAt: null,
    );
    await database.savePendingInspection(pendingInspection);
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
  Future<void> syncPendingInspections() {
    return _activeSync ??= _processSyncQueue().whenComplete(() {
      _activeSync = null;
    });
  }

  Future<void> _processSyncQueue() async {
    if (!await connectivityService.isConnected) {
      return;
    }

    final items = await database.getQueuedInspections();

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
          errorMessage: _errorMessage(error),
        );
      }
    }
  }

  String _errorMessage(Object error) {
    if (error is DioException) {
      final responseData = error.response?.data;
      final responseMessage = responseData is Map
          ? responseData['message']
          : null;
      if (responseMessage is String && responseMessage.isNotEmpty) {
        final statusCode = error.response?.statusCode;
        return statusCode == null
            ? responseMessage
            : '$responseMessage (HTTP $statusCode)';
      }
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        return 'Tempo limite excedido ao sincronizar a inspeção.';
      }
      final statusCode = error.response?.statusCode;
      if (statusCode != null) {
        return 'Falha ao sincronizar a inspeção (HTTP $statusCode).';
      }
    }
    return error.toString();
  }

  @override
  Future<void> retryInspection(String clientId) async {
    final inspection = await database.getInspectionByClientId(clientId);
    if (inspection == null) {
      return;
    }
    if (inspection.status != Inspection.statusFailed &&
        inspection.status != Inspection.statusPending) {
      throw StateError(
        'Somente inspeções pendentes ou com falha podem ser reenviadas.',
      );
    }

    await database.updateInspectionStatus(
      clientId,
      status: Inspection.statusPending,
      errorMessage: null,
    );
    await syncPendingInspections();
  }
}

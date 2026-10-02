import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/inspection.dart' as domain_inspection;
import '../../domain/entities/work_order.dart' as domain;

part 'work_orders_database.g.dart';

@DataClassName('WorkOrderData')
class WorkOrders extends Table {
  TextColumn get id => text()();
  TextColumn get code => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get address => text()();
  TextColumn get priority => text()();
  TextColumn get status => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  DateTimeColumn get scheduledAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('InspectionData')
class Inspections extends Table {
  TextColumn get id => text()();
  TextColumn get clientId => text()();
  TextColumn get workOrderId => text()();
  TextColumn get observation => text()();
  TextColumn get condition => text().nullable()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  DateTimeColumn get capturedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get photoPath => text().nullable()();
  TextColumn get photoUrl => text().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();
  TextColumn get status => text()();
  TextColumn get errorMessage => text().nullable()();
  TextColumn get serverId => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'work_orders.db'));
    return NativeDatabase.createInBackground(file);
  });
}

@DriftDatabase(tables: [WorkOrders, Inspections])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(inspections);
      }
    },
  );

  Future<List<domain.WorkOrder>> getWorkOrders() async {
    final rows = await (select(workOrders)
          ..orderBy([(row) => OrderingTerm.desc(row.updatedAt)]))
        .get();
    return rows.map((row) => row.toDomain()).toList();
  }

  Stream<List<domain.WorkOrder>> watchWorkOrders({
    String status = 'all',
    String query = '',
  }) {
    final normalizedStatus = status.trim().toLowerCase();
    final normalizedQuery = query.trim().toLowerCase();

    final queryBuilder = select(workOrders)
      ..orderBy([
        (row) => OrderingTerm.desc(row.updatedAt),
      ]);

    if (normalizedStatus != 'all' && normalizedStatus.isNotEmpty) {
      queryBuilder.where((row) => row.status.equals(normalizedStatus));
    }

    if (normalizedQuery.isNotEmpty) {
      queryBuilder.where(
        (row) =>
            row.title.lower().contains(normalizedQuery) |
            row.code.lower().contains(normalizedQuery) |
            row.address.lower().contains(normalizedQuery),
      );
    }

    return queryBuilder.watch().map(
      (rows) => rows.map((row) => row.toDomain()).toList(),
    );
  }

  Future<void> saveWorkOrders(List<domain.WorkOrder> orders) async {
    if (orders.isEmpty) return;

    await batch((batch) {
      batch.insertAllOnConflictUpdate(
        workOrders,
        orders.map((order) => order.toCompanion()).toList(),
      );
    });
  }

  Future<List<domain_inspection.Inspection>> getInspections({String status = 'all'}) async {
    final query = select(inspections)
      ..orderBy([(row) => OrderingTerm.desc(row.createdAt)]);

    if (status != 'all' && status.trim().isNotEmpty) {
      query.where((row) => row.status.equals(status));
    }

    final rows = await query.get();
    return rows.map((row) => row.toDomain()).toList();
  }

  Stream<List<domain_inspection.Inspection>> watchInspections({String status = 'all'}) {
    final query = select(inspections)
      ..orderBy([(row) => OrderingTerm.desc(row.createdAt)]);

    if (status != 'all' && status.trim().isNotEmpty) {
      query.where((row) => row.status.equals(status));
    }

    return query.watch().map((rows) => rows.map((row) => row.toDomain()).toList());
  }

  Future<domain_inspection.Inspection?> getInspectionByClientId(String clientId) async {
    final row = await (select(inspections)
          ..where((inspection) => inspection.clientId.equals(clientId)))
        .getSingleOrNull();
    return row?.toDomain();
  }

  Future<void> saveInspection(domain_inspection.Inspection inspection) async {
    await into(inspections).insertOnConflictUpdate(inspection.toCompanion());
  }

  Future<void> updateInspectionStatus(
    String clientId, {
    required String status,
    String? errorMessage,
    String? serverId,
    DateTime? syncedAt,
    String? photoUrl,
  }) async {
    final companion = InspectionsCompanion(
      clientId: Value(clientId),
      status: Value(status),
      errorMessage: Value(errorMessage),
      serverId: Value(serverId),
      syncedAt: Value(syncedAt),
      photoUrl: Value(photoUrl),
    );

    await (update(inspections)
          ..where((row) => row.clientId.equals(clientId)))
        .write(companion);
  }
}

extension WorkOrderDataX on WorkOrderData {
  domain.WorkOrder toDomain() {
    return domain.WorkOrder(
      id: id,
      code: code,
      title: title,
      description: description,
      address: address,
      priority: priority,
      status: status,
      latitude: latitude,
      longitude: longitude,
      scheduledAt: scheduledAt,
      updatedAt: updatedAt,
      notes: notes,
    );
  }
}

extension DomainWorkOrderX on domain.WorkOrder {
  WorkOrdersCompanion toCompanion() {
    return WorkOrdersCompanion(
      id: Value(id),
      code: Value(code),
      title: Value(title),
      description: Value(description),
      address: Value(address),
      priority: Value(priority),
      status: Value(status),
      latitude: Value(latitude),
      longitude: Value(longitude),
      scheduledAt: Value(scheduledAt),
      updatedAt: Value(updatedAt),
      notes: Value(notes),
    );
  }
}

extension InspectionDataX on InspectionData {
  domain_inspection.Inspection toDomain() {
    return domain_inspection.Inspection(
      id: id,
      clientId: clientId,
      workOrderId: workOrderId,
      observation: observation,
      condition: condition,
      latitude: latitude,
      longitude: longitude,
      capturedAt: capturedAt,
      createdAt: createdAt,
      photoPath: photoPath,
      photoUrl: photoUrl,
      syncedAt: syncedAt,
      status: status,
      errorMessage: errorMessage,
      serverId: serverId,
    );
  }
}

extension DomainInspectionX on domain_inspection.Inspection {
  InspectionsCompanion toCompanion() {
    return InspectionsCompanion(
      id: Value(id),
      clientId: Value(clientId),
      workOrderId: Value(workOrderId),
      observation: Value(observation),
      condition: Value(condition),
      latitude: Value(latitude),
      longitude: Value(longitude),
      capturedAt: Value(capturedAt),
      createdAt: Value(createdAt),
      photoPath: Value(photoPath),
      photoUrl: Value(photoUrl),
      syncedAt: Value(syncedAt),
      status: Value(status),
      errorMessage: Value(errorMessage),
      serverId: Value(serverId),
    );
  }
}

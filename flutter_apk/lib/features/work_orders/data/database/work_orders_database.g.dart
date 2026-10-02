// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_orders_database.dart';

// ignore_for_file: type=lint
class $WorkOrdersTable extends WorkOrders
    with TableInfo<$WorkOrdersTable, WorkOrderData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkOrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledAtMeta = const VerificationMeta(
    'scheduledAt',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
    'scheduled_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    title,
    description,
    address,
    priority,
    status,
    latitude,
    longitude,
    scheduledAt,
    updatedAt,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'work_orders';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkOrderData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    } else if (isInserting) {
      context.missing(_priorityMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
        _scheduledAtMeta,
        scheduledAt.isAcceptableOrUnknown(
          data['scheduled_at']!,
          _scheduledAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkOrderData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkOrderData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      scheduledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $WorkOrdersTable createAlias(String alias) {
    return $WorkOrdersTable(attachedDatabase, alias);
  }
}

class WorkOrderData extends DataClass implements Insertable<WorkOrderData> {
  final String id;
  final String code;
  final String title;
  final String description;
  final String address;
  final String priority;
  final String status;
  final double latitude;
  final double longitude;
  final DateTime scheduledAt;
  final DateTime updatedAt;
  final String? notes;
  const WorkOrderData({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.address,
    required this.priority,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.scheduledAt,
    required this.updatedAt,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['code'] = Variable<String>(code);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['address'] = Variable<String>(address);
    map['priority'] = Variable<String>(priority);
    map['status'] = Variable<String>(status);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  WorkOrdersCompanion toCompanion(bool nullToAbsent) {
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
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory WorkOrderData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkOrderData(
      id: serializer.fromJson<String>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      address: serializer.fromJson<String>(json['address']),
      priority: serializer.fromJson<String>(json['priority']),
      status: serializer.fromJson<String>(json['status']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      scheduledAt: serializer.fromJson<DateTime>(json['scheduledAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'code': serializer.toJson<String>(code),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'address': serializer.toJson<String>(address),
      'priority': serializer.toJson<String>(priority),
      'status': serializer.toJson<String>(status),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'scheduledAt': serializer.toJson<DateTime>(scheduledAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  WorkOrderData copyWith({
    String? id,
    String? code,
    String? title,
    String? description,
    String? address,
    String? priority,
    String? status,
    double? latitude,
    double? longitude,
    DateTime? scheduledAt,
    DateTime? updatedAt,
    Value<String?> notes = const Value.absent(),
  }) => WorkOrderData(
    id: id ?? this.id,
    code: code ?? this.code,
    title: title ?? this.title,
    description: description ?? this.description,
    address: address ?? this.address,
    priority: priority ?? this.priority,
    status: status ?? this.status,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    scheduledAt: scheduledAt ?? this.scheduledAt,
    updatedAt: updatedAt ?? this.updatedAt,
    notes: notes.present ? notes.value : this.notes,
  );
  WorkOrderData copyWithCompanion(WorkOrdersCompanion data) {
    return WorkOrderData(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      address: data.address.present ? data.address.value : this.address,
      priority: data.priority.present ? data.priority.value : this.priority,
      status: data.status.present ? data.status.value : this.status,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      scheduledAt: data.scheduledAt.present
          ? data.scheduledAt.value
          : this.scheduledAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkOrderData(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('address: $address, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    code,
    title,
    description,
    address,
    priority,
    status,
    latitude,
    longitude,
    scheduledAt,
    updatedAt,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkOrderData &&
          other.id == this.id &&
          other.code == this.code &&
          other.title == this.title &&
          other.description == this.description &&
          other.address == this.address &&
          other.priority == this.priority &&
          other.status == this.status &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.scheduledAt == this.scheduledAt &&
          other.updatedAt == this.updatedAt &&
          other.notes == this.notes);
}

class WorkOrdersCompanion extends UpdateCompanion<WorkOrderData> {
  final Value<String> id;
  final Value<String> code;
  final Value<String> title;
  final Value<String> description;
  final Value<String> address;
  final Value<String> priority;
  final Value<String> status;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<DateTime> scheduledAt;
  final Value<DateTime> updatedAt;
  final Value<String?> notes;
  final Value<int> rowid;
  const WorkOrdersCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.address = const Value.absent(),
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkOrdersCompanion.insert({
    required String id,
    required String code,
    required String title,
    required String description,
    required String address,
    required String priority,
    required String status,
    required double latitude,
    required double longitude,
    required DateTime scheduledAt,
    required DateTime updatedAt,
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       code = Value(code),
       title = Value(title),
       description = Value(description),
       address = Value(address),
       priority = Value(priority),
       status = Value(status),
       latitude = Value(latitude),
       longitude = Value(longitude),
       scheduledAt = Value(scheduledAt),
       updatedAt = Value(updatedAt);
  static Insertable<WorkOrderData> custom({
    Expression<String>? id,
    Expression<String>? code,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? address,
    Expression<String>? priority,
    Expression<String>? status,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<DateTime>? scheduledAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (address != null) 'address': address,
      if (priority != null) 'priority': priority,
      if (status != null) 'status': status,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkOrdersCompanion copyWith({
    Value<String>? id,
    Value<String>? code,
    Value<String>? title,
    Value<String>? description,
    Value<String>? address,
    Value<String>? priority,
    Value<String>? status,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<DateTime>? scheduledAt,
    Value<DateTime>? updatedAt,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return WorkOrdersCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      description: description ?? this.description,
      address: address ?? this.address,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkOrdersCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('address: $address, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InspectionsTable extends Inspections
    with TableInfo<$InspectionsTable, InspectionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InspectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workOrderIdMeta = const VerificationMeta(
    'workOrderId',
  );
  @override
  late final GeneratedColumn<String> workOrderId = GeneratedColumn<String>(
    'work_order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _observationMeta = const VerificationMeta(
    'observation',
  );
  @override
  late final GeneratedColumn<String> observation = GeneratedColumn<String>(
    'observation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conditionMeta = const VerificationMeta(
    'condition',
  );
  @override
  late final GeneratedColumn<String> condition = GeneratedColumn<String>(
    'condition',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _capturedAtMeta = const VerificationMeta(
    'capturedAt',
  );
  @override
  late final GeneratedColumn<DateTime> capturedAt = GeneratedColumn<DateTime>(
    'captured_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoUrlMeta = const VerificationMeta(
    'photoUrl',
  );
  @override
  late final GeneratedColumn<String> photoUrl = GeneratedColumn<String>(
    'photo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientId,
    workOrderId,
    observation,
    condition,
    latitude,
    longitude,
    capturedAt,
    createdAt,
    photoPath,
    photoUrl,
    syncedAt,
    status,
    errorMessage,
    serverId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inspections';
  @override
  VerificationContext validateIntegrity(
    Insertable<InspectionData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('work_order_id')) {
      context.handle(
        _workOrderIdMeta,
        workOrderId.isAcceptableOrUnknown(
          data['work_order_id']!,
          _workOrderIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workOrderIdMeta);
    }
    if (data.containsKey('observation')) {
      context.handle(
        _observationMeta,
        observation.isAcceptableOrUnknown(
          data['observation']!,
          _observationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_observationMeta);
    }
    if (data.containsKey('condition')) {
      context.handle(
        _conditionMeta,
        condition.isAcceptableOrUnknown(data['condition']!, _conditionMeta),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('captured_at')) {
      context.handle(
        _capturedAtMeta,
        capturedAt.isAcceptableOrUnknown(data['captured_at']!, _capturedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_capturedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('photo_url')) {
      context.handle(
        _photoUrlMeta,
        photoUrl.isAcceptableOrUnknown(data['photo_url']!, _photoUrlMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InspectionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InspectionData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      workOrderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_order_id'],
      )!,
      observation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observation'],
      )!,
      condition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condition'],
      ),
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      capturedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}captured_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      photoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_url'],
      ),
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
    );
  }

  @override
  $InspectionsTable createAlias(String alias) {
    return $InspectionsTable(attachedDatabase, alias);
  }
}

class InspectionData extends DataClass implements Insertable<InspectionData> {
  final String id;
  final String clientId;
  final String workOrderId;
  final String observation;
  final String? condition;
  final double latitude;
  final double longitude;
  final DateTime capturedAt;
  final DateTime createdAt;
  final String? photoPath;
  final String? photoUrl;
  final DateTime? syncedAt;
  final String status;
  final String? errorMessage;
  final String? serverId;
  const InspectionData({
    required this.id,
    required this.clientId,
    required this.workOrderId,
    required this.observation,
    this.condition,
    required this.latitude,
    required this.longitude,
    required this.capturedAt,
    required this.createdAt,
    this.photoPath,
    this.photoUrl,
    this.syncedAt,
    required this.status,
    this.errorMessage,
    this.serverId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['client_id'] = Variable<String>(clientId);
    map['work_order_id'] = Variable<String>(workOrderId);
    map['observation'] = Variable<String>(observation);
    if (!nullToAbsent || condition != null) {
      map['condition'] = Variable<String>(condition);
    }
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['captured_at'] = Variable<DateTime>(capturedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || photoUrl != null) {
      map['photo_url'] = Variable<String>(photoUrl);
    }
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    return map;
  }

  InspectionsCompanion toCompanion(bool nullToAbsent) {
    return InspectionsCompanion(
      id: Value(id),
      clientId: Value(clientId),
      workOrderId: Value(workOrderId),
      observation: Value(observation),
      condition: condition == null && nullToAbsent
          ? const Value.absent()
          : Value(condition),
      latitude: Value(latitude),
      longitude: Value(longitude),
      capturedAt: Value(capturedAt),
      createdAt: Value(createdAt),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      photoUrl: photoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(photoUrl),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      status: Value(status),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
    );
  }

  factory InspectionData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InspectionData(
      id: serializer.fromJson<String>(json['id']),
      clientId: serializer.fromJson<String>(json['clientId']),
      workOrderId: serializer.fromJson<String>(json['workOrderId']),
      observation: serializer.fromJson<String>(json['observation']),
      condition: serializer.fromJson<String?>(json['condition']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      capturedAt: serializer.fromJson<DateTime>(json['capturedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      photoUrl: serializer.fromJson<String?>(json['photoUrl']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      status: serializer.fromJson<String>(json['status']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      serverId: serializer.fromJson<String?>(json['serverId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clientId': serializer.toJson<String>(clientId),
      'workOrderId': serializer.toJson<String>(workOrderId),
      'observation': serializer.toJson<String>(observation),
      'condition': serializer.toJson<String?>(condition),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'capturedAt': serializer.toJson<DateTime>(capturedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'photoPath': serializer.toJson<String?>(photoPath),
      'photoUrl': serializer.toJson<String?>(photoUrl),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'status': serializer.toJson<String>(status),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'serverId': serializer.toJson<String?>(serverId),
    };
  }

  InspectionData copyWith({
    String? id,
    String? clientId,
    String? workOrderId,
    String? observation,
    Value<String?> condition = const Value.absent(),
    double? latitude,
    double? longitude,
    DateTime? capturedAt,
    DateTime? createdAt,
    Value<String?> photoPath = const Value.absent(),
    Value<String?> photoUrl = const Value.absent(),
    Value<DateTime?> syncedAt = const Value.absent(),
    String? status,
    Value<String?> errorMessage = const Value.absent(),
    Value<String?> serverId = const Value.absent(),
  }) => InspectionData(
    id: id ?? this.id,
    clientId: clientId ?? this.clientId,
    workOrderId: workOrderId ?? this.workOrderId,
    observation: observation ?? this.observation,
    condition: condition.present ? condition.value : this.condition,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    capturedAt: capturedAt ?? this.capturedAt,
    createdAt: createdAt ?? this.createdAt,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    photoUrl: photoUrl.present ? photoUrl.value : this.photoUrl,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
    status: status ?? this.status,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
    serverId: serverId.present ? serverId.value : this.serverId,
  );
  InspectionData copyWithCompanion(InspectionsCompanion data) {
    return InspectionData(
      id: data.id.present ? data.id.value : this.id,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      workOrderId: data.workOrderId.present
          ? data.workOrderId.value
          : this.workOrderId,
      observation: data.observation.present
          ? data.observation.value
          : this.observation,
      condition: data.condition.present ? data.condition.value : this.condition,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      capturedAt: data.capturedAt.present
          ? data.capturedAt.value
          : this.capturedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      photoUrl: data.photoUrl.present ? data.photoUrl.value : this.photoUrl,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      status: data.status.present ? data.status.value : this.status,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InspectionData(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('workOrderId: $workOrderId, ')
          ..write('observation: $observation, ')
          ..write('condition: $condition, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('photoPath: $photoPath, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('status: $status, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clientId,
    workOrderId,
    observation,
    condition,
    latitude,
    longitude,
    capturedAt,
    createdAt,
    photoPath,
    photoUrl,
    syncedAt,
    status,
    errorMessage,
    serverId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InspectionData &&
          other.id == this.id &&
          other.clientId == this.clientId &&
          other.workOrderId == this.workOrderId &&
          other.observation == this.observation &&
          other.condition == this.condition &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.capturedAt == this.capturedAt &&
          other.createdAt == this.createdAt &&
          other.photoPath == this.photoPath &&
          other.photoUrl == this.photoUrl &&
          other.syncedAt == this.syncedAt &&
          other.status == this.status &&
          other.errorMessage == this.errorMessage &&
          other.serverId == this.serverId);
}

class InspectionsCompanion extends UpdateCompanion<InspectionData> {
  final Value<String> id;
  final Value<String> clientId;
  final Value<String> workOrderId;
  final Value<String> observation;
  final Value<String?> condition;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<DateTime> capturedAt;
  final Value<DateTime> createdAt;
  final Value<String?> photoPath;
  final Value<String?> photoUrl;
  final Value<DateTime?> syncedAt;
  final Value<String> status;
  final Value<String?> errorMessage;
  final Value<String?> serverId;
  final Value<int> rowid;
  const InspectionsCompanion({
    this.id = const Value.absent(),
    this.clientId = const Value.absent(),
    this.workOrderId = const Value.absent(),
    this.observation = const Value.absent(),
    this.condition = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.capturedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.serverId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InspectionsCompanion.insert({
    required String id,
    required String clientId,
    required String workOrderId,
    required String observation,
    this.condition = const Value.absent(),
    required double latitude,
    required double longitude,
    required DateTime capturedAt,
    required DateTime createdAt,
    this.photoPath = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.syncedAt = const Value.absent(),
    required String status,
    this.errorMessage = const Value.absent(),
    this.serverId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clientId = Value(clientId),
       workOrderId = Value(workOrderId),
       observation = Value(observation),
       latitude = Value(latitude),
       longitude = Value(longitude),
       capturedAt = Value(capturedAt),
       createdAt = Value(createdAt),
       status = Value(status);
  static Insertable<InspectionData> custom({
    Expression<String>? id,
    Expression<String>? clientId,
    Expression<String>? workOrderId,
    Expression<String>? observation,
    Expression<String>? condition,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<DateTime>? capturedAt,
    Expression<DateTime>? createdAt,
    Expression<String>? photoPath,
    Expression<String>? photoUrl,
    Expression<DateTime>? syncedAt,
    Expression<String>? status,
    Expression<String>? errorMessage,
    Expression<String>? serverId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientId != null) 'client_id': clientId,
      if (workOrderId != null) 'work_order_id': workOrderId,
      if (observation != null) 'observation': observation,
      if (condition != null) 'condition': condition,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (capturedAt != null) 'captured_at': capturedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (photoPath != null) 'photo_path': photoPath,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (status != null) 'status': status,
      if (errorMessage != null) 'error_message': errorMessage,
      if (serverId != null) 'server_id': serverId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InspectionsCompanion copyWith({
    Value<String>? id,
    Value<String>? clientId,
    Value<String>? workOrderId,
    Value<String>? observation,
    Value<String?>? condition,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<DateTime>? capturedAt,
    Value<DateTime>? createdAt,
    Value<String?>? photoPath,
    Value<String?>? photoUrl,
    Value<DateTime?>? syncedAt,
    Value<String>? status,
    Value<String?>? errorMessage,
    Value<String?>? serverId,
    Value<int>? rowid,
  }) {
    return InspectionsCompanion(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      workOrderId: workOrderId ?? this.workOrderId,
      observation: observation ?? this.observation,
      condition: condition ?? this.condition,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      capturedAt: capturedAt ?? this.capturedAt,
      createdAt: createdAt ?? this.createdAt,
      photoPath: photoPath ?? this.photoPath,
      photoUrl: photoUrl ?? this.photoUrl,
      syncedAt: syncedAt ?? this.syncedAt,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      serverId: serverId ?? this.serverId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (workOrderId.present) {
      map['work_order_id'] = Variable<String>(workOrderId.value);
    }
    if (observation.present) {
      map['observation'] = Variable<String>(observation.value);
    }
    if (condition.present) {
      map['condition'] = Variable<String>(condition.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (capturedAt.present) {
      map['captured_at'] = Variable<DateTime>(capturedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (photoUrl.present) {
      map['photo_url'] = Variable<String>(photoUrl.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InspectionsCompanion(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('workOrderId: $workOrderId, ')
          ..write('observation: $observation, ')
          ..write('condition: $condition, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('photoPath: $photoPath, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('status: $status, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('serverId: $serverId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WorkOrdersTable workOrders = $WorkOrdersTable(this);
  late final $InspectionsTable inspections = $InspectionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [workOrders, inspections];
}

typedef $$WorkOrdersTableCreateCompanionBuilder = WorkOrdersCompanion Function({
  required String id,
  required String code,
  required String title,
  required String description,
  required String address,
  required String priority,
  required String status,
  required double latitude,
  required double longitude,
  required DateTime scheduledAt,
  required DateTime updatedAt,
  Value<String?> notes,
  Value<int> rowid,
});
typedef $$WorkOrdersTableUpdateCompanionBuilder = WorkOrdersCompanion Function({
  Value<String> id,
  Value<String> code,
  Value<String> title,
  Value<String> description,
  Value<String> address,
  Value<String> priority,
  Value<String> status,
  Value<double> latitude,
  Value<double> longitude,
  Value<DateTime> scheduledAt,
  Value<DateTime> updatedAt,
  Value<String?> notes,
  Value<int> rowid,
});

class $$WorkOrdersTableFilterComposer
    extends Composer<_$AppDatabase, $WorkOrdersTable> {
  $$WorkOrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkOrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkOrdersTable> {
  $$WorkOrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkOrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkOrdersTable> {
  $$WorkOrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$WorkOrdersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkOrdersTable,
          WorkOrderData,
          $$WorkOrdersTableFilterComposer,
          $$WorkOrdersTableOrderingComposer,
          $$WorkOrdersTableAnnotationComposer,
          $$WorkOrdersTableCreateCompanionBuilder,
          $$WorkOrdersTableUpdateCompanionBuilder,
          (
            WorkOrderData,
            BaseReferences<_$AppDatabase, $WorkOrdersTable, WorkOrderData>,
          ),
          WorkOrderData,
          PrefetchHooks Function()
        > {
  $$WorkOrdersTableTableManager(_$AppDatabase db, $WorkOrdersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkOrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkOrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkOrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<DateTime> scheduledAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkOrdersCompanion(
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
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String code,
                required String title,
                required String description,
                required String address,
                required String priority,
                required String status,
                required double latitude,
                required double longitude,
                required DateTime scheduledAt,
                required DateTime updatedAt,
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkOrdersCompanion.insert(
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
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkOrdersTable, WorkOrderData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $WorkOrdersTable,
                    WorkOrderData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkOrdersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkOrdersTable,
      WorkOrderData,
      $$WorkOrdersTableFilterComposer,
      $$WorkOrdersTableOrderingComposer,
      $$WorkOrdersTableAnnotationComposer,
      $$WorkOrdersTableCreateCompanionBuilder,
      $$WorkOrdersTableUpdateCompanionBuilder,
      (
        WorkOrderData,
        BaseReferences<_$AppDatabase, $WorkOrdersTable, WorkOrderData>,
      ),
      WorkOrderData,
      PrefetchHooks Function()
    >;
typedef $$InspectionsTableCreateCompanionBuilder =
    InspectionsCompanion Function({
      required String id,
      required String clientId,
      required String workOrderId,
      required String observation,
      Value<String?> condition,
      required double latitude,
      required double longitude,
      required DateTime capturedAt,
      required DateTime createdAt,
      Value<String?> photoPath,
      Value<String?> photoUrl,
      Value<DateTime?> syncedAt,
      required String status,
      Value<String?> errorMessage,
      Value<String?> serverId,
      Value<int> rowid,
    });
typedef $$InspectionsTableUpdateCompanionBuilder =
    InspectionsCompanion Function({
      Value<String> id,
      Value<String> clientId,
      Value<String> workOrderId,
      Value<String> observation,
      Value<String?> condition,
      Value<double> latitude,
      Value<double> longitude,
      Value<DateTime> capturedAt,
      Value<DateTime> createdAt,
      Value<String?> photoPath,
      Value<String?> photoUrl,
      Value<DateTime?> syncedAt,
      Value<String> status,
      Value<String?> errorMessage,
      Value<String?> serverId,
      Value<int> rowid,
    });

class $$InspectionsTableFilterComposer
    extends Composer<_$AppDatabase, $InspectionsTable> {
  $$InspectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workOrderId => $composableBuilder(
    column: $table.workOrderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observation => $composableBuilder(
    column: $table.observation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InspectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $InspectionsTable> {
  $$InspectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workOrderId => $composableBuilder(
    column: $table.workOrderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observation => $composableBuilder(
    column: $table.observation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InspectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InspectionsTable> {
  $$InspectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get workOrderId => $composableBuilder(
    column: $table.workOrderId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get observation => $composableBuilder(
    column: $table.observation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get condition =>
      $composableBuilder(column: $table.condition, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get photoUrl =>
      $composableBuilder(column: $table.photoUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);
}

class $$InspectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InspectionsTable,
          InspectionData,
          $$InspectionsTableFilterComposer,
          $$InspectionsTableOrderingComposer,
          $$InspectionsTableAnnotationComposer,
          $$InspectionsTableCreateCompanionBuilder,
          $$InspectionsTableUpdateCompanionBuilder,
          (
            InspectionData,
            BaseReferences<_$AppDatabase, $InspectionsTable, InspectionData>,
          ),
          InspectionData,
          PrefetchHooks Function()
        > {
  $$InspectionsTableTableManager(_$AppDatabase db, $InspectionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InspectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InspectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InspectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> clientId = const Value.absent(),
                Value<String> workOrderId = const Value.absent(),
                Value<String> observation = const Value.absent(),
                Value<String?> condition = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<DateTime> capturedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String?> photoUrl = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InspectionsCompanion(
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
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String clientId,
                required String workOrderId,
                required String observation,
                Value<String?> condition = const Value.absent(),
                required double latitude,
                required double longitude,
                required DateTime capturedAt,
                required DateTime createdAt,
                Value<String?> photoPath = const Value.absent(),
                Value<String?> photoUrl = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                required String status,
                Value<String?> errorMessage = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InspectionsCompanion.insert(
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
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InspectionsTable, InspectionData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $InspectionsTable,
                    InspectionData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InspectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InspectionsTable,
      InspectionData,
      $$InspectionsTableFilterComposer,
      $$InspectionsTableOrderingComposer,
      $$InspectionsTableAnnotationComposer,
      $$InspectionsTableCreateCompanionBuilder,
      $$InspectionsTableUpdateCompanionBuilder,
      (
        InspectionData,
        BaseReferences<_$AppDatabase, $InspectionsTable, InspectionData>,
      ),
      InspectionData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WorkOrdersTableTableManager get workOrders =>
      $$WorkOrdersTableTableManager(_db, _db.workOrders);
  $$InspectionsTableTableManager get inspections =>
      $$InspectionsTableTableManager(_db, _db.inspections);
}

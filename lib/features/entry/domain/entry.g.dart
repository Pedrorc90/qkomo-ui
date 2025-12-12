// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EntryAdapter extends TypeAdapter<_$EntryImpl> {
  @override
  final int typeId = 8;

  @override
  _$EntryImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$EntryImpl(
      id: fields[0] as String,
      result: fields[1] as CaptureResult,
      syncStatus: fields[2] as SyncStatus,
      lastModifiedAt: fields[3] as DateTime,
      lastSyncedAt: fields[4] as DateTime?,
      isDeleted: fields[5] as bool,
      cloudVersion: fields[6] as int?,
      pendingChanges: (fields[7] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, _$EntryImpl obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.result)
      ..writeByte(2)
      ..write(obj.syncStatus)
      ..writeByte(3)
      ..write(obj.lastModifiedAt)
      ..writeByte(4)
      ..write(obj.lastSyncedAt)
      ..writeByte(5)
      ..write(obj.isDeleted)
      ..writeByte(6)
      ..write(obj.cloudVersion)
      ..writeByte(7)
      ..write(obj.pendingChanges);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EntryImpl _$$EntryImplFromJson(Map<String, dynamic> json) => _$EntryImpl(
      id: json['id'] as String,
      result: CaptureResult.fromJson(json['result'] as Map<String, dynamic>),
      syncStatus:
          $enumDecodeNullable(_$SyncStatusEnumMap, json['syncStatus']) ??
              SyncStatus.pending,
      lastModifiedAt: DateTime.parse(json['lastModifiedAt'] as String),
      lastSyncedAt: json['lastSyncedAt'] == null
          ? null
          : DateTime.parse(json['lastSyncedAt'] as String),
      isDeleted: json['isDeleted'] as bool? ?? false,
      cloudVersion: (json['cloudVersion'] as num?)?.toInt(),
      pendingChanges: json['pendingChanges'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$EntryImplToJson(_$EntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'result': instance.result,
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus]!,
      'lastModifiedAt': instance.lastModifiedAt.toIso8601String(),
      'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
      'isDeleted': instance.isDeleted,
      'cloudVersion': instance.cloudVersion,
      'pendingChanges': instance.pendingChanges,
    };

const _$SyncStatusEnumMap = {
  SyncStatus.synced: 'synced',
  SyncStatus.pending: 'pending',
  SyncStatus.failed: 'failed',
  SyncStatus.conflict: 'conflict',
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_menu.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeeklyMenuAdapter extends TypeAdapter<_$WeeklyMenuImpl> {
  @override
  final int typeId = 15;

  @override
  _$WeeklyMenuImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$WeeklyMenuImpl(
      weekStart: fields[0] as DateTime,
      status: fields[1] as WeeklyMenuStatus,
      days: (fields[2] as List).cast<WeeklyMenuDay>(),
      userId: fields[3] as String,
      syncStatus: fields[4] as SyncStatus,
      lastModifiedAt: fields[5] as DateTime,
      lastSyncedAt: fields[6] as DateTime?,
      isDeleted: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, _$WeeklyMenuImpl obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.weekStart)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.userId)
      ..writeByte(4)
      ..write(obj.syncStatus)
      ..writeByte(5)
      ..write(obj.lastModifiedAt)
      ..writeByte(6)
      ..write(obj.lastSyncedAt)
      ..writeByte(7)
      ..write(obj.isDeleted)
      ..writeByte(2)
      ..write(obj.days);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeeklyMenuAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeeklyMenuImpl _$$WeeklyMenuImplFromJson(Map<String, dynamic> json) =>
    _$WeeklyMenuImpl(
      weekStart: DateTime.parse(json['weekStart'] as String),
      status: $enumDecode(_$WeeklyMenuStatusEnumMap, json['status']),
      days: (json['days'] as List<dynamic>)
          .map((e) => WeeklyMenuDay.fromJson(e as Map<String, dynamic>))
          .toList(),
      userId: json['userId'] as String,
      syncStatus:
          $enumDecodeNullable(_$SyncStatusEnumMap, json['syncStatus']) ??
              SyncStatus.pending,
      lastModifiedAt: DateTime.parse(json['lastModifiedAt'] as String),
      lastSyncedAt: json['lastSyncedAt'] == null
          ? null
          : DateTime.parse(json['lastSyncedAt'] as String),
      isDeleted: json['isDeleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$WeeklyMenuImplToJson(_$WeeklyMenuImpl instance) =>
    <String, dynamic>{
      'weekStart': instance.weekStart.toIso8601String(),
      'status': instance.status,
      'days': instance.days,
      'userId': instance.userId,
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus]!,
      'lastModifiedAt': instance.lastModifiedAt.toIso8601String(),
      'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
      'isDeleted': instance.isDeleted,
    };

const _$WeeklyMenuStatusEnumMap = {
  WeeklyMenuStatus.generating: 'generating',
  WeeklyMenuStatus.ready: 'ready',
  WeeklyMenuStatus.failed: 'failed',
};

const _$SyncStatusEnumMap = {
  SyncStatus.synced: 'synced',
  SyncStatus.pending: 'pending',
  SyncStatus.failed: 'failed',
  SyncStatus.conflict: 'conflict',
};

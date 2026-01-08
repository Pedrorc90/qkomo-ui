// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'companion.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CompanionImplAdapter extends TypeAdapter<_$CompanionImpl> {
  @override
  final int typeId = 9;

  @override
  _$CompanionImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$CompanionImpl(
      id: fields[0] as String,
      userId: fields[1] as String,
      email: fields[2] as String,
      displayName: fields[3] as String?,
      photoUrl: fields[4] as String?,
      isPending: fields[5] as bool,
      syncStatus: fields[6] as SyncStatus,
      lastModifiedAt: fields[7] as DateTime,
      lastSyncedAt: fields[8] as DateTime?,
      isDeleted: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, _$CompanionImpl obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.displayName)
      ..writeByte(4)
      ..write(obj.photoUrl)
      ..writeByte(5)
      ..write(obj.isPending)
      ..writeByte(6)
      ..write(obj.syncStatus)
      ..writeByte(7)
      ..write(obj.lastModifiedAt)
      ..writeByte(8)
      ..write(obj.lastSyncedAt)
      ..writeByte(9)
      ..write(obj.isDeleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompanionImplAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompanionImpl _$$CompanionImplFromJson(Map<String, dynamic> json) =>
    _$CompanionImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      isPending: json['isPending'] as bool? ?? false,
      syncStatus:
          $enumDecodeNullable(_$SyncStatusEnumMap, json['syncStatus']) ??
              SyncStatus.pending,
      lastModifiedAt: DateTime.parse(json['lastModifiedAt'] as String),
      lastSyncedAt: json['lastSyncedAt'] == null
          ? null
          : DateTime.parse(json['lastSyncedAt'] as String),
      isDeleted: json['isDeleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$CompanionImplToJson(_$CompanionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'email': instance.email,
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
      'isPending': instance.isPending,
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus]!,
      'lastModifiedAt': instance.lastModifiedAt.toIso8601String(),
      'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
      'isDeleted': instance.isDeleted,
    };

const _$SyncStatusEnumMap = {
  SyncStatus.pending: 'pending',
  SyncStatus.synced: 'synced',
  SyncStatus.failed: 'failed',
  SyncStatus.localOnly: 'localOnly',
  SyncStatus.conflict: 'conflict',
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileImplAdapter extends TypeAdapter<_$UserProfileImpl> {
  @override
  final int typeId = 25;

  @override
  _$UserProfileImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$UserProfileImpl(
      firebaseUid: fields[0] as String,
      email: fields[1] as String,
      displayName: fields[2] as String?,
      photoUrl: fields[3] as String?,
      lastLoginAt: fields[4] as DateTime?,
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime,
      syncStatus: fields[7] as SyncStatus,
      lastSyncedAt: fields[8] as DateTime?,
      isDeleted: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, _$UserProfileImpl obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.firebaseUid)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.displayName)
      ..writeByte(3)
      ..write(obj.photoUrl)
      ..writeByte(4)
      ..write(obj.lastLoginAt)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.syncStatus)
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
      other is UserProfileImplAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      firebaseUid: json['firebaseUid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      lastLoginAt: json['lastLoginAt'] == null
          ? null
          : DateTime.parse(json['lastLoginAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      syncStatus:
          $enumDecodeNullable(_$SyncStatusEnumMap, json['syncStatus']) ??
              SyncStatus.pending,
      lastSyncedAt: json['lastSyncedAt'] == null
          ? null
          : DateTime.parse(json['lastSyncedAt'] as String),
      isDeleted: json['isDeleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'firebaseUid': instance.firebaseUid,
      'email': instance.email,
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
      'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus]!,
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

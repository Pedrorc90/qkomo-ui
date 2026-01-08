// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SyncStatusAdapter extends TypeAdapter<SyncStatus> {
  @override
  final int typeId = 26;

  @override
  SyncStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SyncStatus.pending;
      case 1:
        return SyncStatus.synced;
      case 2:
        return SyncStatus.failed;
      case 3:
        return SyncStatus.localOnly;
      case 4:
        return SyncStatus.conflict;
      default:
        return SyncStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, SyncStatus obj) {
    switch (obj) {
      case SyncStatus.pending:
        writer.writeByte(0);
        break;
      case SyncStatus.synced:
        writer.writeByte(1);
        break;
      case SyncStatus.failed:
        writer.writeByte(2);
        break;
      case SyncStatus.localOnly:
        writer.writeByte(3);
        break;
      case SyncStatus.conflict:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

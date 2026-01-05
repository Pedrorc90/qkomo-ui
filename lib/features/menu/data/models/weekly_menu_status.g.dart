// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_menu_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeeklyMenuStatusAdapter extends TypeAdapter<WeeklyMenuStatus> {
  @override
  final int typeId = 11;

  @override
  WeeklyMenuStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WeeklyMenuStatus.generating;
      case 1:
        return WeeklyMenuStatus.ready;
      case 2:
        return WeeklyMenuStatus.failed;
      default:
        return WeeklyMenuStatus.generating;
    }
  }

  @override
  void write(BinaryWriter writer, WeeklyMenuStatus obj) {
    switch (obj) {
      case WeeklyMenuStatus.generating:
        writer.writeByte(0);
        break;
      case WeeklyMenuStatus.ready:
        writer.writeByte(1);
        break;
      case WeeklyMenuStatus.failed:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeeklyMenuStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_meal_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeeklyMealTypeAdapter extends TypeAdapter<WeeklyMealType> {
  @override
  final int typeId = 12;

  @override
  WeeklyMealType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WeeklyMealType.lunch;
      case 1:
        return WeeklyMealType.dinner;
      default:
        return WeeklyMealType.lunch;
    }
  }

  @override
  void write(BinaryWriter writer, WeeklyMealType obj) {
    switch (obj) {
      case WeeklyMealType.lunch:
        writer.writeByte(0);
        break;
      case WeeklyMealType.dinner:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeeklyMealTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

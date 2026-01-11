// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppThemeTypeAdapter extends TypeAdapter<AppThemeType> {
  @override
  final int typeId = 10;

  @override
  AppThemeType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppThemeType.forest;
      case 1:
        return AppThemeType.dark;
      default:
        return AppThemeType.forest;
    }
  }

  @override
  void write(BinaryWriter writer, AppThemeType obj) {
    switch (obj) {
      case AppThemeType.forest:
        writer.writeByte(0);
        break;
      case AppThemeType.dark:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppThemeTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

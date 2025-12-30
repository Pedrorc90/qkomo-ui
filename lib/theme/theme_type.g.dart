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
        return AppThemeType.warm;
      case 1:
        return AppThemeType.offWhite;
      case 2:
        return AppThemeType.dark;
      case 3:
        return AppThemeType.forest;
      case 4:
        return AppThemeType.indigo;
      default:
        return AppThemeType.warm;
    }
  }

  @override
  void write(BinaryWriter writer, AppThemeType obj) {
    switch (obj) {
      case AppThemeType.warm:
        writer.writeByte(0);
        break;
      case AppThemeType.offWhite:
        writer.writeByte(1);
        break;
      case AppThemeType.dark:
        writer.writeByte(2);
        break;
      case AppThemeType.forest:
        writer.writeByte(3);
        break;
      case AppThemeType.indigo:
        writer.writeByte(4);
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

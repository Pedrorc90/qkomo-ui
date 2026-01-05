// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_menu_day.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeeklyMenuDayAdapter extends TypeAdapter<_$WeeklyMenuDayImpl> {
  @override
  final int typeId = 14;

  @override
  _$WeeklyMenuDayImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$WeeklyMenuDayImpl(
      date: fields[0] as DateTime,
      items: (fields[1] as List).cast<WeeklyMenuItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, _$WeeklyMenuDayImpl obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeeklyMenuDayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeeklyMenuDayImpl _$$WeeklyMenuDayImplFromJson(Map<String, dynamic> json) =>
    _$WeeklyMenuDayImpl(
      date: DateTime.parse(json['date'] as String),
      items: (json['items'] as List<dynamic>)
          .map((e) => WeeklyMenuItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$WeeklyMenuDayImplToJson(_$WeeklyMenuDayImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'items': instance.items,
    };

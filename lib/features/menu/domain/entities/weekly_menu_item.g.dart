// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_menu_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeeklyMenuItemAdapter extends TypeAdapter<_$WeeklyMenuItemImpl> {
  @override
  final int typeId = 13;

  @override
  _$WeeklyMenuItemImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$WeeklyMenuItemImpl(
      mealType: fields[0] as WeeklyMealType,
      dishName: fields[1] as String,
      description: fields[2] as String?,
      ingredients: (fields[3] as List).cast<String>(),
      imageUrl: fields[4] as String?,
      constraintsOk: fields[5] as bool,
      violations: (fields[6] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, _$WeeklyMenuItemImpl obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.mealType)
      ..writeByte(1)
      ..write(obj.dishName)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.constraintsOk)
      ..writeByte(3)
      ..write(obj.ingredients)
      ..writeByte(6)
      ..write(obj.violations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeeklyMenuItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeeklyMenuItemImpl _$$WeeklyMenuItemImplFromJson(Map<String, dynamic> json) =>
    _$WeeklyMenuItemImpl(
      mealType: $enumDecode(_$WeeklyMealTypeEnumMap, json['mealType']),
      dishName: json['dishName'] as String,
      description: json['description'] as String?,
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      imageUrl: json['imageUrl'] as String?,
      constraintsOk: json['constraintsOk'] as bool,
      violations: (json['violations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$WeeklyMenuItemImplToJson(
        _$WeeklyMenuItemImpl instance) =>
    <String, dynamic>{
      'mealType': instance.mealType,
      'dishName': instance.dishName,
      'description': instance.description,
      'ingredients': instance.ingredients,
      'imageUrl': instance.imageUrl,
      'constraintsOk': instance.constraintsOk,
      'violations': instance.violations,
    };

const _$WeeklyMealTypeEnumMap = {
  WeeklyMealType.lunch: 'lunch',
  WeeklyMealType.dinner: 'dinner',
};

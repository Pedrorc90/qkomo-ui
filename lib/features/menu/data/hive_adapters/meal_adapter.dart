import 'package:hive/hive.dart';
import 'package:qkomo_ui/features/menu/domain/meal.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';

class MealAdapter extends TypeAdapter<Meal> {
  @override
  final int typeId = 5;

  @override
  Meal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Meal(
      id: fields[0] as String,
      name: fields[1] as String,
      ingredients: (fields[2] as List).cast<String>(),
      mealType: MealType.values[fields[3] as int],
      scheduledFor: fields[4] as DateTime,
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime?,
      notes: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Meal obj) {
    writer
      ..writeByte(8) // Number of fields
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.ingredients)
      ..writeByte(3)
      ..write(obj.mealType.index)
      ..writeByte(4)
      ..write(obj.scheduledFor)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.notes);
  }
}

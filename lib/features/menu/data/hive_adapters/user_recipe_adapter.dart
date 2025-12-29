import 'package:hive/hive.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';
import 'package:qkomo_ui/features/menu/domain/user_recipe.dart';

class UserRecipeAdapter extends TypeAdapter<UserRecipe> {
  @override
  final int typeId = 7;

  @override
  UserRecipe read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserRecipe(
      id: fields[0] as String,
      userId: fields[1] as String,
      name: fields[2] as String,
      ingredients: (fields[3] as List).cast<String>(),
      mealType: MealType.values[fields[4] as int],
      createdAt: fields[5] as DateTime,
      photoPath: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserRecipe obj) {
    writer
      ..writeByte(7) // Number of fields
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.ingredients)
      ..writeByte(4)
      ..write(obj.mealType.index)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.photoPath);
  }
}

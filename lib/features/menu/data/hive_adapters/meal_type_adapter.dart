import 'package:hive/hive.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';

class MealTypeAdapter extends TypeAdapter<MealType> {
  @override
  final int typeId = 25;

  @override
  MealType read(BinaryReader reader) {
    return MealType.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, MealType obj) {
    writer.writeByte(obj.index);
  }
}

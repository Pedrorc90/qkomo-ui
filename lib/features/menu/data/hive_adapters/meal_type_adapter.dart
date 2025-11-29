import 'package:hive/hive.dart';
import '../../domain/meal_type.dart';

class MealTypeAdapter extends TypeAdapter<MealType> {
  @override
  final int typeId = 6;

  @override
  MealType read(BinaryReader reader) {
    return MealType.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, MealType obj) {
    writer.writeByte(obj.index);
  }
}

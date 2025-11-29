import 'package:hive/hive.dart';

import '../../domain/capture_result.dart';
import '../../../menu/domain/meal_type.dart';

class CaptureResultAdapter extends TypeAdapter<CaptureResult> {
  @override
  final int typeId = 2;

  @override
  CaptureResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CaptureResult(
      jobId: fields[0] as String,
      savedAt: fields[1] as DateTime,
      ingredients: (fields[2] as List).cast<String>(),
      allergens: (fields[3] as List).cast<String>(),
      notes: fields[4] as String?,
      title: fields[5] as String?,
      mealType: fields[6] != null ? MealType.values[fields[6] as int] : null,
      isManualEntry: fields[7] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, CaptureResult obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.jobId)
      ..writeByte(1)
      ..write(obj.savedAt)
      ..writeByte(2)
      ..write(obj.ingredients)
      ..writeByte(3)
      ..write(obj.allergens)
      ..writeByte(4)
      ..write(obj.notes)
      ..writeByte(5)
      ..write(obj.title)
      ..writeByte(6)
      ..write(obj.mealType?.index)
      ..writeByte(7)
      ..write(obj.isManualEntry);
  }
}

import 'package:hive/hive.dart';

import 'package:qkomo_ui/features/capture/domain/capture_result.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';

class CaptureResultAdapter extends TypeAdapter<CaptureResult> {
  @override
  final int typeId = 2;

  @override
  CaptureResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    // Parse nested objects from JSON maps if they exist
    final nutrition = fields[12] != null
        ? CaptureNutrition.fromJson((fields[12] as Map).cast<String, dynamic>())
        : null;

    return CaptureResult(
      jobId: fields[0] as String,
      savedAt: fields[1] as DateTime,
      ingredients: (fields[2] as List).cast<String>(),
      allergens: (fields[3] as List).cast<String>(),
      notes: fields[4] as String?,
      title: fields[5] as String?,
      mealType: fields[6] != null ? MealType.values[fields[6] as int] : null,
      isManualEntry: fields[7] as bool? ?? false,
      isReviewed: fields[8] as bool? ?? false,
      reviewedAt: fields[9] as DateTime?,
      userEdited: fields[10] as bool? ?? false,
      // New fields with backward compatibility
      estimatedPortionG: fields[11] as int?,
      nutrition: nutrition,
      imagePath: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CaptureResult obj) {
    writer
      ..writeByte(13) // Updated field count
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
      ..write(obj.isManualEntry)
      ..writeByte(8)
      ..write(obj.isReviewed)
      ..writeByte(9)
      ..write(obj.reviewedAt)
      ..writeByte(10)
      ..write(obj.userEdited)
      // New fields
      ..writeByte(11)
      ..write(obj.estimatedPortionG)
      ..writeByte(12)
      ..write(obj.nutrition?.toJson())
      ..writeByte(15)
      ..write(obj.imagePath);
  }
}

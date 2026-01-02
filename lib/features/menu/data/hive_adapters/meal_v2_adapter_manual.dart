import 'package:hive/hive.dart';
import 'package:qkomo_ui/features/entry/domain/entities/sync_status.dart';
import 'package:qkomo_ui/features/menu/domain/meal.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';

/// Manual adapter for Meal - bypasses Freezed generation issues
class MealV2AdapterManual extends TypeAdapter<Meal> {
  @override
  final int typeId = 6;

  @override
  Meal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return Meal(
      id: fields[0] as String,
      userId: fields[1] as String,
      name: fields[2] as String,
      ingredients: (fields[3] as List).cast<String>(),
      mealType: fields[4] as MealType,
      scheduledFor: fields[5] as DateTime,
      createdAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime?,
      notes: fields[8] as String?,
      photoPath: fields[9] as String?,
      syncStatus: fields[10] as SyncStatus,
      lastModifiedAt: fields[11] as DateTime,
      lastSyncedAt: fields[12] as DateTime?,
      isDeleted: fields[13] as bool,
      cloudVersion: fields[14] as int?,
      pendingChanges: (fields[15] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Meal obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.ingredients)
      ..writeByte(4)
      ..write(obj.mealType)
      ..writeByte(5)
      ..write(obj.scheduledFor)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.notes)
      ..writeByte(9)
      ..write(obj.photoPath)
      ..writeByte(10)
      ..write(obj.syncStatus)
      ..writeByte(11)
      ..write(obj.lastModifiedAt)
      ..writeByte(12)
      ..write(obj.lastSyncedAt)
      ..writeByte(13)
      ..write(obj.isDeleted)
      ..writeByte(14)
      ..write(obj.cloudVersion)
      ..writeByte(15)
      ..write(obj.pendingChanges);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealV2AdapterManual &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

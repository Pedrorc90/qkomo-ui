import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:qkomo_ui/features/entry/domain/sync_status.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';

part 'meal.freezed.dart';
part 'meal.g.dart';

@freezed
class Meal with _$Meal {
  @HiveType(typeId: 6, adapterName: 'MealV2Adapter')
  const factory Meal({
    @HiveField(0) required String id,
    @HiveField(1) required String userId,
    @HiveField(2) required String name,
    @HiveField(3) required List<String> ingredients,
    @HiveField(4) required MealType mealType,
    @HiveField(5) required DateTime scheduledFor,
    @HiveField(6) required DateTime createdAt,
    @HiveField(7) DateTime? updatedAt,
    @HiveField(8) String? notes,
    @HiveField(9) String? photoPath,
    // Sync fields
    @HiveField(10) @Default(SyncStatus.pending) SyncStatus syncStatus,
    @HiveField(11) required DateTime lastModifiedAt,
    @HiveField(12) DateTime? lastSyncedAt,
    @HiveField(13) @Default(false) bool isDeleted,
    @HiveField(14) int? cloudVersion,
    @HiveField(15) Map<String, dynamic>? pendingChanges,
  }) = _Meal;

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);
}

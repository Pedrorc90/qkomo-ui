import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:qkomo_ui/features/menu/domain/meal_type.dart';

part 'capture_result.freezed.dart';
part 'capture_result.g.dart';

@freezed
class CaptureResult with _$CaptureResult {
  const factory CaptureResult({
    required String jobId,
    required DateTime savedAt,
    @Default([]) List<String> ingredients,
    @Default([]) List<String> allergens,
    String? notes,
    String? title,
    MealType? mealType,
    @Default(false) bool isManualEntry,
    @Default(false) bool isReviewed,
    DateTime? reviewedAt,
    @Default(false) bool userEdited,
    // New fields
    int? estimatedPortionG,
    CaptureNutrition? nutrition,
    String? imagePath,
  }) = _CaptureResult;

  factory CaptureResult.fromJson(Map<String, dynamic> json) =>
      _$CaptureResultFromJson(json);
}

@freezed
class CaptureNutrition with _$CaptureNutrition {
  const factory CaptureNutrition({
    int? calories,
    double? proteinsG,
    double? carbohydratesG,
    double? fatsG,
    double? fiberG,
  }) = _CaptureNutrition;

  factory CaptureNutrition.fromJson(Map<String, dynamic> json) =>
      _$CaptureNutritionFromJson(json);
}

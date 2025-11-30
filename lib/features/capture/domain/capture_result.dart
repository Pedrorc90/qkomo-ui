import 'package:qkomo_ui/features/menu/domain/meal_type.dart';

class CaptureResult {
  CaptureResult({
    required this.jobId,
    required this.savedAt,
    this.ingredients = const [],
    this.allergens = const [],
    this.notes,
    this.title,
    this.mealType,
    this.isManualEntry = false,
    this.isReviewed = false,
    this.reviewedAt,
    this.userEdited = false,
  });

  final String jobId;
  final DateTime savedAt;
  final List<String> ingredients;
  final List<String> allergens;
  final String? notes;
  final String? title;
  final MealType? mealType;
  final bool isManualEntry;
  final bool isReviewed;
  final DateTime? reviewedAt;
  final bool userEdited;

  CaptureResult copyWith({
    String? jobId,
    DateTime? savedAt,
    List<String>? ingredients,
    List<String>? allergens,
    String? notes,
    String? title,
    MealType? mealType,
    bool? isManualEntry,
    bool? isReviewed,
    DateTime? reviewedAt,
    bool? userEdited,
  }) {
    return CaptureResult(
      jobId: jobId ?? this.jobId,
      savedAt: savedAt ?? this.savedAt,
      ingredients: ingredients ?? this.ingredients,
      allergens: allergens ?? this.allergens,
      notes: notes ?? this.notes,
      title: title ?? this.title,
      mealType: mealType ?? this.mealType,
      isManualEntry: isManualEntry ?? this.isManualEntry,
      isReviewed: isReviewed ?? this.isReviewed,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      userEdited: userEdited ?? this.userEdited,
    );
  }
}

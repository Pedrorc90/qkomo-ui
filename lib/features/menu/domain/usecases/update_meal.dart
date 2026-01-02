import 'package:qkomo_ui/features/entry/domain/entities/sync_status.dart';
import 'package:qkomo_ui/features/menu/domain/meal_repository.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';

/// Parameters for updating a meal
class UpdateMealParams {
  const UpdateMealParams({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.mealType,
    required this.scheduledFor,
    this.notes,
    this.photoPath,
  });

  final String id;
  final String name;
  final List<String> ingredients;
  final MealType mealType;
  final DateTime scheduledFor;
  final String? notes;
  final String? photoPath;
}

/// UseCase: Update an existing meal
///
/// Updates meal data and marks it as pending sync.
class UpdateMeal {
  UpdateMeal(this._repository);

  final MealRepository _repository;

  Future<void> call(UpdateMealParams params) async {
    final existing = await _repository.getMealById(params.id);
    if (existing == null) {
      throw Exception('Meal not found: ${params.id}');
    }

    final now = DateTime.now();
    final updated = existing.copyWith(
      name: params.name,
      ingredients: params.ingredients,
      mealType: params.mealType,
      scheduledFor: params.scheduledFor,
      notes: params.notes,
      photoPath: params.photoPath,
      updatedAt: now,
      lastModifiedAt: now,
      syncStatus: SyncStatus.pending,
    );

    await _repository.saveMeal(updated);
  }
}

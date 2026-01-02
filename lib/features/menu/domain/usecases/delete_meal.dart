import 'package:qkomo_ui/features/menu/domain/meal_repository.dart';

/// UseCase: Delete a meal
///
/// Performs soft delete, marking the meal as deleted.
class DeleteMeal {
  DeleteMeal(this._repository);

  final MealRepository _repository;

  Future<void> call(String mealId) async {
    await _repository.deleteMeal(mealId);
  }
}

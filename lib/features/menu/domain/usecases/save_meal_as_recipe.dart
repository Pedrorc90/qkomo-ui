import 'package:qkomo_ui/features/menu/domain/meal_type.dart';
import 'package:qkomo_ui/features/menu/domain/repositories/custom_recipe_repository.dart';
import 'package:qkomo_ui/features/menu/domain/user_recipe.dart';

/// Parameters for saving a meal as a recipe
class SaveMealAsRecipeParams {
  const SaveMealAsRecipeParams({
    required this.name,
    required this.ingredients,
    required this.mealType,
    this.photoPath,
  });

  final String name;
  final List<String> ingredients;
  final MealType mealType;
  final String? photoPath;
}

/// UseCase: Save a meal as a reusable custom recipe
///
/// Creates a custom recipe that can be reused for future meals.
class SaveMealAsRecipe {
  SaveMealAsRecipe(this._repository);

  final CustomRecipeRepository _repository;

  Future<UserRecipe> call(SaveMealAsRecipeParams params) async {
    return await _repository.create(
      name: params.name,
      ingredients: params.ingredients,
      mealType: params.mealType,
      photoPath: params.photoPath,
    );
  }
}

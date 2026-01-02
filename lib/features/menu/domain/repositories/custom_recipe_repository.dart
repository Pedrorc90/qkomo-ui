import 'package:qkomo_ui/features/menu/domain/meal_type.dart';
import 'package:qkomo_ui/features/menu/domain/user_recipe.dart';

/// Repository interface for custom user recipes
///
/// Defines the contract for managing user-created recipes.
/// Implementations handle local storage (Hive) and potential sync.
abstract class CustomRecipeRepository {
  /// Create a new custom recipe
  Future<UserRecipe> create({
    required String name,
    required List<String> ingredients,
    required MealType mealType,
    String? photoPath,
  });

  /// Get all recipes sorted by name
  List<UserRecipe> allSorted();

  /// Get recipes filtered by meal type
  List<UserRecipe> byMealType(MealType mealType);

  /// Get a recipe by ID
  UserRecipe? getById(String id);

  /// Update an existing recipe
  Future<void> update(String id, UserRecipe recipe);

  /// Delete a recipe by ID
  Future<void> delete(String id);
}

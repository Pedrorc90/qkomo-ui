import 'package:qkomo_ui/features/menu/domain/repositories/custom_recipe_repository.dart';
import 'package:qkomo_ui/features/menu/domain/repositories/deleted_preset_recipes_repository.dart';

/// UseCase: Delete a recipe (custom or preset)
///
/// For custom recipes: deletes from storage
/// For preset recipes: marks as deleted to hide from UI
class DeleteRecipe {
  DeleteRecipe({
    required CustomRecipeRepository? customRecipeRepository,
    required DeletedPresetRecipesRepository? deletedPresetRecipesRepository,
  })  : _customRecipeRepository = customRecipeRepository,
        _deletedPresetRecipesRepository = deletedPresetRecipesRepository;

  final CustomRecipeRepository? _customRecipeRepository;
  final DeletedPresetRecipesRepository? _deletedPresetRecipesRepository;

  Future<void> call({
    required String recipeId,
    required bool isCustom,
  }) async {
    if (isCustom) {
      if (_customRecipeRepository == null) {
        throw Exception('CustomRecipeRepository not available');
      }
      await _customRecipeRepository.delete(recipeId);
    } else {
      if (_deletedPresetRecipesRepository == null) {
        throw Exception('DeletedPresetRecipesRepository not available');
      }
      // For preset recipes, recipeId is the recipe name
      await _deletedPresetRecipesRepository.markAsDeleted(recipeId);
    }
  }
}

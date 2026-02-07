import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/features/menu/application/menu_providers.dart';
import 'package:qkomo_ui/features/menu/domain/entities/preset_recipe.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/recipe_filter_chips.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/recipe_grid_card.dart';

class PresetRecipeDialog extends ConsumerStatefulWidget {
  const PresetRecipeDialog({super.key});

  @override
  ConsumerState<PresetRecipeDialog> createState() => _PresetRecipeDialogState();
}

class _PresetRecipeDialogState extends ConsumerState<PresetRecipeDialog> {
  MealType? _selectedMealType;

  Future<void> _deleteRecipe(String recipeId, bool isCustom) async {
    final controller = ref.read(menuControllerProvider.notifier);
    await controller.deleteRecipe(recipeId, isCustom: isCustom);
  }

  @override
  Widget build(BuildContext context) {
    final customRecipes = ref.watch(userRecipesProvider);
    final deletedPresetRecipes = ref.watch(deletedPresetRecipesStreamProvider);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Text(
              'Lista de recetas',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: customRecipes.when(
                data: (recipes) {
                  // Get list of deleted preset recipe names from stream
                  final deletedNames = deletedPresetRecipes.value ?? [];

                  // Create list of items: preset recipes + custom recipes
                  final allRecipes = [
                    ...PresetRecipes.all
                        .where((r) => !deletedNames.contains(r.name))
                        .map((r) => {
                              'name': r.name,
                              'ingredients': r.ingredients,
                              'photoPath': r.photoPath,
                              'suggestedMealType': r.suggestedMealType,
                              'isCustom': false,
                              'presetRecipe': r,
                            }),
                    ...recipes.map((r) => {
                          'id': r.id,
                          'name': r.name,
                          'ingredients': r.ingredients,
                          'photoPath': r.photoPath,
                          'suggestedMealType': r.mealType,
                          'isCustom': true,
                        }),
                  ];

                  // Filter recipes by selected meal type
                  final filteredRecipes = _selectedMealType == null
                      ? allRecipes
                      : allRecipes.where((recipe) {
                          return recipe['suggestedMealType'] ==
                              _selectedMealType;
                        }).toList();

                  return Column(
                    children: [
                      RecipeFilterChips(
                        selectedMealType: _selectedMealType,
                        onMealTypeSelected: (mealType) {
                          setState(() => _selectedMealType = mealType);
                        },
                      ),
                      const SizedBox(height: 16),
                      // Recipe grid
                      Expanded(
                        child: filteredRecipes.isEmpty
                            ? Center(
                                child: Text(
                                  'No hay recetas de ${_selectedMealType?.displayName ?? "este tipo"}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              )
                            : GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 140,
                                  childAspectRatio: 0.65,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                                itemCount: filteredRecipes.length,
                                itemBuilder: (context, index) {
                                  final recipe = filteredRecipes[index];
                                  final isCustom = recipe['isCustom'] as bool;
                                  final recipeIdentifier = isCustom
                                      ? recipe['id'] as String
                                      : recipe['name'] as String;

                                  return RecipeGridCard(
                                    name: recipe['name'] as String,
                                    photoPath: recipe['photoPath'] as String?,
                                    ingredientCount:
                                        (recipe['ingredients'] as List<dynamic>)
                                            .length,
                                    mealType:
                                        recipe['suggestedMealType'] as MealType,
                                    onTap: () {
                                      final result = isCustom
                                          ? recipe
                                          : recipe['presetRecipe'];
                                      Navigator.of(context).pop(result);
                                    },
                                    onDelete: () async {
                                      await _deleteRecipe(
                                          recipeIdentifier, isCustom);
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text('Error al cargar recetas: $error'),
                ),
              ),
            ),
          ),
          // Actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

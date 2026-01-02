import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/features/menu/application/menu_providers.dart';
import 'package:qkomo_ui/features/menu/domain/entities/preset_recipe.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';

class PresetRecipeDialog extends ConsumerStatefulWidget {
  const PresetRecipeDialog({super.key});

  @override
  ConsumerState<PresetRecipeDialog> createState() => _PresetRecipeDialogState();
}

class _PresetRecipeDialogState extends ConsumerState<PresetRecipeDialog> {
  Future<void> _deleteRecipe(String recipeId, bool isCustom) async {
    final controller = ref.read(menuControllerProvider.notifier);
    await controller.deleteRecipe(recipeId, isCustom: isCustom);
  }

  @override
  Widget build(BuildContext context) {
    final customRecipes = ref.watch(userRecipesProvider);
    final deletedPresetRecipes = ref.watch(deletedPresetRecipesStreamProvider);

    return AlertDialog(
      title: const Text('Mi lista de recetas'),
      content: SizedBox(
        width: double.maxFinite,
        child: customRecipes.when(
          data: (recipes) {
            // Get list of deleted preset recipe names from stream
            final deletedNames = deletedPresetRecipes.value ?? [];

            // Create list of items: preset recipes + custom recipes
            final List<Map<String, dynamic>> allRecipes = [
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

            return ListView.builder(
              shrinkWrap: true,
              itemCount: allRecipes.length,
              itemBuilder: (context, index) {
                final recipe = allRecipes[index];
                final isCustom = recipe['isCustom'] as bool;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      if (isCustom) {
                        Navigator.of(context).pop(recipe);
                      } else {
                        Navigator.of(context).pop(recipe['presetRecipe']);
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // Recipe image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: (recipe['photoPath'] as String?) != null
                                ? Image.asset(
                                    recipe['photoPath'] as String,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 80,
                                        height: 80,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outlineVariant,
                                        child: const Icon(Icons.restaurant),
                                      );
                                    },
                                  )
                                : Container(
                                    width: 80,
                                    height: 80,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outlineVariant,
                                    child: const Icon(Icons.restaurant),
                                  ),
                          ),
                          const SizedBox(width: 12),
                          // Recipe details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        recipe['name'] as String,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      onPressed: () async {
                                        final recipeIdentifier = isCustom
                                            ? recipe['id'] as String
                                            : recipe['name'] as String;
                                        await _deleteRecipe(
                                            recipeIdentifier, isCustom);
                                      },
                                      tooltip: 'Eliminar receta',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${(recipe['ingredients'] as List<dynamic>).length} ingredientes',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  (recipe['suggestedMealType'] as MealType)
                                      .displayName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('Error al cargar recetas: $error'),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}

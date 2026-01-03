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
              style: Theme.of(context).textTheme.headlineSmall,
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
                    ...PresetRecipes.all.where((r) => !deletedNames.contains(r.name)).map((r) => {
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
                          return recipe['suggestedMealType'] == _selectedMealType;
                        }).toList();

                  return Column(
                    children: [
                      // Meal type filters (2x2 grid)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          childAspectRatio: 4,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            (MealType.breakfast, 'Desayuno'),
                            (MealType.lunch, 'Comida'),
                            (MealType.snack, 'Merienda'),
                            (MealType.dinner, 'Cena'),
                          ].map((filter) {
                            return SizedBox.expand(
                              child: FilterChip(
                                label: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    filter.$2,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                selected: _selectedMealType == filter.$1,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedMealType = selected ? filter.$1 : null;
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
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
                                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 140,
                                  childAspectRatio: 0.65,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                                itemCount: filteredRecipes.length,
                                itemBuilder: (context, index) {
                                  final recipe = filteredRecipes[index];
                                  final isCustom = recipe['isCustom'] as bool;

                                  return Card(
                                    clipBehavior: Clip.antiAlias,
                                    child: InkWell(
                                      onTap: () {
                                        if (isCustom) {
                                          Navigator.of(context).pop(recipe);
                                        } else {
                                          Navigator.of(context).pop(recipe['presetRecipe']);
                                        }
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          // Recipe image with delete button overlay
                                          Expanded(
                                            child: Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                (recipe['photoPath'] as String?) != null
                                                    ? Image.asset(
                                                        recipe['photoPath'] as String,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context, error, stackTrace) {
                                                          return Container(
                                                            color: Theme.of(context)
                                                                .colorScheme
                                                                .outlineVariant,
                                                            child: const Icon(Icons.restaurant),
                                                          );
                                                        },
                                                      )
                                                    : Container(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .outlineVariant,
                                                        child: const Icon(Icons.restaurant),
                                                      ),
                                                // Delete button overlay
                                                Positioned(
                                                  top: 4,
                                                  right: 4,
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      final recipeIdentifier = isCustom
                                                          ? recipe['id'] as String
                                                          : recipe['name'] as String;
                                                      await _deleteRecipe(
                                                          recipeIdentifier, isCustom);
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.all(4),
                                                      decoration: BoxDecoration(
                                                        color: Colors.black54,
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: const Icon(
                                                        Icons.delete_outline,
                                                        size: 16,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Recipe details
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  recipe['name'] as String,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 11,
                                                      ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  '${(recipe['ingredients'] as List<dynamic>).length} ingredientes',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        fontSize: 10,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurfaceVariant,
                                                      ),
                                                ),
                                                const SizedBox(height: 1),
                                                Text(
                                                  (recipe['suggestedMealType'] as MealType)
                                                      .displayName,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        fontSize: 10,
                                                        color:
                                                            Theme.of(context).colorScheme.primary,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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

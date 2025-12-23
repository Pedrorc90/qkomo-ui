import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qkomo_ui/core/animations/feedback_animations.dart';
import 'package:qkomo_ui/features/feature_toggles/application/feature_toggle_providers.dart';
import 'package:qkomo_ui/features/menu/application/menu_providers.dart';
import 'package:qkomo_ui/features/menu/data/preset_recipes.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/meal_card.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/meal_form_dialog.dart';

class SelectedDayMealsSection extends ConsumerWidget {
  const SelectedDayMealsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(selectedDayProvider);
    final meals = ref.watch(selectedDayMealsProvider);
    final aiSuggestionsEnabled =
        ref.watch(featureEnabledProvider('ai_suggestions'));
    debugPrint('[SelectedDayMealsSection] AI suggestions toggle: $aiSuggestionsEnabled');

    if (selectedDay == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today,
                size: 64,
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withAlpha((0.3 * 255).round()),
              ),
              const SizedBox(height: 16),
              Text(
                'Selecciona un día para ver las comidas',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final dateFormat = DateFormat('EEEE, d \'de\' MMMM', 'es');
    final formattedDate = dateFormat.format(selectedDay);
    final capitalizedDate =
        formattedDate[0].toUpperCase() + formattedDate.substring(1);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withAlpha((0.3 * 255).round()),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      capitalizedDate,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Auto-generate menu button
                  IconButton(
                    icon: Icon(
                      Icons.auto_awesome,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () =>
                        _autoGenerateMenu(context, ref, selectedDay),
                    tooltip: 'Generar menú automático',
                    visualDensity: VisualDensity.compact,
                  ),
                  // Suggestions AI button
                  if (aiSuggestionsEnabled)
                    IconButton(
                      icon: Icon(
                        Icons.lightbulb_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () => _generateSuggestions(context),
                      tooltip: 'Sugerencias IA',
                      visualDensity: VisualDensity.compact,
                    ),
                  // Clear meals button
                  IconButton(
                    icon: Icon(
                      Icons.delete_sweep,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () => _clearDayMeals(context, ref, selectedDay),
                    tooltip: 'Limpiar comidas',
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                if (meals.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'No hay comidas planificadas para este día',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  ..._buildMealTypeSections(context, meals, selectedDay),
                const SizedBox(height: 12),
                // Add new meal button
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withAlpha((0.3 * 255).round()),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => MealFormDialog(
                          date: selectedDay,
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle,
                            color: Theme.of(context).colorScheme.primary,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Agregar comida',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getMealTypeColor(BuildContext context, MealType type) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (type) {
      case MealType.breakfast:
        return colorScheme.primary;
      case MealType.lunch:
        return colorScheme.secondary;
      case MealType.snack:
        return colorScheme.tertiary;
      case MealType.dinner:
        return colorScheme.error;
    }
  }

  String _getMealTimeContext(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return '7:00 - 9:00';
      case MealType.lunch:
        return '12:30 - 14:30';
      case MealType.snack:
        return '16:00 - 17:30';
      case MealType.dinner:
        return '20:00 - 22:00';
    }
  }

  List<Widget> _buildMealTypeSections(
    BuildContext context,
    List<dynamic> meals,
    DateTime selectedDay,
  ) {
    final mealsByType = <MealType, List<dynamic>>{};

    for (final meal in meals) {
      final type = meal.mealType;
      mealsByType.putIfAbsent(type, () => []).add(meal);
    }

    final sections = <Widget>[];

    for (final type in MealType.values) {
      if (!mealsByType.containsKey(type)) continue;

      final mealsOfType = mealsByType[type]!;

      sections.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Meals for this type
            ...mealsOfType.map((meal) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: MealCard(meal: meal),
              );
            }),
          ],
        ),
      );
    }

    return sections;
  }

  Future<void> _autoGenerateMenu(
      BuildContext context, WidgetRef ref, DateTime selectedDay) async {
    final controller = ref.read(menuControllerProvider.notifier);

    // Use preset recipes
    final presetRecipes = PresetRecipes.all;

    if (presetRecipes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No hay recetas disponibles para generar un menú',
          ),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Group preset recipes by meal type
    final recipesByType = <MealType, List<PresetRecipe>>{};
    for (final recipe in presetRecipes) {
      recipesByType.putIfAbsent(recipe.suggestedMealType, () => []).add(recipe);
    }

    // Generate menu: add one meal for each of the 4 types
    final random = Random();
    var addedCount = 0;
    final missingTypes = <String>[];

    // Default times for each meal type
    final defaultTimes = {
      MealType.breakfast: const Duration(hours: 8),
      MealType.lunch: const Duration(hours: 14),
      MealType.snack: const Duration(hours: 17),
      MealType.dinner: const Duration(hours: 21),
    };

    for (final mealType in MealType.values) {
      // Check if there are recipes of this type available
      if (!recipesByType.containsKey(mealType) ||
          recipesByType[mealType]!.isEmpty) {
        missingTypes.add(mealType.displayName);
        continue;
      }

      // Select a random recipe of this type
      final recipesOfType = recipesByType[mealType]!;
      final selectedRecipe =
          recipesOfType[random.nextInt(recipesOfType.length)];

      // Get default time for this meal type
      final timeOfDay = defaultTimes[mealType]!;
      final scheduledDateTime = DateTime(
        selectedDay.year,
        selectedDay.month,
        selectedDay.day,
      ).add(timeOfDay);

      // Add the meal to the current day
      await controller.createMeal(
        name: selectedRecipe.name,
        ingredients: selectedRecipe.ingredients,
        mealType: selectedRecipe.suggestedMealType,
        scheduledFor: scheduledDateTime,
        photoPath: selectedRecipe.photoPath,
      );

      addedCount++;
    }

    if (context.mounted) {
      if (addedCount == 4) {
        await SuccessFeedback.show(
          context,
          message:
              'Menú completo generado: 4 comidas agregadas automáticamente',
        );
      } else if (addedCount > 0) {
        var message =
            'Menú generado: $addedCount comida(s) agregada(s) automáticamente';
        if (missingTypes.isNotEmpty) {
          message +=
              '\n\nNo hay recetas disponibles de tipo: ${missingTypes.join(", ")}';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No hay suficientes recetas para generar un menú',
            ),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _clearDayMeals(
      BuildContext context, WidgetRef ref, DateTime selectedDay) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Limpiar comidas'),
        content: const Text(
            '¿Estás seguro de que quieres eliminar todas las comidas para este día?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton.tonal(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await ref
                  .read(menuControllerProvider.notifier)
                  .deleteMealsForDay(selectedDay);
              if (context.mounted) {
                await SuccessFeedback.show(
                  context,
                  message: 'Comidas eliminadas correctamente',
                );
              }
            },
            child: const Text('Limpiar'),
          ),
        ],
      ),
    );
  }

  void _generateSuggestions(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'Función de sugerencias con IA será implementada en la próxima versión'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

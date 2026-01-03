import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qkomo_ui/core/animations/feedback_animations.dart';
import 'package:qkomo_ui/features/auth/application/auth_providers.dart';
import 'package:qkomo_ui/features/feature_toggles/application/feature_toggle_providers.dart';
import 'package:qkomo_ui/features/feature_toggles/domain/feature_toggle_keys.dart';
import 'package:qkomo_ui/features/menu/application/menu_providers.dart';
import 'package:qkomo_ui/features/menu/domain/entities/preset_recipe.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/add_meal_button.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/day_header_with_actions.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/empty_day_placeholder.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/meal_card.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/meal_form_dialog.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/meal_type_selector_dialog.dart';

class SelectedDayMealsSection extends ConsumerWidget {
  const SelectedDayMealsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(selectedDayProvider);
    final meals = ref.watch(selectedDayMealsProvider);
    final aiSuggestionsEnabled =
        ref.watch(featureEnabledProvider(FeatureToggleKeys.aiSuggestions));
    debugPrint(
        '[SelectedDayMealsSection] AI suggestions toggle: $aiSuggestionsEnabled');

    if (selectedDay == null) {
      return const EmptyDayPlaceholder();
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
            DayHeaderWithActions(
              dateText: capitalizedDate,
              onAutoGenerate: () =>
                  _autoGenerateMenu(context, ref, selectedDay),
              onClearMeals: () => _clearDayMeals(context, ref, selectedDay),
              onGenerateSuggestions: () => _generateSuggestions(context),
              showSuggestionsButton: aiSuggestionsEnabled,
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
                AddMealButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => MealFormDialog(
                        date: selectedDay,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
    // Show meal type selector dialog
    final selectedMealTypes = await showDialog<List<MealType>>(
      context: context,
      builder: (context) => const MealTypeSelectorDialog(),
    );

    if (selectedMealTypes == null || selectedMealTypes.isEmpty) {
      return;
    }

    final controller = ref.read(menuControllerProvider.notifier);
    final user = ref.read(firebaseAuthProvider).currentUser;
    final userId = user?.uid ?? '';

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

    // Generate menu: add one meal for each selected type
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

    for (final mealType in selectedMealTypes) {
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
        userId: userId,
        name: selectedRecipe.name,
        ingredients: selectedRecipe.ingredients,
        mealType: selectedRecipe.suggestedMealType,
        scheduledFor: scheduledDateTime,
        photoPath: selectedRecipe.photoPath,
      );

      addedCount++;
    }

    if (context.mounted) {
      if (addedCount != selectedMealTypes.length) {
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
      builder: (dialogContext) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Limpiar comidas',
                style: Theme.of(dialogContext).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              const Text(
                  '¿Estás seguro de que quieres eliminar todas las comidas para este día?'),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 8),
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
            ],
          ),
        ),
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

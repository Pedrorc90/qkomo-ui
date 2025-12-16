import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:qkomo_ui/features/menu/application/menu_providers.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/meal_card.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/meal_form_dialog.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/quick_actions_panel.dart';

class SelectedDayMealsSection extends ConsumerWidget {
  const SelectedDayMealsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(selectedDayProvider);
    final meals = ref.watch(selectedDayMealsProvider);

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
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
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
            Expanded(
              child: ListView(
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
                  const SizedBox(height: 12),
                  // Quick actions panel
                  QuickActionsPanel(selectedDay: selectedDay),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getMealIcon(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return Icons.free_breakfast;
      case MealType.lunch:
        return Icons.restaurant;
      case MealType.snack:
        return Icons.cookie;
      case MealType.dinner:
        return Icons.dinner_dining;
    }
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

    final List<Widget> sections = [];

    for (final type in MealType.values) {
      if (!mealsByType.containsKey(type)) continue;

      final mealsOfType = mealsByType[type]!;
      final typeColor = _getMealTypeColor(context, type);
      final timeContext = _getMealTimeContext(type);

      sections.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Meal type header with time context
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: typeColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type.displayName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: typeColor,
                        ),
                      ),
                      Text(
                        timeContext,
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Icon(
                    _getMealIcon(type),
                    size: 18,
                    color: typeColor.withAlpha((0.6 * 255).round()),
                  ),
                ],
              ),
            ),
            // Meals for this type
            ...mealsOfType.map((meal) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: MealCard(meal: meal),
              );
            }),
            // Divider between sections
            if (mealsOfType != meals.last)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Divider(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  thickness: 1,
                ),
              ),
          ],
        ),
      );
    }

    return sections;
  }
}

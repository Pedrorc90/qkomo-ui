import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:qkomo_ui/features/feature_toggles/application/feature_toggle_providers.dart';
import 'package:qkomo_ui/features/feature_toggles/domain/feature_toggle_keys.dart';
import 'package:qkomo_ui/features/menu/application/menu_providers.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/meal_card.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/meal_form_dialog.dart';

class DayMealSection extends ConsumerWidget {
  const DayMealSection({
    super.key,
    required this.date,
    required this.dayName,
  });

  final DateTime date;
  final String dayName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekMeals = ref.watch(weekMealsProvider);
    final mealsOfDay = weekMeals.where((meal) {
      final mealDate = meal.scheduledFor;
      return mealDate.year == date.year && mealDate.month == date.month && mealDate.day == date.day;
    }).toList();

    // Sort meals by type
    final sortedMeals = mealsOfDay.toList()
      ..sort((a, b) => a.mealType.index.compareTo(b.mealType.index));

    final dateFormat = DateFormat('d MMM', 'es');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            '$dayName ${dateFormat.format(date)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (sortedMeals.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'No hay comidas planificadas',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ...sortedMeals.map((meal) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _getMealIcon(meal.mealType),
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      meal.mealType.displayName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                MealCard(meal: meal),
              ],
            ),
          );
        }),
        const Divider(height: 24),
      ],
    );
  }

  IconData _getMealIcon(MealType type) {
    switch (type) {
      case MealType.lunch:
        return Icons.restaurant;
      case MealType.dinner:
        return Icons.dinner_dining;
    }
  }
}

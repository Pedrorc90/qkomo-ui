import 'package:flutter/material.dart';

import 'package:qkomo_ui/features/menu/domain/meal.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';
import 'package:qkomo_ui/features/menu/presentation/weekly_menu_page.dart';

class UpcomingMealsSection extends StatelessWidget {
  const UpcomingMealsSection({
    super.key,
    required this.todayMeals,
    required this.tomorrowMeals,
  });

  final List<Meal> todayMeals;
  final List<Meal> tomorrowMeals;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer.withAlpha((0.3 * 255).round()),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.restaurant_menu,
                  color: colorScheme.secondary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Menú Semanal',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const WeeklyMenuPage(),
                      ),
                    );
                  },
                  child: const Text('Ver menú'),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (todayMeals.isEmpty && tomorrowMeals.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(
                            Icons.event_busy,
                            size: 48,
                            color: colorScheme.onSurfaceVariant.withAlpha((0.5 * 255).round()),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No hay comidas planificadas',
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else ...[
                  if (todayMeals.isNotEmpty) ...[
                    _buildDaySubsection(
                      context,
                      'Hoy',
                      todayMeals,
                      colorScheme,
                    ),
                    if (tomorrowMeals.isNotEmpty) const SizedBox(height: 16),
                  ],
                  if (tomorrowMeals.isNotEmpty)
                    _buildDaySubsection(
                      context,
                      'Mañana',
                      tomorrowMeals,
                      colorScheme,
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySubsection(
    BuildContext context,
    String title,
    List<Meal> meals,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        ...meals.map((meal) => _buildMealCard(context, meal, colorScheme)),
      ],
    );
  }

  Widget _buildMealCard(
    BuildContext context,
    Meal meal,
    ColorScheme colorScheme,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Icon(
          _getMealIcon(meal.mealType),
          color: colorScheme.secondary,
        ),
        title: Text(
          meal.name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          meal.mealType.displayName,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurfaceVariant,
          ),
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
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qkomo_ui/core/widgets/platform_image.dart';
import 'package:qkomo_ui/features/menu/domain/entities/weekly_menu.dart';
import 'package:qkomo_ui/features/menu/domain/entities/weekly_menu_item.dart';
import 'package:qkomo_ui/features/menu/domain/meal.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';
import 'package:qkomo_ui/features/menu/presentation/weekly_menu_page.dart';

class UpcomingMealsSection extends StatelessWidget {
  const UpcomingMealsSection({
    super.key,
    required this.todayMeals,
    required this.tomorrowMeals,
    this.weeklyMenu,
    this.isAiWeeklyMenuEnabled = false,
  });

  final List<Meal> todayMeals;
  final List<Meal> tomorrowMeals;
  final WeeklyMenu? weeklyMenu;
  final bool isAiWeeklyMenuEnabled;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    debugPrint('[UpcomingMealsSection] weeklyMenu: ${weeklyMenu != null ? "EXISTS (${weeklyMenu!.days.length} days)" : "NULL"}');
    debugPrint('[UpcomingMealsSection] isAiWeeklyMenuEnabled: $isAiWeeklyMenuEnabled');
    debugPrint('[UpcomingMealsSection] todayMeals: ${todayMeals.length}, tomorrowMeals: ${tomorrowMeals.length}');

    // Extract today and tomorrow meals from WeeklyMenu if AI mode is enabled
    List<WeeklyMenuItem> todayWeeklyItems = [];
    List<WeeklyMenuItem> tomorrowWeeklyItems = [];

    final menu = weeklyMenu;
    if (isAiWeeklyMenuEnabled && menu != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));

      for (final day in menu.days) {
        final dayDate = DateTime(day.date.year, day.date.month, day.date.day);
        if (dayDate.isAtSameMomentAs(today)) {
          todayWeeklyItems = day.items;
        } else if (dayDate.isAtSameMomentAs(tomorrow)) {
          tomorrowWeeklyItems = day.items;
        }
      }
    }

    // Use WeeklyMenu items if available, otherwise fall back to legacy Meal entities
    final hasTodayMeals = isAiWeeklyMenuEnabled
        ? todayWeeklyItems.isNotEmpty
        : todayMeals.isNotEmpty;
    final hasTomorrowMeals = isAiWeeklyMenuEnabled
        ? tomorrowWeeklyItems.isNotEmpty
        : tomorrowMeals.isNotEmpty;

    final limitedToday = todayMeals.take(4).toList();
    final remainingSlotsLegacy = 4 - limitedToday.length;
    final limitedTomorrow = tomorrowMeals.take(remainingSlotsLegacy).toList();

    // For AI mode
    final limitedTodayWeekly = todayWeeklyItems.take(4).toList();
    final remainingSlotsAi = 4 - todayWeeklyItems.length;
    final limitedTomorrowWeekly = tomorrowWeeklyItems.take(remainingSlotsAi).toList();

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  colorScheme.secondaryContainer.withAlpha((0.3 * 255).round()),
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
                if (!hasTodayMeals && !hasTomorrowMeals)
                  _buildEmptyState(context, colorScheme)
                else ...[
                  if (isAiWeeklyMenuEnabled) ...[
                    // AI mode: show WeeklyMenuItem cards
                    if (todayWeeklyItems.isNotEmpty) ...[
                      _buildDaySubsectionForWeeklyItems(
                        context,
                        'Hoy',
                        limitedTodayWeekly,
                        colorScheme,
                      ),
                      if (tomorrowWeeklyItems.isNotEmpty) const SizedBox(height: 16),
                    ],
                    if (tomorrowWeeklyItems.isNotEmpty)
                      _buildDaySubsectionForWeeklyItems(
                        context,
                        'Mañana',
                        limitedTomorrowWeekly,
                        colorScheme,
                      ),
                  ] else ...[
                    // Legacy mode: show Meal cards
                    if (todayMeals.isNotEmpty) ...[
                      _buildDaySubsection(
                        context,
                        'Hoy',
                        limitedToday,
                        colorScheme,
                      ),
                      if (limitedTomorrow.isNotEmpty) const SizedBox(height: 16),
                    ],
                    if (limitedTomorrow.isNotEmpty)
                      _buildDaySubsection(
                        context,
                        'Mañana',
                        limitedTomorrow,
                        colorScheme,
                      ),
                  ],
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

  Widget _buildDaySubsectionForWeeklyItems(
    BuildContext context,
    String title,
    List<WeeklyMenuItem> items,
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
        ...items.map((item) => _buildWeeklyMenuItemCard(context, item, colorScheme)),
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
        ),
      ),
      child: ListTile(
        leading: _buildMealImage(context, meal, colorScheme),
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

  Widget _buildWeeklyMenuItemCard(
    BuildContext context,
    WeeklyMenuItem item,
    ColorScheme colorScheme,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: ListTile(
        leading: _buildWeeklyMenuItemImage(context, item, colorScheme),
        title: Text(
          item.dishName,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          _getMealTypeDisplayName(item.mealType),
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  String _getMealTypeDisplayName(dynamic mealType) {
    if (mealType.toString().toLowerCase().contains('lunch')) {
      return 'Almuerzo';
    } else if (mealType.toString().toLowerCase().contains('dinner')) {
      return 'Cena';
    }
    return 'Comida';
  }

  Widget _buildMealImage(
    BuildContext context,
    Meal meal,
    ColorScheme colorScheme,
  ) {
    const size = 48.0;
    final fallbackIcon = Icon(
      _getMealIcon(meal.mealType),
      color: colorScheme.secondary,
      size: 24,
    );

    if (meal.photoPath == null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: fallbackIcon,
      );
    }

    final isAsset = meal.photoPath!.startsWith('assets/');

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: isAsset
          ? Image.asset(
              meal.photoPath!,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildFallbackContainer(
                colorScheme,
                fallbackIcon,
                size,
              ),
            )
          : PlatformImage(
              path: meal.photoPath!,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildFallbackContainer(
                colorScheme,
                fallbackIcon,
                size,
              ),
            ),
    );
  }

  Widget _buildWeeklyMenuItemImage(
    BuildContext context,
    WeeklyMenuItem item,
    ColorScheme colorScheme,
  ) {
    const size = 48.0;
    final fallbackIcon = Icon(
      _getWeeklyMenuIcon(item.mealType),
      color: colorScheme.secondary,
      size: 24,
    );

    if (item.imageUrl == null || item.imageUrl!.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: fallbackIcon,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        item.imageUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildFallbackContainer(
          colorScheme,
          fallbackIcon,
          size,
        ),
      ),
    );
  }

  Widget _buildFallbackContainer(
    ColorScheme colorScheme,
    Widget icon,
    double size,
  ) {
    return Container(
      width: size,
      height: size,
      color: colorScheme.surfaceContainerHighest,
      child: icon,
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

  IconData _getWeeklyMenuIcon(dynamic mealType) {
    if (mealType.toString().toLowerCase().contains('lunch')) {
      return Icons.restaurant;
    } else if (mealType.toString().toLowerCase().contains('dinner')) {
      return Icons.dinner_dining;
    }
    return Icons.restaurant;
  }

  Widget _buildEmptyState(BuildContext context, ColorScheme colorScheme) {
    if (isAiWeeklyMenuEnabled) {
      // AI mode: Informative empty state (no interactive buttons)
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome,
                size: 48,
                color: colorScheme.primary.withAlpha((0.7 * 255).round()),
              ),
              const SizedBox(height: 12),
              Text(
                'Aún no tienes un menú semanal',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Genéralo en un solo paso con IA',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    } else {
      // Legacy mode: Show passive empty state
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.event_busy,
                size: 48,
                color:
                    colorScheme.onSurfaceVariant.withAlpha((0.5 * 255).round()),
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
      );
    }
  }
}

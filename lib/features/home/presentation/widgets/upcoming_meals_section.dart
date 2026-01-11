import 'package:flutter/material.dart';
import 'package:qkomo_ui/features/menu/domain/entities/weekly_menu.dart';
import 'package:qkomo_ui/features/menu/domain/entities/weekly_menu_item.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/dish_image_widget.dart';

class UpcomingMealsSection extends StatelessWidget {
  const UpcomingMealsSection({
    super.key,
    required this.todayMeals,
    required this.tomorrowMeals,
    this.weeklyMenu,
  });

  final List<dynamic> todayMeals;
  final List<dynamic> tomorrowMeals;
  final WeeklyMenu? weeklyMenu;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    debugPrint('[UpcomingMealsSection] weeklyMenu: ${weeklyMenu != null ? "EXISTS (${weeklyMenu!.days.length} days)" : "NULL"}');
    debugPrint('[UpcomingMealsSection] todayMeals: ${todayMeals.length}, tomorrowMeals: ${tomorrowMeals.length}');

    // Extract today and tomorrow meals from WeeklyMenu
    var todayWeeklyItems = <WeeklyMenuItem>[];
    var tomorrowWeeklyItems = <WeeklyMenuItem>[];

    final menu = weeklyMenu;
    if (menu != null) {
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

    final hasTodayMeals = todayWeeklyItems.isNotEmpty;
    final hasTomorrowMeals = tomorrowWeeklyItems.isNotEmpty;

    // Limit to 4 items total
    final limitedTodayWeekly = todayWeeklyItems.take(4).toList();
    final remainingSlots = 4 - todayWeeklyItems.length;
    final limitedTomorrowWeekly = tomorrowWeeklyItems.take(remainingSlots).toList();

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
                  if (todayWeeklyItems.isNotEmpty) ...[
                    _buildDaySubsection(
                      context,
                      'Hoy',
                      limitedTodayWeekly,
                      colorScheme,
                    ),
                    if (tomorrowWeeklyItems.isNotEmpty) const SizedBox(height: 16),
                  ],
                  if (tomorrowWeeklyItems.isNotEmpty)
                    _buildDaySubsection(
                      context,
                      'Mañana',
                      limitedTomorrowWeekly,
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

  Widget _buildWeeklyMenuItemImage(
    BuildContext context,
    WeeklyMenuItem item,
    ColorScheme colorScheme,
  ) {
    return DishImageWidget(
      imageUrl: item.imageUrl,
      imageType: DishImageType.aiGenerated,
      mealType: item.mealType,
      width: 48,
      height: 48,
      borderRadius: 8,
    );
  }

  Widget _buildEmptyState(BuildContext context, ColorScheme colorScheme) {
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
  }
}

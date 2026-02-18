import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qkomo_ui/features/menu/application/menu_providers.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/ai_meal_card.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/empty_day_placeholder.dart';

class SelectedDayMealsSection extends ConsumerWidget {
  const SelectedDayMealsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(selectedDayProvider);
    final weekStart = ref.watch(currentWeekStartProvider);
    final userId = ref.watch(currentUserIdProvider);

    // Load weekly menu for current week
    final menuStateAsync = ref.watch(weeklyMenuByWeekProvider((weekStart, userId)));
    final weeklyMenu = menuStateAsync.valueOrNull;

    return _buildAiMode(context, ref, weeklyMenu, selectedDay);
  }

  Widget _buildAiMode(
    BuildContext context,
    WidgetRef ref,
    dynamic weeklyMenu,
    DateTime? selectedDay,
  ) {
    // If no menu generated, don't show anything (CTA is shown at page level)
    if (weeklyMenu == null) {
      return const SizedBox.shrink();
    }

    if (selectedDay == null) {
      return const EmptyDayPlaceholder();
    }

    final dateFormat = DateFormat('EEEE, d \'de\' MMMM', 'es');
    final formattedDate = dateFormat.format(selectedDay);
    final capitalizedDate = formattedDate[0].toUpperCase() + formattedDate.substring(1);

    // Show AI items for selected day
    final aiItems = _getSelectedDayAiItems(weeklyMenu, selectedDay);

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
            _buildDayHeader(context, capitalizedDate),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                if (aiItems.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'No hay comidas generadas para este día',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  ...aiItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AiMealCard(item: item),
                    );
                  }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayHeader(
    BuildContext context,
    String dateText,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha((0.3 * 255).round()),
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
              dateText,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  List<dynamic> _getSelectedDayAiItems(dynamic weeklyMenu, DateTime selectedDay) {
    if (weeklyMenu == null) return [];

    try {
      final day = weeklyMenu.days.firstWhere(
        (d) =>
            d.date.year == selectedDay.year &&
            d.date.month == selectedDay.month &&
            d.date.day == selectedDay.day,
      );
      return day.items ?? [];
    } catch (_) {
      // Day not found in menu
      return [];
    }
  }
}

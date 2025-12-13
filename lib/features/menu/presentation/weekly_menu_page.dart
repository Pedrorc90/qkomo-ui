import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:qkomo_ui/core/widgets/qkomo_navbar.dart';

import 'package:qkomo_ui/features/menu/application/menu_providers.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/weekly_calendar_widget.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/selected_day_meals_section.dart';

class WeeklyMenuPage extends ConsumerWidget {
  const WeeklyMenuPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekStart = ref.watch(currentWeekStartProvider);
    final dateFormat = DateFormat('d MMM', 'es');

    final weekEnd = weekStart.add(const Duration(days: 6));
    final weekRange = '${dateFormat.format(weekStart)} - ${dateFormat.format(weekEnd)}';

    return Scaffold(
      appBar: const QkomoNavBar(),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  onPressed: () {
                    ref.read(currentWeekStartProvider.notifier).state =
                        weekStart.subtract(const Duration(days: 7));
                    ref.read(selectedDayProvider.notifier).state = null;
                  },
                  tooltip: 'Semana anterior',
                ),
                Expanded(
                  child: Text(
                    'Semana del $weekRange',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.today,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      onPressed: () {
                        final now = DateTime.now();
                        ref.read(currentWeekStartProvider.notifier).state =
                            now.subtract(Duration(days: now.weekday - 1));
                        ref.read(selectedDayProvider.notifier).state =
                            DateTime(now.year, now.month, now.day);
                      },
                      tooltip: 'Semana actual',
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.chevron_right,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      onPressed: () {
                        ref.read(currentWeekStartProvider.notifier).state =
                            weekStart.add(const Duration(days: 7));
                        ref.read(selectedDayProvider.notifier).state = null;
                      },
                      tooltip: 'Semana siguiente',
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Upper half: Weekly Calendar
          WeeklyCalendarWidget(weekStart: weekStart),
          const Divider(height: 1),
          // Lower half: Selected Day Meals
          const Expanded(
            child: SelectedDayMealsSection(),
          ),
        ],
      ),
    );
  }
}

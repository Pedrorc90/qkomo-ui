import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:qkomo_ui/core/widgets/qkomo_navbar.dart';

import 'package:qkomo_ui/features/menu/application/menu_providers.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/day_meal_section.dart';

class WeeklyMenuPage extends ConsumerWidget {
  const WeeklyMenuPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekStart = ref.watch(currentWeekStartProvider);
    final dateFormat = DateFormat('d MMM', 'es');

    final weekEnd = weekStart.add(const Duration(days: 6));
    final weekRange = '${dateFormat.format(weekStart)} - ${dateFormat.format(weekEnd)}';

    return Scaffold(
      appBar: QkomoNavBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              ref.read(currentWeekStartProvider.notifier).state =
                  weekStart.subtract(const Duration(days: 7));
            },
            tooltip: 'Semana anterior',
          ),
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              final now = DateTime.now();
              ref.read(currentWeekStartProvider.notifier).state =
                  now.subtract(Duration(days: now.weekday - 1));
            },
            tooltip: 'Semana actual',
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              ref.read(currentWeekStartProvider.notifier).state =
                  weekStart.add(const Duration(days: 7));
            },
            tooltip: 'Semana siguiente',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primaryContainer,
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
          Expanded(
            child: ListView(
              children: [
                DayMealSection(
                  date: weekStart,
                  dayName: 'Lunes',
                ),
                DayMealSection(
                  date: weekStart.add(const Duration(days: 1)),
                  dayName: 'Martes',
                ),
                DayMealSection(
                  date: weekStart.add(const Duration(days: 2)),
                  dayName: 'Miércoles',
                ),
                DayMealSection(
                  date: weekStart.add(const Duration(days: 3)),
                  dayName: 'Jueves',
                ),
                DayMealSection(
                  date: weekStart.add(const Duration(days: 4)),
                  dayName: 'Viernes',
                ),
                DayMealSection(
                  date: weekStart.add(const Duration(days: 5)),
                  dayName: 'Sábado',
                ),
                DayMealSection(
                  date: weekStart.add(const Duration(days: 6)),
                  dayName: 'Domingo',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

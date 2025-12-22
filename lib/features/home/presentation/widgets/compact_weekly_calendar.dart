import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:qkomo_ui/features/menu/application/menu_providers.dart';
import 'package:qkomo_ui/features/menu/presentation/weekly_menu_page.dart';

/// Compact weekly calendar widget for home page
///
/// Displays a horizontal list of 7 day cards with smaller dimensions than
/// the full weekly calendar. Tapping a day navigates to the weekly menu page.
class CompactWeeklyCalendar extends ConsumerWidget {
  const CompactWeeklyCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekStart = ref.watch(currentWeekStartProvider);
    final selectedDay = ref.watch(selectedDayProvider);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final dayCards = <Widget>[];
    for (var index = 0; index < 7; index++) {
      final date = weekStart.add(Duration(days: index));
      final normalizedDate = DateTime(date.year, date.month, date.day);
      final isSelected = selectedDay != null &&
          normalizedDate.year == selectedDay.year &&
          normalizedDate.month == selectedDay.month &&
          normalizedDate.day == selectedDay.day;
      final isToday = normalizedDate.year == today.year &&
          normalizedDate.month == today.month &&
          normalizedDate.day == today.day;

      dayCards.add(
        _CompactDayCard(
          date: date,
          isSelected: isSelected,
          isToday: isToday,
          onTap: () {
            // Update selected day provider
            ref.read(selectedDayProvider.notifier).state = normalizedDate;

            // Navigate to weekly menu page
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const WeeklyMenuPage(),
              ),
            );
          },
        ),
      );
    }

    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: dayCards,
        ),
      ),
    );
  }
}

/// Compact day card for weekly calendar
class _CompactDayCard extends StatelessWidget {
  const _CompactDayCard({
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dayFormat = DateFormat('EEE', 'es');
    final dateFormat = DateFormat('d', 'es');
    final monthFormat = DateFormat('MMM', 'es');

    final colorScheme = Theme.of(context).colorScheme;

    Color backgroundColor;
    Color textColor;
    Color borderColor;

    if (isSelected) {
      backgroundColor = colorScheme.primaryContainer;
      textColor = colorScheme.onPrimaryContainer;
      borderColor = colorScheme.primary;
    } else if (isToday) {
      backgroundColor = colorScheme.secondaryContainer.withValues(alpha: 0.3);
      textColor = colorScheme.onSurface;
      borderColor = colorScheme.secondary;
    } else {
      backgroundColor = colorScheme.surface;
      textColor = colorScheme.onSurface;
      borderColor = colorScheme.outlineVariant;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 50,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                dayFormat.format(date).toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: textColor.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                dateFormat.format(date),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                monthFormat.format(date).toUpperCase(),
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  color: textColor.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

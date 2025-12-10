import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:qkomo_ui/features/menu/application/menu_providers.dart';

class WeeklyCalendarWidget extends ConsumerWidget {
  const WeeklyCalendarWidget({
    super.key,
    required this.weekStart,
  });

  final DateTime weekStart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(selectedDayProvider);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Selecciona un día',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: 7,
                itemBuilder: (context, index) {
                  final date = weekStart.add(Duration(days: index));
                  final normalizedDate = DateTime(date.year, date.month, date.day);
                  final isSelected = selectedDay != null &&
                      normalizedDate.year == selectedDay.year &&
                      normalizedDate.month == selectedDay.month &&
                      normalizedDate.day == selectedDay.day;
                  final isToday = normalizedDate.year == today.year &&
                      normalizedDate.month == today.month &&
                      normalizedDate.day == today.day;

                  return _DayCard(
                    date: date,
                    isSelected: isSelected,
                    isToday: isToday,
                    onTap: () {
                      ref.read(selectedDayProvider.notifier).state = normalizedDate;
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({
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
      backgroundColor = colorScheme.secondaryContainer.withAlpha((0.3 * 255).round());
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
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 70,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
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
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: textColor.withAlpha((0.7 * 255).round()),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                dateFormat.format(date),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Text(
                monthFormat.format(date).toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: textColor.withAlpha((0.6 * 255).round()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

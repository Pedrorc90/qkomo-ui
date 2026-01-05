import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qkomo_ui/core/accessibility/semantic_labels.dart';
import 'package:qkomo_ui/core/accessibility/semantic_wrapper.dart';
import 'package:qkomo_ui/core/widgets/qkomo_navbar.dart';
import 'package:qkomo_ui/features/feature_toggles/application/feature_toggle_providers.dart';
import 'package:qkomo_ui/features/feature_toggles/domain/feature_toggle_keys.dart';
import 'package:qkomo_ui/features/menu/application/menu_providers.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/selected_day_meals_section.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/weekly_calendar_widget.dart';

class WeeklyMenuPage extends ConsumerStatefulWidget {
  const WeeklyMenuPage({super.key});

  @override
  ConsumerState<WeeklyMenuPage> createState() => _WeeklyMenuPageState();
}

class _WeeklyMenuPageState extends ConsumerState<WeeklyMenuPage> {
  @override
  void initState() {
    super.initState();
    // Try to load AI weekly menu on page mount
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isEnabled = ref.read(
        featureEnabledProvider(FeatureToggleKeys.aiWeeklyMenuIsEnabled),
      );
      debugPrint('[WeeklyMenuPage] aiWeeklyMenuIsEnabled = $isEnabled');

      final menuState = ref.read(menuControllerProvider);
      debugPrint(
          '[WeeklyMenuPage] MenuState: isAiModeActive=${menuState.isAiModeActive}, aiDisabled=${menuState.aiDisabled}');

      final weekStart = ref.read(currentWeekStartProvider);
      ref
          .read(menuControllerProvider.notifier)
          .loadAiWeekIfEnabled(weekStart: weekStart);

      // Sync selectedDay with MenuController
      final selectedDay = ref.read(selectedDayProvider);
      ref.read(menuControllerProvider.notifier).setSelectedDay(selectedDay);
    });
  }

  @override
  Widget build(BuildContext context) {
    final weekStart = ref.watch(currentWeekStartProvider);
    final dateFormat = DateFormat('d MMM', 'es');

    // Sync selectedDay changes with MenuController
    ref.listen<DateTime?>(selectedDayProvider, (previous, next) {
      ref.read(menuControllerProvider.notifier).setSelectedDay(next);
    });

    // Reload AI menu when week changes
    ref.listen<DateTime>(currentWeekStartProvider, (previous, next) {
      if (previous != null && previous != next) {
        ref
            .read(menuControllerProvider.notifier)
            .loadAiWeekIfEnabled(weekStart: next);
      }
    });

    final weekEnd = weekStart.add(const Duration(days: 6));
    final weekRange =
        '${dateFormat.format(weekStart)} - ${dateFormat.format(weekEnd)}';

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const QkomoNavBar(),
      body: SingleChildScrollView(
        child: Column(
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
                    tooltip: SemanticLabels.previousWeek,
                  ).withMinimumTouchTarget(),
                  Expanded(
                    child: Text(
                      'Semana del $weekRange',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      textAlign: TextAlign.center,
                    ).withSemantics(isHeader: true),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.today,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        onPressed: () {
                          final now = DateTime.now();
                          ref.read(currentWeekStartProvider.notifier).state =
                              now.subtract(Duration(days: now.weekday - 1));
                          ref.read(selectedDayProvider.notifier).state =
                              DateTime(now.year, now.month, now.day);
                        },
                        tooltip: SemanticLabels.currentWeek,
                      ).withMinimumTouchTarget(),
                      IconButton(
                        icon: Icon(
                          Icons.chevron_right,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        onPressed: () {
                          ref.read(currentWeekStartProvider.notifier).state =
                              weekStart.add(const Duration(days: 7));
                          ref.read(selectedDayProvider.notifier).state = null;
                        },
                        tooltip: SemanticLabels.nextWeek,
                      ).withMinimumTouchTarget(),
                    ],
                  ),
                ],
              ),
            ),
            // Upper half: Weekly Calendar
            WeeklyCalendarWidget(weekStart: weekStart),
            const Divider(height: 1),
            // Lower half: Selected Day Meals
            const SelectedDayMealsSection(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qkomo_ui/core/accessibility/semantic_labels.dart';
import 'package:qkomo_ui/core/accessibility/semantic_wrapper.dart';
import 'package:qkomo_ui/core/widgets/qkomo_navbar.dart';
import 'package:qkomo_ui/features/menu/application/menu_providers.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/generate_ai_menu_cta.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/premium_images_cta.dart';
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
    // Load AI weekly menu on page mount
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    final userId = ref.watch(currentUserIdProvider);
    final dateFormat = DateFormat('d MMM', 'es');

    // Load menu for current week - this runs on every build when weekStart changes
    final menuStateAsync = ref.watch(weeklyMenuByWeekProvider((weekStart, userId)));

    // Sync the loaded menu to MenuController
    menuStateAsync.whenData((weeklyMenu) {
      final currentMenu = ref.read(menuControllerProvider).aiWeeklyMenu;
      // Only update if menu changed to avoid rebuild loops
      if (weeklyMenu != currentMenu) {
        Future.microtask(() {
          ref.read(menuControllerProvider.notifier).state = ref.read(menuControllerProvider).copyWith(
            aiWeeklyMenu: weeklyMenu,
            clearAiWeeklyMenu: weeklyMenu == null,
          );
        });
      }
    });

    final menuState = ref.watch(menuControllerProvider);

    // Sync selectedDay changes with MenuController
    ref.listen<DateTime?>(selectedDayProvider, (previous, next) {
      ref.read(menuControllerProvider.notifier).setSelectedDay(next);
    });

    final weekEnd = weekStart.add(const Duration(days: 6));
    final weekRange =
        '${dateFormat.format(weekStart)} - ${dateFormat.format(weekEnd)}';

    // Check if we should show the AI CTA below calendar
    final showAiCtaBelowCalendar = menuState.showAiGenerateCta;

    debugPrint('[WeeklyMenuPage] BUILD - weekStart=$weekStart, showAiCtaBelowCalendar=$showAiCtaBelowCalendar, '
        'aiWeeklyMenu=${menuState.aiWeeklyMenu != null ? "EXISTS" : "NULL"}');

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
            // Show AI CTA below calendar if no menu generated
            if (showAiCtaBelowCalendar)
              Padding(
                padding: const EdgeInsets.all(16),
                child: GenerateAiMenuCta(
                  onPressed: () async {
                    await ref
                        .read(menuControllerProvider.notifier)
                        .generateAiWeek(weekStart: weekStart);
                    // Invalidate cache to force reload
                    ref.invalidate(weeklyMenuByWeekProvider((weekStart, userId)));
                  },
                ),
              )
            else ...[
              // Premium CTA for unlocking images (shown when menu exists)
              const PremiumImagesCta(),
              // Lower half: Selected Day Meals
              const SelectedDayMealsSection(),
            ],
          ],
        ),
      ),
    );
  }
}

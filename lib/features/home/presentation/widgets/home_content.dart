import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/features/feature_toggles/application/feature_toggle_providers.dart';
import 'package:qkomo_ui/features/feature_toggles/domain/feature_toggle_keys.dart';
import 'package:qkomo_ui/features/home/application/home_providers.dart';
import 'package:qkomo_ui/features/home/presentation/widgets/recent_entries_section.dart';
import 'package:qkomo_ui/features/home/presentation/widgets/upcoming_meals_section.dart';
import 'package:qkomo_ui/features/menu/application/menu_providers.dart';

class HomeContent extends ConsumerWidget {
  const HomeContent({super.key, required this.user});

  final User? user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final yesterdayEntries = ref.watch(yesterdayEntriesProvider);
    final todayEntries = ref.watch(todayEntriesProvider);
    final todayMeals = ref.watch(todayMealsProvider);
    final tomorrowMeals = ref.watch(tomorrowMealsProvider);
    final weeklyMenuAsync = ref.watch(currentWeeklyMenuProvider);
    final weeklyMenu = weeklyMenuAsync.value;
    final isImageAnalysisEnabled = ref.watch(
      featureEnabledProvider(FeatureToggleKeys.isImageAnalysisEnabled),
    );
    final isAiWeeklyMenuEnabled = ref.watch(
      featureEnabledProvider(FeatureToggleKeys.aiWeeklyMenuIsEnabled),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isImageAnalysisEnabled) ...[
            RecentEntriesSection(
              yesterdayEntries: yesterdayEntries,
              todayEntries: todayEntries,
            ),
            const SizedBox(height: 24),
          ],
          UpcomingMealsSection(
            todayMeals: todayMeals,
            tomorrowMeals: tomorrowMeals,
            weeklyMenu: weeklyMenu,
            isAiWeeklyMenuEnabled: isAiWeeklyMenuEnabled,
          ),
        ],
      ),
    );
  }
}

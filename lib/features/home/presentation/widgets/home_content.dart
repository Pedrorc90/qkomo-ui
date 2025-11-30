import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/features/home/application/home_providers.dart';
import 'package:qkomo_ui/features/home/presentation/widgets/day_section.dart';
import 'package:qkomo_ui/features/home/presentation/widgets/tomorrow_section.dart';

class HomeContent extends ConsumerWidget {
  const HomeContent({super.key, required this.user});

  final User? user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final yesterdayEntries = ref.watch(yesterdayEntriesProvider);
    final todayEntries = ref.watch(todayEntriesProvider);
    final tomorrowMeals = ref.watch(tomorrowMealsProvider);

    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final tomorrow = now.add(const Duration(days: 1));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DaySection(
          title: 'Ayer',
          date: yesterday,
          entries: yesterdayEntries,
        ),
        DaySection(
          title: 'Hoy',
          date: now,
          entries: todayEntries,
        ),
        TomorrowSection(
          date: tomorrow,
          meals: tomorrowMeals,
        ),
      ],
    );
  }
}

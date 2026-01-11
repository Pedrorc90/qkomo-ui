import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/core/animations/page_transitions.dart';
import 'package:qkomo_ui/features/home/presentation/widgets/upcoming_meals_section.dart';
import 'package:qkomo_ui/features/menu/application/menu_providers.dart';
import 'package:qkomo_ui/features/menu/presentation/weekly_menu_page.dart';

class HomeContent extends ConsumerWidget {
  const HomeContent({super.key, required this.user});

  final User? user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayMeals = ref.watch(todayMealsProvider);
    final tomorrowMeals = ref.watch(tomorrowMealsProvider);
    final weeklyMenuAsync = ref.watch(currentWeeklyMenuProvider);
    final weeklyMenu = weeklyMenuAsync.value;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Botón "Ver menú" centrado (solo si hay menú)
          if (weeklyMenu != null) ...[
            _buildViewMenuButton(context),
            const SizedBox(height: 16),
          ],

          // Sección de comidas
          UpcomingMealsSection(
            todayMeals: todayMeals,
            tomorrowMeals: tomorrowMeals,
            weeklyMenu: weeklyMenu,
          ),
        ],
      ),
    );
  }

  Widget _buildViewMenuButton(BuildContext context) {
    return Center(
      child: FilledButton.icon(
        onPressed: () => context.pushSlide(const WeeklyMenuPage()),
        icon: const Icon(Icons.restaurant_menu),
        label: const Text('Ver menú completo'),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
    );
  }
}

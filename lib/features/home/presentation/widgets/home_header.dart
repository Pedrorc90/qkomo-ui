import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qkomo_ui/core/accessibility/semantic_wrapper.dart';
import 'package:qkomo_ui/core/animations/page_transitions.dart';
import 'package:qkomo_ui/features/home/presentation/widgets/hero_cta_card.dart';
import 'package:qkomo_ui/features/home/presentation/widgets/weekly_menu_preview_card.dart';
import 'package:qkomo_ui/features/menu/application/menu_providers.dart';
import 'package:qkomo_ui/features/menu/presentation/weekly_menu_page.dart';
import 'package:qkomo_ui/theme/design_tokens.dart';

/// Home header with weekly menu hero
class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key, required this.user});

  final User? user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = user?.displayName?.split(' ').first ?? '';
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, d MMMM', 'es').format(now);
    final formattedDate =
        dateStr.substring(0, 1).toUpperCase() + dateStr.substring(1);

    final hasWeeklyMenu = ref.watch(hasWeeklyMenuProvider);
    final weekMeals = ref.watch(weekMealsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date and greeting
          Text(
            formattedDate,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
          ).withSemantics(isHeader: true),
          const SizedBox(height: 4),
          Text(
            'Hola, $name',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.2,
                ),
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          // Hero Section - Weekly Menu
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: _buildWeeklyMenuHero(context, hasWeeklyMenu, weekMeals.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyMenuHero(
    BuildContext context,
    bool hasWeeklyMenu,
    int weekMealCount,
  ) {
    if (hasWeeklyMenu) {
      return WeeklyMenuPreviewCard(
        mealCount: weekMealCount,
        onTap: () => context.pushSlide(const WeeklyMenuPage()),
      );
    } else {
      return HeroCTACard(
        title: 'Generar menú semanal',
        subtitle: 'Planifica con IA',
        icon: Icons.auto_awesome,
        onTap: () => context.pushSlide(const WeeklyMenuPage()),
        isPrimary: true,
      );
    }
  }
}

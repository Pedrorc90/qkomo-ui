import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qkomo_ui/core/accessibility/semantic_wrapper.dart';
import 'package:qkomo_ui/core/animations/page_transitions.dart';
import 'package:qkomo_ui/features/capture/presentation/capture_bottom_sheet.dart';
import 'package:qkomo_ui/features/feature_toggles/application/feature_toggle_providers.dart';
import 'package:qkomo_ui/features/feature_toggles/domain/feature_toggle_keys.dart';
import 'package:qkomo_ui/features/home/application/home_providers.dart';
import 'package:qkomo_ui/features/home/presentation/widgets/hero_cta_card.dart';
import 'package:qkomo_ui/features/home/presentation/widgets/last_analysis_preview_card.dart';
import 'package:qkomo_ui/features/home/presentation/widgets/next_meal_preview_card.dart';
import 'package:qkomo_ui/features/home/presentation/widgets/weekly_menu_preview_card.dart';
import 'package:qkomo_ui/features/menu/application/menu_providers.dart';
import 'package:qkomo_ui/features/menu/presentation/weekly_menu_page.dart';
import 'package:qkomo_ui/theme/design_tokens.dart';

/// Enhanced home header with next meal image or hero capture button
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

    final nextMeal = ref.watch(nextMealProvider);
    final lastAnalysis = ref.watch(lastAnalysisProvider);
    final isImageAnalysisEnabled = ref.watch(
      featureEnabledProvider(FeatureToggleKeys.isImageAnalysisEnabled),
    );
    final isAiWeeklyMenuEnabled = ref.watch(
      featureEnabledProvider(FeatureToggleKeys.aiWeeklyMenuIsEnabled),
    );
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
          // Hero Section - conditional layout based on features
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: _buildHeroSection(
                context,
                ref,
                isAiWeeklyMenuEnabled: isAiWeeklyMenuEnabled,
                isImageAnalysisEnabled: isImageAnalysisEnabled,
                hasWeeklyMenu: hasWeeklyMenu,
                weekMealCount: weekMeals.length,
                nextMeal: nextMeal,
                lastAnalysis: lastAnalysis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(
    BuildContext context,
    WidgetRef ref, {
    required bool isAiWeeklyMenuEnabled,
    required bool isImageAnalysisEnabled,
    required bool hasWeeklyMenu,
    required int weekMealCount,
    required dynamic nextMeal,
    required dynamic lastAnalysis,
  }) {
    if (isAiWeeklyMenuEnabled) {
      // AI Weekly Menu mode
      if (isImageAnalysisEnabled) {
        // Both features enabled: show menu + analysis
        return Row(
          children: [
            Expanded(
              child:
                  _buildWeeklyMenuHero(context, hasWeeklyMenu, weekMealCount),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildAnalysisHero(context, ref, lastAnalysis),
            ),
          ],
        );
      } else {
        // Only AI menu enabled
        return _buildWeeklyMenuHero(context, hasWeeklyMenu, weekMealCount);
      }
    } else {
      // Legacy mode (original behavior)
      if (isImageAnalysisEnabled) {
        return Row(
          children: [
            Expanded(
              child: _buildMealHero(context, ref, nextMeal),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildAnalysisHero(context, ref, lastAnalysis),
            ),
          ],
        );
      } else {
        return _buildMealHero(context, ref, nextMeal);
      }
    }
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

  Widget _buildMealHero(BuildContext context, WidgetRef ref, dynamic nextMeal) {
    if (nextMeal != null) {
      return NextMealPreviewCard(
        nextMeal: nextMeal,
        onTap: () => context.pushSlide(const WeeklyMenuPage()),
      );
    } else {
      return HeroCTACard(
        title: 'Crea tu menú',
        subtitle: 'Planifica tu semana',
        icon: Icons.restaurant_menu,
        onTap: () => context.pushSlide(const WeeklyMenuPage()),
      );
    }
  }

  Widget _buildAnalysisHero(
      BuildContext context, WidgetRef ref, dynamic lastAnalysis) {
    if (lastAnalysis != null) {
      return LastAnalysisPreviewCard(
        lastAnalysis: lastAnalysis,
        onTap: () => _showCaptureDialog(context),
      );
    } else {
      return HeroCTACard(
        title: 'Analiza comida',
        subtitle: 'Captura tu plato',
        icon: Icons.camera_alt_outlined,
        onTap: () => _showCaptureDialog(context),
        isPrimary: true,
      );
    }
  }

  void _showCaptureDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: CaptureBottomSheet(),
      ),
    );
  }
}

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qkomo_ui/core/accessibility/semantic_labels.dart';
import 'package:qkomo_ui/core/accessibility/semantic_wrapper.dart';
import 'package:qkomo_ui/core/animations/page_transitions.dart';
import 'package:qkomo_ui/features/capture/presentation/capture_bottom_sheet.dart';
import 'package:qkomo_ui/features/home/application/home_providers.dart';
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
    final formattedDate = dateStr.substring(0, 1).toUpperCase() + dateStr.substring(1);

    final nextMeal = ref.watch(nextMealProvider);
    final lastAnalysis = ref.watch(lastAnalysisProvider);

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
          // Dual Hero Section
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                children: [
                  Expanded(
                    child: _buildMealHero(context, ref, nextMeal),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildAnalysisHero(context, ref, lastAnalysis),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealHero(BuildContext context, WidgetRef ref, dynamic nextMeal) {
    if (nextMeal != null) {
      return _buildNextMealCard(context, ref, nextMeal);
    } else {
      return _buildHeroCTA(
        context,
        title: 'Crea tu menú',
        subtitle: 'Planifica tu semana',
        icon: Icons.restaurant_menu,
        onTap: () => context.pushSlide(const WeeklyMenuPage()),
      );
    }
  }

  Widget _buildAnalysisHero(BuildContext context, WidgetRef ref, dynamic lastAnalysis) {
    if (lastAnalysis != null) {
      return _buildLastAnalysisCard(context, ref, lastAnalysis);
    } else {
      return _buildHeroCTA(
        context,
        title: 'Analiza comida',
        subtitle: 'Captura tu plato',
        icon: Icons.camera_alt_outlined,
        onTap: () => _showCaptureDialog(context),
        isPrimary: true,
      );
    }
  }

  Widget _buildHeroCTA(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return _HeroCard(
      onTap: onTap,
      label: '$title. $subtitle',
      isButton: true,
      color: isPrimary ? scheme.primaryContainer : scheme.surfaceContainerLow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
            color: isPrimary ? scheme.onPrimaryContainer : scheme.primary,
            semanticLabel: '', // Handled by _HeroCard label
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          Text(
            title,
            style: textTheme.titleSmall?.copyWith(
              color: isPrimary ? scheme.onPrimaryContainer : scheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: textTheme.labelSmall?.copyWith(
              color: isPrimary
                  ? scheme.onPrimaryContainer.withValues(alpha: 0.8)
                  : scheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNextMealCard(
    BuildContext context,
    WidgetRef ref,
    dynamic nextMeal,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final isAsset = nextMeal.photoPath != null && nextMeal.photoPath!.startsWith('assets/');
    final timeFormat = DateFormat('HH:mm');
    final scheduledTime = timeFormat.format(nextMeal.scheduledFor);

    return _HeroCard(
      onTap: () => context.pushSlide(const WeeklyMenuPage()),
      label: 'Próxima comida: ${nextMeal.name} a las $scheduledTime',
      isButton: true,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (nextMeal.photoPath != null)
            _buildHeroImage(context, nextMeal.photoPath!, isAsset)
          else
            Container(color: Theme.of(context).colorScheme.primaryContainer),
          _buildHeroGradient(),
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Próxima: $scheduledTime',
                  style: textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  nextMeal.name,
                  style: textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastAnalysisCard(
    BuildContext context,
    WidgetRef ref,
    dynamic lastAnalysis,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final String? imagePath = lastAnalysis.imagePath ?? lastAnalysis.jobId;
    final hasImage =
        imagePath != null && (imagePath.startsWith('assets/') || File(imagePath).existsSync());

    return _HeroCard(
      onTap: () => _showCaptureDialog(context),
      label: 'Último análisis: ${lastAnalysis.title ?? 'comida'}. Toca para analizar otra.',
      isButton: true,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (hasImage)
            _buildHeroImage(context, imagePath, imagePath.startsWith('assets/'))
          else
            Container(color: Theme.of(context).colorScheme.surfaceContainer),
          _buildHeroGradient(),
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Último análisis',
                  style: textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  lastAnalysis.title ??
                      (lastAnalysis.ingredients.isNotEmpty
                          ? lastAnalysis.ingredients.first
                          : 'Comida'),
                  style: textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage(BuildContext context, String path, bool isAsset) {
    final scheme = Theme.of(context).colorScheme;
    if (isAsset) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        semanticLabel: SemanticLabels.mealImage,
        errorBuilder: (context, error, stackTrace) =>
            Container(color: scheme.surfaceContainerHighest),
      );
    } else {
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        semanticLabel: SemanticLabels.mealImage,
        errorBuilder: (context, error, stackTrace) =>
            Container(color: scheme.surfaceContainerHighest),
      );
    }
  }

  Widget _buildHeroGradient() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.7),
          ],
        ),
      ),
    );
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

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.child,
    required this.onTap,
    this.color,
    this.label,
    this.isButton = false,
  });

  final Widget child;
  final VoidCallback onTap;
  final Color? color;
  final String? label;
  final bool isButton;

  @override
  Widget build(BuildContext context) {
    return SemanticWrapper(
      onTap: onTap,
      label: label,
      isButton: isButton,
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          // Material handles the color and clipping, this Decoration is just for shadow
          borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: color ?? Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: child,
          ),
        ),
      ),
    );
  }
}

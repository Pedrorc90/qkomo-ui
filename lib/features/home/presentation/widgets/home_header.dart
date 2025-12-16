import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:qkomo_ui/core/widgets/meal_type_chip.dart';
import 'package:qkomo_ui/features/home/application/home_providers.dart';
import 'package:qkomo_ui/features/menu/presentation/weekly_menu_page.dart';
import 'package:qkomo_ui/features/capture/presentation/capture_bottom_sheet.dart';
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

    return Padding(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
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
          ),
          const SizedBox(height: 4),
          Text(
            'Hola, $name',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.2,
                ),
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          // Next meal image or hero capture button
          if (nextMeal != null && nextMeal.photoPath != null)
            _buildNextMealImageSection(context, ref, nextMeal)
          else
            _buildHeroCaptureButton(context),
        ],
      ),
    );
  }

  /// Builds the next meal image section with overlay
  Widget _buildNextMealImageSection(
    BuildContext context,
    WidgetRef ref,
    dynamic nextMeal,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Determine if photo is asset or file
    final isAsset = nextMeal.photoPath!.startsWith('assets/');
    final timeFormat = DateFormat('HH:mm');
    final scheduledTime = timeFormat.format(nextMeal.scheduledFor);

    // Determine if meal is today or tomorrow
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final mealDate = DateTime(
      nextMeal.scheduledFor.year,
      nextMeal.scheduledFor.month,
      nextMeal.scheduledFor.day,
    );

    final isTomorrow = mealDate.year == tomorrow.year &&
        mealDate.month == tomorrow.month &&
        mealDate.day == tomorrow.day;

    final timeLabel =
        isTomorrow ? 'Mañana a las $scheduledTime' : 'Hoy a las $scheduledTime';

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const WeeklyMenuPage(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
          child: Stack(
            children: [
              // Image background
              if (isAsset)
                Image.asset(
                  nextMeal.photoPath!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: scheme.surfaceContainerHighest,
                    );
                  },
                )
              else
                Container(
                  width: double.infinity,
                  height: 200,
                  color: scheme.surfaceContainerHighest,
                  child: Image.file(
                    File(nextMeal.photoPath!),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: scheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.image_not_supported,
                          color: scheme.onSurfaceVariant,
                        ),
                      );
                    },
                  ),
                ),

              // Gradient overlay
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.0),
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),

              // Text overlay
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tu próxima comida',
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            nextMeal.name,
                            style: textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        MealTypeChip(
                          mealType: nextMeal.mealType,
                          variant: MealTypeChipVariant.iconOnly,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      timeLabel,
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the hero capture button for when no meal is planned
  Widget _buildHeroCaptureButton(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: GestureDetector(
        onTap: () {
          _showCaptureDialog(context);
        },
        child: SizedBox(
          width: double.infinity,
          child: Card(
            elevation: DesignTokens.elevationMd,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
            ),
            color: scheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: DesignTokens.spacingXl,
                horizontal: DesignTokens.spacingLg,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    size: 64,
                    color: scheme.onPrimaryContainer,
                  ),
                  const SizedBox(height: DesignTokens.spacingMd),
                  Text(
                    'Captura tu comida',
                    style: textTheme.titleLarge?.copyWith(
                      color: scheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: DesignTokens.spacingSm),
                  Text(
                    'Toca para tomar una foto o escanear código de barras',
                    style: textTheme.bodyMedium?.copyWith(
                      color: scheme.onPrimaryContainer.withValues(alpha: 0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
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
        insetPadding: EdgeInsets.all(24),
        child: CaptureBottomSheet(scrollController: null),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qkomo_ui/core/widgets/allergen_badge.dart';
import 'package:qkomo_ui/core/widgets/animated_card.dart';
import 'package:qkomo_ui/core/widgets/meal_type_chip.dart';
import 'package:qkomo_ui/features/capture/domain/capture_result.dart';
import 'package:qkomo_ui/theme/app_colors.dart';
import 'package:qkomo_ui/theme/app_typography.dart';
import 'package:qkomo_ui/theme/design_tokens.dart';

/// Enhanced result card with photo, meal type, time, ingredients, allergens and review status
class EnhancedResultCard extends StatelessWidget {
  const EnhancedResultCard({
    super.key,
    required this.result,
    required this.onTap,
  });

  final CaptureResult result;
  final VoidCallback onTap;

  static final _timeFormat = DateFormat('HH:mm', 'es');

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      onTap: onTap,
      padding: EdgeInsets.all(DesignTokens.spacingMd),
      elevation: 0,
      borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail larger (80x80dp)
          _buildThumbnail(context),
          SizedBox(width: DesignTokens.spacingMd),

          // Main content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: meal type icon + title + time
                Row(
                  children: [
                    if (result.mealType != null) ...[
                      MealTypeChip(
                        mealType: result.mealType!,
                        variant: MealTypeChipVariant.iconOnly,
                      ),
                      SizedBox(width: DesignTokens.spacingSm),
                    ],
                    Expanded(
                      child: Text(
                        result.title ??
                            'Captura ${result.jobId.substring(0, 6)}',
                        style: AppTypography.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      _timeFormat.format(result.savedAt),
                      style: AppTypography.labelSmall.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: DesignTokens.spacingXs),

                // Ingredient counter and top 3
                if (result.ingredients.isNotEmpty) ...[
                  Text(
                    '${result.ingredients.length} ${result.ingredients.length == 1 ? 'ingrediente' : 'ingredientes'}',
                    style: AppTypography.bodySmall.copyWith(
                      color:
                          Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: DesignTokens.spacingXs),

                  // Top 3 ingredients
                  Text(
                    _getTopIngredients(),
                    style: AppTypography.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                // Allergen badges and reviewed status
                if (result.allergens.isNotEmpty || result.isReviewed) ...[
                  SizedBox(height: DesignTokens.spacingSm),
                  Wrap(
                    spacing: DesignTokens.spacingXs,
                    runSpacing: DesignTokens.spacingXs,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      // Maximum 2 allergens
                      ...result.allergens.take(2).map(
                            (allergen) => AllergenBadge(
                              allergen: allergen,
                              isPersonalAlert: true,
                            ),
                          ),

                      // Reviewed indicator
                      if (result.isReviewed) ...[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 14,
                              color: AppColors.semanticSuccess,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Revisado',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.semanticSuccess,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
      ),
      child: Icon(
        Icons.fastfood,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        size: 36,
      ),
    );
  }

  String _getTopIngredients() {
    final top3 = result.ingredients.take(3).join(', ');
    if (result.ingredients.length > 3) {
      return '$top3...';
    }
    return top3;
  }
}

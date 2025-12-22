import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/features/history/application/history_providers.dart';
import 'package:qkomo_ui/features/history/utils/date_grouping_helper.dart';
import 'package:qkomo_ui/theme/app_typography.dart';
import 'package:qkomo_ui/theme/design_tokens.dart';

/// Header for date group sections with statistics
class DateGroupHeader extends ConsumerWidget {
  const DateGroupHeader({
    super.key,
    required this.group,
    this.date,
  });

  final DateGroup group;
  final DateTime? date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final label = DateGroupingHelper.getDateGroupLabel(group, date: date);
    final stats = ref.watch(dateGroupStatsProvider)[group];

    return Container(
      margin: const EdgeInsets.only(
        top: DesignTokens.spacingMd,
        bottom: DesignTokens.spacingSm,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: DesignTokens.spacingMd,
        horizontal: DesignTokens.spacingMd,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .primaryContainer
            .withValues(alpha: 0.1),
        border: Border(
          left: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 4,
          ),
        ),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(DesignTokens.radiusSm),
          bottomRight: Radius.circular(DesignTokens.radiusSm),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.titleSmall.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (stats != null && stats.mealCount > 0) ...[
            const SizedBox(height: DesignTokens.spacingXs),
            Text(
              '${stats.mealCount} ${stats.mealCount == 1 ? 'comida' : 'comidas'} • ${stats.ingredientCount} ${stats.ingredientCount == 1 ? 'ingrediente' : 'ingredientes'}',
              style: AppTypography.bodySmall.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

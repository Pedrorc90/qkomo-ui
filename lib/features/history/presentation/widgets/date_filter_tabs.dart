import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/features/history/application/history_providers.dart';
import 'package:qkomo_ui/features/history/domain/entities/date_filter.dart';
import 'package:qkomo_ui/theme/app_typography.dart';
import 'package:qkomo_ui/theme/design_tokens.dart';

/// Tab bar for filtering history by date with entry counts
class DateFilterTabs extends ConsumerWidget {
  const DateFilterTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historyControllerProvider);
    final controller = ref.read(historyControllerProvider.notifier);
    final counts = ref.watch(filterCountsProvider);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
      ),
      padding: const EdgeInsets.all(DesignTokens.spacingXs),
      child: Row(
        children: [
          Expanded(
            child: _FilterTab(
              label: 'Hoy',
              count: counts[DateFilter.today],
              isSelected: state.dateFilter == DateFilter.today,
              onTap: () => controller.setDateFilter(DateFilter.today),
            ),
          ),
          const SizedBox(width: DesignTokens.spacingXs),
          Expanded(
            child: _FilterTab(
              label: 'Esta semana',
              count: counts[DateFilter.thisWeek],
              isSelected: state.dateFilter == DateFilter.thisWeek,
              onTap: () => controller.setDateFilter(DateFilter.thisWeek),
            ),
          ),
          const SizedBox(width: DesignTokens.spacingXs),
          Expanded(
            child: _FilterTab(
              label: 'Todo',
              count: counts[DateFilter.all],
              isSelected: state.dateFilter == DateFilter.all,
              onTap: () => controller.setDateFilter(DateFilter.all),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  const _FilterTab({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int? count;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: DesignTokens.durationFast,
      curve: Curves.easeInOut,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: DesignTokens.spacingMd,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppTypography.labelLarge.copyWith(
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              if (count != null) ...[
                const SizedBox(height: DesignTokens.spacingXs),
                Text(
                  '$count',
                  style: AppTypography.bodySmall.copyWith(
                    color: isSelected
                        ? Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withValues(alpha: 0.7)
                        : Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant
                            .withValues(alpha: 0.6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

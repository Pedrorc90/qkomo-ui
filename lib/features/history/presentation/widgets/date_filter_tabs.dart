import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/features/history/application/history_controller.dart';
import 'package:qkomo_ui/features/history/application/history_providers.dart';

/// Tab bar for filtering history by date
class DateFilterTabs extends ConsumerWidget {
  const DateFilterTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historyControllerProvider);
    final controller = ref.read(historyControllerProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: _FilterTab(
              label: 'Hoy',
              isSelected: state.dateFilter == DateFilter.today,
              onTap: () => controller.setDateFilter(DateFilter.today),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _FilterTab(
              label: 'Esta semana',
              isSelected: state.dateFilter == DateFilter.thisWeek,
              onTap: () => controller.setDateFilter(DateFilter.thisWeek),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _FilterTab(
              label: 'Todo',
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
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

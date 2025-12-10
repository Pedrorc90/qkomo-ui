import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/core/widgets/qkomo_navbar.dart';
import 'package:qkomo_ui/features/capture/application/capture_providers.dart';
import 'package:qkomo_ui/features/capture/presentation/review/capture_review_page.dart';
import 'package:qkomo_ui/features/entry/domain/entry.dart';
import 'package:qkomo_ui/features/entry/domain/sync_status.dart';
import 'package:qkomo_ui/features/history/application/history_controller.dart';
import 'package:qkomo_ui/features/history/application/history_providers.dart';
import 'package:qkomo_ui/features/history/utils/date_grouping_helper.dart';
import 'package:qkomo_ui/features/history/presentation/widgets/date_filter_tabs.dart';
import 'package:qkomo_ui/features/history/presentation/widgets/date_group_header.dart';
import 'package:qkomo_ui/features/history/presentation/widgets/enhanced_result_card.dart';
import 'package:qkomo_ui/features/history/presentation/widgets/history_search_bar.dart';
import 'package:qkomo_ui/features/statistics/presentation/statistics_page.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(historyControllerProvider);
    final groupedEntries = ref.watch(groupedEntriesProvider);
    final queueStatsAsync = ref.watch(queueStatsProvider);

    return Scaffold(
      appBar: QkomoNavBar(
        actions: [
          const HistorySearchBar(),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StatisticsPage(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _onRefresh(ref),
        child: CustomScrollView(
          slivers: [
            // Queue stats (collapsed)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: queueStatsAsync.when(
                  data: (stats) => _buildQueueStats(context, stats),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ),
            ),

            // Date filter tabs
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: DateFilterTabs(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Grouped results
            _buildGroupedEntries(context, ref, groupedEntries, historyState),
          ],
        ),
      ),
    );
  }

  Widget _buildQueueStats(BuildContext context, QueueStats stats) {
    if (stats.total == 0) return const SizedBox.shrink();

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer.withAlpha((0.5 * 255).round()),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.sync, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Cola: ${stats.pending} pendientes, ${stats.processing} procesando',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            if (stats.failed > 0)
              Chip(
                label: Text('${stats.failed} fallidas'),
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupedEntries(
    BuildContext context,
    WidgetRef ref,
    Map<DateGroup, List<Entry>> groupedEntries,
    HistoryState historyState,
  ) {
    // Check if we have any results
    final hasResults = groupedEntries.values.any((list) => list.isNotEmpty);

    if (!hasResults) {
      return SliverFillRemaining(
        child: _buildEmptyState(context, historyState),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final groups = [
            DateGroup.today,
            DateGroup.yesterday,
            DateGroup.thisWeek,
            DateGroup.older,
          ];

          // Build sections for each group that has results
          final widgets = <Widget>[];
          for (final group in groups) {
            final entries = groupedEntries[group] ?? [];
            if (entries.isEmpty) continue;

            widgets.add(
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DateGroupHeader(group: group),
              ),
            );

            for (final entry in entries) {
              widgets.add(
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Stack(
                    children: [
                      EnhancedResultCard(
                        result: entry.result,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CaptureReviewPage(resultId: entry.id),
                            ),
                          );
                        },
                      ),
                      if (entry.syncStatus == SyncStatus.pending)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.orange.withAlpha((0.8 * 255).round()),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.cloud_upload,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      if (entry.syncStatus == SyncStatus.failed)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red.withAlpha((0.8 * 255).round()),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.sync_problem,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }
          }

          if (index >= widgets.length) return null;
          return widgets[index];
        },
        childCount: _countWidgets(groupedEntries),
      ),
    );
  }

  int _countWidgets(Map<DateGroup, List<Entry>> groupedEntries) {
    int count = 0;
    for (final group in DateGroup.values) {
      final entries = groupedEntries[group] ?? [];
      if (entries.isNotEmpty) {
        count += 1 + entries.length; // header + results
      }
    }
    return count;
  }

  Widget _buildEmptyState(BuildContext context, HistoryState state) {
    String message;
    IconData icon;

    if (state.hasSearch) {
      message = 'No se encontraron resultados para "${state.searchQuery}"';
      icon = Icons.search_off;
    } else {
      switch (state.dateFilter) {
        case DateFilter.today:
          message = 'Aún no has registrado comidas hoy.\n¡Empieza capturando una foto!';
          icon = Icons.camera_alt_outlined;
          break;
        case DateFilter.thisWeek:
          message = 'No hay entradas esta semana.';
          icon = Icons.calendar_today_outlined;
          break;
        case DateFilter.all:
          message = 'No hay entradas guardadas.';
          icon = Icons.inbox_outlined;
          break;
      }
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh(WidgetRef ref) async {
    // Trigger queue processing
    await ref.read(captureQueueProcessControllerProvider.notifier).processPending();
  }
}

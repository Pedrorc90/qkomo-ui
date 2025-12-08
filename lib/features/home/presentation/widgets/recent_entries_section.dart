import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:qkomo_ui/features/capture/domain/capture_result.dart';
import 'package:qkomo_ui/features/history/presentation/history_page.dart';

class RecentEntriesSection extends StatelessWidget {
  const RecentEntriesSection({
    super.key,
    required this.yesterdayEntries,
    required this.todayEntries,
  });

  final List<CaptureResult> yesterdayEntries;
  final List<CaptureResult> todayEntries;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.history,
                  color: colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Registros Recientes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HistoryPage(),
                      ),
                    );
                  },
                  child: const Text('Ver todo'),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (todayEntries.isEmpty && yesterdayEntries.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 48,
                            color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No hay registros recientes',
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else ...[
                  if (todayEntries.isNotEmpty) ...[
                    _buildDaySubsection(
                      context,
                      'Hoy',
                      todayEntries,
                      colorScheme,
                    ),
                    if (yesterdayEntries.isNotEmpty) const SizedBox(height: 16),
                  ],
                  if (yesterdayEntries.isNotEmpty)
                    _buildDaySubsection(
                      context,
                      'Ayer',
                      yesterdayEntries,
                      colorScheme,
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySubsection(
    BuildContext context,
    String title,
    List<CaptureResult> entries,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        ...entries.map((entry) => _buildEntryCard(context, entry, colorScheme)),
      ],
    );
  }

  Widget _buildEntryCard(
    BuildContext context,
    CaptureResult entry,
    ColorScheme colorScheme,
  ) {
    final timeFormat = DateFormat('HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Icon(
          entry.isManualEntry ? Icons.edit : Icons.camera_alt,
          color: colorScheme.primary,
        ),
        title: Text(
          entry.title ??
              (entry.ingredients.isNotEmpty
                  ? entry.ingredients.take(2).join(', ')
                  : 'Sin ingredientes detectados'),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14),
        ),
        subtitle: Text(
          timeFormat.format(entry.savedAt),
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: colorScheme.onSurfaceVariant,
        ),
        onTap: () {
          // Navigate to entry details if needed
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const HistoryPage(),
            ),
          );
        },
      ),
    );
  }
}

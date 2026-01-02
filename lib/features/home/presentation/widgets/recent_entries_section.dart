import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qkomo_ui/core/animations/page_transitions.dart';
import 'package:qkomo_ui/core/widgets/widgets.dart';
import 'package:qkomo_ui/core/widgets/platform_image.dart';
import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';
import 'package:qkomo_ui/features/history/presentation/history_page.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';

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

    final limitedToday = todayEntries.take(4).toList();
    final remainingSlots = 4 - limitedToday.length;
    final limitedYesterday = yesterdayEntries.take(remainingSlots).toList();

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.3),
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
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => context.pushSlide(const HistoryPage()),
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
                            color: colorScheme.onSurfaceVariant
                                .withAlpha((0.5 * 255).round()),
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
                      limitedToday,
                      colorScheme,
                    ),
                    if (limitedYesterday.isNotEmpty) const SizedBox(height: 16),
                  ],
                  if (limitedYesterday.isNotEmpty)
                    _buildDaySubsection(
                      context,
                      'Ayer',
                      limitedYesterday,
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
    final textTheme = Theme.of(context).textTheme;

    // Check if we should try to display an image
    final hasImage = !entry.isManualEntry && entry.jobId.isNotEmpty;

    // Get title - prefer custom title, then first 3 ingredients
    final titleText = entry.title ??
        (entry.ingredients.isNotEmpty
            ? entry.ingredients.take(3).join(', ')
            : 'Sin ingredientes detectados');

    return AnimatedCard(
      onTap: () => context.pushSlide(const HistoryPage()),
      elevation: 0,
      color: Colors.transparent,
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          children: [
            hasImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: PlatformImage(
                      path: entry.jobId,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.image_not_supported,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        );
                      },
                    ),
                  )
                : Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer
                          .withAlpha((0.3 * 255).round()),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      entry.isManualEntry ? Icons.edit : Icons.camera_alt,
                      color: colorScheme.primary,
                    ),
                  ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (entry.mealType != null) ...[
                        MealTypeChip(
                          mealType: entry.mealType!,
                          variant: MealTypeChipVariant.iconOnly,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(
                          titleText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (entry.mealType != null)
                        Text(
                          entry.mealType!.displayName,
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      Text(
                        timeFormat.format(entry.savedAt),
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  if (entry.allergens.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      children: entry.allergens.take(2).map((allergen) {
                        return AllergenBadge(
                          allergen: allergen,
                          isPersonalAlert: true,
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

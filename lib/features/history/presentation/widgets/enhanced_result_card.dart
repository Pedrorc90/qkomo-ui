import 'package:flutter/material.dart';
import 'package:qkomo_ui/features/capture/domain/capture_result.dart';

/// Enhanced result card with photo, ingredients, and allergens
class EnhancedResultCard extends StatelessWidget {
  const EnhancedResultCard({
    super.key,
    required this.result,
    required this.onTap,
  });

  final CaptureResult result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo thumbnail (placeholder for now)
              _buildThumbnail(context),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      result.title ?? 'Captura ${result.jobId.substring(0, 6)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Ingredient count and top 3
                    if (result.ingredients.isNotEmpty) ...[
                      Text(
                        '${result.ingredients.length} ingredientes',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getTopIngredients(),
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    // Allergen badges
                    if (result.allergens.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: result.allergens.take(3).map((allergen) {
                          return Chip(
                            label: Text(
                              allergen,
                              style: const TextStyle(fontSize: 11),
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.errorContainer.withOpacity(0.5),
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),

              // Review status indicator
              if (result.isReviewed)
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.fastfood,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        size: 30,
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

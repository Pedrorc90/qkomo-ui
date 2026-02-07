import 'package:flutter/material.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';

/// Grid card displaying a recipe with image, name, and details
class RecipeGridCard extends StatelessWidget {
  const RecipeGridCard({
    required this.name,
    required this.photoPath,
    required this.ingredientCount,
    required this.mealType,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  final String name;
  final String? photoPath;
  final int ingredientCount;
  final MealType mealType;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Recipe image with delete button overlay
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _buildImage(context),
                  _buildDeleteButton(context),
                ],
              ),
            ),
            // Recipe details
            _buildDetails(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    if (photoPath == null) {
      return Container(
        color: Theme.of(context).colorScheme.outlineVariant,
        child: const Icon(Icons.restaurant),
      );
    }

    return Image.asset(
      photoPath!,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Theme.of(context).colorScheme.outlineVariant,
          child: const Icon(Icons.restaurant),
        );
      },
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return Positioned(
      top: 4,
      right: 4,
      child: GestureDetector(
        onTap: onDelete,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.delete_outline,
            size: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            '$ingredientCount ingredientes',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 1),
          Text(
            mealType.displayName,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

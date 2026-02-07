import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/core/accessibility/semantic_labels.dart';
import 'package:qkomo_ui/core/accessibility/semantic_wrapper.dart';
import 'package:qkomo_ui/core/widgets/widgets.dart';
import 'package:qkomo_ui/features/menu/application/menu_providers.dart';
import 'package:qkomo_ui/features/menu/domain/meal.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/delete_meal_confirm_dialog.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/meal_card_image.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/meal_form_dialog.dart';

class MealCard extends ConsumerStatefulWidget {
  const MealCard({
    super.key,
    required this.meal,
  });

  final Meal meal;

  @override
  ConsumerState<MealCard> createState() => _MealCardState();
}

class _MealCardState extends ConsumerState<MealCard> {
  bool _isHovered = false;

  Future<void> _handleDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => DeleteMealConfirmDialog(mealName: widget.meal.name),
    );

    if (confirmed == true && mounted) {
      await ref.read(menuControllerProvider.notifier).deleteMeal(widget.meal.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mealTypeColor = _getMealTypeColor(context, widget.meal.mealType);

    return Semantics(
      label:
          'Comida: ${widget.meal.name}. Tipo: ${widget.meal.mealType.displayName}. Ingredientes: ${widget.meal.ingredients.length}.',
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedCard(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => MealFormDialog(
                date: widget.meal.scheduledFor,
                mealType: widget.meal.mealType,
                existingMeal: widget.meal,
              ),
            );
          },
          elevation: _isHovered ? 8 : 2,
          borderRadius: BorderRadius.circular(12),
          padding: EdgeInsets.zero,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isHovered
                    ? mealTypeColor.withAlpha((0.3 * 255).round())
                    : colorScheme.outlineVariant,
                width: _isHovered ? 2 : 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  MealCardImage(
                    photoPath: widget.meal.photoPath,
                    mealType: widget.meal.mealType,
                    mealTypeColor: mealTypeColor,
                  ),
                  const SizedBox(width: 12),
                  // Meal info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.meal.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Meal type chip
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: mealTypeColor.withAlpha((0.15 * 255).round()),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: mealTypeColor.withAlpha((0.3 * 255).round()),
                                ),
                              ),
                              child: Text(
                                widget.meal.mealType.displayName,
                                style: TextStyle(
                                  color: mealTypeColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.layers,
                              size: 14,
                              color: colorScheme.onSurfaceVariant.withAlpha((0.7 * 255).round()),
                              semanticLabel: '',
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.meal.ingredients.length} ingrediente${widget.meal.ingredients.length != 1 ? 's' : ''}',
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Delete button with improved feedback
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: _isHovered ? colorScheme.error : colorScheme.onSurfaceVariant,
                      ),
                      tooltip: SemanticLabels.deleteMeal,
                      onPressed: () => _handleDelete(context),
                    ).withMinimumTouchTarget(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getMealTypeColor(BuildContext context, MealType type) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (type) {
      case MealType.lunch:
        return colorScheme.secondary;
      case MealType.dinner:
        return colorScheme.error;
    }
  }
}

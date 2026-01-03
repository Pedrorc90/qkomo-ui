import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/core/accessibility/semantic_labels.dart';
import 'package:qkomo_ui/core/accessibility/semantic_wrapper.dart';
import 'package:qkomo_ui/core/widgets/widgets.dart';
import 'package:qkomo_ui/features/menu/application/menu_providers.dart';
import 'package:qkomo_ui/features/menu/domain/meal.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';
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
                  // Meal Image with type badge
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: widget.meal.photoPath != null
                            ? (widget.meal.photoPath!.startsWith('assets/')
                                ? Image.asset(
                                    widget.meal.photoPath!,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    semanticLabel: SemanticLabels.mealImage,
                                    errorBuilder: (_, __, ___) =>
                                        _buildPlaceholder(context),
                                  )
                                : Image.file(
                                    File(widget.meal.photoPath!),
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    semanticLabel: SemanticLabels.mealImage,
                                    errorBuilder: (_, __, ___) =>
                                        _buildPlaceholder(context),
                                  ))
                            : _buildPlaceholder(context),
                      ),
                      // Meal type badge on image
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: mealTypeColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                            ),
                          ),
                          child: Icon(
                            _getMealIcon(widget.meal.mealType),
                            size: 14,
                            color: Colors.white,
                            semanticLabel: '', // Decorative within the card
                          ),
                        ),
                      ),
                    ],
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
                                color: mealTypeColor
                                    .withAlpha((0.15 * 255).round()),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: mealTypeColor
                                      .withAlpha((0.3 * 255).round()),
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
                              color: colorScheme.onSurfaceVariant
                                  .withAlpha((0.7 * 255).round()),
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
                        color: _isHovered
                            ? colorScheme.error
                            : colorScheme.onSurfaceVariant,
                      ),
                      tooltip: SemanticLabels.deleteMeal,
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => Dialog(
                            insetPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 24),
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Eliminar comida',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                      '¿Estás seguro de que quieres eliminar "${widget.meal.name}"?'),
                                  const SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text('Cancelar'),
                                      ),
                                      const SizedBox(width: 8),
                                      FilledButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: const Text('Eliminar'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );

                        if (confirmed == true && mounted) {
                          await ref
                              .read(menuControllerProvider.notifier)
                              .deleteMeal(widget.meal.id);
                        }
                      },
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

  IconData _getMealIcon(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return Icons.free_breakfast;
      case MealType.lunch:
        return Icons.restaurant;
      case MealType.snack:
        return Icons.cookie;
      case MealType.dinner:
        return Icons.dinner_dining;
    }
  }

  Color _getMealTypeColor(BuildContext context, MealType type) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (type) {
      case MealType.breakfast:
        return colorScheme.primary;
      case MealType.lunch:
        return colorScheme.secondary;
      case MealType.snack:
        return colorScheme.tertiary;
      case MealType.dinner:
        return colorScheme.error;
    }
  }

  Widget _buildPlaceholder(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 60,
      height: 60,
      color: colorScheme.surfaceContainerHighest,
      child: Icon(Icons.restaurant, color: colorScheme.onSurfaceVariant),
    );
  }
}

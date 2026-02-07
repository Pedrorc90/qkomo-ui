import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qkomo_ui/core/accessibility/semantic_labels.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';

/// Meal image with type badge overlay
class MealCardImage extends StatelessWidget {
  const MealCardImage({
    required this.photoPath,
    required this.mealType,
    required this.mealTypeColor,
    super.key,
  });

  final String? photoPath;
  final MealType mealType;
  final Color mealTypeColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: _buildImage(context),
        ),
        _buildTypeBadge(),
      ],
    );
  }

  Widget _buildImage(BuildContext context) {
    if (photoPath == null) {
      return _buildPlaceholder(context);
    }

    if (photoPath!.startsWith('assets/')) {
      return Image.asset(
        photoPath!,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        semanticLabel: SemanticLabels.mealImage,
        errorBuilder: (_, __, ___) => _buildPlaceholder(context),
      );
    }

    return Image.file(
      File(photoPath!),
      width: 60,
      height: 60,
      fit: BoxFit.cover,
      semanticLabel: SemanticLabels.mealImage,
      errorBuilder: (_, __, ___) => _buildPlaceholder(context),
    );
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

  Widget _buildTypeBadge() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: mealTypeColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
          ),
        ),
        child: Icon(
          _getMealIcon(mealType),
          size: 14,
          color: Colors.white,
          semanticLabel: '',
        ),
      ),
    );
  }

  IconData _getMealIcon(MealType type) {
    switch (type) {
      case MealType.lunch:
        return Icons.restaurant;
      case MealType.dinner:
        return Icons.dinner_dining;
    }
  }
}

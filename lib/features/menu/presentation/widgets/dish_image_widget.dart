import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:qkomo_ui/features/menu/data/models/weekly_meal_type.dart';

enum DishImageType {
  aiGenerated,
  stock,
}

class DishImageWidget extends StatelessWidget {
  const DishImageWidget({
    super.key,
    this.imageUrl,
    this.imageType = DishImageType.stock,
    required this.mealType,
    this.width = 48,
    this.height = 48,
    this.borderRadius = 8,
  });

  final String? imageUrl;
  final DishImageType imageType;
  final WeeklyMealType mealType;
  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildFallback(context, colorScheme);
    }

    final imageWidget = CachedNetworkImage(
      imageUrl: imageUrl!,
      width: double.infinity,
      height: height,
      fit: BoxFit.cover,
      placeholder: (context, url) => _buildLoadingShimmer(colorScheme),
      errorWidget: (context, url, error) => _buildFallback(context, colorScheme),
    );

    if (borderRadius == 0) {
      return imageWidget;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: imageWidget,
    );
  }

  Widget _buildLoadingShimmer(ColorScheme colorScheme) {
    final shimmerContainer = Container(
      width: width == double.infinity ? null : width,
      height: height,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: borderRadius > 0 ? BorderRadius.circular(borderRadius) : null,
      ),
    );

    return Shimmer.fromColors(
      baseColor: colorScheme.surfaceContainerHighest,
      highlightColor: colorScheme.surface,
      child: shimmerContainer,
    );
  }

  Widget _buildFallback(BuildContext context, ColorScheme colorScheme) {
    return Container(
      width: width == double.infinity ? null : width,
      height: height,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: borderRadius > 0 ? BorderRadius.circular(borderRadius) : null,
      ),
      child: Icon(
        _getMealIcon(mealType),
        color: colorScheme.secondary,
        size: width == double.infinity ? 48 : width * 0.5,
      ),
    );
  }

  IconData _getMealIcon(WeeklyMealType type) {
    switch (type) {
      case WeeklyMealType.lunch:
        return Icons.restaurant;
      case WeeklyMealType.dinner:
        return Icons.dinner_dining;
    }
  }
}

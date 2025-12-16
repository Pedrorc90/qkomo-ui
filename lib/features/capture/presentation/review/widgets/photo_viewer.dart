import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';

import 'package:qkomo_ui/features/menu/domain/meal_type.dart';
import 'package:qkomo_ui/core/widgets/meal_type_chip.dart';
import 'package:qkomo_ui/theme/design_tokens.dart';

/// Widget for viewing photos with zoom and pan capabilities
class PhotoViewer extends StatelessWidget {
  const PhotoViewer({
    super.key,
    this.imagePath,
    this.title,
    this.capturedAt,
    this.estimatedPortionG,
    this.selectedMealType,
    this.onMealTypeChanged,
  });

  final String? imagePath;
  final String? title;
  final DateTime? capturedAt;
  final int? estimatedPortionG;
  final MealType? selectedMealType;
  final Function(MealType?)? onMealTypeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Photo viewer
        _buildPhotoView(context),
        const SizedBox(height: 12),

        // Metadata bar (timestamp + portion)
        _buildMetadataBar(context),
        const SizedBox(height: 16),

        // Meal type selector
        _buildMealTypeSelector(context),
      ],
    );
  }

  Widget _buildPhotoView(BuildContext context) {
    if (imagePath == null || imagePath!.isEmpty) {
      return _buildPlaceholder(context);
    }

    final file = File(imagePath!);
    if (!file.existsSync()) {
      return _buildPlaceholder(context);
    }

    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: PhotoView(
        imageProvider: FileImage(file),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 3,
        initialScale: PhotoViewComputedScale.contained,
        backgroundDecoration: const BoxDecoration(
          color: Colors.black,
        ),
        loadingBuilder: (context, event) => Center(
          child: CircularProgressIndicator(
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
          ),
        ),
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder(context);
        },
      ),
    );
  }

  Widget _buildMetadataBar(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time,
            size: 16,
            color: scheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Text(
            _formatTimestamp(capturedAt),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          if (estimatedPortionG != null) ...[
            const SizedBox(width: 16),
            Icon(
              Icons.scale,
              size: 16,
              color: scheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              '~${estimatedPortionG}g',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMealTypeSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo de comida',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: MealType.values.map((mealType) {
            return MealTypeChip(
              mealType: mealType,
              isSelected: selectedMealType == mealType,
              variant: MealTypeChipVariant.compact,
              onTap: onMealTypeChanged != null
                  ? () => onMealTypeChanged!(
                      selectedMealType == mealType ? null : mealType)
                  : null,
            );
          }).toList(),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return 'Fecha desconocida';

    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return 'Hoy, ${DateFormat('HH:mm').format(timestamp)}';
    } else if (difference.inDays == 1) {
      return 'Ayer, ${DateFormat('HH:mm').format(timestamp)}';
    } else {
      return DateFormat('d MMM, HH:mm', 'es').format(timestamp);
    }
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 8),
          Text(
            title ?? 'Sin imagen',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

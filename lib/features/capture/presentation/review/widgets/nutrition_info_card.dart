import 'package:flutter/material.dart';

import 'package:qkomo_ui/features/capture/domain/capture_result.dart';
import 'package:qkomo_ui/theme/design_tokens.dart';

/// Card para mostrar información nutricional
class NutritionInfoCard extends StatelessWidget {
  const NutritionInfoCard({
    super.key,
    required this.nutrition,
  });

  final CaptureNutrition nutrition;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.restaurant_menu,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Información nutricional',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Grid de macros
            Row(
              children: [
                Expanded(
                  child: _buildNutrientItem(
                    context,
                    'Calorías',
                    '${nutrition.calories ?? 0}',
                    'kcal',
                    Icons.local_fire_department,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildNutrientItem(
                    context,
                    'Proteínas',
                    '${nutrition.proteinsG?.toStringAsFixed(1) ?? 0}',
                    'g',
                    Icons.fitness_center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildNutrientItem(
                    context,
                    'Carbohidratos',
                    '${nutrition.carbohydratesG?.toStringAsFixed(1) ?? 0}',
                    'g',
                    Icons.grain,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildNutrientItem(
                    context,
                    'Grasas',
                    '${nutrition.fatsG?.toStringAsFixed(1) ?? 0}',
                    'g',
                    Icons.water_drop,
                  ),
                ),
              ],
            ),
            if (nutrition.fiberG != null) ...[
              const SizedBox(height: 12),
              _buildNutrientItem(
                context,
                'Fibra',
                nutrition.fiberG!.toStringAsFixed(1),
                'g',
                Icons.eco,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientItem(
    BuildContext context,
    String label,
    String value,
    String unit,
    IconData icon,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            '$value$unit',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

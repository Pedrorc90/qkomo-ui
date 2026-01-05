import 'package:flutter/material.dart';
import 'package:qkomo_ui/core/accessibility/semantic_wrapper.dart';
import 'package:qkomo_ui/theme/design_tokens.dart';

class WeeklyMenuPreviewCard extends StatelessWidget {
  const WeeklyMenuPreviewCard({
    super.key,
    required this.mealCount,
    required this.onTap,
  });

  final int mealCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SemanticWrapper(
      onTap: onTap,
      label: 'Menú semanal. $mealCount comidas planificadas',
      isButton: true,
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: scheme.secondaryContainer,
          borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 32,
                  color: scheme.onSecondaryContainer,
                  semanticLabel: '',
                ),
                const SizedBox(height: DesignTokens.spacingSm),
                Text(
                  'Menú semanal',
                  style: textTheme.titleSmall?.copyWith(
                    color: scheme.onSecondaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  '$mealCount comidas planificadas',
                  style: textTheme.labelSmall?.copyWith(
                    color: scheme.onSecondaryContainer.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

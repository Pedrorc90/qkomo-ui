import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qkomo_ui/core/accessibility/semantic_labels.dart';
import 'package:qkomo_ui/core/accessibility/semantic_wrapper.dart';
import 'package:qkomo_ui/core/widgets/platform_image.dart';
import 'package:qkomo_ui/theme/design_tokens.dart';

class NextMealPreviewCard extends StatelessWidget {
  const NextMealPreviewCard({
    super.key,
    required this.nextMeal,
    required this.onTap,
  });

  final dynamic nextMeal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final isAsset = nextMeal.photoPath != null && nextMeal.photoPath!.startsWith('assets/');
    final timeFormat = DateFormat('HH:mm');
    final scheduledTime = timeFormat.format(nextMeal.scheduledFor);

    return SemanticWrapper(
      onTap: onTap,
      label: 'Próxima comida: ${nextMeal.name} a las $scheduledTime',
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
          color: scheme.surface,
          borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (nextMeal.photoPath != null)
                  _buildImage(context, nextMeal.photoPath!, isAsset, scheme)
                else
                  Container(color: scheme.primaryContainer),
                _buildGradient(),
                Positioned(
                  bottom: 8,
                  left: 8,
                  right: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Próxima: $scheduledTime',
                        style: textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        nextMeal.name,
                        style: textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, String path, bool isAsset, ColorScheme scheme) {
    if (isAsset) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        semanticLabel: SemanticLabels.mealImage,
        errorBuilder: (context, error, stackTrace) =>
            Container(color: scheme.surfaceContainerHighest),
      );
    } else {
      return PlatformImage(
        path: path,
        fit: BoxFit.cover,
        semanticLabel: SemanticLabels.mealImage,
        errorBuilder: (context, error, stackTrace) =>
            Container(color: scheme.surfaceContainerHighest),
      );
    }
  }

  Widget _buildGradient() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.7),
          ],
        ),
      ),
    );
  }
}

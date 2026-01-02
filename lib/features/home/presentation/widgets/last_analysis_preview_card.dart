import 'package:flutter/material.dart';
import 'package:qkomo_ui/core/accessibility/semantic_labels.dart';
import 'package:qkomo_ui/core/accessibility/semantic_wrapper.dart';
import 'package:qkomo_ui/core/widgets/platform_image.dart';
import 'package:qkomo_ui/theme/design_tokens.dart';

class LastAnalysisPreviewCard extends StatelessWidget {
  const LastAnalysisPreviewCard({
    super.key,
    required this.lastAnalysis,
    required this.onTap,
  });

  final dynamic lastAnalysis;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final String? imagePath = lastAnalysis.imagePath ?? lastAnalysis.jobId;
    final hasImage = imagePath != null;

    return SemanticWrapper(
      onTap: onTap,
      label: 'Último análisis: ${lastAnalysis.title ?? 'comida'}. Toca para analizar otra.',
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
                if (hasImage)
                  _buildImage(context, imagePath, imagePath.startsWith('assets/'), scheme)
                else
                  Container(color: scheme.surfaceContainer),
                _buildGradient(),
                Positioned(
                  bottom: 8,
                  left: 8,
                  right: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Último análisis',
                        style: textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        lastAnalysis.title ??
                            (lastAnalysis.ingredients.isNotEmpty
                                ? lastAnalysis.ingredients.first
                                : 'Comida'),
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

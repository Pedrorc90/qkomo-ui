import 'package:flutter/material.dart';
import 'package:qkomo_ui/core/accessibility/semantic_labels.dart';
import 'package:qkomo_ui/core/accessibility/semantic_wrapper.dart';
import 'package:qkomo_ui/theme/design_tokens.dart';

/// A badge widget for displaying allergen information with optional personal alert state.
///
/// Displays allergens with visual distinction between:
/// - Default state: Standard allergen detected
/// - Personal alert state: Allergen that the user is allergic to
///
/// The badge uses semantic color coding:
/// - Default: surfaceContainerHighest background with onSurfaceVariant text
/// - Personal: errorContainer background with error border, warning icon, and bold text
///
/// Example:
/// ```dart
/// AllergenBadge(allergen: 'Gluten')
///
/// AllergenBadge(
///   allergen: 'Lactosa',
///   isPersonalAlert: true,
///   onTap: () => print('Removed from personal allergens'),
/// )
/// ```
class AllergenBadge extends StatelessWidget {
  const AllergenBadge({
    super.key,
    required this.allergen,
    this.isPersonalAlert = false,
    this.onTap,
  });

  /// The allergen name (e.g., 'Gluten', 'Lactosa', 'Frutos secos')
  final String allergen;

  /// Whether this allergen is marked as a personal alert.
  /// When true, displays error colors and warning icon.
  final bool isPersonalAlert;

  /// Callback when the badge is tapped. If null, badge is not interactive.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SemanticWrapper(
      onTap: onTap,
      label:
          'Alérgeno: $allergen${isPersonalAlert ? ', alerta personal' : ', detectado'}',
      enabled: onTap != null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isPersonalAlert
              ? scheme.errorContainer
              : scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
          border: isPersonalAlert
              ? Border.all(
                  color: scheme.error,
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isPersonalAlert) ...[
              Icon(
                Icons.warning_amber,
                size: 12,
                color: scheme.error,
                semanticLabel: SemanticLabels.iconWarning,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              allergen,
              style: textTheme.labelSmall?.copyWith(
                fontWeight: isPersonalAlert ? FontWeight.w700 : FontWeight.w400,
                color: isPersonalAlert ? scheme.error : scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

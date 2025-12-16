import 'package:flutter/material.dart';
import 'package:qkomo_ui/theme/design_tokens.dart';

/// A reusable empty state widget for displaying when no content is available.
///
/// Shows a centered layout with:
/// - A large icon representing the empty state
/// - A title message
/// - Optional descriptive message
/// - Optional action button
///
/// The widget automatically handles spacing and typography according to the
/// design system, with proper support for Spanish text (which is typically
/// 15-30% longer than English).
///
/// Example:
/// ```dart
/// // Simple empty state without action
/// EmptyState(
///   icon: Icons.inbox_outlined,
///   title: 'No hay entradas',
///   message: 'Aún no has registrado ninguna comida.',
/// )
///
/// // Empty state with action button
/// EmptyState(
///   icon: Icons.camera_alt_outlined,
///   title: 'Comienza a registrar',
///   message: 'Captura una foto de tu comida para empezar',
///   actionLabel: 'Tomar foto',
///   onAction: () => showCameraCapture(),
/// )
///
/// // Minimal empty state with custom icon size
/// EmptyState(
///   icon: Icons.event_busy,
///   title: 'Sin comidas planificadas',
///   iconSize: 64,
/// )
/// ```
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.iconSize = 80.0,
  });

  /// The icon to display in the empty state
  final IconData icon;

  /// The main title message (required)
  final String title;

  /// Optional descriptive message below the title
  final String? message;

  /// Optional label for the action button
  final String? actionLabel;

  /// Optional callback for the action button
  final VoidCallback? onAction;

  /// Size of the icon in logical pixels (default: 80.0)
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: '$title${message != null ? '. $message' : ''}',
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingXxxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Icon(
                icon,
                size: iconSize,
                color: scheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),

              // Space between icon and title
              const SizedBox(height: DesignTokens.spacingLg),

              // Title
              Text(
                title,
                style: textTheme.titleLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              // Message (if provided)
              if (message != null) ...[
                const SizedBox(height: DesignTokens.spacingMd),
                Text(
                  message!,
                  style: textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              // Action button (if provided)
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: DesignTokens.spacingLg),
                FilledButton.icon(
                  onPressed: onAction,
                  icon: const Icon(Icons.add),
                  label: Text(actionLabel!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

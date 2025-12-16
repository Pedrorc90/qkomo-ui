import 'package:flutter/material.dart';

/// Enum for different button style variants
enum AppButtonVariant {
  /// Filled button (primary action)
  filled,

  /// Outlined button (secondary action)
  outlined,

  /// Text button (tertiary action)
  text,
}

/// A unified button widget with built-in loading state handling and multiple variants.
///
/// Automatically handles:
/// - Disabling button when loading
/// - Replacing icon/label with a spinner during loading
/// - Supporting three visual variants (filled, outlined, text)
/// - Optional custom border radius and background color
///
/// Example:
/// ```dart
/// // Basic filled button with loading state
/// AppButton(
///   label: 'Guardar',
///   onPressed: () => saveData(),
///   isLoading: state.isSaving,
/// )
///
/// // Button with icon and custom styling
/// AppButton(
///   label: 'Capturar',
///   icon: Icons.camera_alt,
///   onPressed: () => startCapture(),
///   variant: AppButtonVariant.filled,
///   borderRadius: 30, // Pill-shaped button
/// )
///
/// // Outlined secondary button
/// AppButton(
///   label: 'Cancelar',
///   onPressed: () => Navigator.pop(context),
///   variant: AppButtonVariant.outlined,
/// )
///
/// // Text button for tertiary actions
/// AppButton(
///   label: 'Más opciones',
///   onPressed: () => showMenu(),
///   variant: AppButtonVariant.text,
/// )
/// ```
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.variant = AppButtonVariant.filled,
    this.borderRadius,
    this.backgroundColor,
  });

  /// The button label text (required)
  final String label;

  /// Callback when button is pressed. If null or loading, button is disabled.
  final VoidCallback? onPressed;

  /// Optional icon to display before the label
  final IconData? icon;

  /// Whether the button should show loading state (spinner + disabled)
  final bool isLoading;

  /// The visual style variant for this button
  final AppButtonVariant variant;

  /// Optional custom border radius. If null, uses default theme value.
  final double? borderRadius;

  /// Optional custom background color (only for filled variant)
  final Color? backgroundColor;

  /// Get the spinner color based on variant
  Color _getSpinnerColor(BuildContext context) {
    return switch (variant) {
      AppButtonVariant.filled => Theme.of(context).colorScheme.onPrimary,
      AppButtonVariant.outlined ||
      AppButtonVariant.text =>
        Theme.of(context).colorScheme.primary,
    };
  }

  /// Build the button content (label and optional icon)
  Widget _buildButtonContent(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            _getSpinnerColor(context),
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: 8),
        ],
        Text(label),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Create style with custom radius if provided
    final style = _getButtonStyle(context);

    return switch (variant) {
      AppButtonVariant.filled => FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: style,
          child: _buildButtonContent(context),
        ),
      AppButtonVariant.outlined => OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: style,
          child: _buildButtonContent(context),
        ),
      AppButtonVariant.text => TextButton(
          onPressed: isLoading ? null : onPressed,
          style: style,
          child: _buildButtonContent(context),
        ),
    };
  }

  /// Get the button style with custom border radius if provided
  ButtonStyle? _getButtonStyle(BuildContext context) {
    if (borderRadius == null && backgroundColor == null) {
      return null; // Use theme default
    }

    final baseStyle = switch (variant) {
      AppButtonVariant.filled => FilledButton.styleFrom(),
      AppButtonVariant.outlined => OutlinedButton.styleFrom(),
      AppButtonVariant.text => TextButton.styleFrom(),
    };

    // Modify style with custom values
    if (borderRadius != null) {
      return baseStyle.copyWith(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
          ),
        ),
      );
    }

    if (backgroundColor != null && variant == AppButtonVariant.filled) {
      return baseStyle.copyWith(
        backgroundColor: WidgetStateProperty.all(backgroundColor),
      );
    }

    return baseStyle;
  }
}

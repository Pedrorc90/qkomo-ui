import 'package:flutter/material.dart';
import 'package:qkomo_ui/core/accessibility/accessibility_constants.dart';

/// A utility widget that wraps its child with [Semantics] and ensures
/// a minimum touch target size for interactive elements.
class SemanticWrapper extends StatelessWidget {
  const SemanticWrapper({
    super.key,
    required this.child,
    this.label,
    this.hint,
    this.isButton = false,
    this.isHeader = false,
    this.enabled,
    this.onTap,
  });
  final Widget child;
  final String? label;
  final String? hint;
  final bool isButton;
  final bool isHeader;
  final bool? enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget result = Semantics(
      label: label,
      hint: hint,
      button: isButton,
      header: isHeader,
      enabled: enabled,
      onTap: onTap,
      child: child,
    );

    // If it's interactive (has onTap), ensure it has a minimum touch target
    if (onTap != null || isButton) {
      result = ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: AccessibilityConstants.minTouchTargetSize,
          minHeight: AccessibilityConstants.minTouchTargetSize,
        ),
        child: Center(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: result,
        ),
      );
    }

    return result;
  }
}

/// Extension to easily wrap widgets with accessibility properties
extension AccessibilityWidgetExtension on Widget {
  Widget withSemantics({
    String? label,
    String? hint,
    bool isButton = false,
    bool isHeader = false,
    bool? enabled,
    VoidCallback? onTap,
  }) {
    return SemanticWrapper(
      label: label,
      hint: hint,
      isButton: isButton,
      isHeader: isHeader,
      enabled: enabled,
      onTap: onTap,
      child: this,
    );
  }

  /// Ensures the widget meets the minimum touch target size
  Widget withMinimumTouchTarget({
    double minSize = AccessibilityConstants.minTouchTargetSize,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minSize,
        minHeight: minSize,
      ),
      child: Center(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: this,
      ),
    );
  }
}

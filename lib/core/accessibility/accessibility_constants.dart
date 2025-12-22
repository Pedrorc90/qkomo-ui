/// Constants for accessibility throughout the QKomo app.
/// Following Material Design and WCAG guidelines.
class AccessibilityConstants {
  AccessibilityConstants._();

  /// Minimum touch target size (48.0 dp is recommended by Material Design)
  static const double minTouchTargetSize = 48.0;

  /// Alternative minimum (44.0 dp is recommended by iOS)
  static const double minTouchTargetSizeAlt = 44.0;

  /// Minimum contrast ratio for normal text (WCAG AA)
  static const double minContrastRatioAA = 4.5;

  /// Minimum contrast ratio for large text (WCAG AA)
  static const double minContrastRatioLargeTextAA = 3.0;

  /// Minimum contrast ratio for normal text (WCAG AAA)
  static const double minContrastRatioAAA = 7.0;

  /// Standard screen reader debounce time
  static const Duration screenReaderDelay = Duration(milliseconds: 500);
}

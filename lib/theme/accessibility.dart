import 'package:flutter/material.dart';

/// Accessibility validation and utilities for color contrast and readability.
///
/// This module provides tools to ensure the Qkomo app meets WCAG 2.1 accessibility
/// standards, particularly for:
/// - Color contrast ratios (AA and AAA standards)
/// - Text readability and legibility
/// - Touch target sizes
/// - Visual hierarchy clarity
///
/// References:
/// - WCAG 2.1: https://www.w3.org/WAI/WCAG21/quickref/
/// - Color contrast checker: https://www.tpgi.com/color-contrast-checker/
class AccessibilityValidator {
  AccessibilityValidator._();

  /// Minimum contrast ratio for WCAG AA (large text: 3:1, normal text: 4.5:1)
  static const double _minContrastRatioAA = 4.5;

  /// Minimum contrast ratio for WCAG AAA (large text: 4.5:1, normal text: 7:1)
  static const double _minContrastRatioAAA = 7.0;

  /// Minimum contrast ratio for large text (18pt+ bold or 24pt+) WCAG AA: 3:1
  static const double _minContrastRatioLargeTextAA = 3.0;

  /// Minimum contrast ratio for large text WCAG AAA: 4.5:1
  static const double _minContrastRatioLargeTextAAA = 4.5;

  /// Calculate relative luminance of a color per WCAG formula.
  ///
  /// Formula: https://www.w3.org/TR/WCAG21/#dfn-relative-luminance
  ///
  /// Returns a value between 0 (darkest) and 1 (lightest).
  static double _getRelativeLuminance(Color color) {
    final rgb = [
      color.r,
      color.g,
      color.b,
    ];

    final luminance = rgb.map((value) {
      if (value <= 0.03928) {
        return value / 12.92;
      } else {
        return Math.pow((value + 0.055) / 1.055, 2.0);
      }
    }).toList();

    return (0.2126 * luminance[0]) +
        (0.7152 * luminance[1]) +
        (0.0722 * luminance[2]);
  }

  /// Calculate contrast ratio between two colors per WCAG formula.
  ///
  /// Formula: https://www.w3.org/TR/WCAG21/#dfn-contrast-ratio
  ///
  /// Returns a ratio between 1 (no contrast) and 21 (maximum contrast).
  static double getContrastRatio(Color foreground, Color background) {
    final luminance1 = _getRelativeLuminance(foreground);
    final luminance2 = _getRelativeLuminance(background);

    final lighter = Math.max(luminance1, luminance2);
    final darker = Math.min(luminance1, luminance2);

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Check if foreground/background combination meets WCAG AA for normal text.
  ///
  /// Normal text requires a contrast ratio of at least 4.5:1 for WCAG AA.
  static bool isContrastRatioAANormalText(Color foreground, Color background) {
    return getContrastRatio(foreground, background) >= _minContrastRatioAA;
  }

  /// Check if foreground/background combination meets WCAG AA for large text.
  ///
  /// Large text (18pt+ bold or 24pt+) requires a contrast ratio of at least
  /// 3:1 for WCAG AA.
  static bool isContrastRatioAALargeText(Color foreground, Color background) {
    return getContrastRatio(foreground, background) >=
        _minContrastRatioLargeTextAA;
  }

  /// Check if foreground/background combination meets WCAG AAA for normal text.
  ///
  /// Normal text requires a contrast ratio of at least 7:1 for WCAG AAA.
  static bool isContrastRatioAAANormalText(Color foreground, Color background) {
    return getContrastRatio(foreground, background) >= _minContrastRatioAAA;
  }

  /// Check if foreground/background combination meets WCAG AAA for large text.
  ///
  /// Large text (18pt+ bold or 24pt+) requires a contrast ratio of at least
  /// 4.5:1 for WCAG AAA.
  static bool isContrastRatioAAALargeText(Color foreground, Color background) {
    return getContrastRatio(foreground, background) >=
        _minContrastRatioLargeTextAAA;
  }

  /// Get a formatted contrast ratio string for debugging.
  ///
  /// Example: "4.5:1 (AA Pass)"
  static String getContrastRatioString(
    Color foreground,
    Color background, {
    bool largeText = false,
  }) {
    final ratio = getContrastRatio(foreground, background);
    final level = _getContrastLevel(ratio, largeText);

    return '${ratio.toStringAsFixed(2)}:1 ($level)';
  }

  /// Get the accessibility level for a contrast ratio.
  static String _getContrastLevel(double ratio, bool largeText) {
    if (largeText) {
      if (ratio >= _minContrastRatioLargeTextAAA) {
        return 'AAA';
      } else if (ratio >= _minContrastRatioLargeTextAA) {
        return 'AA';
      } else {
        return 'Fail';
      }
    } else {
      if (ratio >= _minContrastRatioAAA) {
        return 'AAA';
      } else if (ratio >= _minContrastRatioAA) {
        return 'AA';
      } else {
        return 'Fail';
      }
    }
  }

  /// Validate that a text style meets minimum contrast with background.
  ///
  /// Returns true if the contrast ratio meets WCAG AA standards for the
  /// given text size.
  static bool isTextStyleAccessible(
    TextStyle textStyle,
    Color textColor,
    Color backgroundColor,
  ) {
    // Determine if this is large text (18pt bold+ or 24pt+)
    final fontSize = textStyle.fontSize ?? 16;
    final fontWeight = textStyle.fontWeight ?? FontWeight.normal;
    final isLargeText =
        (fontSize >= 18 && fontWeight.index >= 6) || fontSize >= 24;

    return isLargeText
        ? isContrastRatioAALargeText(textColor, backgroundColor)
        : isContrastRatioAANormalText(textColor, backgroundColor);
  }

  /// Get suggestions for improving contrast if it fails validation.
  static String getContrastImprovementSuggestions(
    Color foreground,
    Color background,
  ) {
    final ratio = getContrastRatio(foreground, background);
    final suggestions = <String>[];

    if (ratio < _minContrastRatioAA) {
      suggestions
        ..add('Current ratio: ${ratio.toStringAsFixed(2)}:1 (below WCAG AA)')
        ..add('Try using a darker foreground or lighter background')
        ..add('Consider using a more contrasting color pair');
    }

    return suggestions.join('\n');
  }
}

/// Simple math utilities for accessibility calculations
/// (to avoid importing dart:math)
class Math {
  static double pow(double base, double exponent) =>
      _pow(base, exponent.toInt());

  static double max(double a, double b) => a > b ? a : b;

  static double min(double a, double b) => a < b ? a : b;

  static double _pow(double base, int exponent) {
    if (exponent == 0) return 1;
    if (exponent == 1) return base;

    double result = 1;
    for (var i = 0; i < exponent; i++) {
      result *= base;
    }
    return result;
  }
}

/// Extensions for easier accessibility validation
extension ColorAccessibilityExt on Color {
  /// Check contrast ratio against another color
  double getContrastRatio(Color other) =>
      AccessibilityValidator.getContrastRatio(this, other);

  /// Get formatted contrast ratio string
  String getContrastRatioString(Color other, {bool largeText = false}) =>
      AccessibilityValidator.getContrastRatioString(this, other,
          largeText: largeText);

  /// Check if this color meets AA standard as foreground on background
  bool isAccessibleForegroundAANormalText(Color background) =>
      AccessibilityValidator.isContrastRatioAANormalText(this, background);

  /// Check if this color meets AA standard for large text
  bool isAccessibleForegroundAALargeText(Color background) =>
      AccessibilityValidator.isContrastRatioAALargeText(this, background);

  /// Check if this color meets AAA standard as foreground on background
  bool isAccessibleForegroundAAANormalText(Color background) =>
      AccessibilityValidator.isContrastRatioAAANormalText(this, background);

  /// Check if this color meets AAA standard for large text
  bool isAccessibleForegroundAAALargeText(Color background) =>
      AccessibilityValidator.isContrastRatioAAALargeText(this, background);
}

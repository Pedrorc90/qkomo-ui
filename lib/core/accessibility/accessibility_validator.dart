import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:qkomo_ui/core/accessibility/accessibility_constants.dart';

/// Accessibility validation and utilities for color contrast and readability.
class AccessibilityValidator {
  AccessibilityValidator._();

  /// Calculate relative luminance of a color per WCAG formula.
  static double getRelativeLuminance(Color color) {
    // Flutter colors are 0-255, but we need 0-1
    final r = color.r;
    final g = color.g;
    final b = color.b;

    double transform(double val) {
      return val <= 0.03928
          ? val / 12.92
          : math.pow((val + 0.055) / 1.055, 2.4).toDouble();
    }

    return 0.2126 * transform(r) +
        0.7152 * transform(g) +
        0.0722 * transform(b);
  }

  /// Calculate contrast ratio between two colors per WCAG formula.
  static double getContrastRatio(Color foreground, Color background) {
    final l1 = getRelativeLuminance(foreground);
    final l2 = getRelativeLuminance(background);

    final lighter = math.max(l1, l2);
    final darker = math.min(l1, l2);

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Check if foreground/background combination meets WCAG AA for normal text.
  static bool isContrastRatioAANormalText(Color foreground, Color background) {
    return getContrastRatio(foreground, background) >=
        AccessibilityConstants.minContrastRatioAA;
  }

  /// Check if foreground/background combination meets WCAG AA for large text.
  static bool isContrastRatioAALargeText(Color foreground, Color background) {
    return getContrastRatio(foreground, background) >=
        AccessibilityConstants.minContrastRatioLargeTextAA;
  }

  /// Returns true if the text style meets minimum contrast with background.
  static bool isTextStyleAccessible(
    TextStyle textStyle,
    Color textColor,
    Color backgroundColor,
  ) {
    final fontSize = textStyle.fontSize ?? 16;
    final fontWeight = textStyle.fontWeight ?? FontWeight.normal;
    final isLargeText =
        (fontSize >= 18 && fontWeight.index >= 6) || fontSize >= 24;

    return isLargeText
        ? isContrastRatioAALargeText(textColor, backgroundColor)
        : isContrastRatioAANormalText(textColor, backgroundColor);
  }

  /// Validates a list of colors in a theme for accessibility.
  /// Useful for CI or runtime checks in debug mode.
  static List<String> validateThemeColors(
      Map<String, Color> themeColors, Color backgroundColor) {
    final errors = <String>[];
    themeColors.forEach((key, color) {
      if (!isContrastRatioAANormalText(color, backgroundColor)) {
        final ratio = getContrastRatio(color, backgroundColor);
        errors.add(
            'Color "$key" fails AA contrast ratio (current: ${ratio.toStringAsFixed(2)}:1)');
      }
    });
    return errors;
  }
}

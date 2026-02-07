import 'package:flutter/material.dart';

/// Color scheme for day card based on state
class DayCardColors {
  const DayCardColors({
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    required this.borderWidth,
  });

  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final double borderWidth;

  factory DayCardColors.fromState({
    required ColorScheme colorScheme,
    required bool isSelected,
    required bool isToday,
  }) {
    if (isSelected) {
      return DayCardColors(
        backgroundColor: colorScheme.primaryContainer,
        textColor: colorScheme.onPrimaryContainer,
        borderColor: colorScheme.primary,
        borderWidth: 2,
      );
    }

    if (isToday) {
      return DayCardColors(
        backgroundColor:
            colorScheme.secondaryContainer.withAlpha((0.3 * 255).round()),
        textColor: colorScheme.onSurface,
        borderColor: colorScheme.secondary,
        borderWidth: 1,
      );
    }

    return DayCardColors(
      backgroundColor: colorScheme.surface,
      textColor: colorScheme.onSurface,
      borderColor: colorScheme.outlineVariant,
      borderWidth: 1,
    );
  }
}

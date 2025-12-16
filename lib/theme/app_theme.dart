import 'package:flutter/material.dart';

import 'package:qkomo_ui/theme/app_colors.dart';
import 'package:qkomo_ui/theme/app_typography.dart';
import 'package:qkomo_ui/theme/design_tokens.dart';
import 'package:qkomo_ui/theme/theme_type.dart';

class AppTheme {
  AppTheme._();

  static ThemeData theme(AppThemeType type) {
    switch (type) {
      case AppThemeType.warm:
        return _warmTheme;
      case AppThemeType.fresh:
        return _freshTheme;
      case AppThemeType.offWhite:
        return _offWhiteTheme;
      case AppThemeType.dark:
        return _darkTheme;
    }
  }

  static LinearGradient gradient(AppThemeType type) {
    switch (type) {
      case AppThemeType.warm:
        return AppColors.gradientWarm;
      case AppThemeType.fresh:
        return AppColors.gradientFresh;
      case AppThemeType.offWhite:
        return AppColors.gradientOffWhite;
      case AppThemeType.dark:
        return AppColors.gradientDark;
    }
  }

  // -- Warm (actual) --
  /// Warm theme with orange/coral primary colors and inviting surfaces
  static final ColorScheme _warmScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primaryMain,
    brightness: Brightness.light,
    surface: AppColors.warmSurface,
  );

  static ThemeData get _warmTheme => _baseTheme(_warmScheme);

  // -- Fresh alternative --
  /// Fresh theme with teal and blue primary colors and cool surfaces
  static final ColorScheme _freshScheme = ColorScheme.fromSeed(
    seedColor: AppColors.secondaryTeal,
    brightness: Brightness.light,
    surface: AppColors.freshSurface,
    secondary: AppColors.secondaryBlue,
  );

  static ThemeData get _freshTheme => _baseTheme(_freshScheme);

  // -- Off-White (Dirty White) --
  /// Minimalist theme with neutral grays and clean off-white surfaces
  static final ColorScheme _offWhiteScheme = ColorScheme.fromSeed(
    seedColor: AppColors.neutralMediumDark,
    brightness: Brightness.light,
    surface: AppColors.offWhiteSurface,
    primary: AppColors.offWhitePrimary,
    onSurface: AppColors.neutralDark,
    secondary: AppColors.neutralMedium,
  );

  static ThemeData get _offWhiteTheme => _baseTheme(_offWhiteScheme);

  // -- Dark --
  /// Dark theme for night mode with blue accents on dark backgrounds
  static final ColorScheme _darkScheme = ColorScheme.fromSeed(
    seedColor: AppColors.darkPrimary,
    brightness: Brightness.dark,
    surface: AppColors.darkSurface,
    primary: AppColors.darkPrimary,
    onSurface: AppColors.darkOnSurface,
  );

  static ThemeData get _darkTheme => _baseTheme(_darkScheme);

  static ThemeData _baseTheme(ColorScheme scheme) {
    final baseText = AppTypography.baseTextTheme;
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: baseText,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: DesignTokens.elevationNone,
        centerTitle: false,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: scheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: DesignTokens.elevationSm,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: EdgeInsets.symmetric(
            vertical: DesignTokens.spacingMd,
            horizontal: DesignTokens.spacingMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          ),
          textStyle: AppTypography.titleMedium,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            vertical: DesignTokens.spacingMd,
            horizontal: DesignTokens.spacingMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          ),
          side: BorderSide(
            color: scheme.outline,
            width: DesignTokens.borderWidthThin,
          ),
          textStyle: AppTypography.titleMedium,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          borderSide: BorderSide(
            color: scheme.outlineVariant,
            width: DesignTokens.borderWidthThin,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          borderSide: BorderSide(
            color: scheme.outlineVariant,
            width: DesignTokens.borderWidthThin,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          borderSide: BorderSide(
            color: scheme.primary,
            width: DesignTokens.borderWidthMedium,
          ),
        ),
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        ),
        backgroundColor: scheme.onSurface,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: Colors.white,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelStyle: AppTypography.titleMedium,
        unselectedLabelStyle: AppTypography.titleMedium,
        indicator: BoxDecoration(
          color: scheme.primary.withAlpha(
            (DesignTokens.opacityFocus * 255).round(),
          ),
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        ),
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.onSurfaceVariant,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:qkomo_ui/theme/app_colors.dart';
import 'package:qkomo_ui/theme/app_typography.dart';
import 'package:qkomo_ui/theme/design_tokens.dart';
import 'package:qkomo_ui/theme/theme_type.dart';

class AppTheme {
  AppTheme._();

  static ThemeData theme(AppThemeType type) {
    switch (type) {
      case AppThemeType.dark:
        return _darkTheme;
      case AppThemeType.forest:
        return _forestTheme;
    }
  }

  static LinearGradient gradient(AppThemeType type) {
    switch (type) {
      case AppThemeType.dark:
        return AppColors.gradientDark;
      case AppThemeType.forest:
        return AppColors.gradientForest;
    }
  }

  // -- Dark --
  /// Dark theme for night mode - natural forest night with moonlit greens
  static final ColorScheme _darkScheme = ColorScheme.fromSeed(
    seedColor: AppColors.darkPrimary,
    brightness: Brightness.dark,
    surface: AppColors.darkSurface,
    primary: AppColors.darkPrimary,
    secondary: AppColors.darkSecondary,
    onSurface: AppColors.darkOnSurface,
    onPrimary: AppColors.darkBackground,
    onSecondary: AppColors.darkBackground,
  );

  static ThemeData get _darkTheme => _baseTheme(_darkScheme);

  // -- Forest --
  /// Forest theme with deep green earthy colors
  static final ColorScheme _forestScheme = ColorScheme.fromSeed(
    seedColor: AppColors.forestPrimary,
    surface: AppColors.forestSurface,
    secondary: AppColors.forestSecondary,
  );

  static ThemeData get _forestTheme => _baseTheme(_forestScheme);

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
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              scheme.brightness == Brightness.dark ? Brightness.light : Brightness.dark,
          statusBarBrightness: scheme.brightness,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.brightness == Brightness.dark
            ? Color.alphaBlend(
                scheme.primary.withOpacity(0.08),
                scheme.surface,
              )
            : Colors.white,
        surfaceTintColor: scheme.brightness == Brightness.dark ? Colors.transparent : Colors.white,
        elevation: DesignTokens.elevationSm,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(
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
          padding: const EdgeInsets.symmetric(
            vertical: DesignTokens.spacingMd,
            horizontal: DesignTokens.spacingMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          ),
          side: BorderSide(
            color: scheme.outline,
          ),
          textStyle: AppTypography.titleMedium,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.brightness == Brightness.dark
            ? Color.alphaBlend(
                scheme.primary.withOpacity(0.05),
                scheme.surface,
              )
            : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          borderSide: BorderSide(
            color: scheme.outlineVariant,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          borderSide: BorderSide(
            color: scheme.brightness == Brightness.dark
                ? scheme.primary.withOpacity(0.3)
                : scheme.outlineVariant,
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
          color: scheme.surface,
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

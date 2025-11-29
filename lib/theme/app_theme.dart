import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme_type.dart';

class AppTheme {
  AppTheme._();

  static ThemeData theme(AppThemeType type) {
    switch (type) {
      case AppThemeType.warm:
        return _warmTheme;
      case AppThemeType.fresh:
        return _freshTheme;
    }
  }

  static LinearGradient gradient(AppThemeType type) {
    switch (type) {
      case AppThemeType.warm:
        return const LinearGradient(
          colors: [Color(0xFFFFF0E5), Color(0xFFF3F5FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case AppThemeType.fresh:
        return const LinearGradient(
          colors: [Color(0xFFE7FFF7), Color(0xFFE1ECFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  // -- Warm (actual) --
  static final ColorScheme _warmScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFFFF6F3C),
    brightness: Brightness.light,
    surface: const Color(0xFFF6F7FB),
    background: const Color(0xFFF6F7FB),
  );

  static ThemeData get _warmTheme => _baseTheme(_warmScheme);

  // -- Fresh alternative --
  static final ColorScheme _freshScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF2DD4BF),
    brightness: Brightness.light,
    surface: const Color(0xFFF5FAFF),
    background: const Color(0xFFF5FAFF),
    secondary: const Color(0xFF4E7BFF),
  );

  static ThemeData get _freshTheme => _baseTheme(_freshScheme);

  static ThemeData _baseTheme(ColorScheme scheme) {
    final baseText = GoogleFonts.spaceGroteskTextTheme();
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: baseText,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: baseText.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: scheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 2,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: baseText.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          side: BorderSide(color: scheme.outline),
          textStyle: baseText.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 1.4),
        ),
        labelStyle: baseText.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: scheme.onSurface,
        contentTextStyle: baseText.bodyMedium?.copyWith(color: Colors.white),
      ),
      tabBarTheme: TabBarThemeData(
        labelStyle: baseText.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        unselectedLabelStyle: baseText.titleMedium,
        indicator: BoxDecoration(
          color: scheme.primary.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.onSurfaceVariant,
      ),
    );
  }
}

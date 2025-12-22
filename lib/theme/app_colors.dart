import 'package:flutter/material.dart';

/// Color palette for the Qkomo application.
///
/// This file defines all colors used across the app, organized by semantic
/// purpose and theme variant. Colors are independent of theme type and are
/// referenced by both light and dark themes.
///
/// Organization:
/// - Brand colors: Primary colors representing the app identity
/// - Semantic colors: Colors for states (success, error, warning, info)
/// - Neutral colors: Grayscale palette for text, backgrounds, borders
/// - Theme-specific palettes: Color schemes for each theme variant
class AppColors {
  AppColors._();

  // Primary brand colors
  /// Main orange/coral color - warm, energetic, food-related
  /// Used for: Primary buttons, active states, brand elements
  static const Color primaryMain = Color(0xFFFF6F3C);

  /// Lighter orange for hover/focus states
  static const Color primaryLight = Color(0xFFFFB899);

  /// Darker orange for pressed states
  static const Color primaryDark = Color(0xFFE85D2A);

  /// Very light orange for backgrounds and disabled states
  static const Color primaryVeryLight = Color(0xFFFFF0E5);

  // Secondary brand colors
  /// Teal/turquoise - fresh, natural, food freshness
  /// Used for: Secondary actions, accents, highlights
  static const Color secondaryTeal = Color(0xFF2DD4BF);

  /// Light teal for hover/focus states
  static const Color secondaryTealLight = Color(0xFF7FEBE0);

  /// Dark teal for pressed states
  static const Color secondaryTealDark = Color(0xFF1BA39C);

  /// Blue - calm, trust, complementary accent
  static const Color secondaryBlue = Color(0xFF4E7BFF);

  /// Light blue for backgrounds
  static const Color secondaryBlueLight = Color(0xFFE1ECFF);

  // Semantic colors for status and feedback
  /// Success state - green
  /// Used for: Successful operations, positive feedback
  static const Color semanticSuccess = Color(0xFF10B981);

  /// Success light variant
  static const Color semanticSuccessLight = Color(0xFFD1FAE5);

  /// Success dark variant
  static const Color semanticSuccessDark = Color(0xFF059669);

  /// Error state - red
  /// Used for: Errors, validation failures, destructive actions
  static const Color semanticError = Color(0xFFEF4444);

  /// Error light variant
  static const Color semanticErrorLight = Color(0xFFFEE2E2);

  /// Error dark variant
  static const Color semanticErrorDark = Color(0xFFDC2626);

  /// Warning state - amber/yellow
  /// Used for: Warnings, alerts, pending actions
  static const Color semanticWarning = Color(0xFFFBBF24);

  /// Warning light variant
  static const Color semanticWarningLight = Color(0xFFFEF3C7);

  /// Warning dark variant
  static const Color semanticWarningDark = Color(0xFFD97706);

  /// Information state - blue
  /// Used for: Informational messages, hints, tips
  static const Color semanticInfo = Color(0xFF3B82F6);

  /// Info light variant
  static const Color semanticInfoLight = Color(0xFFDBEAFE);

  /// Info dark variant
  static const Color semanticInfoDark = Color(0xFF1D4ED8);

  // Neutral grayscale palette
  /// Darkest gray - primary text
  static const Color neutralDark = Color(0xFF1A1A1A);

  /// Dark gray - secondary text
  static const Color neutralDarkGray = Color(0xFF3F3F3F);

  /// Medium-dark gray - tertiary text
  static const Color neutralMediumDark = Color(0xFF5D5D5D);

  /// Medium gray - body text alternative
  static const Color neutralMedium = Color(0xFF757575);

  /// Medium-light gray - hints, disabled text
  static const Color neutralMediumLight = Color(0xFF9E9E9E);

  /// Light gray - borders, dividers
  static const Color neutralLight = Color(0xFFCCCCCC);

  /// Lighter gray - subtle borders
  static const Color neutralLighter = Color(0xFFE5E5E5);

  /// Very light gray - backgrounds, hover states
  static const Color neutralVeryLight = Color(0xFFFAFAFA);

  /// Near white - surfaces
  static const Color neutralAlmostWhite = Color(0xFFFBFBFB);

  /// Pure white
  static const Color neutralWhite = Color(0xFFFFFFFF);

  // Chart color palette - 5-color palette for data visualization
  /// Blue color for charts - light theme variant
  static const Color chartBlue = Color(0xFF2196F3);

  /// Red color for charts - light theme variant
  static const Color chartRed = Color(0xFFF44336);

  /// Green color for charts - light theme variant
  static const Color chartGreen = Color(0xFF4CAF50);

  /// Orange color for charts - light theme variant
  static const Color chartOrange = Color(0xFFFF9800);

  /// Purple color for charts - light theme variant
  static const Color chartPurple = Color(0xFF9C27B0);

  /// Blue color for charts - dark theme variant (brighter for visibility)
  static const Color chartBlueDark = Color(0xFF42A5F5);

  /// Red color for charts - dark theme variant (brighter for visibility)
  static const Color chartRedDark = Color(0xFFEF5350);

  /// Green color for charts - dark theme variant (brighter for visibility)
  static const Color chartGreenDark = Color(0xFF66BB6A);

  /// Orange color for charts - dark theme variant (brighter for visibility)
  static const Color chartOrangeDark = Color(0xFFFFB74D);

  /// Purple color for charts - dark theme variant (brighter for visibility)
  static const Color chartPurpleDark = Color(0xFFAB47BC);

  /// Returns chart color palette appropriate for theme brightness
  static List<Color> getChartColors(Brightness brightness) {
    return brightness == Brightness.dark
        ? [
            chartBlueDark,
            chartRedDark,
            chartGreenDark,
            chartOrangeDark,
            chartPurpleDark
          ]
        : [chartBlue, chartRed, chartGreen, chartOrange, chartPurple];
  }

  // Warm theme color scheme (default)
  /// Warm theme with orange/coral primary colors and inviting surfaces
  static const Color warmSurface =
      Color(0xFFF6F7FB); // Light lavender-tinted white
  static const Color warmBackground = Color(0xFFFFFFFF);
  static const Color warmPrimary = primaryMain; // Orange
  static const Color warmSecondary = Color(0xFF6B5B95); // Purple accent
  static const Color warmOnSurface = neutralDark;
  static const Color warmBorder =
      Color(0xFFE5D9FF); // Light purple-tinted border

  // Off-white theme color scheme
  /// Minimalist theme using grays and blacks
  static const Color offWhiteSurface = Color(0xFFFAFAFA); // Warm off-white
  static const Color offWhiteBackground = Color(0xFFFFFFFF);
  static const Color offWhitePrimary = Color(0xFF2D2D2D); // Dark gray
  static const Color offWhiteSecondary = Color(0xFF757575); // Medium gray
  static const Color offWhiteOnSurface = neutralDark;
  static const Color offWhiteBorder = Color(0xFFDDDDDD); // Subtle border

  // Dark theme color scheme
  /// Dark palette for night mode using dark backgrounds and light text
  static const Color darkSurface = Color(0xFF121212); // Very dark gray
  static const Color darkBackground = Color(0xFF0D0D0D); // Almost black
  static const Color darkPrimary = Color(0xFF3B82F6); // Bright blue
  static const Color darkSecondary = Color(0xFF60A5FA); // Light blue
  static const Color darkOnSurface = Color(0xFFE0E0E0); // Light gray text
  static const Color darkBorder = Color(0xFF383838); // Dark border

  // Overlay colors for modals, dialogs, and semi-transparent backgrounds
  /// Black overlay at 50% opacity
  static const Color overlayBlack50 = Color(0x80000000);

  /// Black overlay at 30% opacity - subtle darkening
  static const Color overlayBlack30 = Color(0x4D000000);

  /// Black overlay at 70% opacity - strong darkening
  static const Color overlayBlack70 = Color(0xB3000000);

  /// Scrim color for modals
  static const Color overlayScrim = Color(0x33000000);

  // Gradient definitions for decorative and background elements
  /// Warm theme gradient - orange to lavender
  static const LinearGradient gradientWarm = LinearGradient(
    colors: [Color(0xFFFFF0E5), Color(0xFFF3F5FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Off-white theme gradient - subtle neutrals
  static const LinearGradient gradientOffWhite = LinearGradient(
    colors: [Color(0xFFFBFBFB), Color(0xFFEAEAEA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Dark theme gradient - dark grays to charcoal
  static const LinearGradient gradientDark = LinearGradient(
    colors: [Color(0xFF1A1A1A), Color(0xFF2C2C2C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Forest theme color scheme
  /// Forest theme with deep green and earthy tones
  static const Color forestSurface = Color(0xFFF1F5F0); // Light forest-white
  static const Color forestBackground = Color(0xFFFFFFFF);
  static const Color forestPrimary = Color(0xFF2D5016); // Deep forest green
  static const Color forestSecondary = Color(0xFF66BB6A); // Light green
  static const Color forestOnSurface = neutralDark;
  static const Color forestBorder = Color(0xFFC8E6C9); // Light green border

  /// Forest gradient - earthy green tones
  static const LinearGradient gradientForest = LinearGradient(
    colors: [Color(0xFFF1F5F0), Color(0xFFE8F5E9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Indigo theme color scheme
  /// Indigo theme with deep indigo and elegant tones
  static const Color indigoSurface = Color(0xFFF0F4FF); // Indigo-white
  static const Color indigoBackground = Color(0xFFFFFFFF);
  static const Color indigoPrimary = Color(0xFF4338CA); // Deep indigo
  static const Color indigoSecondary = Color(0xFF7C3AED); // Purple
  static const Color indigoOnSurface = neutralDark;
  static const Color indigoBorder = Color(0xFFE0E7FF); // Light indigo border

  /// Indigo gradient - deep indigo and purple
  static const LinearGradient gradientIndigo = LinearGradient(
    colors: [Color(0xFFF0F4FF), Color(0xFFF5F3FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

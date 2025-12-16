import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography scale and text styles for the Qkomo application.
///
/// This file defines all text styles used across the app, organized by size
/// and semantic purpose. All text should use these styles rather than custom
/// TextStyle definitions.
///
/// Typography scale is based on a modular scale with ratios for visual harmony:
/// - Display styles (large, eye-catching headings)
/// - Headline styles (section headings)
/// - Title styles (component titles)
/// - Body styles (content and descriptions)
/// - Label styles (buttons, tags, chips)
/// - Hint/Caption styles (supplementary text)
///
/// Font family: Space Grotesk (from Google Fonts)
/// - Excellent readability for Spanish text
/// - Clean, modern, and accessible
/// - Available weights: 400 (regular), 500, 600, 700 (bold)
class AppTypography {
  AppTypography._();

  /// Get the base text theme with Space Grotesk font
  ///
  /// This is the foundation for all typography in the app.
  static TextTheme get baseTextTheme =>
      GoogleFonts.spaceGroteskTextTheme();

  // Display Large - 57px / Line 64px
  /// Display Large - 57px / Line 64px
  /// Rarely used, only for largest headings
  ///
  /// Example: App hero section title
  static TextStyle get displayLarge => baseTextTheme.displayLarge!.copyWith(
    fontSize: 57,
    height: 1.12,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
  );

  /// Display Medium - 45px / Line 52px
  /// Used for significant headings
  ///
  /// Example: Screen title
  static TextStyle get displayMedium => baseTextTheme.displayMedium!.copyWith(
    fontSize: 45,
    height: 1.16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );

  /// Display Small - 36px / Line 44px
  /// Used for important section titles
  ///
  /// Example: Feature section headline
  static TextStyle get displaySmall => baseTextTheme.displaySmall!.copyWith(
    fontSize: 36,
    height: 1.22,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );

  /// Headline Large - 32px / Line 40px
  /// Used for main screen titles and major sections
  ///
  /// Example: Screen title (Home, Profile, History)
  static TextStyle get headlineLarge => baseTextTheme.headlineLarge!.copyWith(
    fontSize: 32,
    height: 1.25,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );

  /// Headline Medium - 28px / Line 36px
  /// Used for subsections and secondary screen titles
  ///
  /// Example: Card section header
  static TextStyle get headlineMedium => baseTextTheme.headlineMedium!.copyWith(
    fontSize: 28,
    height: 1.29,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );

  /// Headline Small - 24px / Line 32px
  /// Used for smaller section titles and dialog titles
  ///
  /// Example: Dialog title, subsection header
  static TextStyle get headlineSmall => baseTextTheme.headlineSmall!.copyWith(
    fontSize: 24,
    height: 1.33,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );

  /// Title Large - 22px / Line 28px
  /// Used for important content headings
  ///
  /// Example: Card title, list item primary text
  static TextStyle get titleLarge => baseTextTheme.titleLarge!.copyWith(
    fontSize: 22,
    height: 1.27,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );

  /// Title Medium - 16px / Line 24px
  /// Standard heading for components
  ///
  /// Example: Button text, input label, list item title
  static TextStyle get titleMedium => baseTextTheme.titleMedium!.copyWith(
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.15,
  );

  /// Title Small - 14px / Line 20px
  /// Small heading for compact components
  ///
  /// Example: Tab label, small card title, badge text
  static TextStyle get titleSmall => baseTextTheme.titleSmall!.copyWith(
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
  );

  /// Body Large - 16px / Line 24px
  /// Primary reading text, main content
  ///
  /// Example: Article text, long-form content, form input text
  static TextStyle get bodyLarge => baseTextTheme.bodyLarge!.copyWith(
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
  );

  /// Body Medium - 14px / Line 20px
  /// Standard body text, list items
  ///
  /// Example: Description, form field value, list item subtitle
  static TextStyle get bodyMedium => baseTextTheme.bodyMedium!.copyWith(
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  );

  /// Body Small - 12px / Line 16px
  /// Supplementary text, secondary content
  ///
  /// Example: Helper text, subtext, metadata
  static TextStyle get bodySmall => baseTextTheme.bodySmall!.copyWith(
    fontSize: 12,
    height: 1.33,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );

  /// Label Large - 14px / Line 20px
  /// Button text, larger interactive labels
  ///
  /// Example: Button text, navigation label, chip text
  static TextStyle get labelLarge => baseTextTheme.labelLarge!.copyWith(
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
  );

  /// Label Medium - 12px / Line 16px
  /// Standard interactive labels
  ///
  /// Example: Small button text, badge text, tab label
  static TextStyle get labelMedium => baseTextTheme.labelMedium!.copyWith(
    fontSize: 12,
    height: 1.33,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  );

  /// Label Small - 11px / Line 16px
  /// Compact labels for minimal space
  ///
  /// Example: Small badge, tiny label
  static TextStyle get labelSmall => baseTextTheme.labelSmall!.copyWith(
    fontSize: 11,
    height: 1.45,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  );

  /// Caption Large - 12px / Line 16px
  /// Larger supplementary text
  ///
  /// Example: Image caption, input hint, timestamp
  static TextStyle get captionLarge => TextStyle(
    fontSize: 12,
    height: 1.33,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
  );

  /// Caption Small - 11px / Line 16px
  /// Compact supplementary text
  ///
  /// Example: Copyright text, minor metadata
  static TextStyle get captionSmall => TextStyle(
    fontSize: 11,
    height: 1.45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
  );

  /// Error/validation message text
  /// Typically small and in error color
  static TextStyle get error => bodySmall.copyWith(
    fontWeight: FontWeight.w500,
  );

  /// Success/confirmation message text
  /// Typically small and in success color
  static TextStyle get success => bodySmall.copyWith(
    fontWeight: FontWeight.w500,
  );

  /// Disabled or inactive text
  /// Typically uses opacity for visual distinction
  static TextStyle get disabled => bodyMedium.copyWith(
    fontWeight: FontWeight.w400,
  );

  /// Hint or placeholder text
  /// Typically lighter than normal body text
  static TextStyle get hint => bodyMedium.copyWith(
    fontWeight: FontWeight.w400,
  );

  /// Link/hyperlink text
  /// Typically underlined or colored distinctly
  static TextStyle get link => bodyMedium.copyWith(
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.underline,
  );
}

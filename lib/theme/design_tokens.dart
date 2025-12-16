/// Design tokens for the Qkomo application.
///
/// This file centralizes all design system values including spacing, corner
/// radii, elevations, and other layout constants. All UI components should
/// reference these tokens rather than hardcoding values.
///
/// These tokens are independent of color or typography and work across all
/// theme variants (warm, fresh, offWhite, dark).
class DesignTokens {
  DesignTokens._();

  /// Spacing scale (8pt base unit system)
  ///
  /// Used for padding, margins, and gaps throughout the app.
  /// Based on 8pt base unit for consistency across screens.
  static const double spacingXs = 4.0; // Extra small (half unit)
  static const double spacingSm = 8.0; // Small (1 unit)
  static const double spacingMd = 16.0; // Medium (2 units)
  static const double spacingLg = 24.0; // Large (3 units)
  static const double spacingXl = 32.0; // Extra large (4 units)
  static const double spacingXxl = 48.0; // Extra extra large (6 units)
  static const double spacingXxxl = 64.0; // Triple extra large (8 units)

  /// Corner radius values for different component types
  ///
  /// Maintains visual consistency across buttons, cards, inputs, etc.
  static const double radiusXs = 4.0; // Extra small (for subtle effects)
  static const double radiusSm = 8.0; // Small (form inputs, chips)
  static const double radiusMd = 12.0; // Medium (buttons, small cards)
  static const double radiusLg = 16.0; // Large (cards, modals)
  static const double radiusXl = 20.0; // Extra large (large cards)
  static const double radiusFull = 100.0; // Full circle (for pill-shaped components)

  /// Elevation (shadow) values following Material Design elevation system
  ///
  /// Used for depth perception and visual hierarchy. Each elevation level
  /// corresponds to a specific material layer in the design system.
  static const double elevationNone = 0.0; // Flat surface (no shadow)
  static const double elevationSm = 2.0; // Subtle elevation (cards, FAB resting)
  static const double elevationMd = 4.0; // Medium elevation (raised buttons, hovered cards)
  static const double elevationLg = 8.0; // Large elevation (floating action button)
  static const double elevationXl = 12.0; // Extra large (modals, overlays)
  static const double elevationXxl = 16.0; // Extra extra large (top-level modals)

  /// Border width values
  ///
  /// Used for strokes on outlined buttons, input fields, and dividers.
  static const double borderWidthThin = 1.0; // Thin stroke (input borders, dividers)
  static const double borderWidthMedium = 1.5; // Medium stroke (focused states)
  static const double borderWidthThick = 2.0; // Thick stroke (emphasis)

  /// Animation duration values
  ///
  /// Consistent timing across all transitions and animations for a cohesive
  /// feel throughout the app. Follows Material Design guidance.
  static const Duration durationFast = Duration(milliseconds: 150); // Micro-interactions
  static const Duration durationBase = Duration(milliseconds: 300); // Standard transitions
  static const Duration durationSlow = Duration(milliseconds: 500); // Complex animations

  /// Opacity/Alpha values for various semantic purposes
  ///
  /// Used for disabled states, overlays, and visual hierarchy emphasis.
  static const double opacityDisabled = 0.5; // Disabled component opacity
  static const double opacityHover = 0.08; // Hover state overlay
  static const double opacityFocus = 0.12; // Focus state indicator
  static const double opacityPressed = 0.16; // Pressed/active state

  /// Component sizing conventions
  ///
  /// Standard sizes for interactive elements to ensure adequate touch targets
  /// (minimum 48x48dp per Material Design guidelines).
  static const double sizeTouchTarget = 48.0; // Minimum touch target size
  static const double sizeIconSmall = 20.0; // Small icons
  static const double sizeIconMedium = 24.0; // Medium icons
  static const double sizeIconLarge = 32.0; // Large icons
  static const double sizeAvatarSmall = 32.0; // Small avatar
  static const double sizeAvatarMedium = 48.0; // Medium avatar
  static const double sizeAvatarLarge = 64.0; // Large avatar

  /// Stroke width values for icons and graphics
  static const double strokeWidthThin = 1.5; // Thin strokes
  static const double strokeWidthMedium = 2.0; // Medium strokes (default)
  static const double strokeWidthThick = 2.5; // Thick strokes
}

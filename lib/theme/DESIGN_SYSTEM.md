# Qkomo Design System - Phase 1: Foundations

This document describes the design system foundation established in Phase 1, which centralizes all design tokens, colors, and typography for the Qkomo mobile app.

## Files Created

### 1. `design_tokens.dart`
Core design system values that are theme-independent:

- **Spacing**: 8pt base unit scale (4px to 64px)
  - `spacingXs` through `spacingXxxl`
- **Radius**: Corner radius values for different component types
  - `radiusXs` (4px) to `radiusFull` (100px)
- **Elevation**: Material Design shadow values
  - `elevationNone` through `elevationXxl`
- **BorderWidth**: Stroke sizes for UI elements
  - `borderWidthThin`, `borderWidthMedium`, `borderWidthThick`
- **Duration**: Animation timing values
  - `durationFast` (150ms), `durationBase` (300ms), `durationSlow` (500ms)
- **Opacity**: Semantic opacity values for disabled/hover/focus states
- **Size**: Standard component sizing (icons, avatars, touch targets)
- **StrokeWidth**: Icon and graphic stroke widths

**Usage:**
```dart
import 'package:qkomo_ui/theme/design_tokens.dart';

padding: EdgeInsets.all(DesignTokens.spacingMd),
borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
```

### 2. `app_colors.dart`
Semantic color palette organized by purpose:

- **Primary Colors**: Orange/coral brand colors with variants
  - `primaryMain`, `primaryLight`, `primaryDark`, `primaryVeryLight`
- **Secondary Colors**: Teal, blue accents
  - `secondaryTeal`, `secondaryTealLight`, `secondaryBlueLight`
- **Semantic Colors**: Status indication colors
  - Success (green), Error (red), Warning (amber), Info (blue)
  - Each with light and dark variants
- **Neutral Grays**: Complete grayscale palette
  - `neutralDark` through `neutralWhite`
- **Theme Palettes**: Pre-configured colors for each theme variant
  - Warm, Fresh, OffWhite, Dark
- **Overlay Colors**: Semi-transparent overlays for modals
- **Gradients**: Theme-specific gradient definitions

**Usage:**
```dart
import 'package:qkomo_ui/theme/app_colors.dart';

color: AppColors.primaryMain,
backgroundColor: AppColors.warmSurface,
gradient: AppColors.gradientFresh,
```

### 3. `app_typography.dart`
Complete typography scale with semantic text styles:

- **Display Styles**: Large, eye-catching headings
  - `displayLarge` (57px), `displayMedium` (45px), `displaySmall` (36px)
- **Headline Styles**: Section headings
  - `headlineLarge` (32px), `headlineMedium` (28px), `headlineSmall` (24px)
- **Title Styles**: Component and content titles
  - `titleLarge` (22px), `titleMedium` (16px), `titleSmall` (14px)
- **Body Styles**: Main content text
  - `bodyLarge` (16px), `bodyMedium` (14px), `bodySmall` (12px)
- **Label Styles**: Buttons, tags, badges
  - `labelLarge` (14px), `labelMedium` (12px), `labelSmall` (11px)
- **Caption Styles**: Supplementary text
  - `captionLarge` (12px), `captionSmall` (11px)
- **Special Styles**: Error, success, disabled, hint, link text

Font: Space Grotesk (Google Fonts) - excellent for Spanish text readability

**Usage:**
```dart
import 'package:qkomo_ui/theme/app_typography.dart';

Text('Title', style: AppTypography.titleLarge),
Text('Body text', style: AppTypography.bodyMedium),
FilledButton(
  onPressed: () {},
  child: Text('Button', style: AppTypography.labelLarge),
),
```

### 4. `accessibility.dart`
WCAG 2.1 accessibility validation tools:

- **Contrast Ratio Calculation**: Per WCAG formula
  - `getContrastRatio(Color, Color) -> double`
- **Validation Methods**: Check AA and AAA compliance
  - `isContrastRatioAANormalText()`
  - `isContrastRatioAAANormalText()`
  - Similar methods for large text (18pt+)
- **Color Extensions**: Convenient extension methods
  - `color.getContrastRatio(other)`
  - `color.isAccessibleForegroundAANormalText(background)`
- **Improvement Suggestions**: Debug helper for failing ratios

**Usage:**
```dart
import 'package:qkomo_ui/theme/accessibility.dart';

// Validate color pair
final isAccessible = AppColors.primaryMain
    .isAccessibleForegroundAANormalText(AppColors.warmSurface);

// Get formatted ratio for debugging
final ratio = AppColors.primaryMain
    .getContrastRatioString(AppColors.warmSurface);
```

### 5. `app_theme.dart` (Updated)
Now uses all design tokens and colors:

- References `AppColors` for all color scheme definitions
- Uses `AppTypography` for text styles
- Uses `DesignTokens` for spacing, radius, elevation, opacity values
- 4 theme variants: Warm (default), Fresh, OffWhite, Dark

**Usage:**
```dart
// Already integrated via existing providers
final theme = ref.watch(appThemeProvider);
```

## Theme Variants

### Warm (Default)
- Primary: Orange (#FF6F3C)
- Secondary: Purple accent
- Surface: Light lavender-tinted white
- Use case: Inviting, food-focused, energy

### Fresh
- Primary: Teal (#2DD4BF)
- Secondary: Blue (#4E7BFF)
- Surface: Cool icy blue-white
- Use case: Natural, fresh, healthy

### OffWhite
- Primary: Dark gray (#2D2D2D)
- Secondary: Medium gray
- Surface: Warm off-white
- Use case: Minimalist, professional, clean

### Dark
- Primary: Blue (#3B82F6)
- Secondary: Light blue
- Surface: Very dark gray
- Use case: Night mode, low-light accessibility

## Best Practices

### 1. Always Use Design Tokens
Instead of hardcoding values:
```dart
// ✅ Good
padding: EdgeInsets.all(DesignTokens.spacingMd),
borderRadius: BorderRadius.circular(DesignTokens.radiusLg),

// ❌ Bad
padding: EdgeInsets.all(16),
borderRadius: BorderRadius.circular(16),
```

### 2. Use Semantic Text Styles
```dart
// ✅ Good
Text('Title', style: AppTypography.titleLarge),
Text('Body', style: AppTypography.bodyMedium),

// ❌ Bad
Text('Title', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
Text('Body', style: TextStyle(fontSize: 14)),
```

### 3. Validate Color Contrast
All text-color combinations should meet WCAG AA minimum:
- Normal text: 4.5:1 contrast ratio
- Large text (18pt+): 3:1 contrast ratio

```dart
// Validate during development
assert(
  AppColors.primaryMain.isAccessibleForegroundAANormalText(
    AppColors.warmSurface,
  ),
  'Color contrast fails accessibility requirements',
);
```

### 4. Use Theme-Appropriate Colors
Reference theme-specific colors from AppColors:
```dart
// ✅ Good - uses warm theme surface
container: AppColors.warmSurface,

// Use ColorScheme for theme-aware colors
backgroundColor: theme.colorScheme.surface,
```

## Next Steps (Phase 2+)

- Component library with reusable widgets (buttons, cards, inputs, etc.)
- Motion/animation system using Duration tokens
- Shadow system using Elevation tokens
- Design documentation and showcase page
- Storybook-like widget catalog for QA testing

## Related Files

- `lib/theme/theme_providers.dart` - Riverpod theme management
- `lib/theme/theme_type.dart` - Theme variant enum
- `lib/theme/app_theme.dart` - Material theme configuration

## References

- [Material Design 3](https://m3.material.io/)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Color Contrast Checker](https://www.tpgi.com/color-contrast-checker/)

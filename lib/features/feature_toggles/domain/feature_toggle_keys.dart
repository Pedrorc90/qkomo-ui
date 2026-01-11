/// Feature toggle keys used across the application
///
/// Centralized constants to avoid magic strings when checking feature flags.
class FeatureToggleKeys {
  FeatureToggleKeys._();

  /// Companion (community) features - share weekly menu with others
  static const String companion = 'companion';

  /// Show appearance/theme settings
  static const String showAppearance = 'show_appearance';
}

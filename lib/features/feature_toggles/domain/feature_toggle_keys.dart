/// Feature toggle keys used across the application
///
/// Centralized constants to avoid magic strings when checking feature flags.
class FeatureToggleKeys {
  FeatureToggleKeys._();

  /// AI-powered suggestions for meal planning
  static const String aiSuggestions = 'ai_suggestions';

  /// AI-generated weekly menu feature
  static const String aiWeeklyMenuIsEnabled = 'ai_weekly_menu_is_enabled';

  /// Companion (community) features - share weekly menu with others
  static const String companion = 'companion';

  /// Historical profile data tracking
  static const String profileDataHistoricalIsEnabled = 'profile_data_historical_is_enabled';

  /// Enable/disable image analysis feature
  static const String isImageAnalysisEnabled = 'is_image_analysis_enabled';

  /// Show appearance/theme settings
  static const String showAppearance = 'show_appearance';
}

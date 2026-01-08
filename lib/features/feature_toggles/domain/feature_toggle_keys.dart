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

  /// Enable/disable manual meal adding feature
  static const String isManualMealAddEnabled = 'is_manual_meal_add_enabled';

  /// Enable/disable automatic menu generation
  static const String isGenerateAutomaticMenuEnabled = 'is_generate_automatic_menu_enabled';

  /// Show appearance/theme settings
  static const String showAppearance = 'show_appearance';
}

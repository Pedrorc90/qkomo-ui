/// Feature toggle keys used across the application
///
/// Centralized constants to avoid magic strings when checking feature flags.
class FeatureToggleKeys {
  FeatureToggleKeys._();

  /// AI-powered suggestions for meal planning
  static const String aiSuggestions = 'ai_suggestions';

  /// Companion (community) features - share weekly menu with others
  static const String companion = 'companion';

  /// Historical profile data tracking
  static const String profileDataHistoricalIsEnabled = 'profile_data_historical_is_enabled';
}

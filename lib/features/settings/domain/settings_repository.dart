import 'package:qkomo_ui/features/settings/domain/user_settings.dart';

/// Abstract repository interface for user settings operations
///
/// This interface defines the contract for settings persistence,
/// allowing different implementations (local-only, hybrid with sync, etc.)
abstract class SettingsRepository {
  /// Load user settings
  ///
  /// Returns stored settings or default values if none exist.
  /// Implementations may fetch from local storage, remote API, or both.
  Future<UserSettings> loadSettings();

  /// Save user settings
  ///
  /// Persists the provided settings.
  /// Implementations may save locally, remotely, or both.
  Future<void> saveSettings(UserSettings settings);

  /// Clear all user settings
  ///
  /// Removes stored settings and reverts to defaults.
  Future<void> clearSettings();
}

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:qkomo_ui/features/settings/data/local_settings_repository.dart';
import 'package:qkomo_ui/features/settings/data/remote_settings_repository.dart';
import 'package:qkomo_ui/features/settings/domain/repositories/settings_repository.dart';
import 'package:qkomo_ui/features/settings/domain/entities/user_settings.dart';

/// Hybrid implementation combining local and remote settings repositories
///
/// Implements offline-first pattern:
/// - Always returns local data immediately
/// - Syncs with backend asynchronously in background (only if user is authenticated)
/// - First sync after app update: pushes local settings to backend
/// - Subsequent syncs: fetches from backend (server authoritative)
class HybridSettingsRepository implements SettingsRepository {
  HybridSettingsRepository({
    required LocalSettingsRepository localRepo,
    required RemoteSettingsRepository remoteRepo,
    required FirebaseAuth firebaseAuth,
    this.enableCloudSync = false,
  })  : _localRepo = localRepo,
        _remoteRepo = remoteRepo,
        _firebaseAuth = firebaseAuth;

  final LocalSettingsRepository _localRepo;
  final RemoteSettingsRepository _remoteRepo;
  final FirebaseAuth _firebaseAuth;
  final bool enableCloudSync;

  @override
  Future<UserSettings> loadSettings() async {
    // 1. Always return local immediately (Offline-first)
    final localSettings = await _localRepo.loadSettings();

    // 2. Sync with backend in background (fire-and-forget)
    if (enableCloudSync) {
      unawaited(_syncFromBackend(localSettings));
    }

    return localSettings;
  }

  @override
  Future<void> saveSettings(UserSettings settings) async {
    // 1. Save locally first (Optimistic update)
    await _localRepo.saveSettings(settings);

    // 2. Push to backend async (fire-and-forget)
    if (enableCloudSync) {
      unawaited(_pushToBackend(settings));
    }
  }

  @override
  Future<void> clearSettings() async {
    // 1. Clear locally
    await _localRepo.clearSettings();

    // 2. Delete from backend async (fire-and-forget)
    if (enableCloudSync) {
      unawaited(_deleteFromBackend());
    }
  }

  /// Check if user is authenticated
  bool get _isUserAuthenticated => _firebaseAuth.currentUser != null;

  /// Sync settings from backend in background
  ///
  /// First sync: Push local settings to backend (migration)
  /// Subsequent syncs: Fetch from backend and update local (server wins)
  /// Only syncs if user is authenticated.
  Future<void> _syncFromBackend(UserSettings localSettings) async {
    // Don't sync if user is not authenticated
    if (!_isUserAuthenticated) {
      if (kDebugMode) {
        print('[HybridSettingsRepo] Skipping sync: user not authenticated');
      }
      return;
    }

    try {
      final isFirstSync = !(await _localRepo.isFirstSyncCompleted());

      if (isFirstSync) {
        // First sync: Push local data to backend (migration)
        if (kDebugMode) {
          print(
              '[HybridSettingsRepo] First sync: sending local settings to backend');
        }

        await _remoteRepo.pushPreferences(localSettings);
        await _localRepo.markFirstSyncCompleted();

        if (kDebugMode) {
          print('[HybridSettingsRepo] First sync completed');
        }
      } else {
        // Subsequent syncs: Fetch from backend (server authoritative)
        final remoteSettings = await _remoteRepo.fetchPreferences();

        if (remoteSettings != null) {
          // Preserve local-only fields from current settings
          final mergedSettings = remoteSettings.copyWith(
            languageCode: localSettings.languageCode,
            enableNotifications: localSettings.enableNotifications,
            enableDailyReminders: localSettings.enableDailyReminders,
          );

          await _localRepo.saveSettings(mergedSettings);

          if (kDebugMode) {
            print('[HybridSettingsRepo] Settings updated from backend');
          }
        }
      }
    } catch (e, stackTrace) {
      // Silent failure - don't block user
      if (kDebugMode) {
        print('[HybridSettingsRepo] Error synchronizing settings: $e');
        print(stackTrace);
      }
    }
  }

  /// Push settings to backend in background
  /// Only pushes if user is authenticated.
  Future<void> _pushToBackend(UserSettings settings) async {
    // Don't push if user is not authenticated
    if (!_isUserAuthenticated) {
      if (kDebugMode) {
        print('[HybridSettingsRepo] Skipping push: user not authenticated');
      }
      return;
    }

    try {
      await _remoteRepo.pushPreferences(settings);

      if (kDebugMode) {
        print('[HybridSettingsRepo] Settings sent to backend');
      }
    } catch (e, stackTrace) {
      // Silent failure - don't block user
      if (kDebugMode) {
        print('[HybridSettingsRepo] Error sending settings to backend: $e');
        print(stackTrace);
      }

      // TODO: Implement retry queue for failed pushes
      // For now, changes remain local and will sync on next app start
    }
  }

  /// Delete settings from backend in background
  /// Only deletes if user is authenticated.
  Future<void> _deleteFromBackend() async {
    // Don't delete if user is not authenticated
    if (!_isUserAuthenticated) {
      if (kDebugMode) {
        print('[HybridSettingsRepo] Skipping delete: user not authenticated');
      }
      return;
    }

    try {
      await _remoteRepo.deletePreferences();

      if (kDebugMode) {
        print('[HybridSettingsRepo] Settings deleted from backend');
      }
    } catch (e, stackTrace) {
      // Silent failure - don't block user
      if (kDebugMode) {
        print('[HybridSettingsRepo] Error deleting settings from backend: $e');
        print(stackTrace);
      }
    }
  }

  /// Manually trigger sync (useful for "Sync Now" button in UI)
  ///
  /// Unlike automatic background sync, this method throws errors for UI feedback.
  Future<void> manualSync() async {
    if (!enableCloudSync) {
      throw Exception('Cloud sync está deshabilitado');
    }

    final localSettings = await _localRepo.loadSettings();
    final isFirstSync = !(await _localRepo.isFirstSyncCompleted());

    if (isFirstSync) {
      // First sync: Push local to backend
      await _remoteRepo.pushPreferences(localSettings);
      await _localRepo.markFirstSyncCompleted();
    } else {
      // Subsequent syncs: Fetch from backend
      final remoteSettings = await _remoteRepo.fetchPreferences();

      if (remoteSettings != null) {
        // Preserve local-only fields
        final mergedSettings = remoteSettings.copyWith(
          languageCode: localSettings.languageCode,
          enableNotifications: localSettings.enableNotifications,
          enableDailyReminders: localSettings.enableDailyReminders,
        );

        await _localRepo.saveSettings(mergedSettings);
      }
    }
  }
}

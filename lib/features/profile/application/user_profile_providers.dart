import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/config/env.dart';
import 'package:qkomo_ui/core/http/dio_provider.dart';
import 'package:qkomo_ui/features/profile/data/hybrid_user_profile_repository.dart';
import 'package:qkomo_ui/features/profile/data/local_user_profile_repository.dart';
import 'package:qkomo_ui/features/profile/data/remote_user_profile_repository.dart';
import 'package:qkomo_ui/features/profile/domain/entities/user_profile.dart';
import 'package:qkomo_ui/features/profile/domain/repositories/user_profile_repository.dart';

/// Provider for local user profile repository (Hive storage)
final localUserProfileRepositoryProvider =
    Provider<LocalUserProfileRepository>((ref) {
  return LocalUserProfileRepository();
});

/// Provider for remote user profile repository (API client)
final remoteUserProfileRepositoryProvider =
    Provider<RemoteUserProfileRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return RemoteUserProfileRepository(dio: dio);
});

/// Provider for hybrid user profile repository (combines local + remote)
///
/// Uses enableCloudSync from EnvConfig to determine if backend sync is enabled.
final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  final localRepo = ref.watch(localUserProfileRepositoryProvider);
  final remoteRepo = ref.watch(remoteUserProfileRepositoryProvider);

  return HybridUserProfileRepository(
    localRepo: localRepo,
    remoteRepo: remoteRepo,
    enableCloudSync: EnvConfig.enableCloudSync,
  );
});

/// StateNotifier for user profile state management
///
/// Automatically loads profile on initialization.
/// Provides methods to:
/// - sync(): Manually trigger background sync (called after login)
/// - clear(): Clear profile on logout
final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, AsyncValue<UserProfile?>>((ref) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return UserProfileNotifier(repository);
});

/// Notifier for managing user profile state
///
/// Behavior (identical to feature toggles):
/// - Always loads from cache immediately (never shows loading state)
/// - Refreshes in background using unawaited()
/// - Silent failures (no errors shown to user)
class UserProfileNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  UserProfileNotifier(this._repository) : super(const AsyncValue.data(null)) {
    _loadProfile();
  }

  final UserProfileRepository _repository;

  /// Load profile with cache-first strategy (identical to feature toggles)
  ///
  /// - Always loads local cache immediately (non-blocking)
  /// - Triggers background refresh using unawaited()
  Future<void> _loadProfile() async {
    // Load local immediately (never blocks UI)
    final cached = await _repository.loadProfile();
    state = AsyncValue.data(cached);

    // Trigger background refresh (fire-and-forget, exactly like feature toggles)
    unawaited(_refreshInBackground());
  }

  /// Refresh from API in background without blocking UI
  ///
  /// - Fails silently if network is unavailable
  /// - Updates state only if fresh data is available
  /// - Preserves cached data on error
  Future<void> _refreshInBackground() async {
    try {
      await _repository.triggerSync();
      final fresh = await _repository.loadProfile();
      if (fresh != null) {
        state = AsyncValue.data(fresh);
      }
    } catch (e) {
      // Silent failure - keep cached data
    }
  }

  /// Manually trigger sync (called after login)
  ///
  /// Uses unawaited() to ensure it never blocks (identical to feature toggles)
  void sync() {
    // Fire-and-forget using unawaited() - exactly like feature toggles
    unawaited(_refreshInBackground());
  }

  /// Clear profile (called on logout)
  Future<void> clear() async {
    await _repository.clearProfile();
    state = const AsyncValue.data(null);
  }
}

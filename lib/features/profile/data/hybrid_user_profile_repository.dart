import 'dart:async';

import 'package:qkomo_ui/features/profile/data/local_user_profile_repository.dart';
import 'package:qkomo_ui/features/profile/data/remote_user_profile_repository.dart';
import 'package:qkomo_ui/features/profile/domain/entities/user_profile.dart';
import 'package:qkomo_ui/features/profile/domain/repositories/user_profile_repository.dart';

/// Hybrid implementation combining local and remote profile repositories
///
/// Implements offline-first pattern:
/// - Always returns local data immediately
/// - Syncs with backend asynchronously in background (fire-and-forget)
/// - Server is always authoritative (no merge logic needed)
/// - UserProfile is read-only from client perspective
///
/// Differences from HybridSettingsRepository:
/// - No first-sync migration logic (profile is read-only)
/// - No push to backend (only fetch)
/// - No merge logic (server wins unconditionally)
class HybridUserProfileRepository implements UserProfileRepository {
  HybridUserProfileRepository({
    required LocalUserProfileRepository localRepo,
    required RemoteUserProfileRepository remoteRepo,
    this.enableCloudSync = false,
  })  : _localRepo = localRepo,
        _remoteRepo = remoteRepo;

  final LocalUserProfileRepository _localRepo;
  final RemoteUserProfileRepository _remoteRepo;
  final bool enableCloudSync;

  @override
  Future<UserProfile?> loadProfile() async {
    // 1. Always return local immediately (Offline-first)
    final localProfile = await _localRepo.loadProfile();

    // 2. Sync with backend in background (fire-and-forget)
    if (enableCloudSync) {
      unawaited(triggerSync());
    }

    return localProfile;
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    await _localRepo.saveProfile(profile);
  }

  @override
  Future<void> clearProfile() async {
    await _localRepo.clearProfile();
  }

  @override
  Future<void> triggerSync() async {
    try {
      final remoteProfile = await _remoteRepo.fetchProfile();

      if (remoteProfile != null) {
        await _localRepo.saveProfile(remoteProfile);
        await _localRepo.markFirstSyncCompleted();
      }
    } catch (e) {
      // Silent failure - don't block user, no logging
    }
  }
}

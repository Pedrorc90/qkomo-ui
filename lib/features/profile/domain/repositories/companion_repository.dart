import 'package:qkomo_ui/features/profile/domain/entities/companion.dart';

/// Repository interface for companion (community) management
///
/// Defines the contract for managing user companions.
/// Supports local caching and remote synchronization.
abstract class CompanionRepository {
  /// Get cached companions (offline-first)
  ///
  /// Returns immediately with locally cached data.
  List<Companion> getCachedCompanions();

  /// Sync companions from remote API
  ///
  /// Fetches latest companions from backend and updates local cache.
  /// Throws on network errors.
  Future<List<Companion>> syncRemoteCompanions();

  /// Invite a companion by email
  Future<void> inviteCompanion(String email);

  /// Remove a companion by ID
  Future<void> removeCompanion(String id);
}

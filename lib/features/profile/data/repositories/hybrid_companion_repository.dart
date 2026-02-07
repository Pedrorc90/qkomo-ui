import 'package:qkomo_ui/features/profile/data/repositories/local_companion_repository.dart';
import 'package:qkomo_ui/features/profile/data/repositories/remote_companion_repository.dart';
import 'package:qkomo_ui/features/profile/domain/entities/companion.dart';
import 'package:qkomo_ui/features/profile/domain/repositories/companion_repository.dart';

/// Hybrid implementation combining local and remote companion repositories
///
/// Implements offline-first pattern:
/// - Always returns local data immediately
/// - Syncs with backend asynchronously (fire-and-forget)
/// - Server is authoritative (no merge logic needed)
///
/// Pattern follows HybridUserProfileRepository implementation.
class HybridCompanionRepository implements CompanionRepository {
  HybridCompanionRepository({
    required LocalCompanionRepository localRepo,
    required RemoteCompanionRepository remoteRepo,
  })  : _localRepo = localRepo,
        _remoteRepo = remoteRepo;

  final LocalCompanionRepository _localRepo;
  final RemoteCompanionRepository _remoteRepo;

  @override
  List<Companion> getCachedCompanions() {
    return _localRepo.getAll();
  }

  @override
  Future<List<Companion>> syncRemoteCompanions() async {
    try {
      final remoteCompanions = await _remoteRepo.fetchAll();
      await _localRepo.saveAll(remoteCompanions);
      return remoteCompanions;
    } catch (e) {
      // On error, clear cache to avoid stale data
      // This matches original behavior
      if (e is Exception) {
        await _localRepo.clear();
      }
      rethrow;
    }
  }

  @override
  Future<void> inviteCompanion(String email) async {
    await _remoteRepo.invite(email);
    // Note: Sync will be triggered by controller after this call
  }

  @override
  Future<void> removeCompanion(String id) async {
    await _remoteRepo.remove(id);
    // Note: Sync will be triggered by controller after this call
  }
}

import 'package:qkomo_ui/features/profile/data/companion_local_data_source.dart';
import 'package:qkomo_ui/features/profile/domain/entities/companion.dart';

/// Local repository for companions using Hive storage
///
/// Handles offline storage and retrieval of companion data.
/// Pattern follows LocalUserProfileRepository implementation.
class LocalCompanionRepository {
  LocalCompanionRepository({required CompanionLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  final CompanionLocalDataSource _localDataSource;

  /// Get all companions from local storage
  ///
  /// Returns immediately with cached data.
  List<Companion> getAll() {
    return _localDataSource.getCompanions();
  }

  /// Save companions list to local storage
  ///
  /// Replaces all existing companions with new list.
  Future<void> saveAll(List<Companion> companions) async {
    await _localDataSource.saveCompanions(companions);
  }

  /// Clear all companions from local storage
  ///
  /// Called on logout or sync failure requiring reset.
  Future<void> clear() async {
    await _localDataSource.clear();
  }
}

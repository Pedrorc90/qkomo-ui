/// Interface for repositories that support cloud synchronization
///
/// Any repository that implements this interface can be registered
/// with the SyncService for automatic background synchronization
abstract class SyncableRepository {
  /// Repository name for logging and debugging
  String get repositoryName;

  /// Synchronize local changes with remote server
  ///
  /// This method should:
  /// 1. PULL: Fetch remote updates since last sync
  /// 2. Detect and mark conflicts where local pending changes conflict with remote
  /// 3. PUSH: Send all pending local changes to remote
  ///
  /// Throws exceptions on error for UI feedback
  Future<void> sync();

  /// Get count of items with pending sync status
  ///
  /// Used by UI to display pending sync count indicator
  Future<int> getPendingSyncCount();
}

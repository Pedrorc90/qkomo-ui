import 'package:hive/hive.dart';

part 'sync_status.g.dart';

/// Sync status for entities that need cloud synchronization
@HiveType(typeId: 26)
enum SyncStatus {
  /// Not yet synced to backend
  @HiveField(0)
  pending,

  /// Successfully synced
  @HiveField(1)
  synced,

  /// Sync failed
  @HiveField(2)
  failed,

  /// Created locally, pending upload
  @HiveField(3)
  localOnly,

  /// Conflict detected during sync
  @HiveField(4)
  conflict,
}

/// Exception thrown when a sync conflict is detected
class ConflictException implements Exception {
  final String message;
  final dynamic localData;
  final dynamic remoteData;

  ConflictException(this.message, {this.localData, this.remoteData});

  @override
  String toString() => 'ConflictException: $message';
}

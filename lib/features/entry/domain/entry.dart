import 'package:hive/hive.dart';
import 'package:qkomo_ui/features/capture/domain/capture_result.dart';
import 'package:qkomo_ui/features/entry/domain/sync_status.dart';

part 'entry.g.dart';

@HiveType(typeId: 8)
class Entry {
  Entry({
    required this.id,
    required this.result,
    this.syncStatus = SyncStatus.pending,
    required this.lastModifiedAt,
    this.lastSyncedAt,
    this.isDeleted = false,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final CaptureResult result;

  @HiveField(2)
  final SyncStatus syncStatus;

  @HiveField(3)
  final DateTime lastModifiedAt;

  @HiveField(4)
  final DateTime? lastSyncedAt;

  @HiveField(5)
  final bool isDeleted;

  Entry copyWith({
    String? id,
    CaptureResult? result,
    SyncStatus? syncStatus,
    DateTime? lastModifiedAt,
    DateTime? lastSyncedAt,
    bool? isDeleted,
  }) {
    return Entry(
      id: id ?? this.id,
      result: result ?? this.result,
      syncStatus: syncStatus ?? this.syncStatus,
      lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}

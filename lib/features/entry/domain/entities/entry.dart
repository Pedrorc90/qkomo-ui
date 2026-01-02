import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';
import 'package:qkomo_ui/features/entry/domain/entities/sync_status.dart';

part 'entry.freezed.dart';
part 'entry.g.dart';

@freezed
class Entry with _$Entry {
  @HiveType(typeId: 8, adapterName: 'EntryAdapter')
  const factory Entry({
    @HiveField(0) required String id,
    @HiveField(1) required CaptureResult result,
    @HiveField(2) @Default(SyncStatus.pending) SyncStatus syncStatus,
    @HiveField(3) required DateTime lastModifiedAt,
    @HiveField(4) DateTime? lastSyncedAt,
    @HiveField(5) @Default(false) bool isDeleted,
    @HiveField(6) int? cloudVersion,
    @HiveField(7) Map<String, dynamic>? pendingChanges,
  }) = _Entry;

  factory Entry.fromJson(Map<String, dynamic> json) => _$EntryFromJson(json);
}

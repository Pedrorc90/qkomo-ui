import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:qkomo_ui/core/sync/sync_status.dart';

part 'companion.freezed.dart';
part 'companion.g.dart';

@freezed
class Companion with _$Companion {
  @HiveType(typeId: 9)
  const factory Companion({
    @HiveField(0) required String id,
    @HiveField(1) required String userId,
    @HiveField(2) required String email,
    @HiveField(3) String? displayName,
    @HiveField(4) String? photoUrl,
    @HiveField(5) @Default(false) bool isPending,

    // Sync fields
    @HiveField(6) @Default(SyncStatus.pending) SyncStatus syncStatus,
    @HiveField(7) required DateTime lastModifiedAt,
    @HiveField(8) DateTime? lastSyncedAt,
    @HiveField(9) @Default(false) bool isDeleted,
  }) = _Companion;

  factory Companion.fromJson(Map<String, dynamic> json) => _$CompanionFromJson(json);
}

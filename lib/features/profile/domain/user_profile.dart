import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:qkomo_ui/features/entry/domain/sync_status.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

/// Domain model for user profile data from backend /api/v1/users/me
///
/// Represents user identity information (email, displayName, photoUrl, timestamps).
/// User preferences (allergens, dietary restrictions) are managed separately
/// by UserSettings via /v1/preferences endpoint.
@freezed
class UserProfile with _$UserProfile {
  @HiveType(typeId: 25, adapterName: 'UserProfileImplAdapter')
  const factory UserProfile({
    @HiveField(0) required String firebaseUid,
    @HiveField(1) required String email,
    @HiveField(2) String? displayName,
    @HiveField(3) String? photoUrl,
    @HiveField(4) DateTime? lastLoginAt,
    @HiveField(5) required DateTime createdAt,
    @HiveField(6) required DateTime updatedAt,

    // Sync fields (following Companion pattern)
    @HiveField(7) @Default(SyncStatus.pending) SyncStatus syncStatus,
    @HiveField(8) DateTime? lastSyncedAt,
    @HiveField(9) @Default(false) bool isDeleted,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

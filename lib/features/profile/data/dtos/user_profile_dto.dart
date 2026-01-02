import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qkomo_ui/features/entry/domain/entities/sync_status.dart';
import 'package:qkomo_ui/features/profile/domain/entities/user_profile.dart';

part 'user_profile_dto.freezed.dart';
part 'user_profile_dto.g.dart';

/// DTO for /api/v1/users/me endpoint response
///
/// Backend returns allergens and dietaryPreferences, but these are IGNORED
/// in the converter. User preferences are managed separately by UserSettings
/// via the /v1/preferences endpoint to avoid data duplication and conflicts.
@freezed
class UserProfileDto with _$UserProfileDto {
  const factory UserProfileDto({
    required String firebaseUid,
    required String email,
    String? displayName,
    String? photoUrl,
    DateTime? lastLoginAt,

    // Ignored fields from backend (handled by UserSettings)
    List<String>? allergens,
    @JsonKey(name: 'dietaryPreferences') List<String>? dietaryPreferences,

    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserProfileDto;

  factory UserProfileDto.fromJson(Map<String, dynamic> json) =>
      _$UserProfileDtoFromJson(json);
}

/// Extension to convert DTO to domain model
extension UserProfileDtoConverter on UserProfileDto {
  /// Convert DTO to domain model
  ///
  /// IMPORTANT: Allergens and dietaryPreferences from backend are IGNORED.
  /// These are managed exclusively by UserSettings to maintain separation
  /// of concerns and avoid sync conflicts.
  UserProfile toDomain() {
    return UserProfile(
      firebaseUid: firebaseUid,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      lastLoginAt: lastLoginAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      // Sync fields default to synced on successful fetch
      syncStatus: SyncStatus.synced,
      lastSyncedAt: DateTime.now(),
      isDeleted: false,
    );
  }
}

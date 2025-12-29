import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qkomo_ui/features/settings/domain/user_settings.dart';

part 'preferences_dto.freezed.dart';
part 'preferences_dto.g.dart';

/// DTO for user preferences from backend /v1/preferences endpoint
///
/// Backend stores allergens and dietary preferences as comma-separated strings.
/// This DTO handles conversion between backend format and domain model.
@freezed
class PreferencesDto with _$PreferencesDto {
  const factory PreferencesDto({
    /// Comma-separated allergen names (e.g., "gluten,lactose,nuts")
    String? allergens,

    /// Comma-separated dietary restriction names (e.g., "vegan,keto,glutenFree")
    @JsonKey(name: 'dietary_preferences') String? dietaryPreferences,

    /// Timestamp when preferences were created
    @JsonKey(name: 'created_at') DateTime? createdAt,

    /// Timestamp when preferences were last updated
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _PreferencesDto;

  factory PreferencesDto.fromJson(Map<String, dynamic> json) =>
      _$PreferencesDtoFromJson(json);
}

/// Extension to convert PreferencesDto to UserSettings domain model
extension PreferencesDtoConverter on PreferencesDto {
  /// Convert DTO to domain model
  ///
  /// Parses comma-separated strings into enum lists.
  /// Invalid enum values from backend are filtered out gracefully.
  UserSettings toDomain({
    String languageCode = 'es',
    bool enableNotifications = true,
    bool enableDailyReminders = true,
  }) {
    return UserSettings(
      allergens: _parseAllergens(allergens),
      dietaryRestrictions: _parseDietaryRestrictions(dietaryPreferences),
      languageCode: languageCode,
      enableNotifications: enableNotifications,
      enableDailyReminders: enableDailyReminders,
    );
  }

  /// Parse comma-separated allergen string into list of Allergen enums
  static List<Allergen> _parseAllergens(String? csv) {
    if (csv == null || csv.trim().isEmpty) {
      return [];
    }

    return csv
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .map((s) => _allergenFromString(s))
        .whereType<Allergen>() // Filter out nulls from invalid values
        .toList();
  }

  /// Parse comma-separated dietary restriction string into list of enums
  static List<DietaryRestriction> _parseDietaryRestrictions(String? csv) {
    if (csv == null || csv.trim().isEmpty) {
      return [];
    }

    return csv
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .map((s) => _dietaryRestrictionFromString(s))
        .whereType<DietaryRestriction>() // Filter out nulls from invalid values
        .toList();
  }

  /// Convert string to Allergen enum, returns null if invalid
  static Allergen? _allergenFromString(String value) {
    try {
      return Allergen.values.firstWhere(
        (e) => e.name.toLowerCase() == value.toLowerCase(),
      );
    } catch (_) {
      return null; // Invalid value from backend
    }
  }

  /// Convert string to DietaryRestriction enum, returns null if invalid
  static DietaryRestriction? _dietaryRestrictionFromString(String value) {
    try {
      return DietaryRestriction.values.firstWhere(
        (e) => e.name.toLowerCase() == value.toLowerCase(),
      );
    } catch (_) {
      return null; // Invalid value from backend
    }
  }
}

/// Extension to convert UserSettings domain model to PreferencesDto
extension UserSettingsDtoConverter on UserSettings {
  /// Convert domain model to DTO for backend API
  ///
  /// Converts enum lists to comma-separated strings.
  /// Empty lists are converted to null.
  PreferencesDto toDto() {
    return PreferencesDto(
      allergens: allergens.isEmpty
          ? null
          : allergens.map((a) => a.name).join(','),
      dietaryPreferences: dietaryRestrictions.isEmpty
          ? null
          : dietaryRestrictions.map((d) => d.name).join(','),
      // createdAt and updatedAt are managed by backend
    );
  }
}

import 'package:dio/dio.dart';
import 'package:qkomo_ui/features/settings/data/dtos/preferences_dto.dart';
import 'package:qkomo_ui/features/settings/domain/user_settings.dart';

/// Remote implementation of settings repository using backend API
///
/// Communicates with `/v1/preferences` endpoint for user preferences sync.
/// Requires Firebase authentication token (automatically added by Dio interceptor).
class RemoteSettingsRepository {
  RemoteSettingsRepository({required Dio dio}) : _dio = dio;

  final Dio _dio;

  /// Fetch user preferences from backend
  ///
  /// Returns null if user has no preferences set (404).
  /// Throws [DioException] for network errors, auth failures, etc.
  ///
  /// Note: Local-only fields (languageCode, enableNotifications, enableDailyReminders)
  /// are not returned from backend and use default values.
  Future<UserSettings?> fetchPreferences() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/v1/preferences');

      if (response.data == null) {
        return null;
      }

      final dto = PreferencesDto.fromJson(response.data!);
      return dto.toDomain();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // No preferences set - not an error
        return null;
      }
      rethrow;
    }
  }

  /// Push user preferences to backend (idempotent)
  ///
  /// Uses PUT to ensure idempotency - same preferences = same result.
  /// Only syncs allergens and dietary restrictions, not local-only fields.
  ///
  /// Throws [ValidationException] on 400 (invalid allergen/restriction values).
  /// Throws [DioException] for network errors, auth failures, etc.
  Future<void> pushPreferences(UserSettings settings) async {
    try {
      final dto = settings.toDto();
      final payload = dto.toJson();

      await _dio.put<void>('/v1/preferences', data: payload);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        // Backend validation failed
        final responseData = e.response?.data;
        final message = (responseData is Map<String, dynamic>)
            ? (responseData['message'] as String? ??
                'Error de validación al guardar preferencias')
            : 'Error de validación al guardar preferencias';
        throw ValidationException(message);
      }
      rethrow;
    }
  }

  /// Delete user preferences from backend
  ///
  /// Treats 404 as success (already deleted).
  /// Throws [DioException] for network errors, auth failures, etc.
  Future<void> deletePreferences() async {
    try {
      await _dio.delete<void>('/v1/preferences');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Already deleted - not an error
        return;
      }
      rethrow;
    }
  }
}

/// Exception thrown when backend validation fails (400)
class ValidationException implements Exception {
  ValidationException(this.message);

  final String message;

  @override
  String toString() => 'ValidationException: $message';
}

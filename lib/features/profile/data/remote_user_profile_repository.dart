import 'package:dio/dio.dart';
import 'package:qkomo_ui/core/network/api_endpoints.dart';
import 'package:qkomo_ui/features/profile/data/dtos/user_profile_dto.dart';
import 'package:qkomo_ui/features/profile/domain/entities/user_profile.dart';

/// Remote repository for user profile using backend API
///
/// Calls the /api/v1/users/me endpoint which:
/// - Returns user profile from backend
/// - Creates user lazily if they don't exist (first time login)
/// - Is read-only from client perspective (no PUT/DELETE methods)
class RemoteUserProfileRepository {
  RemoteUserProfileRepository({required Dio dio}) : _dio = dio;

  final Dio _dio;

  /// Fetch user profile from /api/v1/users/me
  ///
  /// Backend creates user lazily if they don't exist.
  /// Returns null on 404 (defensive, should never happen due to lazy creation).
  ///
  /// The response includes allergens and dietaryPreferences, but these are
  /// IGNORED by the DTO converter - they're managed by UserSettings.
  ///
  /// SILENT REQUEST: Does not show "Connecting..." overlay to user
  Future<UserProfile?> fetchProfile() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.userProfile,
        options: Options(
          extra: {'silent_request': true}, // Don't show connection overlay
        ),
      );

      if (response.data == null) {
        return null;
      }

      final dto = UserProfileDto.fromJson(response.data!);
      return dto.toDomain();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // User doesn't exist - should be created by backend on next call
        // This is defensive handling, shouldn't occur due to lazy creation
        return null;
      }
      rethrow;
    }
  }
}

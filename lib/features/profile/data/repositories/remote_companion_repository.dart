import 'package:dio/dio.dart';
import 'package:qkomo_ui/core/network/api_endpoints.dart';
import 'package:qkomo_ui/features/profile/domain/entities/companion.dart';

/// Remote repository for companions using backend API
///
/// Handles all API calls for companion management.
/// Pattern follows RemoteUserProfileRepository implementation.
class RemoteCompanionRepository {
  RemoteCompanionRepository({required Dio dio}) : _dio = dio;

  final Dio _dio;

  /// Fetch all companions from API
  ///
  /// SILENT REQUEST: Does not show "Connecting..." overlay to user.
  /// Returns empty list if response is null or empty.
  Future<List<Companion>> fetchAll() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.companions,
      options: Options(
        extra: {'silent_request': true},
      ),
    );

    if (response.data == null) {
      return [];
    }

    final list = response.data!['companions'] as List<dynamic>?;
    if (list == null) {
      return [];
    }

    return list
        .map((e) => Companion.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Invite a companion by email
  ///
  /// Sends invitation to backend.
  Future<void> invite(String email) async {
    await _dio.post(ApiEndpoints.companions, data: {'email': email});
  }

  /// Remove a companion by ID
  ///
  /// Deletes companion from backend.
  Future<void> remove(String id) async {
    await _dio.delete(ApiEndpoints.companionById(id));
  }
}

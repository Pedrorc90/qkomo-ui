import 'package:dio/dio.dart';
import 'package:qkomo_ui/core/network/api_endpoints.dart';
import 'package:qkomo_ui/features/profile/data/companion_local_data_source.dart';
import 'package:qkomo_ui/features/profile/domain/entities/companion.dart';
import 'package:qkomo_ui/features/profile/domain/repositories/companion_repository.dart';

class CompanionRepositoryImpl implements CompanionRepository {
  CompanionRepositoryImpl({
    required Dio dio,
    required CompanionLocalDataSource localDataSource,
  })  : _dio = dio,
        _localDataSource = localDataSource;

  final Dio _dio;
  final CompanionLocalDataSource _localDataSource;

  /// Returns locally cached companions immediately.
  List<Companion> getCachedCompanions() {
    return _localDataSource.getCompanions();
  }

  /// Fetches from API and updates local cache.
  /// Throws DioException on network error.
  Future<List<Companion>> syncRemoteCompanions() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.companions,
      options: Options(
        extra: {'silent_request': true},
      ),
    );

    if (response.data == null) {
      // API returned null, treat as empty list? Or keep existing?
      // Assuming null/empty response means no companions.
      // We should probably NOT clear local data if server returns garbage unless we are sure.
      // But here we assume 200 OK with null means empty.
      await _localDataSource.clear();
      return [];
    }

    final list = response.data!['companions'] as List<dynamic>?;
    if (list == null) {
      await _localDataSource.clear();
      return [];
    }

    final companions = list.map((e) => Companion.fromJson(e as Map<String, dynamic>)).toList();

    // Cache the new data
    await _localDataSource.saveCompanions(companions);

    return companions;
  }

  Future<void> inviteCompanion(String email) async {
    await _dio.post(ApiEndpoints.companions, data: {'email': email});
  }

  Future<void> removeCompanion(String id) async {
    await _dio.delete(ApiEndpoints.companionById(id));
    // We could optimize by removing locally here, but next getCompanions will sync it.
  }
}

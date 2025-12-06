import 'package:dio/dio.dart';
import 'package:qkomo_ui/features/entry/domain/entry.dart';

class RemoteEntryRepository {
  RemoteEntryRepository({required Dio dio}) : _dio = dio;

  final Dio _dio;

  /// Fetch entries from backend with optional date range
  Future<List<Entry>> fetchEntries({DateTime? from, DateTime? to}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (from != null) {
        queryParams['from'] = from.toIso8601String();
      }
      if (to != null) {
        queryParams['to'] = to.toIso8601String();
      }

      final response = await _dio.get<Map<String, dynamic>>(
        '/v1/entries',
        queryParameters: queryParams,
      );

      if (response.data == null) {
        return [];
      }

      final entries = (response.data!['entries'] as List<dynamic>?)
              ?.map((json) => _entryFromJson(json as Map<String, dynamic>))
              .toList() ??
          [];

      return entries;
    } on DioException catch (e) {
      // Log error but don't throw - allow offline-first behavior
      // TODO: Add proper logging
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        // Network error - return empty list to use local cache
        return [];
      }
      rethrow;
    }
  }

  /// Push an entry to the backend (create or update)
  Future<void> pushEntry(Entry entry) async {
    try {
      final payload = _entryToJson(entry);

      // Use PUT for idempotency (same ID = same result)
      await _dio.put<void>(
        '/v1/entries/${entry.id}',
        data: payload,
      );
    } on DioException catch (e) {
      // TODO: Add proper logging
      if (e.response?.statusCode == 409) {
        // Conflict - entry already exists with different version
        throw ConflictException('Entry conflict detected');
      }
      rethrow;
    }
  }

  /// Delete an entry from the backend
  Future<void> deleteEntry(String id) async {
    try {
      await _dio.delete<void>('/v1/entries/$id');
    } on DioException catch (e) {
      // TODO: Add proper logging
      if (e.response?.statusCode == 404) {
        // Entry not found - already deleted, consider success
        return;
      }
      rethrow;
    }
  }

  /// Convert Entry to JSON for API
  Map<String, dynamic> _entryToJson(Entry entry) {
    return {
      'id': entry.id,
      'result': {
        'jobId': entry.result.jobId,
        'title': entry.result.title,
        'ingredients': entry.result.ingredients,
        'allergens': entry.result.allergens,
        'savedAt': entry.result.savedAt.toIso8601String(),
        'notes': entry.result.notes,
        'mealType': entry.result.mealType?.index,
        'isManualEntry': entry.result.isManualEntry,
      },
      'lastModifiedAt': entry.lastModifiedAt.toIso8601String(),
      'isDeleted': entry.isDeleted,
    };
  }

  /// Convert JSON from API to Entry
  Entry _entryFromJson(Map<String, dynamic> json) {
    // TODO: This is a placeholder - actual implementation depends on backend API response format
    // For now, throw an error to indicate this needs backend coordination
    throw UnimplementedError(
      'Entry deserialization from backend requires B5/B6 API specification',
    );
  }
}

/// Exception thrown when there's a conflict during sync
class ConflictException implements Exception {
  ConflictException(this.message);
  final String message;

  @override
  String toString() => 'ConflictException: $message';
}

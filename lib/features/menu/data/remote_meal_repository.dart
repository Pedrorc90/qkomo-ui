import 'package:dio/dio.dart';
import 'package:qkomo_ui/core/network/api_endpoints.dart';
import 'package:qkomo_ui/features/entry/data/remote_entry_repository.dart';
import 'package:qkomo_ui/features/entry/domain/entities/sync_status.dart';
import 'package:qkomo_ui/features/menu/domain/meal.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';

/// Remote repository for Meal API operations
class RemoteMealRepository {
  RemoteMealRepository({required Dio dio}) : _dio = dio;

  final Dio _dio;

  /// Fetch meals from backend with optional date range
  Future<List<Meal>> fetchMeals({DateTime? from, DateTime? to}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (from != null) {
        queryParams['from'] = from.toIso8601String();
      }
      if (to != null) {
        queryParams['to'] = to.toIso8601String();
      }

      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.meals,
        queryParameters: queryParams,
        options: Options(
          extra: {'silent_request': true}, // Background sync, don't show retry overlay
        ),
      );

      if (response.data == null) {
        return [];
      }

      final meals = (response.data!['meals'] as List<dynamic>?)
              ?.map((json) => _mealFromJson(json as Map<String, dynamic>))
              .toList() ??
          [];

      return meals;
    } on DioException catch (e) {
      // Network error - return empty list for offline-first behavior
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        return [];
      }
      rethrow;
    }
  }

  /// Push a meal to the backend (create or update, idempotent)
  Future<void> pushMeal(Meal meal) async {
    try {
      final payload = _mealToJson(meal);

      // Use PUT for idempotency
      await _dio.put<void>(
        ApiEndpoints.mealById(meal.id),
        data: payload,
        options: Options(
          extra: {'silent_request': true}, // Background sync, don't show retry overlay
        ),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        // Conflict - meal already exists with different version
        throw ConflictException('Meal conflict detected');
      }
      rethrow;
    }
  }

  /// Delete a meal from the backend
  Future<void> deleteMeal(String id) async {
    try {
      await _dio.delete<void>(
        ApiEndpoints.mealById(id),
        options: Options(
          extra: {'silent_request': true}, // Background sync, don't show retry overlay
        ),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Meal not found - already deleted, consider success
        return;
      }
      rethrow;
    }
  }

  /// Convert Meal to JSON for API
  Map<String, dynamic> _mealToJson(Meal meal) {
    return {
      'id': meal.id,
      'userId': meal.userId,
      'name': meal.name,
      'ingredients': meal.ingredients,
      'mealType': meal.mealType.index,
      'scheduledFor': meal.scheduledFor.toIso8601String(),
      'createdAt': meal.createdAt.toIso8601String(),
      'updatedAt': meal.updatedAt?.toIso8601String(),
      'notes': meal.notes,
      'photoPath': meal.photoPath,
      'lastModifiedAt': meal.lastModifiedAt.toIso8601String(),
      'isDeleted': meal.isDeleted,
    };
  }

  /// Convert JSON from API to Meal
  Meal _mealFromJson(Map<String, dynamic> json) {
    // Parse MealType safely
    MealType mealType = MealType.lunch; // Default fallback
    if (json['mealType'] != null) {
      final idx = json['mealType'] as int;
      if (idx >= 0 && idx < MealType.values.length) {
        mealType = MealType.values[idx];
      }
    }

    return Meal(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      ingredients:
          (json['ingredients'] as List<dynamic>?)?.cast<String>() ?? [],
      mealType: mealType,
      scheduledFor: DateTime.tryParse(json['scheduledFor'] as String) ??
          DateTime.now(),
      createdAt:
          DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      notes: json['notes'] as String?,
      photoPath: json['photoPath'] as String?,
      // Sync fields
      syncStatus: SyncStatus.synced, // Freshly fetched from server
      lastModifiedAt:
          DateTime.tryParse(json['lastModifiedAt'] as String) ?? DateTime.now(),
      lastSyncedAt: DateTime.now(), // Just synced
      isDeleted: json['isDeleted'] as bool? ?? false,
      cloudVersion: json['version'] as int?,
      pendingChanges: null,
    );
  }
}

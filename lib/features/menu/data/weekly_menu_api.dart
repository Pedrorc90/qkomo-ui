import 'package:dio/dio.dart';
import 'package:qkomo_ui/features/menu/application/date_utils.dart';
import 'package:qkomo_ui/features/menu/data/exceptions/ai_weekly_menu_disabled_exception.dart';
import 'package:qkomo_ui/features/menu/data/models/weekly_menu_dto.dart';

class WeeklyMenuApi {
  WeeklyMenuApi(this._dio);

  final Dio _dio;

  Future<WeeklyMenuDto> getWeeklyMenu(DateTime weekStart) async {
    final weekStartStr = ymd(weekStart);
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/v1/weekly-menus/$weekStartStr',
        // NOT silent - show loading indicator to user
      );

      if (response.data == null) {
        throw Exception('Empty response from GET /v1/weekly-menus/$weekStartStr');
      }

      return WeeklyMenuDto.fromJson(response.data!);
    } on DioException catch (e) {
      _handleDioError(e, 'getWeeklyMenu');
      rethrow;
    }
  }

  Future<WeeklyMenuDto> generateWeeklyMenu(DateTime weekStart) async {
    final weekStartStr = ymd(weekStart);
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/weekly-menus/$weekStartStr/generate',
      );

      if (response.data == null) {
        throw Exception('Empty response from POST /v1/weekly-menus/$weekStartStr/generate');
      }

      return WeeklyMenuDto.fromJson(response.data!);
    } on DioException catch (e) {
      _handleDioError(e, 'generateWeeklyMenu');
      rethrow;
    }
  }

  Future<WeeklyMenuDto> regenerateWeeklyMenu(DateTime weekStart) async {
    final weekStartStr = ymd(weekStart);
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/weekly-menus/$weekStartStr/regenerate',
      );

      if (response.data == null) {
        throw Exception('Empty response from POST /v1/weekly-menus/$weekStartStr/regenerate');
      }

      return WeeklyMenuDto.fromJson(response.data!);
    } on DioException catch (e) {
      _handleDioError(e, 'regenerateWeeklyMenu');
      rethrow;
    }
  }

  Future<WeeklyMenuDto> regenerateDay(DateTime weekStart, DateTime date) async {
    final weekStartStr = ymd(weekStart);
    final dateStr = ymd(date);
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/weekly-menus/$weekStartStr/days/$dateStr/regenerate',
      );

      if (response.data == null) {
        throw Exception(
          'Empty response from POST /v1/weekly-menus/$weekStartStr/days/$dateStr/regenerate',
        );
      }

      return WeeklyMenuDto.fromJson(response.data!);
    } on DioException catch (e) {
      _handleDioError(e, 'regenerateDay');
      rethrow;
    }
  }

  void _handleDioError(DioException e, String operation) {
    if (e.response?.statusCode == 409) {
      final responseData = e.response?.data;
      String? message;

      if (responseData is Map) {
        message = responseData['message']?.toString() ?? responseData['error']?.toString();
      } else if (responseData is String) {
        message = responseData;
      }

      if (message != null && message.toLowerCase().contains('ai weekly menu disabled')) {
        throw AiWeeklyMenuDisabledException(message);
      }
    }
  }
}

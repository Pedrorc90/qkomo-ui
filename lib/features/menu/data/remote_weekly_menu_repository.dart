import 'package:flutter/foundation.dart';
import 'package:qkomo_ui/features/menu/data/mappers/weekly_menu_mapper.dart';
import 'package:qkomo_ui/features/menu/data/weekly_menu_api.dart';
import 'package:qkomo_ui/features/menu/domain/entities/weekly_menu.dart';
import 'package:qkomo_ui/features/menu/domain/repositories/weekly_menu_repository.dart';

class RemoteWeeklyMenuRepository implements WeeklyMenuRepository {
  RemoteWeeklyMenuRepository(this._api);

  final WeeklyMenuApi _api;

  // Cache for in-flight requests to prevent duplicate calls
  final Map<String, Future<WeeklyMenu>> _inflightRequests = {};

  @override
  Future<WeeklyMenu> getWeek(DateTime weekStart, {required String userId}) async {
    // Normalize weekStart to midnight to ensure consistent cache keys
    final normalizedWeekStart = DateTime(weekStart.year, weekStart.month, weekStart.day);
    final key = 'getWeek_${normalizedWeekStart.toIso8601String()}';

    // If there's already a request in progress for this week, return it
    if (_inflightRequests.containsKey(key)) {
      debugPrint('[RemoteWeeklyMenuRepository] ♻️ Reusing in-flight request for $key');
      return _inflightRequests[key]!;
    }

    debugPrint('[RemoteWeeklyMenuRepository] 🌐 Starting new request for $key');

    // Create new request and cache it (use normalized date for API call too)
    final request = _api.getWeeklyMenu(normalizedWeekStart).then((dto) {
      final entity = WeeklyMenuMapper.toEntity(dto, userId: userId);
      // Remove from cache once complete
      _inflightRequests.remove(key);
      return entity;
    }).catchError((error) {
      // Remove from cache on error too
      _inflightRequests.remove(key);
      throw error;
    });

    _inflightRequests[key] = request;
    return request;
  }

  @override
  Future<WeeklyMenu> generateWeek(DateTime weekStart, {required String userId}) async {
    final dto = await _api.generateWeeklyMenu(weekStart);
    return WeeklyMenuMapper.toEntity(dto, userId: userId);
  }

  @override
  Future<WeeklyMenu> regenerateWeek(DateTime weekStart, {required String userId}) async {
    final dto = await _api.regenerateWeeklyMenu(weekStart);
    return WeeklyMenuMapper.toEntity(dto, userId: userId);
  }

  @override
  Future<WeeklyMenu> regenerateDay(DateTime weekStart, DateTime date, {required String userId}) async {
    final dto = await _api.regenerateDay(weekStart, date);
    return WeeklyMenuMapper.toEntity(dto, userId: userId);
  }

  @override
  Future<void> sync() async {
    // Remote repository doesn't handle sync - only the hybrid repository does
    // This is a no-op for remote-only implementation
  }

  @override
  Future<int> getPendingSyncCount() async {
    // Remote repository doesn't track pending sync count
    return 0;
  }
}

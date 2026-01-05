import 'package:qkomo_ui/features/menu/data/mappers/weekly_menu_mapper.dart';
import 'package:qkomo_ui/features/menu/data/weekly_menu_api.dart';
import 'package:qkomo_ui/features/menu/domain/entities/weekly_menu.dart';
import 'package:qkomo_ui/features/menu/domain/repositories/weekly_menu_repository.dart';

class RemoteWeeklyMenuRepository implements WeeklyMenuRepository {
  RemoteWeeklyMenuRepository(this._api);

  final WeeklyMenuApi _api;

  @override
  Future<WeeklyMenu> getWeek(DateTime weekStart, {required String userId}) async {
    final dto = await _api.getWeeklyMenu(weekStart);
    return WeeklyMenuMapper.toEntity(dto, userId: userId);
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

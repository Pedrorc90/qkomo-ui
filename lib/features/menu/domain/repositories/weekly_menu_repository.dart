import 'package:qkomo_ui/features/menu/domain/entities/weekly_menu.dart';

abstract class WeeklyMenuRepository {
  Future<WeeklyMenu> getWeek(DateTime weekStart, {required String userId});
  Future<WeeklyMenu> generateWeek(DateTime weekStart, {required String userId});
  Future<WeeklyMenu> regenerateWeek(DateTime weekStart, {required String userId});
  Future<WeeklyMenu> regenerateDay(DateTime weekStart, DateTime date, {required String userId});
  Future<void> sync();
  Future<int> getPendingSyncCount();
}

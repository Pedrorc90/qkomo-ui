import 'package:hive/hive.dart';
import 'package:qkomo_ui/features/entry/domain/entities/sync_status.dart';
import 'package:qkomo_ui/features/menu/domain/entities/weekly_menu.dart';

/// Local-only repository for WeeklyMenu operations using Hive
class LocalWeeklyMenuRepository {
  LocalWeeklyMenuRepository({
    required Box<WeeklyMenu> weeklyMenuBox,
    required String userId,
  })  : _weeklyMenuBox = weeklyMenuBox,
        _userId = userId;

  final Box<WeeklyMenu> _weeklyMenuBox;
  final String _userId;

  /// Save weekly menu to local storage (create or update)
  /// Key format: "userId_weekStartYYYYMMDD"
  Future<void> saveWeeklyMenu(WeeklyMenu menu) async {
    final key = _buildKey(menu.weekStart);
    await _weeklyMenuBox.put(key, menu);
  }

  /// Get weekly menu by week start date (null if not found or deleted)
  WeeklyMenu? getWeeklyMenu(DateTime weekStart) {
    final key = _buildKey(weekStart);
    final menu = _weeklyMenuBox.get(key);
    if (menu == null || menu.isDeleted) return null;
    return menu;
  }

  /// Soft delete weekly menu (mark as deleted and pending sync)
  Future<void> deleteWeeklyMenu(DateTime weekStart) async {
    final key = _buildKey(weekStart);
    final menu = _weeklyMenuBox.get(key);
    if (menu == null) return;
    await _weeklyMenuBox.put(
      key,
      menu.copyWith(
        isDeleted: true,
        syncStatus: SyncStatus.pending,
        lastModifiedAt: DateTime.now(),
      ),
    );
  }

  /// Get all non-deleted weekly menus for current user
  List<WeeklyMenu> getAllWeeklyMenus() {
    return _weeklyMenuBox.values
        .where((menu) => menu.userId == _userId && !menu.isDeleted)
        .toList()
      ..sort((a, b) => a.weekStart.compareTo(b.weekStart));
  }

  /// Get weekly menus with pending sync status
  List<WeeklyMenu> getPendingWeeklyMenus() {
    return _weeklyMenuBox.values
        .where((menu) =>
            menu.userId == _userId && menu.syncStatus == SyncStatus.pending)
        .toList();
  }

  /// Watch weekly menus reactively (emits list on any change)
  Stream<List<WeeklyMenu>> watchWeeklyMenus() {
    return _weeklyMenuBox.watch().map((_) => getAllWeeklyMenus());
  }

  /// Build unique key for weekly menu
  /// Format: "userId_weekStartYYYYMMDD"
  String _buildKey(DateTime weekStart) {
    final dateStr = weekStart.toIso8601String().substring(0, 10).replaceAll('-', '');
    return '${_userId}_$dateStr';
  }
}

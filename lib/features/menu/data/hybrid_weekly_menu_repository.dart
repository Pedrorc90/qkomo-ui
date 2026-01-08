import 'dart:async';

import 'package:qkomo_ui/core/services/logger_service.dart';
import 'package:qkomo_ui/features/menu/data/local_weekly_menu_repository.dart';
import 'package:qkomo_ui/features/menu/data/remote_weekly_menu_repository.dart';
import 'package:qkomo_ui/features/menu/domain/entities/weekly_menu.dart';
import 'package:qkomo_ui/features/menu/domain/repositories/weekly_menu_repository.dart';
import 'package:qkomo_ui/features/sync/domain/interfaces/syncable_repository.dart';

/// Hybrid repository implementing offline-first pattern with cloud sync for WeeklyMenu
class HybridWeeklyMenuRepository
    implements WeeklyMenuRepository, SyncableRepository {
  HybridWeeklyMenuRepository({
    required LocalWeeklyMenuRepository localRepo,
    required RemoteWeeklyMenuRepository remoteRepo,
    required String userId,
    this.enableCloudSync = false,
  })  : _localRepo = localRepo,
        _remoteRepo = remoteRepo,
        _userId = userId;

  final LocalWeeklyMenuRepository _localRepo;
  final RemoteWeeklyMenuRepository _remoteRepo;
  final String _userId;
  final bool enableCloudSync;

  @override
  String get repositoryName => 'WeeklyMenu';

  @override
  Future<WeeklyMenu> getWeek(DateTime weekStart, {required String userId}) async {
    // Return local menu immediately (offline-first)
    final localMenu = _localRepo.getWeeklyMenu(weekStart);

    if (localMenu != null) {
      // Return local menu without background sync
      // Sync can be triggered manually or via periodic background task
      return localMenu;
    }

    // No local cache, fetch from remote
    if (!enableCloudSync) {
      throw Exception('No hay menú local y la sincronización está deshabilitada');
    }

    try {
      final remoteMenu = await _remoteRepo.getWeek(weekStart, userId: userId);
      await _localRepo.saveWeeklyMenu(remoteMenu);
      return remoteMenu;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<WeeklyMenu> generateWeek(DateTime weekStart, {required String userId}) async {
    if (!enableCloudSync) {
      throw Exception('La generación de menú requiere conexión al servidor');
    }

    try {
      final menu = await _remoteRepo.generateWeek(weekStart, userId: userId);
      await _localRepo.saveWeeklyMenu(menu);
      return menu;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<WeeklyMenu> regenerateWeek(DateTime weekStart, {required String userId}) async {
    if (!enableCloudSync) {
      throw Exception('La regeneración de menú requiere conexión al servidor');
    }

    try {
      final menu = await _remoteRepo.regenerateWeek(weekStart, userId: userId);
      await _localRepo.saveWeeklyMenu(menu);
      return menu;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<WeeklyMenu> regenerateDay(DateTime weekStart, DateTime date, {required String userId}) async {
    if (!enableCloudSync) {
      throw Exception('La regeneración de día requiere conexión al servidor');
    }

    try {
      final menu = await _remoteRepo.regenerateDay(weekStart, date, userId: userId);
      await _localRepo.saveWeeklyMenu(menu);
      return menu;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> sync() async {
    if (!enableCloudSync) return;

    // Get all local menus to sync
    final allMenus = _localRepo.getAllWeeklyMenus();

    for (final menu in allMenus) {
      await _syncSingle(menu.weekStart);
    }
  }

  @override
  Future<int> getPendingSyncCount() async {
    return _localRepo.getPendingWeeklyMenus().length;
  }

  /// Sync a single weekly menu in the background
  Future<void> _syncSingle(DateTime weekStart) async {
    if (!enableCloudSync) return;

    try {
      // Fetch latest from server (use _userId from instance)
      final remoteMenu = await _remoteRepo.getWeek(weekStart, userId: _userId);

      final localMenu = _localRepo.getWeeklyMenu(weekStart);

      if (localMenu == null) {
        // New from cloud → save locally
        await _localRepo.saveWeeklyMenu(remoteMenu);
      } else {
        // Check if remote is newer
        if (remoteMenu.lastModifiedAt.isAfter(localMenu.lastModifiedAt)) {
          // Remote is newer → update local
          await _localRepo.saveWeeklyMenu(remoteMenu);
        }
      }
    } catch (e, stackTrace) {
      // Sync failed - log but don't throw (background operation)
      LogService().e(
        'Error al sincronizar weekly menu para $weekStart',
        e,
        stackTrace,
      );
    }
  }
}

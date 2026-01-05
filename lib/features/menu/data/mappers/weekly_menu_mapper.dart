import 'package:qkomo_ui/features/entry/domain/entities/sync_status.dart';
import 'package:qkomo_ui/features/menu/application/date_utils.dart';
import 'package:qkomo_ui/features/menu/data/models/weekly_menu_day_dto.dart';
import 'package:qkomo_ui/features/menu/data/models/weekly_menu_dto.dart';
import 'package:qkomo_ui/features/menu/data/models/weekly_menu_item_dto.dart';
import 'package:qkomo_ui/features/menu/domain/entities/weekly_menu.dart';
import 'package:qkomo_ui/features/menu/domain/entities/weekly_menu_day.dart';
import 'package:qkomo_ui/features/menu/domain/entities/weekly_menu_item.dart';

class WeeklyMenuMapper {
  static WeeklyMenu toEntity(WeeklyMenuDto dto, {required String userId}) {
    final now = DateTime.now();
    return WeeklyMenu(
      weekStart: parseYmd(dto.weekStart),
      status: dto.status,
      days: dto.days.map(_mapDay).toList(),
      userId: userId,
      syncStatus: SyncStatus.synced,
      lastModifiedAt: now,
      lastSyncedAt: now,
      isDeleted: false,
    );
  }

  static WeeklyMenuDay _mapDay(WeeklyMenuDayDto dto) {
    return WeeklyMenuDay(
      date: parseYmd(dto.date),
      items: dto.items.map(_mapItem).toList(),
    );
  }

  static WeeklyMenuItem _mapItem(WeeklyMenuItemDto dto) {
    return WeeklyMenuItem(
      mealType: dto.mealType,
      dishName: dto.dishName,
      description: dto.description,
      ingredients: dto.ingredients,
      imageUrl: dto.imageUrl,
      constraintsOk: dto.constraintsOk,
      violations: dto.violations ?? [],
    );
  }
}

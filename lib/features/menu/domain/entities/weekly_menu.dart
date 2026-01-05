import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:qkomo_ui/features/entry/domain/entities/sync_status.dart';
import 'package:qkomo_ui/features/menu/data/models/weekly_menu_status.dart';
import 'package:qkomo_ui/features/menu/domain/entities/weekly_menu_day.dart';

part 'weekly_menu.freezed.dart';
part 'weekly_menu.g.dart';

@freezed
class WeeklyMenu with _$WeeklyMenu {
  @HiveType(typeId: 15, adapterName: 'WeeklyMenuAdapter')
  const factory WeeklyMenu({
    @HiveField(0) required DateTime weekStart,
    @HiveField(1) required WeeklyMenuStatus status,
    @HiveField(2) required List<WeeklyMenuDay> days,
    @HiveField(3) required String userId,
    // Sync fields
    @HiveField(4) @Default(SyncStatus.pending) SyncStatus syncStatus,
    @HiveField(5) required DateTime lastModifiedAt,
    @HiveField(6) DateTime? lastSyncedAt,
    @HiveField(7) @Default(false) bool isDeleted,
  }) = _WeeklyMenu;

  factory WeeklyMenu.fromJson(Map<String, dynamic> json) =>
      _$WeeklyMenuFromJson(json);
}

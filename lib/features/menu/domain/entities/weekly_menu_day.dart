import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:qkomo_ui/features/menu/domain/entities/weekly_menu_item.dart';

part 'weekly_menu_day.freezed.dart';
part 'weekly_menu_day.g.dart';

@freezed
class WeeklyMenuDay with _$WeeklyMenuDay {
  @HiveType(typeId: 14, adapterName: 'WeeklyMenuDayAdapter')
  const factory WeeklyMenuDay({
    @HiveField(0) required DateTime date,
    @HiveField(1) required List<WeeklyMenuItem> items,
  }) = _WeeklyMenuDay;

  factory WeeklyMenuDay.fromJson(Map<String, dynamic> json) =>
      _$WeeklyMenuDayFromJson(json);
}

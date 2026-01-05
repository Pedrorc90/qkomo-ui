import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:qkomo_ui/features/menu/data/models/weekly_meal_type.dart';

part 'weekly_menu_item.freezed.dart';
part 'weekly_menu_item.g.dart';

@freezed
class WeeklyMenuItem with _$WeeklyMenuItem {
  @HiveType(typeId: 13, adapterName: 'WeeklyMenuItemAdapter')
  const factory WeeklyMenuItem({
    @HiveField(0) required WeeklyMealType mealType,
    @HiveField(1) required String dishName,
    @HiveField(2) String? description,
    @HiveField(3) required List<String> ingredients,
    @HiveField(4) String? imageUrl,
    @HiveField(5) required bool constraintsOk,
    @HiveField(6) required List<String> violations,
  }) = _WeeklyMenuItem;

  factory WeeklyMenuItem.fromJson(Map<String, dynamic> json) =>
      _$WeeklyMenuItemFromJson(json);
}

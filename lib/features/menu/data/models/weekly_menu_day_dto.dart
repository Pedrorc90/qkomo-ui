import 'package:qkomo_ui/features/menu/data/models/weekly_menu_item_dto.dart';

class WeeklyMenuDayDto {
  WeeklyMenuDayDto({
    required this.date,
    required this.items,
  });

  final String date; // YYYY-MM-DD
  final List<WeeklyMenuItemDto> items;

  factory WeeklyMenuDayDto.fromJson(Map<String, dynamic> json) {
    return WeeklyMenuDayDto(
      date: json['date'] as String? ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map(
                  (e) => WeeklyMenuItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

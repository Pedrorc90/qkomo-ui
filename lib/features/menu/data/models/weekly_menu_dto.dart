import 'package:qkomo_ui/features/menu/data/models/weekly_menu_day_dto.dart';
import 'package:qkomo_ui/features/menu/data/models/weekly_menu_status.dart';

class WeeklyMenuDto {
  WeeklyMenuDto({
    required this.weekStart,
    required this.status,
    required this.days,
  });

  final String weekStart; // YYYY-MM-DD
  final WeeklyMenuStatus status;
  final List<WeeklyMenuDayDto> days;

  factory WeeklyMenuDto.fromJson(Map<String, dynamic> json) {
    return WeeklyMenuDto(
      weekStart: json['weekStart'] as String? ?? '',
      status: WeeklyMenuStatus.parse(json['status'] as String?),
      days: (json['days'] as List<dynamic>?)
              ?.map((e) => WeeklyMenuDayDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weekStart': weekStart,
      'status': status.toJson(),
      'days': days.map((e) => e.toJson()).toList(),
    };
  }
}

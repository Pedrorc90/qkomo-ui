import 'package:hive/hive.dart';

part 'weekly_menu_status.g.dart';

@HiveType(typeId: 11)
enum WeeklyMenuStatus {
  @HiveField(0)
  generating,

  @HiveField(1)
  ready,

  @HiveField(2)
  failed;

  static WeeklyMenuStatus parse(String? value) {
    if (value == null) return WeeklyMenuStatus.failed;
    switch (value.toUpperCase()) {
      case 'GENERATING':
        return WeeklyMenuStatus.generating;
      case 'READY':
        return WeeklyMenuStatus.ready;
      case 'FAILED':
        return WeeklyMenuStatus.failed;
      default:
        return WeeklyMenuStatus.failed;
    }
  }

  String toJson() {
    switch (this) {
      case WeeklyMenuStatus.generating:
        return 'GENERATING';
      case WeeklyMenuStatus.ready:
        return 'READY';
      case WeeklyMenuStatus.failed:
        return 'FAILED';
    }
  }
}

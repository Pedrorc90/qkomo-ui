import 'package:hive/hive.dart';

part 'weekly_meal_type.g.dart';

@HiveType(typeId: 12)
enum WeeklyMealType {
  @HiveField(0)
  lunch,

  @HiveField(1)
  dinner;

  static WeeklyMealType parse(String? value) {
    if (value == null) return WeeklyMealType.lunch;
    switch (value.toUpperCase()) {
      case 'LUNCH':
        return WeeklyMealType.lunch;
      case 'DINNER':
        return WeeklyMealType.dinner;
      default:
        return WeeklyMealType.lunch;
    }
  }

  String toJson() {
    switch (this) {
      case WeeklyMealType.lunch:
        return 'LUNCH';
      case WeeklyMealType.dinner:
        return 'DINNER';
    }
  }

  String get displayName {
    switch (this) {
      case WeeklyMealType.lunch:
        return 'COMIDA';
      case WeeklyMealType.dinner:
        return 'CENA';
    }
  }
}

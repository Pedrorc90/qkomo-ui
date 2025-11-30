import 'package:hive_flutter/hive_flutter.dart';
import 'package:qkomo_ui/features/menu/domain/meal.dart';
import 'package:qkomo_ui/features/menu/data/hive_adapters/meal_adapter.dart';

class MenuHiveBoxes {
  static const meals = 'meals';

  static Future<void> init() async {
    Hive.registerAdapter(MealAdapter());
    await Hive.openBox<Meal>(meals);
  }
}

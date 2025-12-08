import 'package:hive_flutter/hive_flutter.dart';
import 'package:qkomo_ui/features/menu/domain/meal.dart';
import 'package:qkomo_ui/features/menu/data/hive_adapters/meal_adapter.dart';

class MenuHiveBoxes {
  static const meals = 'meals';
  static const _migrationVersion = 'meal_migration_v1';

  static Future<void> init() async {
    // Check if migration is needed BEFORE registering adapter
    final prefs = await Hive.openBox('app_preferences');
    final migrationDone = prefs.get(_migrationVersion, defaultValue: false);

    if (!migrationDone) {
      // Delete the old box completely to avoid deserialization errors
      await Hive.deleteBoxFromDisk(meals);
      await prefs.put(_migrationVersion, true);
    }

    // Now register adapter and open box with new schema
    Hive.registerAdapter(MealAdapter());
    await Hive.openBox<Meal>(meals);
  }
}

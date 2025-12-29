import 'package:hive_flutter/hive_flutter.dart';

import 'package:qkomo_ui/features/menu/domain/meal.dart';

class MenuHiveBoxes {
  static const meals = 'meals';
  static const userRecipes = 'user_recipes';
  static const deletedPresetRecipes = 'deleted_preset_recipes';
  static const migrationKey = 'meal_sync_migration_v2';

  static Future<void> init() async {
    // CRITICAL: Delete old box data to start fresh
    try {
      await Hive.deleteBoxFromDisk(meals);
    } catch (e) {
      // Box might not exist, continue
    }

    // Register V2 adapter (generated version)
    // FORCE override to ensure the correct adapter is used for _$MealImpl
    // This fixes "unknown type: _$MealImpl" error if ID 6 was claimed by another adapter
    Hive.registerAdapter(MealV2Adapter(), override: true);

    // Open the box as typed Box<Meal>
    await Hive.openBox<Meal>(meals);

    // Open user recipes box (stores JSON as Map<String, dynamic>)
    try {
      await Hive.openBox<dynamic>(userRecipes);
    } catch (e) {
      try {
        await Hive.deleteBoxFromDisk(userRecipes);
        await Hive.openBox<dynamic>(userRecipes);
      } catch (e2) {
        // Try one more time without deleting
        try {
          await Hive.openBox<dynamic>(userRecipes);
        } catch (e3) {
          // Unable to open box, continue anyway
        }
      }
    }

    // Open deleted preset recipes box
    try {
      await Hive.openBox<String>(deletedPresetRecipes);
    } catch (e) {
      try {
        await Hive.deleteBoxFromDisk(deletedPresetRecipes);
        await Hive.openBox<String>(deletedPresetRecipes);
      } catch (e2) {
        // Unable to open box, continue anyway
      }
    }
  }
}

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:qkomo_ui/config/env.dart';
import 'package:qkomo_ui/core/http/dio_provider.dart';
import 'package:qkomo_ui/features/auth/application/auth_providers.dart';
import 'package:qkomo_ui/features/feature_toggles/application/feature_toggle_providers.dart';
import 'package:qkomo_ui/features/feature_toggles/domain/feature_toggle_keys.dart';
import 'package:qkomo_ui/features/menu/application/ai_weekly_menu_availability.dart';
import 'package:qkomo_ui/features/menu/application/menu_controller.dart';
import 'package:qkomo_ui/features/menu/application/menu_state.dart';
import 'package:qkomo_ui/features/menu/data/custom_recipe_repository.dart'
    as impl;
import 'package:qkomo_ui/features/menu/data/deleted_preset_recipes_repository.dart'
    as impl2;
import 'package:qkomo_ui/features/menu/data/hive_boxes.dart';
import 'package:qkomo_ui/features/menu/data/hybrid_meal_repository.dart';
import 'package:qkomo_ui/features/menu/data/local_meal_repository.dart';
import 'package:qkomo_ui/features/menu/data/remote_meal_repository.dart';
import 'package:qkomo_ui/features/menu/data/hybrid_weekly_menu_repository.dart';
import 'package:qkomo_ui/features/menu/data/local_weekly_menu_repository.dart';
import 'package:qkomo_ui/features/menu/data/remote_weekly_menu_repository.dart';
import 'package:qkomo_ui/features/menu/data/weekly_menu_api.dart';
import 'package:qkomo_ui/features/menu/domain/entities/weekly_menu.dart';
import 'package:qkomo_ui/features/menu/domain/meal.dart';
import 'package:qkomo_ui/features/menu/domain/meal_repository.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';
import 'package:qkomo_ui/features/menu/domain/repositories/custom_recipe_repository.dart';
import 'package:qkomo_ui/features/menu/domain/repositories/deleted_preset_recipes_repository.dart';
import 'package:qkomo_ui/features/menu/domain/repositories/weekly_menu_repository.dart';
import 'package:qkomo_ui/features/menu/domain/user_recipe.dart';

// Box provider
final mealBoxProvider = Provider<Box<Meal>>((ref) {
  return Hive.box<Meal>(MenuHiveBoxes.meals);
});

// Local repository provider
final localMealRepositoryProvider = Provider<LocalMealRepository>((ref) {
  final box = ref.watch(mealBoxProvider);
  final user = ref.watch(authStateChangesProvider).value;
  final userId = user?.uid ?? '';

  return LocalMealRepository(mealBox: box, userId: userId);
});

// Remote repository provider
final remoteMealRepositoryProvider = Provider<RemoteMealRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return RemoteMealRepository(dio: dio);
});

// Hybrid repository provider (main interface)
final mealRepositoryProvider = Provider<MealRepository>((ref) {
  final localRepo = ref.watch(localMealRepositoryProvider);
  final remoteRepo = ref.watch(remoteMealRepositoryProvider);

  return HybridMealRepository(
    localRepo: localRepo,
    remoteRepo: remoteRepo,
    enableCloudSync: EnvConfig.enableCloudSync,
  );
});

// Pending sync count provider
final mealPendingSyncCountProvider = FutureProvider<int>((ref) async {
  final repo = ref.watch(mealRepositoryProvider);
  return repo.getPendingSyncCount();
});

// Stream provider for reactive updates
final mealsProvider = StreamProvider<List<Meal>>((ref) {
  final repo = ref.watch(mealRepositoryProvider);
  return repo.watchMeals();
});

// Current week provider
final currentWeekStartProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  // Monday as first day of week
  return now.subtract(Duration(days: now.weekday - 1));
});

// Filtered meals for current week
final weekMealsProvider = Provider<List<Meal>>((ref) {
  final allMeals = ref.watch(mealsProvider).value ?? [];
  final weekStart = ref.watch(currentWeekStartProvider);
  final weekEnd = weekStart.add(const Duration(days: 7));

  return allMeals.where((meal) {
    return meal.scheduledFor
            .isAfter(weekStart.subtract(const Duration(days: 1))) &&
        meal.scheduledFor.isBefore(weekEnd);
  }).toList();
});

// Selected day provider
// Selected day provider
final selectedDayProvider = StateProvider<DateTime?>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

// Filtered meals for selected day
final selectedDayMealsProvider = Provider<List<Meal>>((ref) {
  final selectedDay = ref.watch(selectedDayProvider);
  if (selectedDay == null) return [];

  final allMeals = ref.watch(mealsProvider).value ?? [];

  return allMeals.where((meal) {
    final mealDate = meal.scheduledFor;
    return mealDate.year == selectedDay.year &&
        mealDate.month == selectedDay.month &&
        mealDate.day == selectedDay.day;
  }).toList()
    ..sort((a, b) => a.mealType.index.compareTo(b.mealType.index));
});

// Today's meals provider
final todayMealsProvider = Provider<List<Meal>>((ref) {
  final allMeals = ref.watch(mealsProvider).value ?? [];
  final now = DateTime.now();

  return allMeals.where((meal) {
    final mealDate = meal.scheduledFor;
    return mealDate.year == now.year &&
        mealDate.month == now.month &&
        mealDate.day == now.day;
  }).toList()
    ..sort((a, b) => a.mealType.index.compareTo(b.mealType.index));
});

// All meals provider (for selecting existing meals)
final allMealsProvider = Provider<List<Meal>>((ref) {
  final allMeals = ref.watch(mealsProvider).value ?? [];
  return allMeals;
});

// User recipes box provider
final userRecipeBoxProvider = Provider<Box<dynamic>?>((ref) {
  try {
    if (Hive.isBoxOpen(MenuHiveBoxes.userRecipes)) {
      return Hive.box<dynamic>(MenuHiveBoxes.userRecipes);
    }
    return null;
  } catch (e) {
    // If box is not available, return null
    print('Error accessing userRecipes box: $e');
    return null;
  }
});

// Deleted preset recipes box provider
final deletedPresetRecipesBoxProvider = Provider<Box<String>?>((ref) {
  try {
    if (Hive.isBoxOpen(MenuHiveBoxes.deletedPresetRecipes)) {
      return Hive.box<String>(MenuHiveBoxes.deletedPresetRecipes);
    }
    return null;
  } catch (e) {
    print('Error accessing deletedPresetRecipes box: $e');
    return null;
  }
});

// Deleted preset recipes repository provider
final deletedPresetRecipesRepositoryProvider =
    Provider<DeletedPresetRecipesRepository?>((ref) {
  try {
    final box = ref.watch(deletedPresetRecipesBoxProvider);
    if (box == null) {
      return null;
    }
    return impl2.DeletedPresetRecipesRepositoryImpl(box: box);
  } catch (e) {
    print('Error creating deleted preset recipes repository: $e');
    return null;
  }
});

// Custom recipe repository provider
final customRecipeRepositoryProvider = Provider<CustomRecipeRepository?>((ref) {
  try {
    final box = ref.watch(userRecipeBoxProvider);

    if (box == null) {
      return null;
    }

    final user = ref.watch(firebaseAuthProvider).currentUser;
    final userId = user?.uid ?? '';

    return impl.CustomRecipeRepositoryImpl(recipeBox: box, userId: userId);
  } catch (e) {
    // If repository creation fails, return null
    return null;
  }
});

// Stream provider for custom recipes
final userRecipesProvider = StreamProvider<List<UserRecipe>>((ref) {
  final box = ref.watch(userRecipeBoxProvider);
  final controller = StreamController<List<UserRecipe>>();

  if (box == null) {
    controller.add([]);
    ref.onDispose(() {
      controller.close();
    });
    return controller.stream;
  }

  List<UserRecipe> filtered() {
    final user = ref.read(firebaseAuthProvider).currentUser;
    final userId = user?.uid ?? '';

    final items = box.values
        .whereType<Map<dynamic, dynamic>>()
        .where((data) => data['userId'] == userId)
        .map((data) {
      return UserRecipe(
        id: data['id'] as String? ?? '',
        userId: data['userId'] as String? ?? '',
        name: data['name'] as String? ?? '',
        ingredients: (data['ingredients'] as List?)?.cast<String>() ?? [],
        mealType: data['mealType'] != null
            ? MealType.values[data['mealType'] as int]
            : MealType.lunch,
        createdAt: data['createdAt'] != null
            ? DateTime.parse(data['createdAt'] as String)
            : DateTime.now(),
        photoPath: data['photoPath'] as String?,
      );
    }).toList();

    items.sort((a, b) => a.name.compareTo(b.name));
    return items;
  }

  controller.add(filtered());
  final sub = box.watch().listen((_) => controller.add(filtered()));

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});

// Stream provider for deleted preset recipes
final deletedPresetRecipesStreamProvider = StreamProvider<List<String>>((ref) {
  final box = ref.watch(deletedPresetRecipesBoxProvider);
  final controller = StreamController<List<String>>();

  if (box == null) {
    controller.add([]);
    ref.onDispose(() {
      controller.close();
    });
    return controller.stream;
  }

  List<String> getDeleted() {
    return box.values.toList();
  }

  controller.add(getDeleted());
  final sub = box.watch().listen((_) => controller.add(getDeleted()));

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});

// Weekly Menu providers
final weeklyMenuBoxProvider = Provider<Box<WeeklyMenu>>((ref) {
  return Hive.box<WeeklyMenu>(MenuHiveBoxes.weeklyMenus);
});

final weeklyMenuApiProvider = Provider<WeeklyMenuApi>((ref) {
  final dio = ref.watch(dioProvider);
  return WeeklyMenuApi(dio);
});

final localWeeklyMenuRepositoryProvider =
    Provider<LocalWeeklyMenuRepository>((ref) {
  final box = ref.watch(weeklyMenuBoxProvider);
  final user = ref.watch(authStateChangesProvider).value;
  final userId = user?.uid ?? '';

  return LocalWeeklyMenuRepository(weeklyMenuBox: box, userId: userId);
});

final remoteWeeklyMenuRepositoryProvider =
    Provider<RemoteWeeklyMenuRepository>((ref) {
  final api = ref.watch(weeklyMenuApiProvider);
  return RemoteWeeklyMenuRepository(api);
});

final weeklyMenuRepositoryProvider = Provider<WeeklyMenuRepository>((ref) {
  final localRepo = ref.watch(localWeeklyMenuRepositoryProvider);
  final remoteRepo = ref.watch(remoteWeeklyMenuRepositoryProvider);
  final user = ref.watch(authStateChangesProvider).value;
  final userId = user?.uid ?? '';

  return HybridWeeklyMenuRepository(
    localRepo: localRepo,
    remoteRepo: remoteRepo,
    userId: userId,
    enableCloudSync: EnvConfig.enableCloudSync,
  );
});

final aiWeeklyMenuAvailabilityProvider =
    Provider<AiWeeklyMenuAvailability>((ref) {
  return AiWeeklyMenuAvailability();
});

// Controller provider
final menuControllerProvider =
    StateNotifierProvider<MenuController, MenuState>((ref) {
  final repository = ref.watch(mealRepositoryProvider);
  final customRecipeRepository = ref.watch(customRecipeRepositoryProvider);
  final deletedPresetRecipesRepository =
      ref.watch(deletedPresetRecipesRepositoryProvider);
  final weeklyMenuRepository = ref.watch(weeklyMenuRepositoryProvider);
  final aiAvailability = ref.watch(aiWeeklyMenuAvailabilityProvider);

  return MenuController(
    repository,
    isAiWeeklyMenuEnabled: () {
      return ref.read(featureEnabledProvider(FeatureToggleKeys.aiWeeklyMenuIsEnabled));
    },
    getUserId: () {
      final user = ref.read(authStateChangesProvider).value;
      return user?.uid ?? '';
    },
    customRecipeRepository: customRecipeRepository,
    deletedPresetRecipesRepository: deletedPresetRecipesRepository,
    weeklyMenuRepository: weeklyMenuRepository,
    aiAvailability: aiAvailability,
  );
});

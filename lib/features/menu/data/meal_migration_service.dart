import 'package:hive/hive.dart';
import 'package:qkomo_ui/features/entry/domain/sync_status.dart';
import 'package:qkomo_ui/features/menu/data/local_meal_repository.dart';
import 'package:qkomo_ui/features/menu/domain/meal.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';

/// Service to migrate existing Meal data from V1 (typeId: 5) to V2 (typeId: 6)
/// NOTE: Migration is now deprecated - box opened directly with V2 adapter
class MealMigrationService {
  MealMigrationService({
    required LocalMealRepository mealRepository,
    required Box<Meal> mealBox,
  })  : _mealRepository = mealRepository,
        _mealBox = mealBox;

  final LocalMealRepository _mealRepository;
  final Box<Meal> _mealBox;

  static const String _migrationKey = 'meal_sync_migration_v2';

  /// Check if migration is needed (DEPRECATED - always returns false)
  Future<bool> needsMigration() async {
    return false;
  }

  /// Run migration (DEPRECATED - does nothing)
  Future<void> migrate() async {
    return;
  }

  /// Get migration progress (DEPRECATED)
  Future<MigrationProgress> getProgress() async {
    return MigrationProgress(
      total: 0,
      migrated: 0,
      isComplete: true,
    );
  }
}

/// Migration progress data
class MigrationProgress {
  MigrationProgress({
    required this.total,
    required this.migrated,
    required this.isComplete,
  });

  final int total;
  final int migrated;
  final bool isComplete;

  double get percentage => total > 0 ? migrated / total : 1.0;
}

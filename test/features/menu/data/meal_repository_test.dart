import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qkomo_ui/features/menu/data/meal_repository.dart';
import 'package:qkomo_ui/features/menu/domain/meal.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';
import 'package:qkomo_ui/features/menu/data/hive_adapters/meal_adapter.dart';
import 'dart:io';

void main() {
  late Box<Meal> mealBox;
  late MealRepository repository;
  const userId = 'test-user';

  setUp(() async {
    // Initialize Hive for testing
    final tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);

    // Register adapter
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(MealAdapter());
    }

    // Open a test box
    mealBox = await Hive.openBox<Meal>('test_meals');
    repository = MealRepository(mealBox: mealBox, userId: userId);
  });

  tearDown(() async {
    await mealBox.close();
    await Hive.deleteBoxFromDisk('test_meals');
  });

  group('MealRepository', () {
    test('deleteForDay should remove all meals for a specific day', () async {
      final date1 = DateTime(2023, 10, 27);
      final date2 = DateTime(2023, 10, 28);

      // Add meals for date1
      await repository.create(
        name: 'Breakfast 1',
        ingredients: ['egg'],
        mealType: MealType.breakfast,
        scheduledFor: DateTime(2023, 10, 27, 8, 0),
      );
      await repository.create(
        name: 'Lunch 1',
        ingredients: ['chicken'],
        mealType: MealType.lunch,
        scheduledFor: DateTime(2023, 10, 27, 13, 0),
      );

      // Add meal for date2
      await repository.create(
        name: 'Breakfast 2',
        ingredients: ['toast'],
        mealType: MealType.breakfast,
        scheduledFor: DateTime(2023, 10, 28, 8, 0),
      );

      // Verify initial state
      expect(repository.forDay(date1).length, equals(2));
      expect(repository.forDay(date2).length, equals(1));

      // Delete meals for date1
      await repository.deleteForDay(date1);

      // Verify final state
      expect(repository.forDay(date1).length, equals(0));
      expect(repository.forDay(date2).length, equals(1));
    });
  });
}

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:qkomo_ui/features/settings/data/local_settings_repository.dart';
import 'package:qkomo_ui/features/settings/domain/entities/user_settings.dart';

void main() {
  late LocalSettingsRepository repository;
  late Directory testDir;

  setUpAll(() async {
    // Create temporary directory for Hive tests
    testDir = Directory.systemTemp.createTempSync('hive_test_');

    // Initialize Hive with temp directory (no path_provider needed)
    Hive.init(testDir.path);

    // Register adapters if not already registered
    if (!Hive.isAdapterRegistered(20)) {
      Hive.registerAdapter(UserSettingsImplAdapter());
    }
    if (!Hive.isAdapterRegistered(21)) {
      Hive.registerAdapter(AllergenAdapter());
    }
    if (!Hive.isAdapterRegistered(22)) {
      Hive.registerAdapter(DietaryRestrictionAdapter());
    }
  });

  tearDownAll(() async {
    // Clean up temporary directory
    await testDir.delete(recursive: true);
  });

  setUp(() async {
    repository = LocalSettingsRepository();
  });

  tearDown(() async {
    // Clean up after each test
    if (Hive.isBoxOpen(LocalSettingsRepository.boxName)) {
      final box = Hive.box(LocalSettingsRepository.boxName);
      await box.clear();
      await box.close();
    }
  });

  group('LocalSettingsRepository', () {
    group('loadSettings', () {
      test('returns default settings when none exist', () async {
        final settings = await repository.loadSettings();

        expect(settings.allergens, isEmpty);
        expect(settings.dietaryRestrictions, isEmpty);
        expect(settings.languageCode, 'es');
        expect(settings.enableNotifications, true);
        expect(settings.enableDailyReminders, true);
      });

      test('automatically saves default settings when none exist', () async {
        // First load creates defaults
        await repository.loadSettings();

        // Second load should return the same defaults from storage
        final settings = await repository.loadSettings();

        expect(settings.allergens, isEmpty);
        expect(settings.dietaryRestrictions, isEmpty);
      });

      test('returns previously saved settings', () async {
        const testSettings = UserSettings(
          allergens: [Allergen.gluten, Allergen.lactose],
          dietaryRestrictions: [DietaryRestriction.vegan],
          languageCode: 'en',
        );

        await repository.saveSettings(testSettings);
        final loadedSettings = await repository.loadSettings();

        expect(loadedSettings.allergens, [Allergen.gluten, Allergen.lactose]);
        expect(loadedSettings.dietaryRestrictions, [DietaryRestriction.vegan]);
        expect(loadedSettings.languageCode, 'en');
      });

      test('can be called multiple times safely', () async {
        const testSettings = UserSettings(
          allergens: [Allergen.gluten],
        );

        await repository.saveSettings(testSettings);

        final settings1 = await repository.loadSettings();
        final settings2 = await repository.loadSettings();
        final settings3 = await repository.loadSettings();

        expect(settings1.allergens, [Allergen.gluten]);
        expect(settings2.allergens, [Allergen.gluten]);
        expect(settings3.allergens, [Allergen.gluten]);
      });
    });

    group('saveSettings', () {
      test('saves settings successfully', () async {
        const testSettings = UserSettings(
          allergens: [Allergen.nuts, Allergen.shellfish],
          dietaryRestrictions: [DietaryRestriction.keto, DietaryRestriction.paleo],
        );

        await repository.saveSettings(testSettings);
        final loadedSettings = await repository.loadSettings();

        expect(loadedSettings.allergens, testSettings.allergens);
        expect(loadedSettings.dietaryRestrictions, testSettings.dietaryRestrictions);
      });

      test('overwrites previous settings', () async {
        const settings1 = UserSettings(
          allergens: [Allergen.gluten],
        );
        const settings2 = UserSettings(
          allergens: [Allergen.lactose],
        );

        await repository.saveSettings(settings1);
        await repository.saveSettings(settings2);

        final loadedSettings = await repository.loadSettings();
        expect(loadedSettings.allergens, [Allergen.lactose]);
        expect(loadedSettings.allergens, isNot(contains(Allergen.gluten)));
      });

      test('saves all allergen types correctly', () async {
        const testSettings = UserSettings(
          allergens: Allergen.values,
        );

        await repository.saveSettings(testSettings);
        final loadedSettings = await repository.loadSettings();

        expect(loadedSettings.allergens.length, 14);
        expect(loadedSettings.allergens, containsAll(Allergen.values));
      });

      test('saves all dietary restriction types correctly', () async {
        const testSettings = UserSettings(
          dietaryRestrictions: DietaryRestriction.values,
        );

        await repository.saveSettings(testSettings);
        final loadedSettings = await repository.loadSettings();

        expect(loadedSettings.dietaryRestrictions.length, 8);
        expect(loadedSettings.dietaryRestrictions, containsAll(DietaryRestriction.values));
      });

      test('saves empty lists correctly', () async {
        const testSettings = UserSettings(
          allergens: [],
          dietaryRestrictions: [],
        );

        await repository.saveSettings(testSettings);
        final loadedSettings = await repository.loadSettings();

        expect(loadedSettings.allergens, isEmpty);
        expect(loadedSettings.dietaryRestrictions, isEmpty);
      });

      test('saves local-only fields correctly', () async {
        const testSettings = UserSettings(
          languageCode: 'fr',
          enableNotifications: false,
          enableDailyReminders: false,
        );

        await repository.saveSettings(testSettings);
        final loadedSettings = await repository.loadSettings();

        expect(loadedSettings.languageCode, 'fr');
        expect(loadedSettings.enableNotifications, false);
        expect(loadedSettings.enableDailyReminders, false);
      });
    });

    group('clearSettings', () {
      test('removes stored settings', () async {
        const testSettings = UserSettings(
          allergens: [Allergen.gluten],
        );

        await repository.saveSettings(testSettings);
        await repository.clearSettings();

        // After clearing, loadSettings should return defaults
        final loadedSettings = await repository.loadSettings();
        expect(loadedSettings.allergens, isEmpty);
      });

      test('can be called when no settings exist', () async {
        // Should not throw
        await repository.clearSettings();

        final settings = await repository.loadSettings();
        expect(settings, isA<UserSettings>());
      });

      test('can be called multiple times safely', () async {
        await repository.clearSettings();
        await repository.clearSettings();
        await repository.clearSettings();

        final settings = await repository.loadSettings();
        expect(settings, isA<UserSettings>());
      });
    });

    group('markFirstSyncCompleted', () {
      test('marks first sync as completed', () async {
        await repository.markFirstSyncCompleted();

        final isCompleted = await repository.isFirstSyncCompleted();
        expect(isCompleted, true);
      });

      test('persists across repository instances', () async {
        await repository.markFirstSyncCompleted();

        // Create new repository instance
        final newRepository = LocalSettingsRepository();
        final isCompleted = await newRepository.isFirstSyncCompleted();

        expect(isCompleted, true);
      });

      test('can be called multiple times safely', () async {
        await repository.markFirstSyncCompleted();
        await repository.markFirstSyncCompleted();
        await repository.markFirstSyncCompleted();

        final isCompleted = await repository.isFirstSyncCompleted();
        expect(isCompleted, true);
      });
    });

    group('isFirstSyncCompleted', () {
      test('returns false by default', () async {
        final isCompleted = await repository.isFirstSyncCompleted();
        expect(isCompleted, false);
      });

      test('returns true after marking completed', () async {
        await repository.markFirstSyncCompleted();

        final isCompleted = await repository.isFirstSyncCompleted();
        expect(isCompleted, true);
      });

      test('can be called multiple times safely', () async {
        await repository.markFirstSyncCompleted();

        final result1 = await repository.isFirstSyncCompleted();
        final result2 = await repository.isFirstSyncCompleted();
        final result3 = await repository.isFirstSyncCompleted();

        expect(result1, true);
        expect(result2, true);
        expect(result3, true);
      });
    });

    group('resetFirstSyncFlag', () {
      test('resets first sync flag to false', () async {
        await repository.markFirstSyncCompleted();
        await repository.resetFirstSyncFlag();

        final isCompleted = await repository.isFirstSyncCompleted();
        expect(isCompleted, false);
      });

      test('can be called when flag is not set', () async {
        // Should not throw
        await repository.resetFirstSyncFlag();

        final isCompleted = await repository.isFirstSyncCompleted();
        expect(isCompleted, false);
      });

      test('allows re-migration workflow', () async {
        // Initial migration
        await repository.markFirstSyncCompleted();
        expect(await repository.isFirstSyncCompleted(), true);

        // Reset for re-migration
        await repository.resetFirstSyncFlag();
        expect(await repository.isFirstSyncCompleted(), false);

        // Can mark completed again
        await repository.markFirstSyncCompleted();
        expect(await repository.isFirstSyncCompleted(), true);
      });
    });

    group('Integration tests', () {
      test('first sync flag is independent of settings', () async {
        const testSettings = UserSettings(
          allergens: [Allergen.gluten],
        );

        // Save settings but don't mark sync
        await repository.saveSettings(testSettings);
        expect(await repository.isFirstSyncCompleted(), false);

        // Mark sync
        await repository.markFirstSyncCompleted();
        expect(await repository.isFirstSyncCompleted(), true);

        // Clear settings
        await repository.clearSettings();

        // Sync flag should still be true
        expect(await repository.isFirstSyncCompleted(), true);
      });

      test('complete workflow: save → clear → save → sync', () async {
        // Save initial settings
        const settings1 = UserSettings(allergens: [Allergen.gluten]);
        await repository.saveSettings(settings1);

        // Clear
        await repository.clearSettings();

        // Save new settings
        const settings2 = UserSettings(allergens: [Allergen.lactose]);
        await repository.saveSettings(settings2);

        // Mark sync
        await repository.markFirstSyncCompleted();

        // Verify final state
        final finalSettings = await repository.loadSettings();
        final syncCompleted = await repository.isFirstSyncCompleted();

        expect(finalSettings.allergens, [Allergen.lactose]);
        expect(syncCompleted, true);
      });

      test('handles concurrent operations safely', () async {
        // Simulate concurrent saves and checks
        final futures = <Future<void>>[];

        for (var i = 0; i < 10; i++) {
          futures.add(repository.saveSettings(
            UserSettings(allergens: [Allergen.values[i % Allergen.values.length]]),
          ));
        }

        await Future.wait(futures);

        // Should not throw and should have valid settings
        final settings = await repository.loadSettings();
        expect(settings, isA<UserSettings>());
      });
    });
  });
}

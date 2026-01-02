import 'package:flutter_test/flutter_test.dart';
import 'package:qkomo_ui/features/settings/data/dtos/preferences_dto.dart';
import 'package:qkomo_ui/features/settings/domain/entities/user_settings.dart';

void main() {
  group('PreferencesDto', () {
    group('fromJson', () {
      test('parses complete JSON from backend correctly', () {
        final json = {
          'allergens': 'gluten,lactose,nuts',
          'dietary_preferences': 'vegan,keto',
          'created_at': '2025-01-15T10:00:00.000Z',
          'updated_at': '2025-01-15T12:00:00.000Z',
        };

        final dto = PreferencesDto.fromJson(json);

        expect(dto.allergens, 'gluten,lactose,nuts');
        expect(dto.dietaryPreferences, 'vegan,keto');
        expect(dto.createdAt, DateTime.parse('2025-01-15T10:00:00.000Z'));
        expect(dto.updatedAt, DateTime.parse('2025-01-15T12:00:00.000Z'));
      });

      test('handles null values correctly', () {
        final json = <String, dynamic>{};

        final dto = PreferencesDto.fromJson(json);

        expect(dto.allergens, isNull);
        expect(dto.dietaryPreferences, isNull);
        expect(dto.createdAt, isNull);
        expect(dto.updatedAt, isNull);
      });

      test('handles empty strings correctly', () {
        final json = {
          'allergens': '',
          'dietary_preferences': '',
        };

        final dto = PreferencesDto.fromJson(json);

        expect(dto.allergens, '');
        expect(dto.dietaryPreferences, '');
      });
    });

    group('toDomain', () {
      test('converts allergens from comma-separated string to enum list', () {
        final dto = PreferencesDto(
          allergens: 'gluten,lactose,nuts',
        );

        final settings = dto.toDomain();

        expect(settings.allergens, [
          Allergen.gluten,
          Allergen.lactose,
          Allergen.nuts,
        ]);
      });

      test('converts dietary restrictions from comma-separated string to enum list', () {
        final dto = PreferencesDto(
          dietaryPreferences: 'vegan,keto,glutenFree',
        );

        final settings = dto.toDomain();

        expect(settings.dietaryRestrictions, [
          DietaryRestriction.vegan,
          DietaryRestriction.keto,
          DietaryRestriction.glutenFree,
        ]);
      });

      test('handles camelCase dietary restrictions correctly', () {
        final dto = PreferencesDto(
          dietaryPreferences: 'lowCarb,glutenFree,dairyFree',
        );

        final settings = dto.toDomain();

        expect(settings.dietaryRestrictions, [
          DietaryRestriction.lowCarb,
          DietaryRestriction.glutenFree,
          DietaryRestriction.dairyFree,
        ]);
      });

      test('filters out invalid allergen values gracefully', () {
        final dto = PreferencesDto(
          allergens: 'gluten,invalid,lactose,unknown,nuts',
        );

        final settings = dto.toDomain();

        expect(settings.allergens, [
          Allergen.gluten,
          Allergen.lactose,
          Allergen.nuts,
        ]);
      });

      test('filters out invalid dietary restriction values gracefully', () {
        final dto = PreferencesDto(
          dietaryPreferences: 'vegan,invalid,keto,unknown',
        );

        final settings = dto.toDomain();

        expect(settings.dietaryRestrictions, [
          DietaryRestriction.vegan,
          DietaryRestriction.keto,
        ]);
      });

      test('handles null allergens as empty list', () {
        final dto = PreferencesDto(allergens: null);

        final settings = dto.toDomain();

        expect(settings.allergens, isEmpty);
      });

      test('handles empty allergens string as empty list', () {
        final dto = PreferencesDto(allergens: '');

        final settings = dto.toDomain();

        expect(settings.allergens, isEmpty);
      });

      test('handles whitespace-only allergens as empty list', () {
        final dto = PreferencesDto(allergens: '   ');

        final settings = dto.toDomain();

        expect(settings.allergens, isEmpty);
      });

      test('trims whitespace around allergen values', () {
        final dto = PreferencesDto(
          allergens: ' gluten , lactose , nuts ',
        );

        final settings = dto.toDomain();

        expect(settings.allergens, [
          Allergen.gluten,
          Allergen.lactose,
          Allergen.nuts,
        ]);
      });

      test('filters out empty strings after split', () {
        final dto = PreferencesDto(
          allergens: 'gluten,,lactose,,nuts',
        );

        final settings = dto.toDomain();

        expect(settings.allergens, [
          Allergen.gluten,
          Allergen.lactose,
          Allergen.nuts,
        ]);
      });

      test('sets default values for local-only fields', () {
        final dto = PreferencesDto();

        final settings = dto.toDomain();

        expect(settings.languageCode, 'es');
        expect(settings.enableNotifications, true);
        expect(settings.enableDailyReminders, true);
      });

      test('allows overriding default values for local-only fields', () {
        final dto = PreferencesDto();

        final settings = dto.toDomain(
          languageCode: 'en',
          enableNotifications: false,
          enableDailyReminders: false,
        );

        expect(settings.languageCode, 'en');
        expect(settings.enableNotifications, false);
        expect(settings.enableDailyReminders, false);
      });

      test('handles all 14 allergen types correctly', () {
        final dto = PreferencesDto(
          allergens: 'gluten,lactose,egg,nuts,soy,fish,shellfish,peanuts,sesame,sulfites,celery,mustard,lupin,molluscs',
        );

        final settings = dto.toDomain();

        expect(settings.allergens.length, 14);
        expect(settings.allergens, containsAll(Allergen.values));
      });

      test('handles all 8 dietary restriction types correctly', () {
        final dto = PreferencesDto(
          dietaryPreferences: 'vegan,vegetarian,pescatarian,keto,paleo,lowCarb,glutenFree,dairyFree',
        );

        final settings = dto.toDomain();

        expect(settings.dietaryRestrictions.length, 8);
        expect(settings.dietaryRestrictions, containsAll(DietaryRestriction.values));
      });

      test('is case-insensitive for allergen values', () {
        final dto = PreferencesDto(
          allergens: 'GLUTEN,Lactose,nUtS',
        );

        final settings = dto.toDomain();

        expect(settings.allergens, [
          Allergen.gluten,
          Allergen.lactose,
          Allergen.nuts,
        ]);
      });

      test('is case-insensitive for dietary restriction values', () {
        final dto = PreferencesDto(
          dietaryPreferences: 'VEGAN,Keto,glutenFree',
        );

        final settings = dto.toDomain();

        expect(settings.dietaryRestrictions, [
          DietaryRestriction.vegan,
          DietaryRestriction.keto,
          DietaryRestriction.glutenFree,
        ]);
      });
    });

    group('UserSettings.toDto', () {
      test('converts allergens from enum list to comma-separated string', () {
        final settings = UserSettings(
          allergens: [Allergen.gluten, Allergen.lactose, Allergen.nuts],
        );

        final dto = settings.toDto();

        expect(dto.allergens, 'gluten,lactose,nuts');
      });

      test('converts dietary restrictions from enum list to comma-separated string', () {
        final settings = UserSettings(
          dietaryRestrictions: [
            DietaryRestriction.vegan,
            DietaryRestriction.keto,
            DietaryRestriction.glutenFree,
          ],
        );

        final dto = settings.toDto();

        expect(dto.dietaryPreferences, 'vegan,keto,glutenFree');
      });

      test('converts empty allergens list to null', () {
        final settings = UserSettings(allergens: []);

        final dto = settings.toDto();

        expect(dto.allergens, isNull);
      });

      test('converts empty dietary restrictions list to null', () {
        final settings = UserSettings(dietaryRestrictions: []);

        final dto = settings.toDto();

        expect(dto.dietaryPreferences, isNull);
      });

      test('preserves camelCase in dietary restriction names', () {
        final settings = UserSettings(
          dietaryRestrictions: [
            DietaryRestriction.lowCarb,
            DietaryRestriction.glutenFree,
            DietaryRestriction.dairyFree,
          ],
        );

        final dto = settings.toDto();

        expect(dto.dietaryPreferences, 'lowCarb,glutenFree,dairyFree');
      });

      test('does not include local-only fields in DTO', () {
        final settings = UserSettings(
          languageCode: 'en',
          enableNotifications: false,
          enableDailyReminders: false,
        );

        final dto = settings.toDto();

        expect(dto.allergens, isNull);
        expect(dto.dietaryPreferences, isNull);
        expect(dto.createdAt, isNull);
        expect(dto.updatedAt, isNull);
      });
    });

    group('Round-trip conversion', () {
      test('preserves allergens through domain → DTO → domain', () {
        final original = UserSettings(
          allergens: [Allergen.gluten, Allergen.lactose, Allergen.nuts],
        );

        final dto = original.toDto();
        final restored = dto.toDomain();

        expect(restored.allergens, original.allergens);
      });

      test('preserves dietary restrictions through domain → DTO → domain', () {
        final original = UserSettings(
          dietaryRestrictions: [
            DietaryRestriction.vegan,
            DietaryRestriction.keto,
          ],
        );

        final dto = original.toDto();
        final restored = dto.toDomain();

        expect(restored.dietaryRestrictions, original.dietaryRestrictions);
      });

      test('preserves all values through DTO → domain → DTO', () {
        final original = PreferencesDto(
          allergens: 'gluten,lactose,nuts',
          dietaryPreferences: 'vegan,keto',
        );

        final settings = original.toDomain();
        final restored = settings.toDto();

        expect(restored.allergens, original.allergens);
        expect(restored.dietaryPreferences, original.dietaryPreferences);
      });

      test('preserves empty lists through round-trip', () {
        final original = UserSettings(
          allergens: [],
          dietaryRestrictions: [],
        );

        final dto = original.toDto();
        final restored = dto.toDomain();

        expect(restored.allergens, isEmpty);
        expect(restored.dietaryRestrictions, isEmpty);
      });

      test('preserves all 14 allergens through round-trip', () {
        final original = UserSettings(
          allergens: Allergen.values,
        );

        final dto = original.toDto();
        final restored = dto.toDomain();

        expect(restored.allergens.length, 14);
        expect(restored.allergens, containsAll(Allergen.values));
      });

      test('preserves all 8 dietary restrictions through round-trip', () {
        final original = UserSettings(
          dietaryRestrictions: DietaryRestriction.values,
        );

        final dto = original.toDto();
        final restored = dto.toDomain();

        expect(restored.dietaryRestrictions.length, 8);
        expect(restored.dietaryRestrictions, containsAll(DietaryRestriction.values));
      });
    });
  });
}

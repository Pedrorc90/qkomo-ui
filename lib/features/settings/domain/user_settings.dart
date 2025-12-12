import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'user_settings.freezed.dart';
part 'user_settings.g.dart';

@freezed
class UserSettings with _$UserSettings {
  @HiveType(typeId: 20)
  const factory UserSettings({
    @HiveField(0) @Default([]) List<Allergen> allergens,
    @HiveField(1) @Default([]) List<DietaryRestriction> dietaryRestrictions,
    @HiveField(2) @Default('es') String languageCode,
    @HiveField(3) @Default(true) bool enableNotifications,
    @HiveField(4) @Default(true) bool enableDailyReminders,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) => _$UserSettingsFromJson(json);
}

@HiveType(typeId: 21)
enum Allergen {
  @HiveField(0)
  gluten,
  @HiveField(1)
  lactose,
  @HiveField(2)
  egg,
  @HiveField(3)
  nuts,
  @HiveField(4)
  soy,
  @HiveField(5)
  fish,
  @HiveField(6)
  shellfish,
  @HiveField(7)
  peanuts,
  @HiveField(8)
  sesame,
  @HiveField(9)
  sulfites,
  @HiveField(10)
  celery,
  @HiveField(11)
  mustard,
  @HiveField(12)
  lupin,
  @HiveField(13)
  molluscs;

  String get displayName {
    switch (this) {
      case Allergen.gluten:
        return 'Gluten';
      case Allergen.lactose:
        return 'Lactosa';
      case Allergen.egg:
        return 'Huevo';
      case Allergen.nuts:
        return 'Frutos secos';
      case Allergen.soy:
        return 'Soja';
      case Allergen.fish:
        return 'Pescado';
      case Allergen.shellfish:
        return 'Mariscos';
      case Allergen.peanuts:
        return 'Cacahuetes';
      case Allergen.sesame:
        return 'Sésamo';
      case Allergen.sulfites:
        return 'Sulfitos';
      case Allergen.celery:
        return 'Apio';
      case Allergen.mustard:
        return 'Mostaza';
      case Allergen.lupin:
        return 'Altramuces';
      case Allergen.molluscs:
        return 'Moluscos';
    }
  }
}

@HiveType(typeId: 22)
enum DietaryRestriction {
  @HiveField(0)
  vegan,
  @HiveField(1)
  vegetarian,
  @HiveField(2)
  pescatarian,
  @HiveField(3)
  keto,
  @HiveField(4)
  paleo,
  @HiveField(5)
  lowCarb,
  @HiveField(6)
  glutenFree,
  @HiveField(7)
  dairyFree;

  String get displayName {
    switch (this) {
      case DietaryRestriction.vegan:
        return 'Vegano';
      case DietaryRestriction.vegetarian:
        return 'Vegetariano';
      case DietaryRestriction.pescatarian:
        return 'Pescatariano';
      case DietaryRestriction.keto:
        return 'Keto';
      case DietaryRestriction.paleo:
        return 'Paleo';
      case DietaryRestriction.lowCarb:
        return 'Bajo en carbohidratos';
      case DietaryRestriction.glutenFree:
        return 'Sin gluten';
      case DietaryRestriction.dairyFree:
        return 'Sin lácteos';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:qkomo_ui/theme/theme_type.dart';

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
    @HiveField(5) @Default(AppThemeType.forest) AppThemeType themeType,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);
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
  molluscs,
  @HiveField(14)
  wheat;

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
      case Allergen.wheat:
        return 'Trigo';
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

/// Extension for Allergen enum to provide theme-appropriate icons
extension AllergenIcon on Allergen {
  IconData get icon {
    switch (this) {
      case Allergen.gluten:
        return MdiIcons.grain;
      case Allergen.lactose:
        return MdiIcons.beerOutline;
      case Allergen.egg:
        return MdiIcons.egg;
      case Allergen.nuts:
        return MdiIcons.peanut;
      case Allergen.soy:
        return MdiIcons.leaf;
      case Allergen.fish:
        return MdiIcons.fish;
      case Allergen.shellfish:
        return MdiIcons.fish;
      case Allergen.peanuts:
        return MdiIcons.peanut;
      case Allergen.sesame:
        return MdiIcons.seed;
      case Allergen.sulfites:
        return MdiIcons.flaskOutline;
      case Allergen.celery:
        return MdiIcons.carrot;
      case Allergen.mustard:
        return MdiIcons.leaf;
      case Allergen.lupin:
        return MdiIcons.leaf;
      case Allergen.molluscs:
        return MdiIcons.close;
      case Allergen.wheat:
        return MdiIcons.barley;
    }
  }
}

/// Extension for DietaryRestriction enum to provide theme-appropriate icons
extension DietaryRestrictionIcon on DietaryRestriction {
  IconData get icon {
    switch (this) {
      case DietaryRestriction.vegan:
        return MdiIcons.leaf;
      case DietaryRestriction.vegetarian:
        return MdiIcons.sprout;
      case DietaryRestriction.pescatarian:
        return MdiIcons.fish;
      case DietaryRestriction.keto:
        return MdiIcons.egg;
      case DietaryRestriction.paleo:
        return MdiIcons.fire;
      case DietaryRestriction.lowCarb:
        return MdiIcons.grain;
      case DietaryRestriction.glutenFree:
        return MdiIcons.close;
      case DietaryRestriction.dairyFree:
        return MdiIcons.beerOutline;
    }
  }
}

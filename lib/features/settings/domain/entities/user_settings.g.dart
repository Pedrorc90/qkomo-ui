// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AllergenAdapter extends TypeAdapter<Allergen> {
  @override
  final int typeId = 21;

  @override
  Allergen read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Allergen.gluten;
      case 1:
        return Allergen.lactose;
      case 2:
        return Allergen.egg;
      case 3:
        return Allergen.nuts;
      case 4:
        return Allergen.soy;
      case 5:
        return Allergen.fish;
      case 6:
        return Allergen.shellfish;
      case 7:
        return Allergen.peanuts;
      case 8:
        return Allergen.sesame;
      case 9:
        return Allergen.sulfites;
      case 10:
        return Allergen.celery;
      case 11:
        return Allergen.mustard;
      case 12:
        return Allergen.lupin;
      case 13:
        return Allergen.molluscs;
      case 14:
        return Allergen.wheat;
      default:
        return Allergen.gluten;
    }
  }

  @override
  void write(BinaryWriter writer, Allergen obj) {
    switch (obj) {
      case Allergen.gluten:
        writer.writeByte(0);
        break;
      case Allergen.lactose:
        writer.writeByte(1);
        break;
      case Allergen.egg:
        writer.writeByte(2);
        break;
      case Allergen.nuts:
        writer.writeByte(3);
        break;
      case Allergen.soy:
        writer.writeByte(4);
        break;
      case Allergen.fish:
        writer.writeByte(5);
        break;
      case Allergen.shellfish:
        writer.writeByte(6);
        break;
      case Allergen.peanuts:
        writer.writeByte(7);
        break;
      case Allergen.sesame:
        writer.writeByte(8);
        break;
      case Allergen.sulfites:
        writer.writeByte(9);
        break;
      case Allergen.celery:
        writer.writeByte(10);
        break;
      case Allergen.mustard:
        writer.writeByte(11);
        break;
      case Allergen.lupin:
        writer.writeByte(12);
        break;
      case Allergen.molluscs:
        writer.writeByte(13);
        break;
      case Allergen.wheat:
        writer.writeByte(14);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AllergenAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DietaryRestrictionAdapter extends TypeAdapter<DietaryRestriction> {
  @override
  final int typeId = 22;

  @override
  DietaryRestriction read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DietaryRestriction.vegan;
      case 1:
        return DietaryRestriction.vegetarian;
      case 2:
        return DietaryRestriction.pescatarian;
      case 3:
        return DietaryRestriction.keto;
      case 4:
        return DietaryRestriction.paleo;
      case 5:
        return DietaryRestriction.lowCarb;
      case 6:
        return DietaryRestriction.glutenFree;
      case 7:
        return DietaryRestriction.dairyFree;
      default:
        return DietaryRestriction.vegan;
    }
  }

  @override
  void write(BinaryWriter writer, DietaryRestriction obj) {
    switch (obj) {
      case DietaryRestriction.vegan:
        writer.writeByte(0);
        break;
      case DietaryRestriction.vegetarian:
        writer.writeByte(1);
        break;
      case DietaryRestriction.pescatarian:
        writer.writeByte(2);
        break;
      case DietaryRestriction.keto:
        writer.writeByte(3);
        break;
      case DietaryRestriction.paleo:
        writer.writeByte(4);
        break;
      case DietaryRestriction.lowCarb:
        writer.writeByte(5);
        break;
      case DietaryRestriction.glutenFree:
        writer.writeByte(6);
        break;
      case DietaryRestriction.dairyFree:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DietaryRestrictionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserSettingsImplAdapter extends TypeAdapter<_$UserSettingsImpl> {
  @override
  final int typeId = 20;

  @override
  _$UserSettingsImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$UserSettingsImpl(
      allergens: (fields[0] as List).cast<Allergen>(),
      dietaryRestrictions: (fields[1] as List).cast<DietaryRestriction>(),
      languageCode: fields[2] as String,
      enableNotifications: fields[3] as bool,
      enableDailyReminders: fields[4] as bool,
      themeType: fields[5] as AppThemeType,
    );
  }

  @override
  void write(BinaryWriter writer, _$UserSettingsImpl obj) {
    writer
      ..writeByte(6)
      ..writeByte(2)
      ..write(obj.languageCode)
      ..writeByte(3)
      ..write(obj.enableNotifications)
      ..writeByte(4)
      ..write(obj.enableDailyReminders)
      ..writeByte(5)
      ..write(obj.themeType)
      ..writeByte(0)
      ..write(obj.allergens)
      ..writeByte(1)
      ..write(obj.dietaryRestrictions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSettingsImplAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserSettingsImpl _$$UserSettingsImplFromJson(Map<String, dynamic> json) =>
    _$UserSettingsImpl(
      allergens: (json['allergens'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$AllergenEnumMap, e))
              .toList() ??
          const [],
      dietaryRestrictions: (json['dietaryRestrictions'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$DietaryRestrictionEnumMap, e))
              .toList() ??
          const [],
      languageCode: json['languageCode'] as String? ?? 'es',
      enableNotifications: json['enableNotifications'] as bool? ?? true,
      enableDailyReminders: json['enableDailyReminders'] as bool? ?? true,
      themeType:
          $enumDecodeNullable(_$AppThemeTypeEnumMap, json['themeType']) ??
              AppThemeType.forest,
    );

Map<String, dynamic> _$$UserSettingsImplToJson(_$UserSettingsImpl instance) =>
    <String, dynamic>{
      'allergens':
          instance.allergens.map((e) => _$AllergenEnumMap[e]!).toList(),
      'dietaryRestrictions': instance.dietaryRestrictions
          .map((e) => _$DietaryRestrictionEnumMap[e]!)
          .toList(),
      'languageCode': instance.languageCode,
      'enableNotifications': instance.enableNotifications,
      'enableDailyReminders': instance.enableDailyReminders,
      'themeType': _$AppThemeTypeEnumMap[instance.themeType]!,
    };

const _$AllergenEnumMap = {
  Allergen.gluten: 'gluten',
  Allergen.lactose: 'lactose',
  Allergen.egg: 'egg',
  Allergen.nuts: 'nuts',
  Allergen.soy: 'soy',
  Allergen.fish: 'fish',
  Allergen.shellfish: 'shellfish',
  Allergen.peanuts: 'peanuts',
  Allergen.sesame: 'sesame',
  Allergen.sulfites: 'sulfites',
  Allergen.celery: 'celery',
  Allergen.mustard: 'mustard',
  Allergen.lupin: 'lupin',
  Allergen.molluscs: 'molluscs',
  Allergen.wheat: 'wheat',
};

const _$DietaryRestrictionEnumMap = {
  DietaryRestriction.vegan: 'vegan',
  DietaryRestriction.vegetarian: 'vegetarian',
  DietaryRestriction.pescatarian: 'pescatarian',
  DietaryRestriction.keto: 'keto',
  DietaryRestriction.paleo: 'paleo',
  DietaryRestriction.lowCarb: 'lowCarb',
  DietaryRestriction.glutenFree: 'glutenFree',
  DietaryRestriction.dairyFree: 'dairyFree',
};

const _$AppThemeTypeEnumMap = {
  AppThemeType.forest: 'forest',
  AppThemeType.dark: 'dark',
};

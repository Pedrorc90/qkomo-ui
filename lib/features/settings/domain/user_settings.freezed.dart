// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) {
  return _UserSettings.fromJson(json);
}

/// @nodoc
mixin _$UserSettings {
  @HiveField(0)
  List<Allergen> get allergens => throw _privateConstructorUsedError;
  @HiveField(1)
  List<DietaryRestriction> get dietaryRestrictions =>
      throw _privateConstructorUsedError;
  @HiveField(2)
  String get languageCode => throw _privateConstructorUsedError;
  @HiveField(3)
  bool get enableNotifications => throw _privateConstructorUsedError;
  @HiveField(4)
  bool get enableDailyReminders => throw _privateConstructorUsedError;
  @HiveField(5)
  AppThemeType get themeType => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserSettingsCopyWith<UserSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSettingsCopyWith<$Res> {
  factory $UserSettingsCopyWith(
          UserSettings value, $Res Function(UserSettings) then) =
      _$UserSettingsCopyWithImpl<$Res, UserSettings>;
  @useResult
  $Res call(
      {@HiveField(0) List<Allergen> allergens,
      @HiveField(1) List<DietaryRestriction> dietaryRestrictions,
      @HiveField(2) String languageCode,
      @HiveField(3) bool enableNotifications,
      @HiveField(4) bool enableDailyReminders,
      @HiveField(5) AppThemeType themeType});
}

/// @nodoc
class _$UserSettingsCopyWithImpl<$Res, $Val extends UserSettings>
    implements $UserSettingsCopyWith<$Res> {
  _$UserSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allergens = null,
    Object? dietaryRestrictions = null,
    Object? languageCode = null,
    Object? enableNotifications = null,
    Object? enableDailyReminders = null,
    Object? themeType = null,
  }) {
    return _then(_value.copyWith(
      allergens: null == allergens
          ? _value.allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<Allergen>,
      dietaryRestrictions: null == dietaryRestrictions
          ? _value.dietaryRestrictions
          : dietaryRestrictions // ignore: cast_nullable_to_non_nullable
              as List<DietaryRestriction>,
      languageCode: null == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
      enableNotifications: null == enableNotifications
          ? _value.enableNotifications
          : enableNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      enableDailyReminders: null == enableDailyReminders
          ? _value.enableDailyReminders
          : enableDailyReminders // ignore: cast_nullable_to_non_nullable
              as bool,
      themeType: null == themeType
          ? _value.themeType
          : themeType // ignore: cast_nullable_to_non_nullable
              as AppThemeType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserSettingsImplCopyWith<$Res>
    implements $UserSettingsCopyWith<$Res> {
  factory _$$UserSettingsImplCopyWith(
          _$UserSettingsImpl value, $Res Function(_$UserSettingsImpl) then) =
      __$$UserSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) List<Allergen> allergens,
      @HiveField(1) List<DietaryRestriction> dietaryRestrictions,
      @HiveField(2) String languageCode,
      @HiveField(3) bool enableNotifications,
      @HiveField(4) bool enableDailyReminders,
      @HiveField(5) AppThemeType themeType});
}

/// @nodoc
class __$$UserSettingsImplCopyWithImpl<$Res>
    extends _$UserSettingsCopyWithImpl<$Res, _$UserSettingsImpl>
    implements _$$UserSettingsImplCopyWith<$Res> {
  __$$UserSettingsImplCopyWithImpl(
      _$UserSettingsImpl _value, $Res Function(_$UserSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allergens = null,
    Object? dietaryRestrictions = null,
    Object? languageCode = null,
    Object? enableNotifications = null,
    Object? enableDailyReminders = null,
    Object? themeType = null,
  }) {
    return _then(_$UserSettingsImpl(
      allergens: null == allergens
          ? _value._allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<Allergen>,
      dietaryRestrictions: null == dietaryRestrictions
          ? _value._dietaryRestrictions
          : dietaryRestrictions // ignore: cast_nullable_to_non_nullable
              as List<DietaryRestriction>,
      languageCode: null == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
      enableNotifications: null == enableNotifications
          ? _value.enableNotifications
          : enableNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      enableDailyReminders: null == enableDailyReminders
          ? _value.enableDailyReminders
          : enableDailyReminders // ignore: cast_nullable_to_non_nullable
              as bool,
      themeType: null == themeType
          ? _value.themeType
          : themeType // ignore: cast_nullable_to_non_nullable
              as AppThemeType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 20)
class _$UserSettingsImpl implements _UserSettings {
  const _$UserSettingsImpl(
      {@HiveField(0) final List<Allergen> allergens = const [],
      @HiveField(1)
      final List<DietaryRestriction> dietaryRestrictions = const [],
      @HiveField(2) this.languageCode = 'es',
      @HiveField(3) this.enableNotifications = true,
      @HiveField(4) this.enableDailyReminders = true,
      @HiveField(5) this.themeType = AppThemeType.forest})
      : _allergens = allergens,
        _dietaryRestrictions = dietaryRestrictions;

  factory _$UserSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSettingsImplFromJson(json);

  final List<Allergen> _allergens;
  @override
  @JsonKey()
  @HiveField(0)
  List<Allergen> get allergens {
    if (_allergens is EqualUnmodifiableListView) return _allergens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allergens);
  }

  final List<DietaryRestriction> _dietaryRestrictions;
  @override
  @JsonKey()
  @HiveField(1)
  List<DietaryRestriction> get dietaryRestrictions {
    if (_dietaryRestrictions is EqualUnmodifiableListView)
      return _dietaryRestrictions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dietaryRestrictions);
  }

  @override
  @JsonKey()
  @HiveField(2)
  final String languageCode;
  @override
  @JsonKey()
  @HiveField(3)
  final bool enableNotifications;
  @override
  @JsonKey()
  @HiveField(4)
  final bool enableDailyReminders;
  @override
  @JsonKey()
  @HiveField(5)
  final AppThemeType themeType;

  @override
  String toString() {
    return 'UserSettings(allergens: $allergens, dietaryRestrictions: $dietaryRestrictions, languageCode: $languageCode, enableNotifications: $enableNotifications, enableDailyReminders: $enableDailyReminders, themeType: $themeType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSettingsImpl &&
            const DeepCollectionEquality()
                .equals(other._allergens, _allergens) &&
            const DeepCollectionEquality()
                .equals(other._dietaryRestrictions, _dietaryRestrictions) &&
            (identical(other.languageCode, languageCode) ||
                other.languageCode == languageCode) &&
            (identical(other.enableNotifications, enableNotifications) ||
                other.enableNotifications == enableNotifications) &&
            (identical(other.enableDailyReminders, enableDailyReminders) ||
                other.enableDailyReminders == enableDailyReminders) &&
            (identical(other.themeType, themeType) ||
                other.themeType == themeType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_allergens),
      const DeepCollectionEquality().hash(_dietaryRestrictions),
      languageCode,
      enableNotifications,
      enableDailyReminders,
      themeType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSettingsImplCopyWith<_$UserSettingsImpl> get copyWith =>
      __$$UserSettingsImplCopyWithImpl<_$UserSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSettingsImplToJson(
      this,
    );
  }
}

abstract class _UserSettings implements UserSettings {
  const factory _UserSettings(
      {@HiveField(0) final List<Allergen> allergens,
      @HiveField(1) final List<DietaryRestriction> dietaryRestrictions,
      @HiveField(2) final String languageCode,
      @HiveField(3) final bool enableNotifications,
      @HiveField(4) final bool enableDailyReminders,
      @HiveField(5) final AppThemeType themeType}) = _$UserSettingsImpl;

  factory _UserSettings.fromJson(Map<String, dynamic> json) =
      _$UserSettingsImpl.fromJson;

  @override
  @HiveField(0)
  List<Allergen> get allergens;
  @override
  @HiveField(1)
  List<DietaryRestriction> get dietaryRestrictions;
  @override
  @HiveField(2)
  String get languageCode;
  @override
  @HiveField(3)
  bool get enableNotifications;
  @override
  @HiveField(4)
  bool get enableDailyReminders;
  @override
  @HiveField(5)
  AppThemeType get themeType;
  @override
  @JsonKey(ignore: true)
  _$$UserSettingsImplCopyWith<_$UserSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

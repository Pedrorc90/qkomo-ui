// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'preferences_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PreferencesDto _$PreferencesDtoFromJson(Map<String, dynamic> json) {
  return _PreferencesDto.fromJson(json);
}

/// @nodoc
mixin _$PreferencesDto {
  /// Comma-separated allergen names (e.g., "gluten,lactose,nuts")
  String? get allergens => throw _privateConstructorUsedError;

  /// Comma-separated dietary restriction names (e.g., "vegan,keto,glutenFree")
  @JsonKey(name: 'dietary_preferences')
  String? get dietaryPreferences => throw _privateConstructorUsedError;

  /// Timestamp when preferences were created
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Timestamp when preferences were last updated
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PreferencesDtoCopyWith<PreferencesDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PreferencesDtoCopyWith<$Res> {
  factory $PreferencesDtoCopyWith(
          PreferencesDto value, $Res Function(PreferencesDto) then) =
      _$PreferencesDtoCopyWithImpl<$Res, PreferencesDto>;
  @useResult
  $Res call(
      {String? allergens,
      @JsonKey(name: 'dietary_preferences') String? dietaryPreferences,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$PreferencesDtoCopyWithImpl<$Res, $Val extends PreferencesDto>
    implements $PreferencesDtoCopyWith<$Res> {
  _$PreferencesDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allergens = freezed,
    Object? dietaryPreferences = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      allergens: freezed == allergens
          ? _value.allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as String?,
      dietaryPreferences: freezed == dietaryPreferences
          ? _value.dietaryPreferences
          : dietaryPreferences // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PreferencesDtoImplCopyWith<$Res>
    implements $PreferencesDtoCopyWith<$Res> {
  factory _$$PreferencesDtoImplCopyWith(_$PreferencesDtoImpl value,
          $Res Function(_$PreferencesDtoImpl) then) =
      __$$PreferencesDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? allergens,
      @JsonKey(name: 'dietary_preferences') String? dietaryPreferences,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$PreferencesDtoImplCopyWithImpl<$Res>
    extends _$PreferencesDtoCopyWithImpl<$Res, _$PreferencesDtoImpl>
    implements _$$PreferencesDtoImplCopyWith<$Res> {
  __$$PreferencesDtoImplCopyWithImpl(
      _$PreferencesDtoImpl _value, $Res Function(_$PreferencesDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allergens = freezed,
    Object? dietaryPreferences = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$PreferencesDtoImpl(
      allergens: freezed == allergens
          ? _value.allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as String?,
      dietaryPreferences: freezed == dietaryPreferences
          ? _value.dietaryPreferences
          : dietaryPreferences // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PreferencesDtoImpl implements _PreferencesDto {
  const _$PreferencesDtoImpl(
      {this.allergens,
      @JsonKey(name: 'dietary_preferences') this.dietaryPreferences,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$PreferencesDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PreferencesDtoImplFromJson(json);

  /// Comma-separated allergen names (e.g., "gluten,lactose,nuts")
  @override
  final String? allergens;

  /// Comma-separated dietary restriction names (e.g., "vegan,keto,glutenFree")
  @override
  @JsonKey(name: 'dietary_preferences')
  final String? dietaryPreferences;

  /// Timestamp when preferences were created
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  /// Timestamp when preferences were last updated
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'PreferencesDto(allergens: $allergens, dietaryPreferences: $dietaryPreferences, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PreferencesDtoImpl &&
            (identical(other.allergens, allergens) ||
                other.allergens == allergens) &&
            (identical(other.dietaryPreferences, dietaryPreferences) ||
                other.dietaryPreferences == dietaryPreferences) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, allergens, dietaryPreferences, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PreferencesDtoImplCopyWith<_$PreferencesDtoImpl> get copyWith =>
      __$$PreferencesDtoImplCopyWithImpl<_$PreferencesDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PreferencesDtoImplToJson(
      this,
    );
  }
}

abstract class _PreferencesDto implements PreferencesDto {
  const factory _PreferencesDto(
      {final String? allergens,
      @JsonKey(name: 'dietary_preferences') final String? dietaryPreferences,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      final DateTime? updatedAt}) = _$PreferencesDtoImpl;

  factory _PreferencesDto.fromJson(Map<String, dynamic> json) =
      _$PreferencesDtoImpl.fromJson;

  @override

  /// Comma-separated allergen names (e.g., "gluten,lactose,nuts")
  String? get allergens;
  @override

  /// Comma-separated dietary restriction names (e.g., "vegan,keto,glutenFree")
  @JsonKey(name: 'dietary_preferences')
  String? get dietaryPreferences;
  @override

  /// Timestamp when preferences were created
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override

  /// Timestamp when preferences were last updated
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$PreferencesDtoImplCopyWith<_$PreferencesDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

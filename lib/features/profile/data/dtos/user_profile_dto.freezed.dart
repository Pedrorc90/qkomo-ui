// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserProfileDto _$UserProfileDtoFromJson(Map<String, dynamic> json) {
  return _UserProfileDto.fromJson(json);
}

/// @nodoc
mixin _$UserProfileDto {
  String get firebaseUid => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  DateTime? get lastLoginAt =>
      throw _privateConstructorUsedError; // Ignored fields from backend (handled by UserSettings)
  List<String>? get allergens => throw _privateConstructorUsedError;
  @JsonKey(name: 'dietaryPreferences')
  List<String>? get dietaryPreferences => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserProfileDtoCopyWith<UserProfileDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileDtoCopyWith<$Res> {
  factory $UserProfileDtoCopyWith(
          UserProfileDto value, $Res Function(UserProfileDto) then) =
      _$UserProfileDtoCopyWithImpl<$Res, UserProfileDto>;
  @useResult
  $Res call(
      {String firebaseUid,
      String email,
      String? displayName,
      String? photoUrl,
      DateTime? lastLoginAt,
      List<String>? allergens,
      @JsonKey(name: 'dietaryPreferences') List<String>? dietaryPreferences,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$UserProfileDtoCopyWithImpl<$Res, $Val extends UserProfileDto>
    implements $UserProfileDtoCopyWith<$Res> {
  _$UserProfileDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firebaseUid = null,
    Object? email = null,
    Object? displayName = freezed,
    Object? photoUrl = freezed,
    Object? lastLoginAt = freezed,
    Object? allergens = freezed,
    Object? dietaryPreferences = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      firebaseUid: null == firebaseUid
          ? _value.firebaseUid
          : firebaseUid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      allergens: freezed == allergens
          ? _value.allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      dietaryPreferences: freezed == dietaryPreferences
          ? _value.dietaryPreferences
          : dietaryPreferences // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileDtoImplCopyWith<$Res>
    implements $UserProfileDtoCopyWith<$Res> {
  factory _$$UserProfileDtoImplCopyWith(_$UserProfileDtoImpl value,
          $Res Function(_$UserProfileDtoImpl) then) =
      __$$UserProfileDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String firebaseUid,
      String email,
      String? displayName,
      String? photoUrl,
      DateTime? lastLoginAt,
      List<String>? allergens,
      @JsonKey(name: 'dietaryPreferences') List<String>? dietaryPreferences,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$UserProfileDtoImplCopyWithImpl<$Res>
    extends _$UserProfileDtoCopyWithImpl<$Res, _$UserProfileDtoImpl>
    implements _$$UserProfileDtoImplCopyWith<$Res> {
  __$$UserProfileDtoImplCopyWithImpl(
      _$UserProfileDtoImpl _value, $Res Function(_$UserProfileDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firebaseUid = null,
    Object? email = null,
    Object? displayName = freezed,
    Object? photoUrl = freezed,
    Object? lastLoginAt = freezed,
    Object? allergens = freezed,
    Object? dietaryPreferences = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$UserProfileDtoImpl(
      firebaseUid: null == firebaseUid
          ? _value.firebaseUid
          : firebaseUid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      allergens: freezed == allergens
          ? _value._allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      dietaryPreferences: freezed == dietaryPreferences
          ? _value._dietaryPreferences
          : dietaryPreferences // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileDtoImpl implements _UserProfileDto {
  const _$UserProfileDtoImpl(
      {required this.firebaseUid,
      required this.email,
      this.displayName,
      this.photoUrl,
      this.lastLoginAt,
      final List<String>? allergens,
      @JsonKey(name: 'dietaryPreferences')
      final List<String>? dietaryPreferences,
      required this.createdAt,
      required this.updatedAt})
      : _allergens = allergens,
        _dietaryPreferences = dietaryPreferences;

  factory _$UserProfileDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileDtoImplFromJson(json);

  @override
  final String firebaseUid;
  @override
  final String email;
  @override
  final String? displayName;
  @override
  final String? photoUrl;
  @override
  final DateTime? lastLoginAt;
// Ignored fields from backend (handled by UserSettings)
  final List<String>? _allergens;
// Ignored fields from backend (handled by UserSettings)
  @override
  List<String>? get allergens {
    final value = _allergens;
    if (value == null) return null;
    if (_allergens is EqualUnmodifiableListView) return _allergens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _dietaryPreferences;
  @override
  @JsonKey(name: 'dietaryPreferences')
  List<String>? get dietaryPreferences {
    final value = _dietaryPreferences;
    if (value == null) return null;
    if (_dietaryPreferences is EqualUnmodifiableListView)
      return _dietaryPreferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'UserProfileDto(firebaseUid: $firebaseUid, email: $email, displayName: $displayName, photoUrl: $photoUrl, lastLoginAt: $lastLoginAt, allergens: $allergens, dietaryPreferences: $dietaryPreferences, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileDtoImpl &&
            (identical(other.firebaseUid, firebaseUid) ||
                other.firebaseUid == firebaseUid) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.lastLoginAt, lastLoginAt) ||
                other.lastLoginAt == lastLoginAt) &&
            const DeepCollectionEquality()
                .equals(other._allergens, _allergens) &&
            const DeepCollectionEquality()
                .equals(other._dietaryPreferences, _dietaryPreferences) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      firebaseUid,
      email,
      displayName,
      photoUrl,
      lastLoginAt,
      const DeepCollectionEquality().hash(_allergens),
      const DeepCollectionEquality().hash(_dietaryPreferences),
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileDtoImplCopyWith<_$UserProfileDtoImpl> get copyWith =>
      __$$UserProfileDtoImplCopyWithImpl<_$UserProfileDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileDtoImplToJson(
      this,
    );
  }
}

abstract class _UserProfileDto implements UserProfileDto {
  const factory _UserProfileDto(
      {required final String firebaseUid,
      required final String email,
      final String? displayName,
      final String? photoUrl,
      final DateTime? lastLoginAt,
      final List<String>? allergens,
      @JsonKey(name: 'dietaryPreferences')
      final List<String>? dietaryPreferences,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$UserProfileDtoImpl;

  factory _UserProfileDto.fromJson(Map<String, dynamic> json) =
      _$UserProfileDtoImpl.fromJson;

  @override
  String get firebaseUid;
  @override
  String get email;
  @override
  String? get displayName;
  @override
  String? get photoUrl;
  @override
  DateTime? get lastLoginAt;
  @override // Ignored fields from backend (handled by UserSettings)
  List<String>? get allergens;
  @override
  @JsonKey(name: 'dietaryPreferences')
  List<String>? get dietaryPreferences;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$UserProfileDtoImplCopyWith<_$UserProfileDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weekly_menu_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WeeklyMenuItem _$WeeklyMenuItemFromJson(Map<String, dynamic> json) {
  return _WeeklyMenuItem.fromJson(json);
}

/// @nodoc
mixin _$WeeklyMenuItem {
  @HiveField(0)
  WeeklyMealType get mealType => throw _privateConstructorUsedError;
  @HiveField(1)
  String get dishName => throw _privateConstructorUsedError;
  @HiveField(2)
  String? get description => throw _privateConstructorUsedError;
  @HiveField(3)
  List<String> get ingredients => throw _privateConstructorUsedError;
  @HiveField(4)
  String? get imageUrl => throw _privateConstructorUsedError;
  @HiveField(5)
  bool get constraintsOk => throw _privateConstructorUsedError;
  @HiveField(6)
  List<String> get violations => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WeeklyMenuItemCopyWith<WeeklyMenuItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeeklyMenuItemCopyWith<$Res> {
  factory $WeeklyMenuItemCopyWith(
          WeeklyMenuItem value, $Res Function(WeeklyMenuItem) then) =
      _$WeeklyMenuItemCopyWithImpl<$Res, WeeklyMenuItem>;
  @useResult
  $Res call(
      {@HiveField(0) WeeklyMealType mealType,
      @HiveField(1) String dishName,
      @HiveField(2) String? description,
      @HiveField(3) List<String> ingredients,
      @HiveField(4) String? imageUrl,
      @HiveField(5) bool constraintsOk,
      @HiveField(6) List<String> violations});
}

/// @nodoc
class _$WeeklyMenuItemCopyWithImpl<$Res, $Val extends WeeklyMenuItem>
    implements $WeeklyMenuItemCopyWith<$Res> {
  _$WeeklyMenuItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mealType = null,
    Object? dishName = null,
    Object? description = freezed,
    Object? ingredients = null,
    Object? imageUrl = freezed,
    Object? constraintsOk = null,
    Object? violations = null,
  }) {
    return _then(_value.copyWith(
      mealType: null == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as WeeklyMealType,
      dishName: null == dishName
          ? _value.dishName
          : dishName // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      ingredients: null == ingredients
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<String>,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      constraintsOk: null == constraintsOk
          ? _value.constraintsOk
          : constraintsOk // ignore: cast_nullable_to_non_nullable
              as bool,
      violations: null == violations
          ? _value.violations
          : violations // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeeklyMenuItemImplCopyWith<$Res>
    implements $WeeklyMenuItemCopyWith<$Res> {
  factory _$$WeeklyMenuItemImplCopyWith(_$WeeklyMenuItemImpl value,
          $Res Function(_$WeeklyMenuItemImpl) then) =
      __$$WeeklyMenuItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) WeeklyMealType mealType,
      @HiveField(1) String dishName,
      @HiveField(2) String? description,
      @HiveField(3) List<String> ingredients,
      @HiveField(4) String? imageUrl,
      @HiveField(5) bool constraintsOk,
      @HiveField(6) List<String> violations});
}

/// @nodoc
class __$$WeeklyMenuItemImplCopyWithImpl<$Res>
    extends _$WeeklyMenuItemCopyWithImpl<$Res, _$WeeklyMenuItemImpl>
    implements _$$WeeklyMenuItemImplCopyWith<$Res> {
  __$$WeeklyMenuItemImplCopyWithImpl(
      _$WeeklyMenuItemImpl _value, $Res Function(_$WeeklyMenuItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mealType = null,
    Object? dishName = null,
    Object? description = freezed,
    Object? ingredients = null,
    Object? imageUrl = freezed,
    Object? constraintsOk = null,
    Object? violations = null,
  }) {
    return _then(_$WeeklyMenuItemImpl(
      mealType: null == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as WeeklyMealType,
      dishName: null == dishName
          ? _value.dishName
          : dishName // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      ingredients: null == ingredients
          ? _value._ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<String>,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      constraintsOk: null == constraintsOk
          ? _value.constraintsOk
          : constraintsOk // ignore: cast_nullable_to_non_nullable
              as bool,
      violations: null == violations
          ? _value._violations
          : violations // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 13, adapterName: 'WeeklyMenuItemAdapter')
class _$WeeklyMenuItemImpl implements _WeeklyMenuItem {
  const _$WeeklyMenuItemImpl(
      {@HiveField(0) required this.mealType,
      @HiveField(1) required this.dishName,
      @HiveField(2) this.description,
      @HiveField(3) required final List<String> ingredients,
      @HiveField(4) this.imageUrl,
      @HiveField(5) required this.constraintsOk,
      @HiveField(6) required final List<String> violations})
      : _ingredients = ingredients,
        _violations = violations;

  factory _$WeeklyMenuItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeeklyMenuItemImplFromJson(json);

  @override
  @HiveField(0)
  final WeeklyMealType mealType;
  @override
  @HiveField(1)
  final String dishName;
  @override
  @HiveField(2)
  final String? description;
  final List<String> _ingredients;
  @override
  @HiveField(3)
  List<String> get ingredients {
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredients);
  }

  @override
  @HiveField(4)
  final String? imageUrl;
  @override
  @HiveField(5)
  final bool constraintsOk;
  final List<String> _violations;
  @override
  @HiveField(6)
  List<String> get violations {
    if (_violations is EqualUnmodifiableListView) return _violations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_violations);
  }

  @override
  String toString() {
    return 'WeeklyMenuItem(mealType: $mealType, dishName: $dishName, description: $description, ingredients: $ingredients, imageUrl: $imageUrl, constraintsOk: $constraintsOk, violations: $violations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeklyMenuItemImpl &&
            (identical(other.mealType, mealType) ||
                other.mealType == mealType) &&
            (identical(other.dishName, dishName) ||
                other.dishName == dishName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._ingredients, _ingredients) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.constraintsOk, constraintsOk) ||
                other.constraintsOk == constraintsOk) &&
            const DeepCollectionEquality()
                .equals(other._violations, _violations));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      mealType,
      dishName,
      description,
      const DeepCollectionEquality().hash(_ingredients),
      imageUrl,
      constraintsOk,
      const DeepCollectionEquality().hash(_violations));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeklyMenuItemImplCopyWith<_$WeeklyMenuItemImpl> get copyWith =>
      __$$WeeklyMenuItemImplCopyWithImpl<_$WeeklyMenuItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeeklyMenuItemImplToJson(
      this,
    );
  }
}

abstract class _WeeklyMenuItem implements WeeklyMenuItem {
  const factory _WeeklyMenuItem(
          {@HiveField(0) required final WeeklyMealType mealType,
          @HiveField(1) required final String dishName,
          @HiveField(2) final String? description,
          @HiveField(3) required final List<String> ingredients,
          @HiveField(4) final String? imageUrl,
          @HiveField(5) required final bool constraintsOk,
          @HiveField(6) required final List<String> violations}) =
      _$WeeklyMenuItemImpl;

  factory _WeeklyMenuItem.fromJson(Map<String, dynamic> json) =
      _$WeeklyMenuItemImpl.fromJson;

  @override
  @HiveField(0)
  WeeklyMealType get mealType;
  @override
  @HiveField(1)
  String get dishName;
  @override
  @HiveField(2)
  String? get description;
  @override
  @HiveField(3)
  List<String> get ingredients;
  @override
  @HiveField(4)
  String? get imageUrl;
  @override
  @HiveField(5)
  bool get constraintsOk;
  @override
  @HiveField(6)
  List<String> get violations;
  @override
  @JsonKey(ignore: true)
  _$$WeeklyMenuItemImplCopyWith<_$WeeklyMenuItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

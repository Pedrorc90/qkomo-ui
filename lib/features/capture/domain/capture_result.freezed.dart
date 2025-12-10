// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'capture_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CaptureResult _$CaptureResultFromJson(Map<String, dynamic> json) {
  return _CaptureResult.fromJson(json);
}

/// @nodoc
mixin _$CaptureResult {
  String get jobId => throw _privateConstructorUsedError;
  DateTime get savedAt => throw _privateConstructorUsedError;
  List<String> get ingredients => throw _privateConstructorUsedError;
  List<String> get allergens => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  MealType? get mealType => throw _privateConstructorUsedError;
  bool get isManualEntry => throw _privateConstructorUsedError;
  bool get isReviewed => throw _privateConstructorUsedError;
  DateTime? get reviewedAt => throw _privateConstructorUsedError;
  bool get userEdited => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CaptureResultCopyWith<CaptureResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CaptureResultCopyWith<$Res> {
  factory $CaptureResultCopyWith(
          CaptureResult value, $Res Function(CaptureResult) then) =
      _$CaptureResultCopyWithImpl<$Res, CaptureResult>;
  @useResult
  $Res call(
      {String jobId,
      DateTime savedAt,
      List<String> ingredients,
      List<String> allergens,
      String? notes,
      String? title,
      MealType? mealType,
      bool isManualEntry,
      bool isReviewed,
      DateTime? reviewedAt,
      bool userEdited});
}

/// @nodoc
class _$CaptureResultCopyWithImpl<$Res, $Val extends CaptureResult>
    implements $CaptureResultCopyWith<$Res> {
  _$CaptureResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jobId = null,
    Object? savedAt = null,
    Object? ingredients = null,
    Object? allergens = null,
    Object? notes = freezed,
    Object? title = freezed,
    Object? mealType = freezed,
    Object? isManualEntry = null,
    Object? isReviewed = null,
    Object? reviewedAt = freezed,
    Object? userEdited = null,
  }) {
    return _then(_value.copyWith(
      jobId: null == jobId
          ? _value.jobId
          : jobId // ignore: cast_nullable_to_non_nullable
              as String,
      savedAt: null == savedAt
          ? _value.savedAt
          : savedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ingredients: null == ingredients
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allergens: null == allergens
          ? _value.allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      mealType: freezed == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as MealType?,
      isManualEntry: null == isManualEntry
          ? _value.isManualEntry
          : isManualEntry // ignore: cast_nullable_to_non_nullable
              as bool,
      isReviewed: null == isReviewed
          ? _value.isReviewed
          : isReviewed // ignore: cast_nullable_to_non_nullable
              as bool,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      userEdited: null == userEdited
          ? _value.userEdited
          : userEdited // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CaptureResultImplCopyWith<$Res>
    implements $CaptureResultCopyWith<$Res> {
  factory _$$CaptureResultImplCopyWith(
          _$CaptureResultImpl value, $Res Function(_$CaptureResultImpl) then) =
      __$$CaptureResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String jobId,
      DateTime savedAt,
      List<String> ingredients,
      List<String> allergens,
      String? notes,
      String? title,
      MealType? mealType,
      bool isManualEntry,
      bool isReviewed,
      DateTime? reviewedAt,
      bool userEdited});
}

/// @nodoc
class __$$CaptureResultImplCopyWithImpl<$Res>
    extends _$CaptureResultCopyWithImpl<$Res, _$CaptureResultImpl>
    implements _$$CaptureResultImplCopyWith<$Res> {
  __$$CaptureResultImplCopyWithImpl(
      _$CaptureResultImpl _value, $Res Function(_$CaptureResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jobId = null,
    Object? savedAt = null,
    Object? ingredients = null,
    Object? allergens = null,
    Object? notes = freezed,
    Object? title = freezed,
    Object? mealType = freezed,
    Object? isManualEntry = null,
    Object? isReviewed = null,
    Object? reviewedAt = freezed,
    Object? userEdited = null,
  }) {
    return _then(_$CaptureResultImpl(
      jobId: null == jobId
          ? _value.jobId
          : jobId // ignore: cast_nullable_to_non_nullable
              as String,
      savedAt: null == savedAt
          ? _value.savedAt
          : savedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ingredients: null == ingredients
          ? _value._ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allergens: null == allergens
          ? _value._allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      mealType: freezed == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as MealType?,
      isManualEntry: null == isManualEntry
          ? _value.isManualEntry
          : isManualEntry // ignore: cast_nullable_to_non_nullable
              as bool,
      isReviewed: null == isReviewed
          ? _value.isReviewed
          : isReviewed // ignore: cast_nullable_to_non_nullable
              as bool,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      userEdited: null == userEdited
          ? _value.userEdited
          : userEdited // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CaptureResultImpl implements _CaptureResult {
  const _$CaptureResultImpl(
      {required this.jobId,
      required this.savedAt,
      final List<String> ingredients = const [],
      final List<String> allergens = const [],
      this.notes,
      this.title,
      this.mealType,
      this.isManualEntry = false,
      this.isReviewed = false,
      this.reviewedAt,
      this.userEdited = false})
      : _ingredients = ingredients,
        _allergens = allergens;

  factory _$CaptureResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$CaptureResultImplFromJson(json);

  @override
  final String jobId;
  @override
  final DateTime savedAt;
  final List<String> _ingredients;
  @override
  @JsonKey()
  List<String> get ingredients {
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredients);
  }

  final List<String> _allergens;
  @override
  @JsonKey()
  List<String> get allergens {
    if (_allergens is EqualUnmodifiableListView) return _allergens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allergens);
  }

  @override
  final String? notes;
  @override
  final String? title;
  @override
  final MealType? mealType;
  @override
  @JsonKey()
  final bool isManualEntry;
  @override
  @JsonKey()
  final bool isReviewed;
  @override
  final DateTime? reviewedAt;
  @override
  @JsonKey()
  final bool userEdited;

  @override
  String toString() {
    return 'CaptureResult(jobId: $jobId, savedAt: $savedAt, ingredients: $ingredients, allergens: $allergens, notes: $notes, title: $title, mealType: $mealType, isManualEntry: $isManualEntry, isReviewed: $isReviewed, reviewedAt: $reviewedAt, userEdited: $userEdited)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CaptureResultImpl &&
            (identical(other.jobId, jobId) || other.jobId == jobId) &&
            (identical(other.savedAt, savedAt) || other.savedAt == savedAt) &&
            const DeepCollectionEquality()
                .equals(other._ingredients, _ingredients) &&
            const DeepCollectionEquality()
                .equals(other._allergens, _allergens) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.mealType, mealType) ||
                other.mealType == mealType) &&
            (identical(other.isManualEntry, isManualEntry) ||
                other.isManualEntry == isManualEntry) &&
            (identical(other.isReviewed, isReviewed) ||
                other.isReviewed == isReviewed) &&
            (identical(other.reviewedAt, reviewedAt) ||
                other.reviewedAt == reviewedAt) &&
            (identical(other.userEdited, userEdited) ||
                other.userEdited == userEdited));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      jobId,
      savedAt,
      const DeepCollectionEquality().hash(_ingredients),
      const DeepCollectionEquality().hash(_allergens),
      notes,
      title,
      mealType,
      isManualEntry,
      isReviewed,
      reviewedAt,
      userEdited);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CaptureResultImplCopyWith<_$CaptureResultImpl> get copyWith =>
      __$$CaptureResultImplCopyWithImpl<_$CaptureResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CaptureResultImplToJson(
      this,
    );
  }
}

abstract class _CaptureResult implements CaptureResult {
  const factory _CaptureResult(
      {required final String jobId,
      required final DateTime savedAt,
      final List<String> ingredients,
      final List<String> allergens,
      final String? notes,
      final String? title,
      final MealType? mealType,
      final bool isManualEntry,
      final bool isReviewed,
      final DateTime? reviewedAt,
      final bool userEdited}) = _$CaptureResultImpl;

  factory _CaptureResult.fromJson(Map<String, dynamic> json) =
      _$CaptureResultImpl.fromJson;

  @override
  String get jobId;
  @override
  DateTime get savedAt;
  @override
  List<String> get ingredients;
  @override
  List<String> get allergens;
  @override
  String? get notes;
  @override
  String? get title;
  @override
  MealType? get mealType;
  @override
  bool get isManualEntry;
  @override
  bool get isReviewed;
  @override
  DateTime? get reviewedAt;
  @override
  bool get userEdited;
  @override
  @JsonKey(ignore: true)
  _$$CaptureResultImplCopyWith<_$CaptureResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

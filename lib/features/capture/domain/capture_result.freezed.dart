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
  bool get userEdited => throw _privateConstructorUsedError; // New fields
  int? get estimatedPortionG => throw _privateConstructorUsedError;
  CaptureNutrition? get nutrition => throw _privateConstructorUsedError;
  CaptureMedicalAlerts? get medicalAlerts => throw _privateConstructorUsedError;
  CaptureSuitableFor? get suitableFor => throw _privateConstructorUsedError;
  List<String> get improvementSuggestions => throw _privateConstructorUsedError;

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
      bool userEdited,
      int? estimatedPortionG,
      CaptureNutrition? nutrition,
      CaptureMedicalAlerts? medicalAlerts,
      CaptureSuitableFor? suitableFor,
      List<String> improvementSuggestions});

  $CaptureNutritionCopyWith<$Res>? get nutrition;
  $CaptureMedicalAlertsCopyWith<$Res>? get medicalAlerts;
  $CaptureSuitableForCopyWith<$Res>? get suitableFor;
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
    Object? estimatedPortionG = freezed,
    Object? nutrition = freezed,
    Object? medicalAlerts = freezed,
    Object? suitableFor = freezed,
    Object? improvementSuggestions = null,
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
      estimatedPortionG: freezed == estimatedPortionG
          ? _value.estimatedPortionG
          : estimatedPortionG // ignore: cast_nullable_to_non_nullable
              as int?,
      nutrition: freezed == nutrition
          ? _value.nutrition
          : nutrition // ignore: cast_nullable_to_non_nullable
              as CaptureNutrition?,
      medicalAlerts: freezed == medicalAlerts
          ? _value.medicalAlerts
          : medicalAlerts // ignore: cast_nullable_to_non_nullable
              as CaptureMedicalAlerts?,
      suitableFor: freezed == suitableFor
          ? _value.suitableFor
          : suitableFor // ignore: cast_nullable_to_non_nullable
              as CaptureSuitableFor?,
      improvementSuggestions: null == improvementSuggestions
          ? _value.improvementSuggestions
          : improvementSuggestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CaptureNutritionCopyWith<$Res>? get nutrition {
    if (_value.nutrition == null) {
      return null;
    }

    return $CaptureNutritionCopyWith<$Res>(_value.nutrition!, (value) {
      return _then(_value.copyWith(nutrition: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $CaptureMedicalAlertsCopyWith<$Res>? get medicalAlerts {
    if (_value.medicalAlerts == null) {
      return null;
    }

    return $CaptureMedicalAlertsCopyWith<$Res>(_value.medicalAlerts!, (value) {
      return _then(_value.copyWith(medicalAlerts: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $CaptureSuitableForCopyWith<$Res>? get suitableFor {
    if (_value.suitableFor == null) {
      return null;
    }

    return $CaptureSuitableForCopyWith<$Res>(_value.suitableFor!, (value) {
      return _then(_value.copyWith(suitableFor: value) as $Val);
    });
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
      bool userEdited,
      int? estimatedPortionG,
      CaptureNutrition? nutrition,
      CaptureMedicalAlerts? medicalAlerts,
      CaptureSuitableFor? suitableFor,
      List<String> improvementSuggestions});

  @override
  $CaptureNutritionCopyWith<$Res>? get nutrition;
  @override
  $CaptureMedicalAlertsCopyWith<$Res>? get medicalAlerts;
  @override
  $CaptureSuitableForCopyWith<$Res>? get suitableFor;
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
    Object? estimatedPortionG = freezed,
    Object? nutrition = freezed,
    Object? medicalAlerts = freezed,
    Object? suitableFor = freezed,
    Object? improvementSuggestions = null,
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
      estimatedPortionG: freezed == estimatedPortionG
          ? _value.estimatedPortionG
          : estimatedPortionG // ignore: cast_nullable_to_non_nullable
              as int?,
      nutrition: freezed == nutrition
          ? _value.nutrition
          : nutrition // ignore: cast_nullable_to_non_nullable
              as CaptureNutrition?,
      medicalAlerts: freezed == medicalAlerts
          ? _value.medicalAlerts
          : medicalAlerts // ignore: cast_nullable_to_non_nullable
              as CaptureMedicalAlerts?,
      suitableFor: freezed == suitableFor
          ? _value.suitableFor
          : suitableFor // ignore: cast_nullable_to_non_nullable
              as CaptureSuitableFor?,
      improvementSuggestions: null == improvementSuggestions
          ? _value._improvementSuggestions
          : improvementSuggestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
      this.userEdited = false,
      this.estimatedPortionG,
      this.nutrition,
      this.medicalAlerts,
      this.suitableFor,
      final List<String> improvementSuggestions = const []})
      : _ingredients = ingredients,
        _allergens = allergens,
        _improvementSuggestions = improvementSuggestions;

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
// New fields
  @override
  final int? estimatedPortionG;
  @override
  final CaptureNutrition? nutrition;
  @override
  final CaptureMedicalAlerts? medicalAlerts;
  @override
  final CaptureSuitableFor? suitableFor;
  final List<String> _improvementSuggestions;
  @override
  @JsonKey()
  List<String> get improvementSuggestions {
    if (_improvementSuggestions is EqualUnmodifiableListView)
      return _improvementSuggestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_improvementSuggestions);
  }

  @override
  String toString() {
    return 'CaptureResult(jobId: $jobId, savedAt: $savedAt, ingredients: $ingredients, allergens: $allergens, notes: $notes, title: $title, mealType: $mealType, isManualEntry: $isManualEntry, isReviewed: $isReviewed, reviewedAt: $reviewedAt, userEdited: $userEdited, estimatedPortionG: $estimatedPortionG, nutrition: $nutrition, medicalAlerts: $medicalAlerts, suitableFor: $suitableFor, improvementSuggestions: $improvementSuggestions)';
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
                other.userEdited == userEdited) &&
            (identical(other.estimatedPortionG, estimatedPortionG) ||
                other.estimatedPortionG == estimatedPortionG) &&
            (identical(other.nutrition, nutrition) ||
                other.nutrition == nutrition) &&
            (identical(other.medicalAlerts, medicalAlerts) ||
                other.medicalAlerts == medicalAlerts) &&
            (identical(other.suitableFor, suitableFor) ||
                other.suitableFor == suitableFor) &&
            const DeepCollectionEquality().equals(
                other._improvementSuggestions, _improvementSuggestions));
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
      userEdited,
      estimatedPortionG,
      nutrition,
      medicalAlerts,
      suitableFor,
      const DeepCollectionEquality().hash(_improvementSuggestions));

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
      final bool userEdited,
      final int? estimatedPortionG,
      final CaptureNutrition? nutrition,
      final CaptureMedicalAlerts? medicalAlerts,
      final CaptureSuitableFor? suitableFor,
      final List<String> improvementSuggestions}) = _$CaptureResultImpl;

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
  @override // New fields
  int? get estimatedPortionG;
  @override
  CaptureNutrition? get nutrition;
  @override
  CaptureMedicalAlerts? get medicalAlerts;
  @override
  CaptureSuitableFor? get suitableFor;
  @override
  List<String> get improvementSuggestions;
  @override
  @JsonKey(ignore: true)
  _$$CaptureResultImplCopyWith<_$CaptureResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CaptureNutrition _$CaptureNutritionFromJson(Map<String, dynamic> json) {
  return _CaptureNutrition.fromJson(json);
}

/// @nodoc
mixin _$CaptureNutrition {
  int? get calories => throw _privateConstructorUsedError;
  double? get proteinsG => throw _privateConstructorUsedError;
  double? get carbohydratesG => throw _privateConstructorUsedError;
  double? get fatsG => throw _privateConstructorUsedError;
  double? get fiberG => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CaptureNutritionCopyWith<CaptureNutrition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CaptureNutritionCopyWith<$Res> {
  factory $CaptureNutritionCopyWith(
          CaptureNutrition value, $Res Function(CaptureNutrition) then) =
      _$CaptureNutritionCopyWithImpl<$Res, CaptureNutrition>;
  @useResult
  $Res call(
      {int? calories,
      double? proteinsG,
      double? carbohydratesG,
      double? fatsG,
      double? fiberG});
}

/// @nodoc
class _$CaptureNutritionCopyWithImpl<$Res, $Val extends CaptureNutrition>
    implements $CaptureNutritionCopyWith<$Res> {
  _$CaptureNutritionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? calories = freezed,
    Object? proteinsG = freezed,
    Object? carbohydratesG = freezed,
    Object? fatsG = freezed,
    Object? fiberG = freezed,
  }) {
    return _then(_value.copyWith(
      calories: freezed == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as int?,
      proteinsG: freezed == proteinsG
          ? _value.proteinsG
          : proteinsG // ignore: cast_nullable_to_non_nullable
              as double?,
      carbohydratesG: freezed == carbohydratesG
          ? _value.carbohydratesG
          : carbohydratesG // ignore: cast_nullable_to_non_nullable
              as double?,
      fatsG: freezed == fatsG
          ? _value.fatsG
          : fatsG // ignore: cast_nullable_to_non_nullable
              as double?,
      fiberG: freezed == fiberG
          ? _value.fiberG
          : fiberG // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CaptureNutritionImplCopyWith<$Res>
    implements $CaptureNutritionCopyWith<$Res> {
  factory _$$CaptureNutritionImplCopyWith(_$CaptureNutritionImpl value,
          $Res Function(_$CaptureNutritionImpl) then) =
      __$$CaptureNutritionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? calories,
      double? proteinsG,
      double? carbohydratesG,
      double? fatsG,
      double? fiberG});
}

/// @nodoc
class __$$CaptureNutritionImplCopyWithImpl<$Res>
    extends _$CaptureNutritionCopyWithImpl<$Res, _$CaptureNutritionImpl>
    implements _$$CaptureNutritionImplCopyWith<$Res> {
  __$$CaptureNutritionImplCopyWithImpl(_$CaptureNutritionImpl _value,
      $Res Function(_$CaptureNutritionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? calories = freezed,
    Object? proteinsG = freezed,
    Object? carbohydratesG = freezed,
    Object? fatsG = freezed,
    Object? fiberG = freezed,
  }) {
    return _then(_$CaptureNutritionImpl(
      calories: freezed == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as int?,
      proteinsG: freezed == proteinsG
          ? _value.proteinsG
          : proteinsG // ignore: cast_nullable_to_non_nullable
              as double?,
      carbohydratesG: freezed == carbohydratesG
          ? _value.carbohydratesG
          : carbohydratesG // ignore: cast_nullable_to_non_nullable
              as double?,
      fatsG: freezed == fatsG
          ? _value.fatsG
          : fatsG // ignore: cast_nullable_to_non_nullable
              as double?,
      fiberG: freezed == fiberG
          ? _value.fiberG
          : fiberG // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CaptureNutritionImpl implements _CaptureNutrition {
  const _$CaptureNutritionImpl(
      {this.calories,
      this.proteinsG,
      this.carbohydratesG,
      this.fatsG,
      this.fiberG});

  factory _$CaptureNutritionImpl.fromJson(Map<String, dynamic> json) =>
      _$$CaptureNutritionImplFromJson(json);

  @override
  final int? calories;
  @override
  final double? proteinsG;
  @override
  final double? carbohydratesG;
  @override
  final double? fatsG;
  @override
  final double? fiberG;

  @override
  String toString() {
    return 'CaptureNutrition(calories: $calories, proteinsG: $proteinsG, carbohydratesG: $carbohydratesG, fatsG: $fatsG, fiberG: $fiberG)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CaptureNutritionImpl &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.proteinsG, proteinsG) ||
                other.proteinsG == proteinsG) &&
            (identical(other.carbohydratesG, carbohydratesG) ||
                other.carbohydratesG == carbohydratesG) &&
            (identical(other.fatsG, fatsG) || other.fatsG == fatsG) &&
            (identical(other.fiberG, fiberG) || other.fiberG == fiberG));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, calories, proteinsG, carbohydratesG, fatsG, fiberG);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CaptureNutritionImplCopyWith<_$CaptureNutritionImpl> get copyWith =>
      __$$CaptureNutritionImplCopyWithImpl<_$CaptureNutritionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CaptureNutritionImplToJson(
      this,
    );
  }
}

abstract class _CaptureNutrition implements CaptureNutrition {
  const factory _CaptureNutrition(
      {final int? calories,
      final double? proteinsG,
      final double? carbohydratesG,
      final double? fatsG,
      final double? fiberG}) = _$CaptureNutritionImpl;

  factory _CaptureNutrition.fromJson(Map<String, dynamic> json) =
      _$CaptureNutritionImpl.fromJson;

  @override
  int? get calories;
  @override
  double? get proteinsG;
  @override
  double? get carbohydratesG;
  @override
  double? get fatsG;
  @override
  double? get fiberG;
  @override
  @JsonKey(ignore: true)
  _$$CaptureNutritionImplCopyWith<_$CaptureNutritionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CaptureMedicalAlerts _$CaptureMedicalAlertsFromJson(Map<String, dynamic> json) {
  return _CaptureMedicalAlerts.fromJson(json);
}

/// @nodoc
mixin _$CaptureMedicalAlerts {
  String? get diabetes => throw _privateConstructorUsedError;
  String? get hypertension => throw _privateConstructorUsedError;
  String? get cholesterol => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CaptureMedicalAlertsCopyWith<CaptureMedicalAlerts> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CaptureMedicalAlertsCopyWith<$Res> {
  factory $CaptureMedicalAlertsCopyWith(CaptureMedicalAlerts value,
          $Res Function(CaptureMedicalAlerts) then) =
      _$CaptureMedicalAlertsCopyWithImpl<$Res, CaptureMedicalAlerts>;
  @useResult
  $Res call({String? diabetes, String? hypertension, String? cholesterol});
}

/// @nodoc
class _$CaptureMedicalAlertsCopyWithImpl<$Res,
        $Val extends CaptureMedicalAlerts>
    implements $CaptureMedicalAlertsCopyWith<$Res> {
  _$CaptureMedicalAlertsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? diabetes = freezed,
    Object? hypertension = freezed,
    Object? cholesterol = freezed,
  }) {
    return _then(_value.copyWith(
      diabetes: freezed == diabetes
          ? _value.diabetes
          : diabetes // ignore: cast_nullable_to_non_nullable
              as String?,
      hypertension: freezed == hypertension
          ? _value.hypertension
          : hypertension // ignore: cast_nullable_to_non_nullable
              as String?,
      cholesterol: freezed == cholesterol
          ? _value.cholesterol
          : cholesterol // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CaptureMedicalAlertsImplCopyWith<$Res>
    implements $CaptureMedicalAlertsCopyWith<$Res> {
  factory _$$CaptureMedicalAlertsImplCopyWith(_$CaptureMedicalAlertsImpl value,
          $Res Function(_$CaptureMedicalAlertsImpl) then) =
      __$$CaptureMedicalAlertsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? diabetes, String? hypertension, String? cholesterol});
}

/// @nodoc
class __$$CaptureMedicalAlertsImplCopyWithImpl<$Res>
    extends _$CaptureMedicalAlertsCopyWithImpl<$Res, _$CaptureMedicalAlertsImpl>
    implements _$$CaptureMedicalAlertsImplCopyWith<$Res> {
  __$$CaptureMedicalAlertsImplCopyWithImpl(_$CaptureMedicalAlertsImpl _value,
      $Res Function(_$CaptureMedicalAlertsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? diabetes = freezed,
    Object? hypertension = freezed,
    Object? cholesterol = freezed,
  }) {
    return _then(_$CaptureMedicalAlertsImpl(
      diabetes: freezed == diabetes
          ? _value.diabetes
          : diabetes // ignore: cast_nullable_to_non_nullable
              as String?,
      hypertension: freezed == hypertension
          ? _value.hypertension
          : hypertension // ignore: cast_nullable_to_non_nullable
              as String?,
      cholesterol: freezed == cholesterol
          ? _value.cholesterol
          : cholesterol // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CaptureMedicalAlertsImpl implements _CaptureMedicalAlerts {
  const _$CaptureMedicalAlertsImpl(
      {this.diabetes, this.hypertension, this.cholesterol});

  factory _$CaptureMedicalAlertsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CaptureMedicalAlertsImplFromJson(json);

  @override
  final String? diabetes;
  @override
  final String? hypertension;
  @override
  final String? cholesterol;

  @override
  String toString() {
    return 'CaptureMedicalAlerts(diabetes: $diabetes, hypertension: $hypertension, cholesterol: $cholesterol)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CaptureMedicalAlertsImpl &&
            (identical(other.diabetes, diabetes) ||
                other.diabetes == diabetes) &&
            (identical(other.hypertension, hypertension) ||
                other.hypertension == hypertension) &&
            (identical(other.cholesterol, cholesterol) ||
                other.cholesterol == cholesterol));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, diabetes, hypertension, cholesterol);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CaptureMedicalAlertsImplCopyWith<_$CaptureMedicalAlertsImpl>
      get copyWith =>
          __$$CaptureMedicalAlertsImplCopyWithImpl<_$CaptureMedicalAlertsImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CaptureMedicalAlertsImplToJson(
      this,
    );
  }
}

abstract class _CaptureMedicalAlerts implements CaptureMedicalAlerts {
  const factory _CaptureMedicalAlerts(
      {final String? diabetes,
      final String? hypertension,
      final String? cholesterol}) = _$CaptureMedicalAlertsImpl;

  factory _CaptureMedicalAlerts.fromJson(Map<String, dynamic> json) =
      _$CaptureMedicalAlertsImpl.fromJson;

  @override
  String? get diabetes;
  @override
  String? get hypertension;
  @override
  String? get cholesterol;
  @override
  @JsonKey(ignore: true)
  _$$CaptureMedicalAlertsImplCopyWith<_$CaptureMedicalAlertsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CaptureSuitableFor _$CaptureSuitableForFromJson(Map<String, dynamic> json) {
  return _CaptureSuitableFor.fromJson(json);
}

/// @nodoc
mixin _$CaptureSuitableFor {
  bool get children => throw _privateConstructorUsedError;
  bool get lowFodmap => throw _privateConstructorUsedError;
  bool get glutenFree => throw _privateConstructorUsedError;
  bool get vegetarian => throw _privateConstructorUsedError;
  bool get vegan => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CaptureSuitableForCopyWith<CaptureSuitableFor> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CaptureSuitableForCopyWith<$Res> {
  factory $CaptureSuitableForCopyWith(
          CaptureSuitableFor value, $Res Function(CaptureSuitableFor) then) =
      _$CaptureSuitableForCopyWithImpl<$Res, CaptureSuitableFor>;
  @useResult
  $Res call(
      {bool children,
      bool lowFodmap,
      bool glutenFree,
      bool vegetarian,
      bool vegan});
}

/// @nodoc
class _$CaptureSuitableForCopyWithImpl<$Res, $Val extends CaptureSuitableFor>
    implements $CaptureSuitableForCopyWith<$Res> {
  _$CaptureSuitableForCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? children = null,
    Object? lowFodmap = null,
    Object? glutenFree = null,
    Object? vegetarian = null,
    Object? vegan = null,
  }) {
    return _then(_value.copyWith(
      children: null == children
          ? _value.children
          : children // ignore: cast_nullable_to_non_nullable
              as bool,
      lowFodmap: null == lowFodmap
          ? _value.lowFodmap
          : lowFodmap // ignore: cast_nullable_to_non_nullable
              as bool,
      glutenFree: null == glutenFree
          ? _value.glutenFree
          : glutenFree // ignore: cast_nullable_to_non_nullable
              as bool,
      vegetarian: null == vegetarian
          ? _value.vegetarian
          : vegetarian // ignore: cast_nullable_to_non_nullable
              as bool,
      vegan: null == vegan
          ? _value.vegan
          : vegan // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CaptureSuitableForImplCopyWith<$Res>
    implements $CaptureSuitableForCopyWith<$Res> {
  factory _$$CaptureSuitableForImplCopyWith(_$CaptureSuitableForImpl value,
          $Res Function(_$CaptureSuitableForImpl) then) =
      __$$CaptureSuitableForImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool children,
      bool lowFodmap,
      bool glutenFree,
      bool vegetarian,
      bool vegan});
}

/// @nodoc
class __$$CaptureSuitableForImplCopyWithImpl<$Res>
    extends _$CaptureSuitableForCopyWithImpl<$Res, _$CaptureSuitableForImpl>
    implements _$$CaptureSuitableForImplCopyWith<$Res> {
  __$$CaptureSuitableForImplCopyWithImpl(_$CaptureSuitableForImpl _value,
      $Res Function(_$CaptureSuitableForImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? children = null,
    Object? lowFodmap = null,
    Object? glutenFree = null,
    Object? vegetarian = null,
    Object? vegan = null,
  }) {
    return _then(_$CaptureSuitableForImpl(
      children: null == children
          ? _value.children
          : children // ignore: cast_nullable_to_non_nullable
              as bool,
      lowFodmap: null == lowFodmap
          ? _value.lowFodmap
          : lowFodmap // ignore: cast_nullable_to_non_nullable
              as bool,
      glutenFree: null == glutenFree
          ? _value.glutenFree
          : glutenFree // ignore: cast_nullable_to_non_nullable
              as bool,
      vegetarian: null == vegetarian
          ? _value.vegetarian
          : vegetarian // ignore: cast_nullable_to_non_nullable
              as bool,
      vegan: null == vegan
          ? _value.vegan
          : vegan // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CaptureSuitableForImpl implements _CaptureSuitableFor {
  const _$CaptureSuitableForImpl(
      {this.children = false,
      this.lowFodmap = false,
      this.glutenFree = false,
      this.vegetarian = false,
      this.vegan = false});

  factory _$CaptureSuitableForImpl.fromJson(Map<String, dynamic> json) =>
      _$$CaptureSuitableForImplFromJson(json);

  @override
  @JsonKey()
  final bool children;
  @override
  @JsonKey()
  final bool lowFodmap;
  @override
  @JsonKey()
  final bool glutenFree;
  @override
  @JsonKey()
  final bool vegetarian;
  @override
  @JsonKey()
  final bool vegan;

  @override
  String toString() {
    return 'CaptureSuitableFor(children: $children, lowFodmap: $lowFodmap, glutenFree: $glutenFree, vegetarian: $vegetarian, vegan: $vegan)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CaptureSuitableForImpl &&
            (identical(other.children, children) ||
                other.children == children) &&
            (identical(other.lowFodmap, lowFodmap) ||
                other.lowFodmap == lowFodmap) &&
            (identical(other.glutenFree, glutenFree) ||
                other.glutenFree == glutenFree) &&
            (identical(other.vegetarian, vegetarian) ||
                other.vegetarian == vegetarian) &&
            (identical(other.vegan, vegan) || other.vegan == vegan));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, children, lowFodmap, glutenFree, vegetarian, vegan);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CaptureSuitableForImplCopyWith<_$CaptureSuitableForImpl> get copyWith =>
      __$$CaptureSuitableForImplCopyWithImpl<_$CaptureSuitableForImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CaptureSuitableForImplToJson(
      this,
    );
  }
}

abstract class _CaptureSuitableFor implements CaptureSuitableFor {
  const factory _CaptureSuitableFor(
      {final bool children,
      final bool lowFodmap,
      final bool glutenFree,
      final bool vegetarian,
      final bool vegan}) = _$CaptureSuitableForImpl;

  factory _CaptureSuitableFor.fromJson(Map<String, dynamic> json) =
      _$CaptureSuitableForImpl.fromJson;

  @override
  bool get children;
  @override
  bool get lowFodmap;
  @override
  bool get glutenFree;
  @override
  bool get vegetarian;
  @override
  bool get vegan;
  @override
  @JsonKey(ignore: true)
  _$$CaptureSuitableForImplCopyWith<_$CaptureSuitableForImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'statistics_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$StatisticsData {
  int get totalEntries => throw _privateConstructorUsedError;
  int get currentStreak => throw _privateConstructorUsedError;
  Map<String, int> get entriesPerDay =>
      throw _privateConstructorUsedError; // Date string (yyyy-MM-dd) -> count
  Map<String, int> get topIngredients =>
      throw _privateConstructorUsedError; // Ingredient name -> count
  Map<String, int> get allergenCounts => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $StatisticsDataCopyWith<StatisticsData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatisticsDataCopyWith<$Res> {
  factory $StatisticsDataCopyWith(
          StatisticsData value, $Res Function(StatisticsData) then) =
      _$StatisticsDataCopyWithImpl<$Res, StatisticsData>;
  @useResult
  $Res call(
      {int totalEntries,
      int currentStreak,
      Map<String, int> entriesPerDay,
      Map<String, int> topIngredients,
      Map<String, int> allergenCounts});
}

/// @nodoc
class _$StatisticsDataCopyWithImpl<$Res, $Val extends StatisticsData>
    implements $StatisticsDataCopyWith<$Res> {
  _$StatisticsDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalEntries = null,
    Object? currentStreak = null,
    Object? entriesPerDay = null,
    Object? topIngredients = null,
    Object? allergenCounts = null,
  }) {
    return _then(_value.copyWith(
      totalEntries: null == totalEntries
          ? _value.totalEntries
          : totalEntries // ignore: cast_nullable_to_non_nullable
              as int,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      entriesPerDay: null == entriesPerDay
          ? _value.entriesPerDay
          : entriesPerDay // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      topIngredients: null == topIngredients
          ? _value.topIngredients
          : topIngredients // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      allergenCounts: null == allergenCounts
          ? _value.allergenCounts
          : allergenCounts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StatisticsDataImplCopyWith<$Res>
    implements $StatisticsDataCopyWith<$Res> {
  factory _$$StatisticsDataImplCopyWith(_$StatisticsDataImpl value,
          $Res Function(_$StatisticsDataImpl) then) =
      __$$StatisticsDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalEntries,
      int currentStreak,
      Map<String, int> entriesPerDay,
      Map<String, int> topIngredients,
      Map<String, int> allergenCounts});
}

/// @nodoc
class __$$StatisticsDataImplCopyWithImpl<$Res>
    extends _$StatisticsDataCopyWithImpl<$Res, _$StatisticsDataImpl>
    implements _$$StatisticsDataImplCopyWith<$Res> {
  __$$StatisticsDataImplCopyWithImpl(
      _$StatisticsDataImpl _value, $Res Function(_$StatisticsDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalEntries = null,
    Object? currentStreak = null,
    Object? entriesPerDay = null,
    Object? topIngredients = null,
    Object? allergenCounts = null,
  }) {
    return _then(_$StatisticsDataImpl(
      totalEntries: null == totalEntries
          ? _value.totalEntries
          : totalEntries // ignore: cast_nullable_to_non_nullable
              as int,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      entriesPerDay: null == entriesPerDay
          ? _value._entriesPerDay
          : entriesPerDay // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      topIngredients: null == topIngredients
          ? _value._topIngredients
          : topIngredients // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      allergenCounts: null == allergenCounts
          ? _value._allergenCounts
          : allergenCounts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ));
  }
}

/// @nodoc

class _$StatisticsDataImpl implements _StatisticsData {
  const _$StatisticsDataImpl(
      {required this.totalEntries,
      required this.currentStreak,
      required final Map<String, int> entriesPerDay,
      required final Map<String, int> topIngredients,
      required final Map<String, int> allergenCounts})
      : _entriesPerDay = entriesPerDay,
        _topIngredients = topIngredients,
        _allergenCounts = allergenCounts;

  @override
  final int totalEntries;
  @override
  final int currentStreak;
  final Map<String, int> _entriesPerDay;
  @override
  Map<String, int> get entriesPerDay {
    if (_entriesPerDay is EqualUnmodifiableMapView) return _entriesPerDay;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_entriesPerDay);
  }

// Date string (yyyy-MM-dd) -> count
  final Map<String, int> _topIngredients;
// Date string (yyyy-MM-dd) -> count
  @override
  Map<String, int> get topIngredients {
    if (_topIngredients is EqualUnmodifiableMapView) return _topIngredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_topIngredients);
  }

// Ingredient name -> count
  final Map<String, int> _allergenCounts;
// Ingredient name -> count
  @override
  Map<String, int> get allergenCounts {
    if (_allergenCounts is EqualUnmodifiableMapView) return _allergenCounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_allergenCounts);
  }

  @override
  String toString() {
    return 'StatisticsData(totalEntries: $totalEntries, currentStreak: $currentStreak, entriesPerDay: $entriesPerDay, topIngredients: $topIngredients, allergenCounts: $allergenCounts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatisticsDataImpl &&
            (identical(other.totalEntries, totalEntries) ||
                other.totalEntries == totalEntries) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            const DeepCollectionEquality()
                .equals(other._entriesPerDay, _entriesPerDay) &&
            const DeepCollectionEquality()
                .equals(other._topIngredients, _topIngredients) &&
            const DeepCollectionEquality()
                .equals(other._allergenCounts, _allergenCounts));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalEntries,
      currentStreak,
      const DeepCollectionEquality().hash(_entriesPerDay),
      const DeepCollectionEquality().hash(_topIngredients),
      const DeepCollectionEquality().hash(_allergenCounts));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StatisticsDataImplCopyWith<_$StatisticsDataImpl> get copyWith =>
      __$$StatisticsDataImplCopyWithImpl<_$StatisticsDataImpl>(
          this, _$identity);
}

abstract class _StatisticsData implements StatisticsData {
  const factory _StatisticsData(
      {required final int totalEntries,
      required final int currentStreak,
      required final Map<String, int> entriesPerDay,
      required final Map<String, int> topIngredients,
      required final Map<String, int> allergenCounts}) = _$StatisticsDataImpl;

  @override
  int get totalEntries;
  @override
  int get currentStreak;
  @override
  Map<String, int> get entriesPerDay;
  @override // Date string (yyyy-MM-dd) -> count
  Map<String, int> get topIngredients;
  @override // Ingredient name -> count
  Map<String, int> get allergenCounts;
  @override
  @JsonKey(ignore: true)
  _$$StatisticsDataImplCopyWith<_$StatisticsDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

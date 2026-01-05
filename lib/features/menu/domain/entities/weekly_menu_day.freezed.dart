// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weekly_menu_day.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WeeklyMenuDay _$WeeklyMenuDayFromJson(Map<String, dynamic> json) {
  return _WeeklyMenuDay.fromJson(json);
}

/// @nodoc
mixin _$WeeklyMenuDay {
  @HiveField(0)
  DateTime get date => throw _privateConstructorUsedError;
  @HiveField(1)
  List<WeeklyMenuItem> get items => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WeeklyMenuDayCopyWith<WeeklyMenuDay> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeeklyMenuDayCopyWith<$Res> {
  factory $WeeklyMenuDayCopyWith(
          WeeklyMenuDay value, $Res Function(WeeklyMenuDay) then) =
      _$WeeklyMenuDayCopyWithImpl<$Res, WeeklyMenuDay>;
  @useResult
  $Res call(
      {@HiveField(0) DateTime date, @HiveField(1) List<WeeklyMenuItem> items});
}

/// @nodoc
class _$WeeklyMenuDayCopyWithImpl<$Res, $Val extends WeeklyMenuDay>
    implements $WeeklyMenuDayCopyWith<$Res> {
  _$WeeklyMenuDayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<WeeklyMenuItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeeklyMenuDayImplCopyWith<$Res>
    implements $WeeklyMenuDayCopyWith<$Res> {
  factory _$$WeeklyMenuDayImplCopyWith(
          _$WeeklyMenuDayImpl value, $Res Function(_$WeeklyMenuDayImpl) then) =
      __$$WeeklyMenuDayImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) DateTime date, @HiveField(1) List<WeeklyMenuItem> items});
}

/// @nodoc
class __$$WeeklyMenuDayImplCopyWithImpl<$Res>
    extends _$WeeklyMenuDayCopyWithImpl<$Res, _$WeeklyMenuDayImpl>
    implements _$$WeeklyMenuDayImplCopyWith<$Res> {
  __$$WeeklyMenuDayImplCopyWithImpl(
      _$WeeklyMenuDayImpl _value, $Res Function(_$WeeklyMenuDayImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? items = null,
  }) {
    return _then(_$WeeklyMenuDayImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<WeeklyMenuItem>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 14, adapterName: 'WeeklyMenuDayAdapter')
class _$WeeklyMenuDayImpl implements _WeeklyMenuDay {
  const _$WeeklyMenuDayImpl(
      {@HiveField(0) required this.date,
      @HiveField(1) required final List<WeeklyMenuItem> items})
      : _items = items;

  factory _$WeeklyMenuDayImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeeklyMenuDayImplFromJson(json);

  @override
  @HiveField(0)
  final DateTime date;
  final List<WeeklyMenuItem> _items;
  @override
  @HiveField(1)
  List<WeeklyMenuItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'WeeklyMenuDay(date: $date, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeklyMenuDayImpl &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, date, const DeepCollectionEquality().hash(_items));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeklyMenuDayImplCopyWith<_$WeeklyMenuDayImpl> get copyWith =>
      __$$WeeklyMenuDayImplCopyWithImpl<_$WeeklyMenuDayImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeeklyMenuDayImplToJson(
      this,
    );
  }
}

abstract class _WeeklyMenuDay implements WeeklyMenuDay {
  const factory _WeeklyMenuDay(
          {@HiveField(0) required final DateTime date,
          @HiveField(1) required final List<WeeklyMenuItem> items}) =
      _$WeeklyMenuDayImpl;

  factory _WeeklyMenuDay.fromJson(Map<String, dynamic> json) =
      _$WeeklyMenuDayImpl.fromJson;

  @override
  @HiveField(0)
  DateTime get date;
  @override
  @HiveField(1)
  List<WeeklyMenuItem> get items;
  @override
  @JsonKey(ignore: true)
  _$$WeeklyMenuDayImplCopyWith<_$WeeklyMenuDayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

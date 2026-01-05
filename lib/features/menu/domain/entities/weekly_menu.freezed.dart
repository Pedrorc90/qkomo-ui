// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weekly_menu.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WeeklyMenu _$WeeklyMenuFromJson(Map<String, dynamic> json) {
  return _WeeklyMenu.fromJson(json);
}

/// @nodoc
mixin _$WeeklyMenu {
  @HiveField(0)
  DateTime get weekStart => throw _privateConstructorUsedError;
  @HiveField(1)
  WeeklyMenuStatus get status => throw _privateConstructorUsedError;
  @HiveField(2)
  List<WeeklyMenuDay> get days => throw _privateConstructorUsedError;
  @HiveField(3)
  String get userId => throw _privateConstructorUsedError; // Sync fields
  @HiveField(4)
  SyncStatus get syncStatus => throw _privateConstructorUsedError;
  @HiveField(5)
  DateTime get lastModifiedAt => throw _privateConstructorUsedError;
  @HiveField(6)
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;
  @HiveField(7)
  bool get isDeleted => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WeeklyMenuCopyWith<WeeklyMenu> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeeklyMenuCopyWith<$Res> {
  factory $WeeklyMenuCopyWith(
          WeeklyMenu value, $Res Function(WeeklyMenu) then) =
      _$WeeklyMenuCopyWithImpl<$Res, WeeklyMenu>;
  @useResult
  $Res call(
      {@HiveField(0) DateTime weekStart,
      @HiveField(1) WeeklyMenuStatus status,
      @HiveField(2) List<WeeklyMenuDay> days,
      @HiveField(3) String userId,
      @HiveField(4) SyncStatus syncStatus,
      @HiveField(5) DateTime lastModifiedAt,
      @HiveField(6) DateTime? lastSyncedAt,
      @HiveField(7) bool isDeleted});
}

/// @nodoc
class _$WeeklyMenuCopyWithImpl<$Res, $Val extends WeeklyMenu>
    implements $WeeklyMenuCopyWith<$Res> {
  _$WeeklyMenuCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weekStart = null,
    Object? status = null,
    Object? days = null,
    Object? userId = null,
    Object? syncStatus = null,
    Object? lastModifiedAt = null,
    Object? lastSyncedAt = freezed,
    Object? isDeleted = null,
  }) {
    return _then(_value.copyWith(
      weekStart: null == weekStart
          ? _value.weekStart
          : weekStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as WeeklyMenuStatus,
      days: null == days
          ? _value.days
          : days // ignore: cast_nullable_to_non_nullable
              as List<WeeklyMenuDay>,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      syncStatus: null == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
      lastModifiedAt: null == lastModifiedAt
          ? _value.lastModifiedAt
          : lastModifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeeklyMenuImplCopyWith<$Res>
    implements $WeeklyMenuCopyWith<$Res> {
  factory _$$WeeklyMenuImplCopyWith(
          _$WeeklyMenuImpl value, $Res Function(_$WeeklyMenuImpl) then) =
      __$$WeeklyMenuImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) DateTime weekStart,
      @HiveField(1) WeeklyMenuStatus status,
      @HiveField(2) List<WeeklyMenuDay> days,
      @HiveField(3) String userId,
      @HiveField(4) SyncStatus syncStatus,
      @HiveField(5) DateTime lastModifiedAt,
      @HiveField(6) DateTime? lastSyncedAt,
      @HiveField(7) bool isDeleted});
}

/// @nodoc
class __$$WeeklyMenuImplCopyWithImpl<$Res>
    extends _$WeeklyMenuCopyWithImpl<$Res, _$WeeklyMenuImpl>
    implements _$$WeeklyMenuImplCopyWith<$Res> {
  __$$WeeklyMenuImplCopyWithImpl(
      _$WeeklyMenuImpl _value, $Res Function(_$WeeklyMenuImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weekStart = null,
    Object? status = null,
    Object? days = null,
    Object? userId = null,
    Object? syncStatus = null,
    Object? lastModifiedAt = null,
    Object? lastSyncedAt = freezed,
    Object? isDeleted = null,
  }) {
    return _then(_$WeeklyMenuImpl(
      weekStart: null == weekStart
          ? _value.weekStart
          : weekStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as WeeklyMenuStatus,
      days: null == days
          ? _value._days
          : days // ignore: cast_nullable_to_non_nullable
              as List<WeeklyMenuDay>,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      syncStatus: null == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
      lastModifiedAt: null == lastModifiedAt
          ? _value.lastModifiedAt
          : lastModifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 15, adapterName: 'WeeklyMenuAdapter')
class _$WeeklyMenuImpl implements _WeeklyMenu {
  const _$WeeklyMenuImpl(
      {@HiveField(0) required this.weekStart,
      @HiveField(1) required this.status,
      @HiveField(2) required final List<WeeklyMenuDay> days,
      @HiveField(3) required this.userId,
      @HiveField(4) this.syncStatus = SyncStatus.pending,
      @HiveField(5) required this.lastModifiedAt,
      @HiveField(6) this.lastSyncedAt,
      @HiveField(7) this.isDeleted = false})
      : _days = days;

  factory _$WeeklyMenuImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeeklyMenuImplFromJson(json);

  @override
  @HiveField(0)
  final DateTime weekStart;
  @override
  @HiveField(1)
  final WeeklyMenuStatus status;
  final List<WeeklyMenuDay> _days;
  @override
  @HiveField(2)
  List<WeeklyMenuDay> get days {
    if (_days is EqualUnmodifiableListView) return _days;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_days);
  }

  @override
  @HiveField(3)
  final String userId;
// Sync fields
  @override
  @JsonKey()
  @HiveField(4)
  final SyncStatus syncStatus;
  @override
  @HiveField(5)
  final DateTime lastModifiedAt;
  @override
  @HiveField(6)
  final DateTime? lastSyncedAt;
  @override
  @JsonKey()
  @HiveField(7)
  final bool isDeleted;

  @override
  String toString() {
    return 'WeeklyMenu(weekStart: $weekStart, status: $status, days: $days, userId: $userId, syncStatus: $syncStatus, lastModifiedAt: $lastModifiedAt, lastSyncedAt: $lastSyncedAt, isDeleted: $isDeleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeklyMenuImpl &&
            (identical(other.weekStart, weekStart) ||
                other.weekStart == weekStart) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._days, _days) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.lastModifiedAt, lastModifiedAt) ||
                other.lastModifiedAt == lastModifiedAt) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      weekStart,
      status,
      const DeepCollectionEquality().hash(_days),
      userId,
      syncStatus,
      lastModifiedAt,
      lastSyncedAt,
      isDeleted);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeklyMenuImplCopyWith<_$WeeklyMenuImpl> get copyWith =>
      __$$WeeklyMenuImplCopyWithImpl<_$WeeklyMenuImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeeklyMenuImplToJson(
      this,
    );
  }
}

abstract class _WeeklyMenu implements WeeklyMenu {
  const factory _WeeklyMenu(
      {@HiveField(0) required final DateTime weekStart,
      @HiveField(1) required final WeeklyMenuStatus status,
      @HiveField(2) required final List<WeeklyMenuDay> days,
      @HiveField(3) required final String userId,
      @HiveField(4) final SyncStatus syncStatus,
      @HiveField(5) required final DateTime lastModifiedAt,
      @HiveField(6) final DateTime? lastSyncedAt,
      @HiveField(7) final bool isDeleted}) = _$WeeklyMenuImpl;

  factory _WeeklyMenu.fromJson(Map<String, dynamic> json) =
      _$WeeklyMenuImpl.fromJson;

  @override
  @HiveField(0)
  DateTime get weekStart;
  @override
  @HiveField(1)
  WeeklyMenuStatus get status;
  @override
  @HiveField(2)
  List<WeeklyMenuDay> get days;
  @override
  @HiveField(3)
  String get userId;
  @override // Sync fields
  @HiveField(4)
  SyncStatus get syncStatus;
  @override
  @HiveField(5)
  DateTime get lastModifiedAt;
  @override
  @HiveField(6)
  DateTime? get lastSyncedAt;
  @override
  @HiveField(7)
  bool get isDeleted;
  @override
  @JsonKey(ignore: true)
  _$$WeeklyMenuImplCopyWith<_$WeeklyMenuImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

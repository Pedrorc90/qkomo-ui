// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Entry _$EntryFromJson(Map<String, dynamic> json) {
  return _Entry.fromJson(json);
}

/// @nodoc
mixin _$Entry {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  CaptureResult get result => throw _privateConstructorUsedError;
  @HiveField(2)
  SyncStatus get syncStatus => throw _privateConstructorUsedError;
  @HiveField(3)
  DateTime get lastModifiedAt => throw _privateConstructorUsedError;
  @HiveField(4)
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;
  @HiveField(5)
  bool get isDeleted => throw _privateConstructorUsedError;
  @HiveField(6)
  int? get cloudVersion => throw _privateConstructorUsedError;
  @HiveField(7)
  Map<String, dynamic>? get pendingChanges =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EntryCopyWith<Entry> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EntryCopyWith<$Res> {
  factory $EntryCopyWith(Entry value, $Res Function(Entry) then) =
      _$EntryCopyWithImpl<$Res, Entry>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) CaptureResult result,
      @HiveField(2) SyncStatus syncStatus,
      @HiveField(3) DateTime lastModifiedAt,
      @HiveField(4) DateTime? lastSyncedAt,
      @HiveField(5) bool isDeleted,
      @HiveField(6) int? cloudVersion,
      @HiveField(7) Map<String, dynamic>? pendingChanges});

  $CaptureResultCopyWith<$Res> get result;
}

/// @nodoc
class _$EntryCopyWithImpl<$Res, $Val extends Entry>
    implements $EntryCopyWith<$Res> {
  _$EntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? result = null,
    Object? syncStatus = null,
    Object? lastModifiedAt = null,
    Object? lastSyncedAt = freezed,
    Object? isDeleted = null,
    Object? cloudVersion = freezed,
    Object? pendingChanges = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as CaptureResult,
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
      cloudVersion: freezed == cloudVersion
          ? _value.cloudVersion
          : cloudVersion // ignore: cast_nullable_to_non_nullable
              as int?,
      pendingChanges: freezed == pendingChanges
          ? _value.pendingChanges
          : pendingChanges // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CaptureResultCopyWith<$Res> get result {
    return $CaptureResultCopyWith<$Res>(_value.result, (value) {
      return _then(_value.copyWith(result: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EntryImplCopyWith<$Res> implements $EntryCopyWith<$Res> {
  factory _$$EntryImplCopyWith(
          _$EntryImpl value, $Res Function(_$EntryImpl) then) =
      __$$EntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) CaptureResult result,
      @HiveField(2) SyncStatus syncStatus,
      @HiveField(3) DateTime lastModifiedAt,
      @HiveField(4) DateTime? lastSyncedAt,
      @HiveField(5) bool isDeleted,
      @HiveField(6) int? cloudVersion,
      @HiveField(7) Map<String, dynamic>? pendingChanges});

  @override
  $CaptureResultCopyWith<$Res> get result;
}

/// @nodoc
class __$$EntryImplCopyWithImpl<$Res>
    extends _$EntryCopyWithImpl<$Res, _$EntryImpl>
    implements _$$EntryImplCopyWith<$Res> {
  __$$EntryImplCopyWithImpl(
      _$EntryImpl _value, $Res Function(_$EntryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? result = null,
    Object? syncStatus = null,
    Object? lastModifiedAt = null,
    Object? lastSyncedAt = freezed,
    Object? isDeleted = null,
    Object? cloudVersion = freezed,
    Object? pendingChanges = freezed,
  }) {
    return _then(_$EntryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as CaptureResult,
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
      cloudVersion: freezed == cloudVersion
          ? _value.cloudVersion
          : cloudVersion // ignore: cast_nullable_to_non_nullable
              as int?,
      pendingChanges: freezed == pendingChanges
          ? _value._pendingChanges
          : pendingChanges // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 8, adapterName: 'EntryAdapter')
class _$EntryImpl implements _Entry {
  const _$EntryImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.result,
      @HiveField(2) this.syncStatus = SyncStatus.pending,
      @HiveField(3) required this.lastModifiedAt,
      @HiveField(4) this.lastSyncedAt,
      @HiveField(5) this.isDeleted = false,
      @HiveField(6) this.cloudVersion,
      @HiveField(7) final Map<String, dynamic>? pendingChanges})
      : _pendingChanges = pendingChanges;

  factory _$EntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$EntryImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final CaptureResult result;
  @override
  @JsonKey()
  @HiveField(2)
  final SyncStatus syncStatus;
  @override
  @HiveField(3)
  final DateTime lastModifiedAt;
  @override
  @HiveField(4)
  final DateTime? lastSyncedAt;
  @override
  @JsonKey()
  @HiveField(5)
  final bool isDeleted;
  @override
  @HiveField(6)
  final int? cloudVersion;
  final Map<String, dynamic>? _pendingChanges;
  @override
  @HiveField(7)
  Map<String, dynamic>? get pendingChanges {
    final value = _pendingChanges;
    if (value == null) return null;
    if (_pendingChanges is EqualUnmodifiableMapView) return _pendingChanges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Entry(id: $id, result: $result, syncStatus: $syncStatus, lastModifiedAt: $lastModifiedAt, lastSyncedAt: $lastSyncedAt, isDeleted: $isDeleted, cloudVersion: $cloudVersion, pendingChanges: $pendingChanges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.lastModifiedAt, lastModifiedAt) ||
                other.lastModifiedAt == lastModifiedAt) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.cloudVersion, cloudVersion) ||
                other.cloudVersion == cloudVersion) &&
            const DeepCollectionEquality()
                .equals(other._pendingChanges, _pendingChanges));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      result,
      syncStatus,
      lastModifiedAt,
      lastSyncedAt,
      isDeleted,
      cloudVersion,
      const DeepCollectionEquality().hash(_pendingChanges));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EntryImplCopyWith<_$EntryImpl> get copyWith =>
      __$$EntryImplCopyWithImpl<_$EntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EntryImplToJson(
      this,
    );
  }
}

abstract class _Entry implements Entry {
  const factory _Entry(
      {@HiveField(0) required final String id,
      @HiveField(1) required final CaptureResult result,
      @HiveField(2) final SyncStatus syncStatus,
      @HiveField(3) required final DateTime lastModifiedAt,
      @HiveField(4) final DateTime? lastSyncedAt,
      @HiveField(5) final bool isDeleted,
      @HiveField(6) final int? cloudVersion,
      @HiveField(7) final Map<String, dynamic>? pendingChanges}) = _$EntryImpl;

  factory _Entry.fromJson(Map<String, dynamic> json) = _$EntryImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  CaptureResult get result;
  @override
  @HiveField(2)
  SyncStatus get syncStatus;
  @override
  @HiveField(3)
  DateTime get lastModifiedAt;
  @override
  @HiveField(4)
  DateTime? get lastSyncedAt;
  @override
  @HiveField(5)
  bool get isDeleted;
  @override
  @HiveField(6)
  int? get cloudVersion;
  @override
  @HiveField(7)
  Map<String, dynamic>? get pendingChanges;
  @override
  @JsonKey(ignore: true)
  _$$EntryImplCopyWith<_$EntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

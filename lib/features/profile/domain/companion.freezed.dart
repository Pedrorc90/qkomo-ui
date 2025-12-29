// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'companion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Companion _$CompanionFromJson(Map<String, dynamic> json) {
  return _Companion.fromJson(json);
}

/// @nodoc
mixin _$Companion {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get userId => throw _privateConstructorUsedError;
  @HiveField(2)
  String get email => throw _privateConstructorUsedError;
  @HiveField(3)
  String? get displayName => throw _privateConstructorUsedError;
  @HiveField(4)
  String? get photoUrl => throw _privateConstructorUsedError;
  @HiveField(5)
  bool get isPending => throw _privateConstructorUsedError; // Sync fields
  @HiveField(6)
  SyncStatus get syncStatus => throw _privateConstructorUsedError;
  @HiveField(7)
  DateTime get lastModifiedAt => throw _privateConstructorUsedError;
  @HiveField(8)
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;
  @HiveField(9)
  bool get isDeleted => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompanionCopyWith<Companion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanionCopyWith<$Res> {
  factory $CompanionCopyWith(Companion value, $Res Function(Companion) then) =
      _$CompanionCopyWithImpl<$Res, Companion>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String userId,
      @HiveField(2) String email,
      @HiveField(3) String? displayName,
      @HiveField(4) String? photoUrl,
      @HiveField(5) bool isPending,
      @HiveField(6) SyncStatus syncStatus,
      @HiveField(7) DateTime lastModifiedAt,
      @HiveField(8) DateTime? lastSyncedAt,
      @HiveField(9) bool isDeleted});
}

/// @nodoc
class _$CompanionCopyWithImpl<$Res, $Val extends Companion>
    implements $CompanionCopyWith<$Res> {
  _$CompanionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? email = null,
    Object? displayName = freezed,
    Object? photoUrl = freezed,
    Object? isPending = null,
    Object? syncStatus = null,
    Object? lastModifiedAt = null,
    Object? lastSyncedAt = freezed,
    Object? isDeleted = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
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
      isPending: null == isPending
          ? _value.isPending
          : isPending // ignore: cast_nullable_to_non_nullable
              as bool,
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
abstract class _$$CompanionImplCopyWith<$Res>
    implements $CompanionCopyWith<$Res> {
  factory _$$CompanionImplCopyWith(
          _$CompanionImpl value, $Res Function(_$CompanionImpl) then) =
      __$$CompanionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String userId,
      @HiveField(2) String email,
      @HiveField(3) String? displayName,
      @HiveField(4) String? photoUrl,
      @HiveField(5) bool isPending,
      @HiveField(6) SyncStatus syncStatus,
      @HiveField(7) DateTime lastModifiedAt,
      @HiveField(8) DateTime? lastSyncedAt,
      @HiveField(9) bool isDeleted});
}

/// @nodoc
class __$$CompanionImplCopyWithImpl<$Res>
    extends _$CompanionCopyWithImpl<$Res, _$CompanionImpl>
    implements _$$CompanionImplCopyWith<$Res> {
  __$$CompanionImplCopyWithImpl(
      _$CompanionImpl _value, $Res Function(_$CompanionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? email = null,
    Object? displayName = freezed,
    Object? photoUrl = freezed,
    Object? isPending = null,
    Object? syncStatus = null,
    Object? lastModifiedAt = null,
    Object? lastSyncedAt = freezed,
    Object? isDeleted = null,
  }) {
    return _then(_$CompanionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
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
      isPending: null == isPending
          ? _value.isPending
          : isPending // ignore: cast_nullable_to_non_nullable
              as bool,
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
@HiveType(typeId: 9)
class _$CompanionImpl implements _Companion {
  const _$CompanionImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.userId,
      @HiveField(2) required this.email,
      @HiveField(3) this.displayName,
      @HiveField(4) this.photoUrl,
      @HiveField(5) this.isPending = false,
      @HiveField(6) this.syncStatus = SyncStatus.pending,
      @HiveField(7) required this.lastModifiedAt,
      @HiveField(8) this.lastSyncedAt,
      @HiveField(9) this.isDeleted = false});

  factory _$CompanionImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompanionImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String userId;
  @override
  @HiveField(2)
  final String email;
  @override
  @HiveField(3)
  final String? displayName;
  @override
  @HiveField(4)
  final String? photoUrl;
  @override
  @JsonKey()
  @HiveField(5)
  final bool isPending;
// Sync fields
  @override
  @JsonKey()
  @HiveField(6)
  final SyncStatus syncStatus;
  @override
  @HiveField(7)
  final DateTime lastModifiedAt;
  @override
  @HiveField(8)
  final DateTime? lastSyncedAt;
  @override
  @JsonKey()
  @HiveField(9)
  final bool isDeleted;

  @override
  String toString() {
    return 'Companion(id: $id, userId: $userId, email: $email, displayName: $displayName, photoUrl: $photoUrl, isPending: $isPending, syncStatus: $syncStatus, lastModifiedAt: $lastModifiedAt, lastSyncedAt: $lastSyncedAt, isDeleted: $isDeleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompanionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.isPending, isPending) ||
                other.isPending == isPending) &&
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
  int get hashCode => Object.hash(runtimeType, id, userId, email, displayName,
      photoUrl, isPending, syncStatus, lastModifiedAt, lastSyncedAt, isDeleted);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CompanionImplCopyWith<_$CompanionImpl> get copyWith =>
      __$$CompanionImplCopyWithImpl<_$CompanionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompanionImplToJson(
      this,
    );
  }
}

abstract class _Companion implements Companion {
  const factory _Companion(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String userId,
      @HiveField(2) required final String email,
      @HiveField(3) final String? displayName,
      @HiveField(4) final String? photoUrl,
      @HiveField(5) final bool isPending,
      @HiveField(6) final SyncStatus syncStatus,
      @HiveField(7) required final DateTime lastModifiedAt,
      @HiveField(8) final DateTime? lastSyncedAt,
      @HiveField(9) final bool isDeleted}) = _$CompanionImpl;

  factory _Companion.fromJson(Map<String, dynamic> json) =
      _$CompanionImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get userId;
  @override
  @HiveField(2)
  String get email;
  @override
  @HiveField(3)
  String? get displayName;
  @override
  @HiveField(4)
  String? get photoUrl;
  @override
  @HiveField(5)
  bool get isPending;
  @override // Sync fields
  @HiveField(6)
  SyncStatus get syncStatus;
  @override
  @HiveField(7)
  DateTime get lastModifiedAt;
  @override
  @HiveField(8)
  DateTime? get lastSyncedAt;
  @override
  @HiveField(9)
  bool get isDeleted;
  @override
  @JsonKey(ignore: true)
  _$$CompanionImplCopyWith<_$CompanionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

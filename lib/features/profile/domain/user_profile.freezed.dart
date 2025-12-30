// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  @HiveField(0)
  String get firebaseUid => throw _privateConstructorUsedError;
  @HiveField(1)
  String get email => throw _privateConstructorUsedError;
  @HiveField(2)
  String? get displayName => throw _privateConstructorUsedError;
  @HiveField(3)
  String? get photoUrl => throw _privateConstructorUsedError;
  @HiveField(4)
  DateTime? get lastLoginAt => throw _privateConstructorUsedError;
  @HiveField(5)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(6)
  DateTime get updatedAt =>
      throw _privateConstructorUsedError; // Sync fields (following Companion pattern)
  @HiveField(7)
  SyncStatus get syncStatus => throw _privateConstructorUsedError;
  @HiveField(8)
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;
  @HiveField(9)
  bool get isDeleted => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call(
      {@HiveField(0) String firebaseUid,
      @HiveField(1) String email,
      @HiveField(2) String? displayName,
      @HiveField(3) String? photoUrl,
      @HiveField(4) DateTime? lastLoginAt,
      @HiveField(5) DateTime createdAt,
      @HiveField(6) DateTime updatedAt,
      @HiveField(7) SyncStatus syncStatus,
      @HiveField(8) DateTime? lastSyncedAt,
      @HiveField(9) bool isDeleted});
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

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
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? syncStatus = null,
    Object? lastSyncedAt = freezed,
    Object? isDeleted = null,
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
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      syncStatus: null == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
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
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
          _$UserProfileImpl value, $Res Function(_$UserProfileImpl) then) =
      __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String firebaseUid,
      @HiveField(1) String email,
      @HiveField(2) String? displayName,
      @HiveField(3) String? photoUrl,
      @HiveField(4) DateTime? lastLoginAt,
      @HiveField(5) DateTime createdAt,
      @HiveField(6) DateTime updatedAt,
      @HiveField(7) SyncStatus syncStatus,
      @HiveField(8) DateTime? lastSyncedAt,
      @HiveField(9) bool isDeleted});
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
      _$UserProfileImpl _value, $Res Function(_$UserProfileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firebaseUid = null,
    Object? email = null,
    Object? displayName = freezed,
    Object? photoUrl = freezed,
    Object? lastLoginAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? syncStatus = null,
    Object? lastSyncedAt = freezed,
    Object? isDeleted = null,
  }) {
    return _then(_$UserProfileImpl(
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
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      syncStatus: null == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
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
@HiveType(typeId: 25, adapterName: 'UserProfileImplAdapter')
class _$UserProfileImpl implements _UserProfile {
  const _$UserProfileImpl(
      {@HiveField(0) required this.firebaseUid,
      @HiveField(1) required this.email,
      @HiveField(2) this.displayName,
      @HiveField(3) this.photoUrl,
      @HiveField(4) this.lastLoginAt,
      @HiveField(5) required this.createdAt,
      @HiveField(6) required this.updatedAt,
      @HiveField(7) this.syncStatus = SyncStatus.pending,
      @HiveField(8) this.lastSyncedAt,
      @HiveField(9) this.isDeleted = false});

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

  @override
  @HiveField(0)
  final String firebaseUid;
  @override
  @HiveField(1)
  final String email;
  @override
  @HiveField(2)
  final String? displayName;
  @override
  @HiveField(3)
  final String? photoUrl;
  @override
  @HiveField(4)
  final DateTime? lastLoginAt;
  @override
  @HiveField(5)
  final DateTime createdAt;
  @override
  @HiveField(6)
  final DateTime updatedAt;
// Sync fields (following Companion pattern)
  @override
  @JsonKey()
  @HiveField(7)
  final SyncStatus syncStatus;
  @override
  @HiveField(8)
  final DateTime? lastSyncedAt;
  @override
  @JsonKey()
  @HiveField(9)
  final bool isDeleted;

  @override
  String toString() {
    return 'UserProfile(firebaseUid: $firebaseUid, email: $email, displayName: $displayName, photoUrl: $photoUrl, lastLoginAt: $lastLoginAt, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus, lastSyncedAt: $lastSyncedAt, isDeleted: $isDeleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.firebaseUid, firebaseUid) ||
                other.firebaseUid == firebaseUid) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.lastLoginAt, lastLoginAt) ||
                other.lastLoginAt == lastLoginAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted));
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
      createdAt,
      updatedAt,
      syncStatus,
      lastSyncedAt,
      isDeleted);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(
      this,
    );
  }
}

abstract class _UserProfile implements UserProfile {
  const factory _UserProfile(
      {@HiveField(0) required final String firebaseUid,
      @HiveField(1) required final String email,
      @HiveField(2) final String? displayName,
      @HiveField(3) final String? photoUrl,
      @HiveField(4) final DateTime? lastLoginAt,
      @HiveField(5) required final DateTime createdAt,
      @HiveField(6) required final DateTime updatedAt,
      @HiveField(7) final SyncStatus syncStatus,
      @HiveField(8) final DateTime? lastSyncedAt,
      @HiveField(9) final bool isDeleted}) = _$UserProfileImpl;

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

  @override
  @HiveField(0)
  String get firebaseUid;
  @override
  @HiveField(1)
  String get email;
  @override
  @HiveField(2)
  String? get displayName;
  @override
  @HiveField(3)
  String? get photoUrl;
  @override
  @HiveField(4)
  DateTime? get lastLoginAt;
  @override
  @HiveField(5)
  DateTime get createdAt;
  @override
  @HiveField(6)
  DateTime get updatedAt;
  @override // Sync fields (following Companion pattern)
  @HiveField(7)
  SyncStatus get syncStatus;
  @override
  @HiveField(8)
  DateTime? get lastSyncedAt;
  @override
  @HiveField(9)
  bool get isDeleted;
  @override
  @JsonKey(ignore: true)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Meal _$MealFromJson(Map<String, dynamic> json) {
  return _Meal.fromJson(json);
}

/// @nodoc
mixin _$Meal {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get userId => throw _privateConstructorUsedError;
  @HiveField(2)
  String get name => throw _privateConstructorUsedError;
  @HiveField(3)
  List<String> get ingredients => throw _privateConstructorUsedError;
  @HiveField(4)
  MealType get mealType => throw _privateConstructorUsedError;
  @HiveField(5)
  DateTime get scheduledFor => throw _privateConstructorUsedError;
  @HiveField(6)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(7)
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @HiveField(8)
  String? get notes => throw _privateConstructorUsedError;
  @HiveField(9)
  String? get photoPath => throw _privateConstructorUsedError; // Sync fields
  @HiveField(10)
  SyncStatus get syncStatus => throw _privateConstructorUsedError;
  @HiveField(11)
  DateTime get lastModifiedAt => throw _privateConstructorUsedError;
  @HiveField(12)
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;
  @HiveField(13)
  bool get isDeleted => throw _privateConstructorUsedError;
  @HiveField(14)
  int? get cloudVersion => throw _privateConstructorUsedError;
  @HiveField(15)
  Map<String, dynamic>? get pendingChanges =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MealCopyWith<Meal> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealCopyWith<$Res> {
  factory $MealCopyWith(Meal value, $Res Function(Meal) then) =
      _$MealCopyWithImpl<$Res, Meal>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String userId,
      @HiveField(2) String name,
      @HiveField(3) List<String> ingredients,
      @HiveField(4) MealType mealType,
      @HiveField(5) DateTime scheduledFor,
      @HiveField(6) DateTime createdAt,
      @HiveField(7) DateTime? updatedAt,
      @HiveField(8) String? notes,
      @HiveField(9) String? photoPath,
      @HiveField(10) SyncStatus syncStatus,
      @HiveField(11) DateTime lastModifiedAt,
      @HiveField(12) DateTime? lastSyncedAt,
      @HiveField(13) bool isDeleted,
      @HiveField(14) int? cloudVersion,
      @HiveField(15) Map<String, dynamic>? pendingChanges});
}

/// @nodoc
class _$MealCopyWithImpl<$Res, $Val extends Meal>
    implements $MealCopyWith<$Res> {
  _$MealCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? ingredients = null,
    Object? mealType = null,
    Object? scheduledFor = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? notes = freezed,
    Object? photoPath = freezed,
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
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      ingredients: null == ingredients
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<String>,
      mealType: null == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as MealType,
      scheduledFor: null == scheduledFor
          ? _value.scheduledFor
          : scheduledFor // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      photoPath: freezed == photoPath
          ? _value.photoPath
          : photoPath // ignore: cast_nullable_to_non_nullable
              as String?,
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
}

/// @nodoc
abstract class _$$MealImplCopyWith<$Res> implements $MealCopyWith<$Res> {
  factory _$$MealImplCopyWith(
          _$MealImpl value, $Res Function(_$MealImpl) then) =
      __$$MealImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String userId,
      @HiveField(2) String name,
      @HiveField(3) List<String> ingredients,
      @HiveField(4) MealType mealType,
      @HiveField(5) DateTime scheduledFor,
      @HiveField(6) DateTime createdAt,
      @HiveField(7) DateTime? updatedAt,
      @HiveField(8) String? notes,
      @HiveField(9) String? photoPath,
      @HiveField(10) SyncStatus syncStatus,
      @HiveField(11) DateTime lastModifiedAt,
      @HiveField(12) DateTime? lastSyncedAt,
      @HiveField(13) bool isDeleted,
      @HiveField(14) int? cloudVersion,
      @HiveField(15) Map<String, dynamic>? pendingChanges});
}

/// @nodoc
class __$$MealImplCopyWithImpl<$Res>
    extends _$MealCopyWithImpl<$Res, _$MealImpl>
    implements _$$MealImplCopyWith<$Res> {
  __$$MealImplCopyWithImpl(_$MealImpl _value, $Res Function(_$MealImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? ingredients = null,
    Object? mealType = null,
    Object? scheduledFor = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? notes = freezed,
    Object? photoPath = freezed,
    Object? syncStatus = null,
    Object? lastModifiedAt = null,
    Object? lastSyncedAt = freezed,
    Object? isDeleted = null,
    Object? cloudVersion = freezed,
    Object? pendingChanges = freezed,
  }) {
    return _then(_$MealImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      ingredients: null == ingredients
          ? _value._ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<String>,
      mealType: null == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as MealType,
      scheduledFor: null == scheduledFor
          ? _value.scheduledFor
          : scheduledFor // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      photoPath: freezed == photoPath
          ? _value.photoPath
          : photoPath // ignore: cast_nullable_to_non_nullable
              as String?,
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
@HiveType(typeId: 6, adapterName: 'MealV2Adapter')
class _$MealImpl implements _Meal {
  const _$MealImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.userId,
      @HiveField(2) required this.name,
      @HiveField(3) required final List<String> ingredients,
      @HiveField(4) required this.mealType,
      @HiveField(5) required this.scheduledFor,
      @HiveField(6) required this.createdAt,
      @HiveField(7) this.updatedAt,
      @HiveField(8) this.notes,
      @HiveField(9) this.photoPath,
      @HiveField(10) this.syncStatus = SyncStatus.pending,
      @HiveField(11) required this.lastModifiedAt,
      @HiveField(12) this.lastSyncedAt,
      @HiveField(13) this.isDeleted = false,
      @HiveField(14) this.cloudVersion,
      @HiveField(15) final Map<String, dynamic>? pendingChanges})
      : _ingredients = ingredients,
        _pendingChanges = pendingChanges;

  factory _$MealImpl.fromJson(Map<String, dynamic> json) =>
      _$$MealImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String userId;
  @override
  @HiveField(2)
  final String name;
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
  final MealType mealType;
  @override
  @HiveField(5)
  final DateTime scheduledFor;
  @override
  @HiveField(6)
  final DateTime createdAt;
  @override
  @HiveField(7)
  final DateTime? updatedAt;
  @override
  @HiveField(8)
  final String? notes;
  @override
  @HiveField(9)
  final String? photoPath;
// Sync fields
  @override
  @JsonKey()
  @HiveField(10)
  final SyncStatus syncStatus;
  @override
  @HiveField(11)
  final DateTime lastModifiedAt;
  @override
  @HiveField(12)
  final DateTime? lastSyncedAt;
  @override
  @JsonKey()
  @HiveField(13)
  final bool isDeleted;
  @override
  @HiveField(14)
  final int? cloudVersion;
  final Map<String, dynamic>? _pendingChanges;
  @override
  @HiveField(15)
  Map<String, dynamic>? get pendingChanges {
    final value = _pendingChanges;
    if (value == null) return null;
    if (_pendingChanges is EqualUnmodifiableMapView) return _pendingChanges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Meal(id: $id, userId: $userId, name: $name, ingredients: $ingredients, mealType: $mealType, scheduledFor: $scheduledFor, createdAt: $createdAt, updatedAt: $updatedAt, notes: $notes, photoPath: $photoPath, syncStatus: $syncStatus, lastModifiedAt: $lastModifiedAt, lastSyncedAt: $lastSyncedAt, isDeleted: $isDeleted, cloudVersion: $cloudVersion, pendingChanges: $pendingChanges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality()
                .equals(other._ingredients, _ingredients) &&
            (identical(other.mealType, mealType) ||
                other.mealType == mealType) &&
            (identical(other.scheduledFor, scheduledFor) ||
                other.scheduledFor == scheduledFor) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.photoPath, photoPath) ||
                other.photoPath == photoPath) &&
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
      userId,
      name,
      const DeepCollectionEquality().hash(_ingredients),
      mealType,
      scheduledFor,
      createdAt,
      updatedAt,
      notes,
      photoPath,
      syncStatus,
      lastModifiedAt,
      lastSyncedAt,
      isDeleted,
      cloudVersion,
      const DeepCollectionEquality().hash(_pendingChanges));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MealImplCopyWith<_$MealImpl> get copyWith =>
      __$$MealImplCopyWithImpl<_$MealImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MealImplToJson(
      this,
    );
  }
}

abstract class _Meal implements Meal {
  const factory _Meal(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String userId,
      @HiveField(2) required final String name,
      @HiveField(3) required final List<String> ingredients,
      @HiveField(4) required final MealType mealType,
      @HiveField(5) required final DateTime scheduledFor,
      @HiveField(6) required final DateTime createdAt,
      @HiveField(7) final DateTime? updatedAt,
      @HiveField(8) final String? notes,
      @HiveField(9) final String? photoPath,
      @HiveField(10) final SyncStatus syncStatus,
      @HiveField(11) required final DateTime lastModifiedAt,
      @HiveField(12) final DateTime? lastSyncedAt,
      @HiveField(13) final bool isDeleted,
      @HiveField(14) final int? cloudVersion,
      @HiveField(15) final Map<String, dynamic>? pendingChanges}) = _$MealImpl;

  factory _Meal.fromJson(Map<String, dynamic> json) = _$MealImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get userId;
  @override
  @HiveField(2)
  String get name;
  @override
  @HiveField(3)
  List<String> get ingredients;
  @override
  @HiveField(4)
  MealType get mealType;
  @override
  @HiveField(5)
  DateTime get scheduledFor;
  @override
  @HiveField(6)
  DateTime get createdAt;
  @override
  @HiveField(7)
  DateTime? get updatedAt;
  @override
  @HiveField(8)
  String? get notes;
  @override
  @HiveField(9)
  String? get photoPath;
  @override // Sync fields
  @HiveField(10)
  SyncStatus get syncStatus;
  @override
  @HiveField(11)
  DateTime get lastModifiedAt;
  @override
  @HiveField(12)
  DateTime? get lastSyncedAt;
  @override
  @HiveField(13)
  bool get isDeleted;
  @override
  @HiveField(14)
  int? get cloudVersion;
  @override
  @HiveField(15)
  Map<String, dynamic>? get pendingChanges;
  @override
  @JsonKey(ignore: true)
  _$$MealImplCopyWith<_$MealImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

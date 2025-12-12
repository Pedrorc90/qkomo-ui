// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'capture_job.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CaptureJob _$CaptureJobFromJson(Map<String, dynamic> json) {
  return _CaptureJob.fromJson(json);
}

/// @nodoc
mixin _$CaptureJob {
  String get id => throw _privateConstructorUsedError;
  CaptureJobType get type => throw _privateConstructorUsedError;
  String? get imagePath => throw _privateConstructorUsedError;
  String? get barcode => throw _privateConstructorUsedError;
  CaptureMode? get captureMode => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  CaptureJobStatus get status => throw _privateConstructorUsedError;
  int get attempts => throw _privateConstructorUsedError;
  String? get lastError => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CaptureJobCopyWith<CaptureJob> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CaptureJobCopyWith<$Res> {
  factory $CaptureJobCopyWith(
          CaptureJob value, $Res Function(CaptureJob) then) =
      _$CaptureJobCopyWithImpl<$Res, CaptureJob>;
  @useResult
  $Res call(
      {String id,
      CaptureJobType type,
      String? imagePath,
      String? barcode,
      CaptureMode? captureMode,
      DateTime createdAt,
      DateTime? updatedAt,
      CaptureJobStatus status,
      int attempts,
      String? lastError});
}

/// @nodoc
class _$CaptureJobCopyWithImpl<$Res, $Val extends CaptureJob>
    implements $CaptureJobCopyWith<$Res> {
  _$CaptureJobCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? imagePath = freezed,
    Object? barcode = freezed,
    Object? captureMode = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? status = null,
    Object? attempts = null,
    Object? lastError = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CaptureJobType,
      imagePath: freezed == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      captureMode: freezed == captureMode
          ? _value.captureMode
          : captureMode // ignore: cast_nullable_to_non_nullable
              as CaptureMode?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CaptureJobStatus,
      attempts: null == attempts
          ? _value.attempts
          : attempts // ignore: cast_nullable_to_non_nullable
              as int,
      lastError: freezed == lastError
          ? _value.lastError
          : lastError // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CaptureJobImplCopyWith<$Res>
    implements $CaptureJobCopyWith<$Res> {
  factory _$$CaptureJobImplCopyWith(
          _$CaptureJobImpl value, $Res Function(_$CaptureJobImpl) then) =
      __$$CaptureJobImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      CaptureJobType type,
      String? imagePath,
      String? barcode,
      CaptureMode? captureMode,
      DateTime createdAt,
      DateTime? updatedAt,
      CaptureJobStatus status,
      int attempts,
      String? lastError});
}

/// @nodoc
class __$$CaptureJobImplCopyWithImpl<$Res>
    extends _$CaptureJobCopyWithImpl<$Res, _$CaptureJobImpl>
    implements _$$CaptureJobImplCopyWith<$Res> {
  __$$CaptureJobImplCopyWithImpl(
      _$CaptureJobImpl _value, $Res Function(_$CaptureJobImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? imagePath = freezed,
    Object? barcode = freezed,
    Object? captureMode = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? status = null,
    Object? attempts = null,
    Object? lastError = freezed,
  }) {
    return _then(_$CaptureJobImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CaptureJobType,
      imagePath: freezed == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      captureMode: freezed == captureMode
          ? _value.captureMode
          : captureMode // ignore: cast_nullable_to_non_nullable
              as CaptureMode?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CaptureJobStatus,
      attempts: null == attempts
          ? _value.attempts
          : attempts // ignore: cast_nullable_to_non_nullable
              as int,
      lastError: freezed == lastError
          ? _value.lastError
          : lastError // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CaptureJobImpl implements _CaptureJob {
  const _$CaptureJobImpl(
      {required this.id,
      required this.type,
      this.imagePath,
      this.barcode,
      this.captureMode,
      required this.createdAt,
      this.updatedAt,
      this.status = CaptureJobStatus.pending,
      this.attempts = 0,
      this.lastError});

  factory _$CaptureJobImpl.fromJson(Map<String, dynamic> json) =>
      _$$CaptureJobImplFromJson(json);

  @override
  final String id;
  @override
  final CaptureJobType type;
  @override
  final String? imagePath;
  @override
  final String? barcode;
  @override
  final CaptureMode? captureMode;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  @JsonKey()
  final CaptureJobStatus status;
  @override
  @JsonKey()
  final int attempts;
  @override
  final String? lastError;

  @override
  String toString() {
    return 'CaptureJob(id: $id, type: $type, imagePath: $imagePath, barcode: $barcode, captureMode: $captureMode, createdAt: $createdAt, updatedAt: $updatedAt, status: $status, attempts: $attempts, lastError: $lastError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CaptureJobImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.captureMode, captureMode) ||
                other.captureMode == captureMode) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.attempts, attempts) ||
                other.attempts == attempts) &&
            (identical(other.lastError, lastError) ||
                other.lastError == lastError));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, type, imagePath, barcode,
      captureMode, createdAt, updatedAt, status, attempts, lastError);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CaptureJobImplCopyWith<_$CaptureJobImpl> get copyWith =>
      __$$CaptureJobImplCopyWithImpl<_$CaptureJobImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CaptureJobImplToJson(
      this,
    );
  }
}

abstract class _CaptureJob implements CaptureJob {
  const factory _CaptureJob(
      {required final String id,
      required final CaptureJobType type,
      final String? imagePath,
      final String? barcode,
      final CaptureMode? captureMode,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final CaptureJobStatus status,
      final int attempts,
      final String? lastError}) = _$CaptureJobImpl;

  factory _CaptureJob.fromJson(Map<String, dynamic> json) =
      _$CaptureJobImpl.fromJson;

  @override
  String get id;
  @override
  CaptureJobType get type;
  @override
  String? get imagePath;
  @override
  String? get barcode;
  @override
  CaptureMode? get captureMode;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  CaptureJobStatus get status;
  @override
  int get attempts;
  @override
  String? get lastError;
  @override
  @JsonKey(ignore: true)
  _$$CaptureJobImplCopyWith<_$CaptureJobImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

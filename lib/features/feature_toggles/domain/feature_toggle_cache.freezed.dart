// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feature_toggle_cache.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FeatureToggleCacheMetadata _$FeatureToggleCacheMetadataFromJson(
    Map<String, dynamic> json) {
  return _FeatureToggleCacheMetadata.fromJson(json);
}

/// @nodoc
mixin _$FeatureToggleCacheMetadata {
  @HiveField(0)
  DateTime get lastUpdated => throw _privateConstructorUsedError;
  @HiveField(1)
  int get toggleCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FeatureToggleCacheMetadataCopyWith<FeatureToggleCacheMetadata>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeatureToggleCacheMetadataCopyWith<$Res> {
  factory $FeatureToggleCacheMetadataCopyWith(FeatureToggleCacheMetadata value,
          $Res Function(FeatureToggleCacheMetadata) then) =
      _$FeatureToggleCacheMetadataCopyWithImpl<$Res,
          FeatureToggleCacheMetadata>;
  @useResult
  $Res call(
      {@HiveField(0) DateTime lastUpdated, @HiveField(1) int toggleCount});
}

/// @nodoc
class _$FeatureToggleCacheMetadataCopyWithImpl<$Res,
        $Val extends FeatureToggleCacheMetadata>
    implements $FeatureToggleCacheMetadataCopyWith<$Res> {
  _$FeatureToggleCacheMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lastUpdated = null,
    Object? toggleCount = null,
  }) {
    return _then(_value.copyWith(
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      toggleCount: null == toggleCount
          ? _value.toggleCount
          : toggleCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FeatureToggleCacheMetadataImplCopyWith<$Res>
    implements $FeatureToggleCacheMetadataCopyWith<$Res> {
  factory _$$FeatureToggleCacheMetadataImplCopyWith(
          _$FeatureToggleCacheMetadataImpl value,
          $Res Function(_$FeatureToggleCacheMetadataImpl) then) =
      __$$FeatureToggleCacheMetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) DateTime lastUpdated, @HiveField(1) int toggleCount});
}

/// @nodoc
class __$$FeatureToggleCacheMetadataImplCopyWithImpl<$Res>
    extends _$FeatureToggleCacheMetadataCopyWithImpl<$Res,
        _$FeatureToggleCacheMetadataImpl>
    implements _$$FeatureToggleCacheMetadataImplCopyWith<$Res> {
  __$$FeatureToggleCacheMetadataImplCopyWithImpl(
      _$FeatureToggleCacheMetadataImpl _value,
      $Res Function(_$FeatureToggleCacheMetadataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lastUpdated = null,
    Object? toggleCount = null,
  }) {
    return _then(_$FeatureToggleCacheMetadataImpl(
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      toggleCount: null == toggleCount
          ? _value.toggleCount
          : toggleCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 23, adapterName: 'FeatureToggleCacheMetadataAdapter')
class _$FeatureToggleCacheMetadataImpl implements _FeatureToggleCacheMetadata {
  const _$FeatureToggleCacheMetadataImpl(
      {@HiveField(0) required this.lastUpdated,
      @HiveField(1) required this.toggleCount});

  factory _$FeatureToggleCacheMetadataImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$FeatureToggleCacheMetadataImplFromJson(json);

  @override
  @HiveField(0)
  final DateTime lastUpdated;
  @override
  @HiveField(1)
  final int toggleCount;

  @override
  String toString() {
    return 'FeatureToggleCacheMetadata(lastUpdated: $lastUpdated, toggleCount: $toggleCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeatureToggleCacheMetadataImpl &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.toggleCount, toggleCount) ||
                other.toggleCount == toggleCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, lastUpdated, toggleCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FeatureToggleCacheMetadataImplCopyWith<_$FeatureToggleCacheMetadataImpl>
      get copyWith => __$$FeatureToggleCacheMetadataImplCopyWithImpl<
          _$FeatureToggleCacheMetadataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeatureToggleCacheMetadataImplToJson(
      this,
    );
  }
}

abstract class _FeatureToggleCacheMetadata
    implements FeatureToggleCacheMetadata {
  const factory _FeatureToggleCacheMetadata(
          {@HiveField(0) required final DateTime lastUpdated,
          @HiveField(1) required final int toggleCount}) =
      _$FeatureToggleCacheMetadataImpl;

  factory _FeatureToggleCacheMetadata.fromJson(Map<String, dynamic> json) =
      _$FeatureToggleCacheMetadataImpl.fromJson;

  @override
  @HiveField(0)
  DateTime get lastUpdated;
  @override
  @HiveField(1)
  int get toggleCount;
  @override
  @JsonKey(ignore: true)
  _$$FeatureToggleCacheMetadataImplCopyWith<_$FeatureToggleCacheMetadataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

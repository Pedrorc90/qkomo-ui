// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_toggle_cache.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FeatureToggleCacheMetadataAdapter
    extends TypeAdapter<_$FeatureToggleCacheMetadataImpl> {
  @override
  final int typeId = 23;

  @override
  _$FeatureToggleCacheMetadataImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$FeatureToggleCacheMetadataImpl(
      lastUpdated: fields[0] as DateTime,
      toggleCount: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, _$FeatureToggleCacheMetadataImpl obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.lastUpdated)
      ..writeByte(1)
      ..write(obj.toggleCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeatureToggleCacheMetadataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FeatureToggleCacheMetadataImpl _$$FeatureToggleCacheMetadataImplFromJson(
        Map<String, dynamic> json) =>
    _$FeatureToggleCacheMetadataImpl(
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      toggleCount: (json['toggleCount'] as num).toInt(),
    );

Map<String, dynamic> _$$FeatureToggleCacheMetadataImplToJson(
        _$FeatureToggleCacheMetadataImpl instance) =>
    <String, dynamic>{
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'toggleCount': instance.toggleCount,
    };

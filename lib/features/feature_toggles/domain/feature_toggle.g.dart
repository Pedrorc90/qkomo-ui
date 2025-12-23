// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_toggle.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FeatureToggleAdapter extends TypeAdapter<_$FeatureToggleImpl> {
  @override
  final int typeId = 24;

  @override
  _$FeatureToggleImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$FeatureToggleImpl(
      key: fields[0] as String,
      enabled: fields[1] as bool,
      description: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, _$FeatureToggleImpl obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.enabled)
      ..writeByte(2)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeatureToggleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FeatureToggleImpl _$$FeatureToggleImplFromJson(Map<String, dynamic> json) =>
    _$FeatureToggleImpl(
      key: json['key'] as String,
      enabled: json['enabled'] as bool,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$FeatureToggleImplToJson(_$FeatureToggleImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'enabled': instance.enabled,
      'description': instance.description,
    };

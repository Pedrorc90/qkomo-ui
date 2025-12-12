// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'capture_job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CaptureJobImpl _$$CaptureJobImplFromJson(Map<String, dynamic> json) =>
    _$CaptureJobImpl(
      id: json['id'] as String,
      type: $enumDecode(_$CaptureJobTypeEnumMap, json['type']),
      imagePath: json['imagePath'] as String?,
      barcode: json['barcode'] as String?,
      captureMode:
          $enumDecodeNullable(_$CaptureModeEnumMap, json['captureMode']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      status: $enumDecodeNullable(_$CaptureJobStatusEnumMap, json['status']) ??
          CaptureJobStatus.pending,
      attempts: (json['attempts'] as num?)?.toInt() ?? 0,
      lastError: json['lastError'] as String?,
    );

Map<String, dynamic> _$$CaptureJobImplToJson(_$CaptureJobImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$CaptureJobTypeEnumMap[instance.type]!,
      'imagePath': instance.imagePath,
      'barcode': instance.barcode,
      'captureMode': _$CaptureModeEnumMap[instance.captureMode],
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'status': _$CaptureJobStatusEnumMap[instance.status]!,
      'attempts': instance.attempts,
      'lastError': instance.lastError,
    };

const _$CaptureJobTypeEnumMap = {
  CaptureJobType.image: 'image',
  CaptureJobType.barcode: 'barcode',
};

const _$CaptureModeEnumMap = {
  CaptureMode.camera: 'camera',
  CaptureMode.gallery: 'gallery',
  CaptureMode.barcode: 'barcode',
  CaptureMode.text: 'text',
};

const _$CaptureJobStatusEnumMap = {
  CaptureJobStatus.pending: 'pending',
  CaptureJobStatus.processing: 'processing',
  CaptureJobStatus.succeeded: 'succeeded',
  CaptureJobStatus.failed: 'failed',
};

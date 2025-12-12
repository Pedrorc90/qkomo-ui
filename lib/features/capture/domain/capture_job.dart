import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qkomo_ui/features/capture/domain/capture_job_status.dart';
import 'package:qkomo_ui/features/capture/domain/capture_job_type.dart';
import 'package:qkomo_ui/features/capture/domain/capture_mode.dart';

part 'capture_job.freezed.dart';
part 'capture_job.g.dart';

@freezed
class CaptureJob with _$CaptureJob {
  const factory CaptureJob({
    required String id,
    required CaptureJobType type,
    String? imagePath,
    String? barcode,
    CaptureMode? captureMode,
    required DateTime createdAt,
    DateTime? updatedAt,
    @Default(CaptureJobStatus.pending) CaptureJobStatus status,
    @Default(0) int attempts,
    String? lastError,
  }) = _CaptureJob;

  factory CaptureJob.fromJson(Map<String, dynamic> json) => _$CaptureJobFromJson(json);
}

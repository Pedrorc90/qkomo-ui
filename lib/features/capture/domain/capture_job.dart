import 'package:qkomo_ui/features/capture/domain/capture_job_status.dart';
import 'package:qkomo_ui/features/capture/domain/capture_job_type.dart';

class CaptureJob {
  CaptureJob({
    required this.id,
    required this.type,
    this.imagePath,
    this.barcode,
    required this.createdAt,
    this.updatedAt,
    this.status = CaptureJobStatus.pending,
    this.attempts = 0,
    this.lastError,
  });

  final String id;
  final CaptureJobType type;
  final String? imagePath;
  final String? barcode;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final CaptureJobStatus status;
  final int attempts;
  final String? lastError;

  CaptureJob copyWith({
    CaptureJobStatus? status,
    int? attempts,
    DateTime? updatedAt,
    String? lastError,
  }) {
    return CaptureJob(
      id: id,
      type: type,
      imagePath: imagePath,
      barcode: barcode,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      attempts: attempts ?? this.attempts,
      lastError: lastError,
    );
  }
}

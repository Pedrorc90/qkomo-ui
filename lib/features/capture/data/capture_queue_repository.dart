import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../domain/capture_job.dart';
import '../domain/capture_job_status.dart';
import '../domain/capture_job_type.dart';
import 'hive_boxes.dart';

class CaptureQueueRepository {
  CaptureQueueRepository({
    required Box<CaptureJob> jobBox,
    Uuid? uuid,
  })  : _jobBox = jobBox,
        _uuid = uuid ?? const Uuid();

  final Box<CaptureJob> _jobBox;
  final Uuid _uuid;

  Future<CaptureJob> enqueueImage(String imagePath) async {
    final job = CaptureJob(
      id: _uuid.v4(),
      type: CaptureJobType.image,
      imagePath: imagePath,
      createdAt: DateTime.now(),
    );
    await _jobBox.put(job.id, job);
    return job;
  }

  Future<CaptureJob> enqueueBarcode(String barcode) async {
    final job = CaptureJob(
      id: _uuid.v4(),
      type: CaptureJobType.barcode,
      barcode: barcode,
      createdAt: DateTime.now(),
    );
    await _jobBox.put(job.id, job);
    return job;
  }

  List<CaptureJob> pendingJobs() {
    return _jobBox.values
        .where((job) => job.status == CaptureJobStatus.pending)
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  Future<void> markProcessing(String id) async {
    final job = _jobBox.get(id);
    if (job == null) return;
    await _jobBox.put(
      id,
      job.copyWith(
        status: CaptureJobStatus.processing,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> markSuccess(String id) async {
    final job = _jobBox.get(id);
    if (job == null) return;
    await _jobBox.put(
      id,
      job.copyWith(
        status: CaptureJobStatus.succeeded,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> markFailure(String id, String error) async {
    final job = _jobBox.get(id);
    if (job == null) return;
    await _jobBox.put(
      id,
      job.copyWith(
        status: CaptureJobStatus.failed,
        attempts: job.attempts + 1,
        updatedAt: DateTime.now(),
        lastError: error,
      ),
    );
  }

  Future<void> deleteJob(String id) {
    return _jobBox.delete(id);
  }

  Future<void> clearSucceeded({Duration? olderThan}) async {
    final now = DateTime.now();
    final toDelete = _jobBox.values.where((job) {
      final isSuccess = job.status == CaptureJobStatus.succeeded;
      final isOld = olderThan == null
          ? true
          : job.updatedAt != null && now.difference(job.updatedAt!).compareTo(olderThan) > 0;
      return isSuccess && isOld;
    }).map((job) => job.id);
    await _jobBox.deleteAll(toDelete);
  }
}

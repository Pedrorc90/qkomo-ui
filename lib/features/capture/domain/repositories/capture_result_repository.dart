import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';

/// Repository interface for CaptureResult persistence
///
/// Defines the contract for storing and retrieving food capture analysis results.
/// Implementations handle local storage (Hive) or remote sync.
///
/// NOTE: This repository follows CRUD principles. Complex queries (today, thisWeek, etc.)
/// are handled by UseCases in domain/usecases/ to keep repository focused on data access.
abstract class CaptureResultRepository {
  /// Save a capture result
  Future<void> saveResult(CaptureResult result);

  /// Find a result by job ID
  CaptureResult? findByJobId(String jobId);

  /// Get all results sorted by date (newest first)
  ///
  /// UseCases can filter this list for specific queries (today, thisWeek, etc.)
  List<CaptureResult> allSorted();

  /// Watch for changes in results (reactive stream)
  ///
  /// Returns all results sorted by date (newest first)
  Stream<List<CaptureResult>> watchAllSorted();
}

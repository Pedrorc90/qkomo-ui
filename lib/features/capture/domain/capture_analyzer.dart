import 'capture_job.dart';
import 'capture_result.dart';

/// Abstraction for turning a capture job into a stored result.
/// Allows plugging real backend analysis later while keeping queue handling local.
abstract class CaptureAnalyzer {
  Future<CaptureResult> analyze(CaptureJob job);
}

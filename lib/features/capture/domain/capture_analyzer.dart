/// Abstraction for turning a capture job into a stored result.
/// Allows plugging real backend analysis later.
library;

import 'package:image_picker/image_picker.dart';
import 'package:qkomo_ui/features/capture/domain/capture_mode.dart';
import 'package:qkomo_ui/features/capture/domain/capture_result.dart';

abstract class CaptureAnalyzer {
  Future<CaptureResult> analyze({
    required CaptureMode mode,
    XFile? file,
    String? barcode,
  });
}

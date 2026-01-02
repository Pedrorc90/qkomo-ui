import 'package:image_picker/image_picker.dart';
import 'package:qkomo_ui/features/capture/domain/interfaces/capture_analyzer.dart';
import 'package:qkomo_ui/features/capture/domain/entities/capture_mode.dart';
import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';

/// UseCase: Analyze an image to extract food information
///
/// Takes an image file and returns analyzed food data.
class AnalyzeImage {
  AnalyzeImage(this._analyzer);

  final CaptureAnalyzer _analyzer;

  Future<CaptureResult> call(XFile imageFile) async {
    return _analyzer.analyze(
      mode: CaptureMode.camera,
      file: imageFile,
    );
  }
}

import 'package:qkomo_ui/features/capture/domain/entities/capture_mode.dart';
import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';
import 'package:qkomo_ui/features/capture/domain/interfaces/capture_analyzer.dart';

/// UseCase: Analyze a barcode to extract product information
///
/// Takes a barcode string and returns analyzed product data.
class AnalyzeBarcode {
  AnalyzeBarcode(this._analyzer);

  final CaptureAnalyzer _analyzer;

  Future<CaptureResult> call(String barcode) {
    return _analyzer.analyze(
      mode: CaptureMode.barcode,
      barcode: barcode,
    );
  }
}

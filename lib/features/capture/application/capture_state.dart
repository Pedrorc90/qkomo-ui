import 'package:image_picker/image_picker.dart';

import '../domain/capture_mode.dart';

class CaptureState {
  const CaptureState({
    required this.mode,
    this.imageFile,
    this.barcode,
    this.message,
    this.error,
    this.isProcessing = false,
  });

  final CaptureMode mode;
  final XFile? imageFile;
  final String? barcode;
  final String? message;
  final String? error;
  final bool isProcessing;

  factory CaptureState.initial() {
    return const CaptureState(mode: CaptureMode.camera);
  }

  CaptureState copyWith({
    CaptureMode? mode,
    XFile? imageFile,
    String? barcode,
    String? message,
    String? error,
    bool? isProcessing,
    bool clearImage = false,
    bool clearBarcode = false,
    bool clearMessage = false,
    bool clearError = false,
  }) {
    return CaptureState(
      mode: mode ?? this.mode,
      imageFile: clearImage ? null : (imageFile ?? this.imageFile),
      barcode: clearBarcode ? null : (barcode ?? this.barcode),
      message: clearMessage ? null : (message ?? this.message),
      error: clearError ? null : (error ?? this.error),
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}

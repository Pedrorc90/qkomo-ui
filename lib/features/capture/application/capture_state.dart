import 'package:image_picker/image_picker.dart';

import '../domain/capture_mode.dart';

class CaptureState {
  const CaptureState({
    this.mode,
    this.imageFile,
    this.message,
    this.error,
    this.isProcessing = false,
  });

  final CaptureMode? mode;
  final XFile? imageFile;
  final String? message;
  final String? error;
  final bool isProcessing;

  factory CaptureState.initial() {
    return const CaptureState(mode: null);
  }

  CaptureState copyWith({
    CaptureMode? mode,
    XFile? imageFile,
    String? message,
    String? error,
    bool? isProcessing,
    bool clearMode = false,
    bool clearImage = false,
    bool clearMessage = false,
    bool clearError = false,
  }) {
    return CaptureState(
      mode: clearMode ? null : (mode ?? this.mode),
      imageFile: clearImage ? null : (imageFile ?? this.imageFile),
      message: clearMessage ? null : (message ?? this.message),
      error: clearError ? null : (error ?? this.error),
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}

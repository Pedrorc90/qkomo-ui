import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qkomo_ui/features/capture/application/capture_permissions.dart';
import 'package:qkomo_ui/features/capture/application/capture_state.dart';
import 'package:qkomo_ui/features/capture/domain/entities/capture_mode.dart';

class CaptureController extends StateNotifier<CaptureState> {
  CaptureController(this._imagePicker, this._permissions) : super(CaptureState.initial());

  final ImagePicker _imagePicker;
  final CapturePermissions _permissions;

  void setMode(CaptureMode mode) {
    if (mode == state.mode) return;
    state = state.copyWith(
      mode: mode,
      clearError: true,
      clearImage: true,
      clearBarcode: true,
      clearMessage: true,
      isProcessing: false,
    );
  }

  void clearMode() {
    state = state.copyWith(
      clearMode: true,
      clearError: true,
      clearImage: true,
      clearBarcode: true,
      clearMessage: true,
      isProcessing: false,
    );
  }

  Future<void> captureWithCamera() async {
    if (state.isProcessing) return;
    final permission = await _permissions.ensureCameraAccess();
    if (!permission.granted) {
      state = state.copyWith(
        error: permission.needsSettings
            ? 'Activa el permiso de cámara en Ajustes para tomar fotos.'
            : 'Necesitamos permiso de cámara para continuar.',
        clearMessage: true,
        clearImage: true,
      );
      return;
    }
    state = state.copyWith(isProcessing: true, clearError: true, clearMessage: true);
    try {
      final file = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 2000,
      );
      if (file == null) {
        state = state.copyWith(
          isProcessing: false,
          message: 'Captura cancelada',
          clearImage: true,
        );
        return;
      }

      // Validate size (max 10MB)
      final length = await file.length();
      if (length > 10 * 1024 * 1024) {
        state = state.copyWith(
          isProcessing: false,
          error: 'La imagen es demasiado grande. El límite es de 10MB.',
          clearImage: true,
        );
        return;
      }

      // Validate type (images only)
      final mimeType = file.mimeType;
      if (mimeType != null && !mimeType.startsWith('image/')) {
        state = state.copyWith(
          isProcessing: false,
          error: 'El archivo seleccionado no es una imagen válida.',
          clearImage: true,
        );
        return;
      }

      state = state.copyWith(
        imageFile: file,
        isProcessing: false,
        message: 'Foto lista para analizar',
      );
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        error: 'No se pudo abrir la cámara: $e',
      );
    }
  }

  Future<void> importFromGallery() async {
    if (state.isProcessing) return;
    final permission = await _permissions.ensureGalleryAccess();
    if (!permission.granted) {
      state = state.copyWith(
        error: permission.needsSettings
            ? 'Activa el permiso de fotos/archivos en Ajustes para importar.'
            : 'Necesitamos permiso de fotos/archivos para continuar.',
        clearMessage: true,
        clearImage: true,
      );
      return;
    }
    state = state.copyWith(isProcessing: true, clearError: true, clearMessage: true);
    try {
      final file = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2000,
      );
      if (file == null) {
        state = state.copyWith(
          isProcessing: false,
          message: 'Importación cancelada',
          clearImage: true,
        );
        return;
      }

      // Validate size (max 10MB)
      final length = await file.length();
      if (length > 10 * 1024 * 1024) {
        state = state.copyWith(
          isProcessing: false,
          error: 'La imagen es demasiado grande. El límite es de 10MB.',
          clearImage: true,
        );
        return;
      }

      // Validate type (images only)
      final mimeType = file.mimeType;
      if (mimeType != null && !mimeType.startsWith('image/')) {
        state = state.copyWith(
          isProcessing: false,
          error: 'El archivo seleccionado no es una imagen válida.',
          clearImage: true,
        );
        return;
      }

      state = state.copyWith(
        imageFile: file,
        isProcessing: false,
        message: 'Imagen importada',
      );
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        error: 'No se pudo abrir la galería: $e',
      );
    }
  }

  void clearMessage() {
    state = state.copyWith(clearMessage: true);
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  Future<void> openSettings() {
    return _permissions.openSettings();
  }

  Future<void> scanBarcode() async {
    if (state.isProcessing) return;
    final permission = await _permissions.ensureCameraAccess();
    if (!permission.granted) {
      state = state.copyWith(
        error: permission.needsSettings
            ? 'Activa el permiso de cámara en Ajustes para escanear.'
            : 'Necesitamos permiso de cámara para continuar.',
        clearMessage: true,
        clearBarcode: true,
      );
      return;
    }
    state = state.copyWith(isProcessing: true, clearError: true, clearMessage: true);
  }

  void onBarcodeScanned(String barcode) {
    // Validate barcode format (minimum 8 characters, numeric)
    // This is a basic validation to avoid garbage
    final isNumeric = RegExp(r'^[0-9]+$').hasMatch(barcode);
    if (barcode.length < 8 || !isNumeric) {
      state = state.copyWith(
        isProcessing: false,
        error: 'Formato de código de barras no válido.',
        clearBarcode: true,
      );
      return;
    }

    state = state.copyWith(
      scannedBarcode: barcode,
      isProcessing: false,
    );
  }

  /// Resets the controller to initial state
  void reset() {
    state = CaptureState.initial();
  }
}

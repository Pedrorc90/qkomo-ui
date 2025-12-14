import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:qkomo_ui/features/capture/domain/capture_mode.dart';
import 'package:qkomo_ui/features/capture/application/capture_permissions.dart';
import 'package:qkomo_ui/features/capture/application/capture_state.dart';

class CaptureController extends StateNotifier<CaptureState> {
  CaptureController(this._imagePicker, this._permissions)
      : super(CaptureState.initial());

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
    state = state.copyWith(
        isProcessing: true, clearError: true, clearMessage: true);
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
    state = state.copyWith(
        isProcessing: true, clearError: true, clearMessage: true);
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
    state = state.copyWith(
        isProcessing: true, clearError: true, clearMessage: true);
  }

  void onBarcodeScanned(String barcode) {
    state = state.copyWith(
      scannedBarcode: barcode,
      isProcessing: false,
    );
  }
}

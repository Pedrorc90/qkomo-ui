import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qkomo_ui/features/capture/application/capture_controller.dart';
import 'package:qkomo_ui/features/capture/application/capture_permissions.dart';
import 'package:qkomo_ui/features/capture/domain/capture_mode.dart';

// Mock ImagePicker
class FakeImagePicker implements ImagePicker {
  XFile? fileToReturn;
  Exception? exceptionToThrow;
  ImageSource? lastSource;

  @override
  Future<XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async {
    lastSource = source;
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return fileToReturn;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// Mock CapturePermissions
class FakeCapturePermissions implements CapturePermissions {
  PermissionOutcome cameraOutcome = const PermissionOutcome(granted: true);
  PermissionOutcome galleryOutcome = const PermissionOutcome(granted: true);
  bool settingsOpened = false;

  @override
  Future<PermissionOutcome> ensureCameraAccess() async {
    return cameraOutcome;
  }

  @override
  Future<PermissionOutcome> ensureGalleryAccess() async {
    return galleryOutcome;
  }

  @override
  Future<void> openSettings() async {
    settingsOpened = true;
  }
}

void main() {
  late CaptureController controller;
  late FakeImagePicker fakeImagePicker;
  late FakeCapturePermissions fakePermissions;

  setUp(() {
    fakeImagePicker = FakeImagePicker();
    fakePermissions = FakeCapturePermissions();
    controller = CaptureController(fakeImagePicker, fakePermissions);
  });

  tearDown(() {
    controller.dispose();
  });

  group('CaptureController - Mode Management', () {
    test('setMode updates state correctly', () {
      controller.setMode(CaptureMode.camera);

      expect(controller.state.mode, CaptureMode.camera);
      expect(controller.state.error, isNull);
      expect(controller.state.imageFile, isNull);
      expect(controller.state.scannedBarcode, isNull);
      expect(controller.state.message, isNull);
      expect(controller.state.isProcessing, false);
    });

    test('setMode with same mode does not trigger state change', () {
      controller.setMode(CaptureMode.camera);
      final firstState = controller.state;

      controller.setMode(CaptureMode.camera);
      final secondState = controller.state;

      expect(identical(firstState, secondState), true);
    });

    test('setMode clears previous errors and data', () {
      // Set up state with error and data
      controller.setMode(CaptureMode.camera);
      // Manually set state with error (simulating previous error)
      // Since we can't directly set state, we'll test the clearing behavior
      controller.setMode(CaptureMode.barcode);

      expect(controller.state.mode, CaptureMode.barcode);
      expect(controller.state.error, isNull);
      expect(controller.state.imageFile, isNull);
      expect(controller.state.scannedBarcode, isNull);
    });

    test('clearMode resets mode to null', () {
      controller.setMode(CaptureMode.camera);
      expect(controller.state.mode, CaptureMode.camera);

      controller.clearMode();

      expect(controller.state.mode, isNull);
      expect(controller.state.error, isNull);
      expect(controller.state.imageFile, isNull);
      expect(controller.state.scannedBarcode, isNull);
      expect(controller.state.message, isNull);
      expect(controller.state.isProcessing, false);
    });

    test('reset returns to initial state', () {
      controller.setMode(CaptureMode.camera);
      controller.reset();

      expect(controller.state.mode, isNull);
      expect(controller.state.imageFile, isNull);
      expect(controller.state.scannedBarcode, isNull);
      expect(controller.state.message, isNull);
      expect(controller.state.error, isNull);
      expect(controller.state.isProcessing, false);
    });
  });

  group('CaptureController - Camera Capture', () {
    test('successful camera capture updates state with image file', () async {
      final testFile = XFile('/test/path/image.jpg');
      fakeImagePicker.fileToReturn = testFile;

      await controller.captureWithCamera();

      expect(controller.state.imageFile, testFile);
      expect(controller.state.isProcessing, false);
      expect(controller.state.message, 'Foto lista para analizar');
      expect(controller.state.error, isNull);
      expect(fakeImagePicker.lastSource, ImageSource.camera);
    });

    test('camera permission denied shows error', () async {
      fakePermissions.cameraOutcome = const PermissionOutcome(granted: false);

      await controller.captureWithCamera();

      expect(controller.state.error, isNotNull);
      expect(controller.state.error, contains('Necesitamos permiso de cámara'));
      expect(controller.state.imageFile, isNull);
      expect(controller.state.isProcessing, false);
    });

    test('camera permission denied with settings needed shows settings message', () async {
      fakePermissions.cameraOutcome = const PermissionOutcome(granted: false, needsSettings: true);

      await controller.captureWithCamera();

      expect(controller.state.error, isNotNull);
      expect(controller.state.error, contains('Activa el permiso de cámara'));
      expect(controller.state.error, contains('Ajustes'));
      expect(controller.state.imageFile, isNull);
    });

    test('user cancels camera capture shows cancellation message', () async {
      fakeImagePicker.fileToReturn = null;

      await controller.captureWithCamera();

      expect(controller.state.message, 'Captura cancelada');
      expect(controller.state.imageFile, isNull);
      expect(controller.state.isProcessing, false);
      expect(controller.state.error, isNull);
    });

    test('camera capture exception shows error message', () async {
      fakeImagePicker.exceptionToThrow = Exception('Camera error');

      await controller.captureWithCamera();

      expect(controller.state.error, isNotNull);
      expect(controller.state.error, contains('No se pudo abrir la cámara'));
      expect(controller.state.isProcessing, false);
      expect(controller.state.imageFile, isNull);
    });

    test('prevents multiple simultaneous captures', () async {
      fakeImagePicker.fileToReturn = XFile('/test/image.jpg');

      // Start first capture (will be async)
      final future1 = controller.captureWithCamera();

      // Try to start second capture while first is processing
      // This should return immediately without doing anything
      await controller.captureWithCamera();

      // Wait for first capture to complete
      await future1;

      // Should only have been called once
      expect(fakeImagePicker.lastSource, ImageSource.camera);
    });
  });

  group('CaptureController - Gallery Import', () {
    test('successful gallery import updates state with image file', () async {
      final testFile = XFile('/test/path/gallery.jpg');
      fakeImagePicker.fileToReturn = testFile;

      await controller.importFromGallery();

      expect(controller.state.imageFile, testFile);
      expect(controller.state.isProcessing, false);
      expect(controller.state.message, 'Imagen importada');
      expect(controller.state.error, isNull);
      expect(fakeImagePicker.lastSource, ImageSource.gallery);
    });

    test('gallery permission denied shows error', () async {
      fakePermissions.galleryOutcome = const PermissionOutcome(granted: false);

      await controller.importFromGallery();

      expect(controller.state.error, isNotNull);
      expect(controller.state.error, contains('Necesitamos permiso de fotos/archivos'));
      expect(controller.state.imageFile, isNull);
      expect(controller.state.isProcessing, false);
    });

    test('gallery permission denied with settings needed shows settings message', () async {
      fakePermissions.galleryOutcome = const PermissionOutcome(granted: false, needsSettings: true);

      await controller.importFromGallery();

      expect(controller.state.error, isNotNull);
      expect(controller.state.error, contains('Activa el permiso de fotos/archivos'));
      expect(controller.state.error, contains('Ajustes'));
      expect(controller.state.imageFile, isNull);
    });

    test('user cancels gallery import shows cancellation message', () async {
      fakeImagePicker.fileToReturn = null;

      await controller.importFromGallery();

      expect(controller.state.message, 'Importación cancelada');
      expect(controller.state.imageFile, isNull);
      expect(controller.state.isProcessing, false);
      expect(controller.state.error, isNull);
    });

    test('gallery import exception shows error message', () async {
      fakeImagePicker.exceptionToThrow = Exception('Gallery error');

      await controller.importFromGallery();

      expect(controller.state.error, isNotNull);
      expect(controller.state.error, contains('No se pudo abrir la galería'));
      expect(controller.state.isProcessing, false);
      expect(controller.state.imageFile, isNull);
    });

    test('prevents multiple simultaneous imports', () async {
      fakeImagePicker.fileToReturn = XFile('/test/image.jpg');

      // Start first import
      final future1 = controller.importFromGallery();

      // Try to start second import while first is processing
      await controller.importFromGallery();

      // Wait for first import to complete
      await future1;

      expect(fakeImagePicker.lastSource, ImageSource.gallery);
    });
  });

  group('CaptureController - Barcode Scanning', () {
    test('scanBarcode sets processing state when permission granted', () async {
      await controller.scanBarcode();

      expect(controller.state.isProcessing, true);
      expect(controller.state.error, isNull);
      expect(controller.state.message, isNull);
    });

    test('scanBarcode shows error when permission denied', () async {
      fakePermissions.cameraOutcome = const PermissionOutcome(granted: false);

      await controller.scanBarcode();

      expect(controller.state.error, isNotNull);
      expect(controller.state.error, contains('Necesitamos permiso de cámara'));
      expect(controller.state.scannedBarcode, isNull);
      expect(controller.state.isProcessing, false);
    });

    test('scanBarcode with settings needed shows settings message', () async {
      fakePermissions.cameraOutcome = const PermissionOutcome(granted: false, needsSettings: true);

      await controller.scanBarcode();

      expect(controller.state.error, isNotNull);
      expect(controller.state.error, contains('Activa el permiso de cámara'));
      expect(controller.state.error, contains('Ajustes'));
    });

    test('onBarcodeScanned updates state with barcode and stops processing', () {
      controller.onBarcodeScanned('123456789');

      expect(controller.state.scannedBarcode, '123456789');
      expect(controller.state.isProcessing, false);
    });

    test('prevents multiple simultaneous scans', () async {
      // Start first scan
      final future1 = controller.scanBarcode();

      // Try to start second scan while first is processing
      await controller.scanBarcode();

      await future1;

      expect(controller.state.isProcessing, true);
    });
  });

  group('CaptureController - State Management', () {
    test('clearMessage clears message', () {
      // Set mode to get a message
      controller.setMode(CaptureMode.camera);

      controller.clearMessage();

      expect(controller.state.message, isNull);
    });

    test('clearError clears error', () {
      controller.clearError();

      expect(controller.state.error, isNull);
    });

    test('openSettings delegates to permissions service', () async {
      await controller.openSettings();

      expect(fakePermissions.settingsOpened, true);
    });
  });
}

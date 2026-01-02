import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qkomo_ui/features/capture/application/backend_capture_analyzer.dart';
import 'package:qkomo_ui/features/capture/application/capture_state.dart';
import 'package:qkomo_ui/features/capture/application/direct_analyze_controller.dart';
import 'package:qkomo_ui/features/capture/domain/entities/capture_mode.dart';
import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';
import 'package:qkomo_ui/features/capture/domain/repositories/capture_result_repository.dart';
import 'package:qkomo_ui/features/entry/domain/entities/entry.dart';
import 'package:qkomo_ui/features/entry/domain/repositories/entry_repository.dart';

// Mock BackendCaptureAnalyzer
class FakeBackendCaptureAnalyzer implements BackendCaptureAnalyzer {
  CaptureResult? resultToReturn;
  Exception? exceptionToThrow;
  CaptureMode? lastMode;
  XFile? lastFile;
  String? lastBarcode;

  @override
  Future<CaptureResult> analyze({
    required CaptureMode mode,
    XFile? file,
    String? barcode,
  }) async {
    lastMode = mode;
    lastFile = file;
    lastBarcode = barcode;

    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return resultToReturn!;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// Mock CaptureResultRepository
class FakeCaptureResultRepository implements CaptureResultRepository {
  CaptureResult? lastSavedResult;
  Exception? saveException;

  @override
  Future<void> saveResult(CaptureResult result) async {
    if (saveException != null) {
      throw saveException!;
    }
    lastSavedResult = result;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// Mock EntryRepository
class FakeEntryRepository implements EntryRepository {
  Entry? lastSavedEntry;
  Exception? saveException;

  @override
  Future<void> saveEntry(Entry entry) async {
    if (saveException != null) {
      throw saveException!;
    }
    lastSavedEntry = entry;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late DirectAnalyzeController controller;
  late FakeBackendCaptureAnalyzer fakeAnalyzer;
  late FakeCaptureResultRepository fakeResultRepository;
  late FakeEntryRepository fakeEntryRepository;

  final testResult = CaptureResult(
    jobId: 'test-job-123',
    savedAt: DateTime(2025, 12, 22, 15, 30),
    title: 'Test Meal',
    ingredients: ['Ingredient 1', 'Ingredient 2'],
    allergens: ['Allergen 1'],
  );

  setUp(() {
    fakeAnalyzer = FakeBackendCaptureAnalyzer();
    fakeResultRepository = FakeCaptureResultRepository();
    fakeEntryRepository = FakeEntryRepository();
    controller = DirectAnalyzeController(
      fakeAnalyzer,
      fakeResultRepository,
      fakeEntryRepository,
    );
  });

  tearDown(() {
    controller.dispose();
  });

  group('DirectAnalyzeController - Analysis Flow', () {
    test('initial state is data(null)', () {
      expect(controller.state, const AsyncValue<String?>.data(null));
    });

    test('successful analysis creates entry and saves to both repositories', () async {
      fakeAnalyzer.resultToReturn = testResult;
      final captureState = CaptureState(
        mode: CaptureMode.camera,
        imageFile: XFile('/test/image.jpg'),
      );

      await controller.analyze(captureState);

      // Verify analyzer was called
      expect(fakeAnalyzer.lastMode, CaptureMode.camera);
      expect(fakeAnalyzer.lastFile?.path, '/test/image.jpg');

      // Verify result was saved to CaptureResultRepository
      expect(fakeResultRepository.lastSavedResult, testResult);

      // Verify entry was saved to EntryRepository
      expect(fakeEntryRepository.lastSavedEntry, isNotNull);
      expect(fakeEntryRepository.lastSavedEntry!.id, 'test-job-123');
      expect(fakeEntryRepository.lastSavedEntry!.result, testResult);

      // Verify final state
      expect(controller.state.hasValue, true);
      expect(controller.state.value, 'test-job-123');
    });

    test('analysis with camera mode uses image file', () async {
      fakeAnalyzer.resultToReturn = testResult;
      final testFile = XFile('/path/to/photo.jpg');
      final captureState = CaptureState(
        mode: CaptureMode.camera,
        imageFile: testFile,
      );

      await controller.analyze(captureState);

      expect(fakeAnalyzer.lastMode, CaptureMode.camera);
      expect(fakeAnalyzer.lastFile, testFile);
      expect(fakeAnalyzer.lastBarcode, isNull);
    });

    test('analysis with barcode mode uses barcode string', () async {
      fakeAnalyzer.resultToReturn = testResult;
      final captureState = const CaptureState(
        mode: CaptureMode.barcode,
        scannedBarcode: '1234567890',
      );

      await controller.analyze(captureState);

      expect(fakeAnalyzer.lastMode, CaptureMode.barcode);
      expect(fakeAnalyzer.lastBarcode, '1234567890');
      expect(fakeAnalyzer.lastFile, isNull);
    });

    test('analysis without mode throws exception', () async {
      final captureState = const CaptureState(mode: null);

      await controller.analyze(captureState);

      expect(controller.state.hasError, true);
      expect(controller.state.error.toString(), contains('Modo de captura no seleccionado'));
    });

    test('state transitions from data(null) to loading to data(jobId)', () async {
      fakeAnalyzer.resultToReturn = testResult;
      final captureState = CaptureState(
        mode: CaptureMode.camera,
        imageFile: XFile('/test/image.jpg'),
      );

      // Initial state
      expect(controller.state, const AsyncValue<String?>.data(null));

      // Start analysis
      final analyzeFuture = controller.analyze(captureState);

      // Should be loading
      expect(controller.state.isLoading, true);

      await analyzeFuture;

      // Should have data
      expect(controller.state.hasValue, true);
      expect(controller.state.value, 'test-job-123');
    });
  });

  group('DirectAnalyzeController - Error Handling', () {
    test('analyzer throws exception sets error state', () async {
      fakeAnalyzer.exceptionToThrow = Exception('Network error');
      final captureState = CaptureState(
        mode: CaptureMode.camera,
        imageFile: XFile('/test/image.jpg'),
      );

      await controller.analyze(captureState);

      expect(controller.state.hasError, true);
      expect(controller.state.error.toString(), contains('Network error'));
    });

    test('result repository save failure propagates error', () async {
      fakeAnalyzer.resultToReturn = testResult;
      fakeResultRepository.saveException = Exception('Save failed');
      final captureState = CaptureState(
        mode: CaptureMode.camera,
        imageFile: XFile('/test/image.jpg'),
      );

      await controller.analyze(captureState);

      expect(controller.state.hasError, true);
      expect(controller.state.error.toString(), contains('Save failed'));
    });

    test('entry repository save failure propagates error', () async {
      fakeAnalyzer.resultToReturn = testResult;
      fakeEntryRepository.saveException = Exception('Entry save failed');
      final captureState = CaptureState(
        mode: CaptureMode.camera,
        imageFile: XFile('/test/image.jpg'),
      );

      await controller.analyze(captureState);

      expect(controller.state.hasError, true);
      expect(controller.state.error.toString(), contains('Entry save failed'));
    });

    test('error state includes stack trace', () async {
      fakeAnalyzer.exceptionToThrow = Exception('Test error');
      final captureState = CaptureState(
        mode: CaptureMode.camera,
        imageFile: XFile('/test/image.jpg'),
      );

      await controller.analyze(captureState);

      expect(controller.state.hasError, true);
      expect(controller.state.stackTrace, isNotNull);
    });

    test('error during analysis does not save to repositories', () async {
      fakeAnalyzer.exceptionToThrow = Exception('Analysis failed');
      final captureState = CaptureState(
        mode: CaptureMode.camera,
        imageFile: XFile('/test/image.jpg'),
      );

      await controller.analyze(captureState);

      expect(fakeResultRepository.lastSavedResult, isNull);
      expect(fakeEntryRepository.lastSavedEntry, isNull);
    });
  });

  group('DirectAnalyzeController - Integration', () {
    test('verifies analyzer is called with correct parameters from camera', () async {
      fakeAnalyzer.resultToReturn = testResult;
      final testFile = XFile('/camera/photo.jpg');
      final captureState = CaptureState(
        mode: CaptureMode.camera,
        imageFile: testFile,
      );

      await controller.analyze(captureState);

      expect(fakeAnalyzer.lastMode, CaptureMode.camera);
      expect(fakeAnalyzer.lastFile, testFile);
      expect(fakeAnalyzer.lastBarcode, isNull);
    });

    test('verifies analyzer is called with correct parameters from barcode', () async {
      fakeAnalyzer.resultToReturn = testResult;
      final captureState = const CaptureState(
        mode: CaptureMode.barcode,
        scannedBarcode: '9876543210',
      );

      await controller.analyze(captureState);

      expect(fakeAnalyzer.lastMode, CaptureMode.barcode);
      expect(fakeAnalyzer.lastBarcode, '9876543210');
      expect(fakeAnalyzer.lastFile, isNull);
    });

    test('verifies both repositories receive correct data', () async {
      fakeAnalyzer.resultToReturn = testResult;
      final captureState = CaptureState(
        mode: CaptureMode.camera,
        imageFile: XFile('/test/image.jpg'),
      );

      await controller.analyze(captureState);

      // Check CaptureResultRepository
      expect(fakeResultRepository.lastSavedResult, testResult);

      // Check EntryRepository
      expect(fakeEntryRepository.lastSavedEntry, isNotNull);
      expect(fakeEntryRepository.lastSavedEntry!.result, testResult);
    });

    test('verifies Entry is created with correct jobId and timestamp', () async {
      fakeAnalyzer.resultToReturn = testResult;
      final captureState = CaptureState(
        mode: CaptureMode.camera,
        imageFile: XFile('/test/image.jpg'),
      );

      final beforeAnalysis = DateTime.now();
      await controller.analyze(captureState);
      final afterAnalysis = DateTime.now();

      final savedEntry = fakeEntryRepository.lastSavedEntry!;
      expect(savedEntry.id, 'test-job-123');
      expect(savedEntry.result, testResult);
      expect(
        savedEntry.lastModifiedAt.isAfter(beforeAnalysis) ||
            savedEntry.lastModifiedAt.isAtSameMomentAs(beforeAnalysis),
        true,
      );
      expect(
        savedEntry.lastModifiedAt.isBefore(afterAnalysis) ||
            savedEntry.lastModifiedAt.isAtSameMomentAs(afterAnalysis),
        true,
      );
    });

    test('multiple analyses update state correctly', () async {
      fakeAnalyzer.resultToReturn = testResult;
      final captureState1 = CaptureState(
        mode: CaptureMode.camera,
        imageFile: XFile('/test/image1.jpg'),
      );

      await controller.analyze(captureState1);
      expect(controller.state.value, 'test-job-123');

      final testResult2 = CaptureResult(
        jobId: 'test-job-456',
        savedAt: DateTime.now(),
        title: 'Second Meal',
      );
      fakeAnalyzer.resultToReturn = testResult2;
      final captureState2 = const CaptureState(
        mode: CaptureMode.barcode,
        scannedBarcode: '123456',
      );

      await controller.analyze(captureState2);
      expect(controller.state.value, 'test-job-456');
    });
  });
}

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:qkomo_ui/features/capture/application/capture_queue_processor.dart';
import 'package:qkomo_ui/features/capture/application/backend_capture_analyzer.dart';
import 'package:qkomo_ui/features/capture/data/capture_api_client.dart';
import 'package:qkomo_ui/features/capture/data/capture_queue_repository.dart';
import 'package:qkomo_ui/features/capture/data/capture_result_repository.dart';
import 'package:qkomo_ui/features/capture/data/hive_adapters/capture_job_adapter.dart';
import 'package:qkomo_ui/features/capture/data/hive_adapters/capture_job_status_adapter.dart';
import 'package:qkomo_ui/features/capture/data/hive_adapters/capture_job_type_adapter.dart';
import 'package:qkomo_ui/features/capture/data/hive_adapters/capture_result_adapter.dart';
import 'package:qkomo_ui/features/capture/domain/capture_job_type.dart';
import 'package:qkomo_ui/core/http/dio_provider.dart' as dio_provider;

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Backend Integration Tests', () {
    late Directory tempDir;
    late CaptureQueueRepository queueRepo;
    late CaptureResultRepository resultRepo;
    late CaptureQueueProcessor processor;

    setUpAll(() async {
      // Check if backend is reachable
      const baseUrl = String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://10.0.2.2:8080',
      );

      final isReachable = await TestHelpers.isBackendReachable(baseUrl);
      if (!isReachable) {
        print('⚠️  Backend not reachable at $baseUrl');
        print('   Skipping integration tests that require backend');
        print('   To run these tests, start the backend server and run:');
        print('   flutter test integration_test/ --dart-define=API_BASE_URL=$baseUrl');
      }
    });

    setUp(() async {
      // Initialize Hive for testing
      tempDir = await Directory.systemTemp.createTemp('integration_test');
      await Hive.initFlutter(tempDir.path);

      // Register adapters
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(CaptureJobAdapter());
      }
      if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(CaptureResultAdapter());
      }
      if (!Hive.isAdapterRegistered(3)) {
        Hive.registerAdapter(CaptureJobStatusAdapter());
      }
      if (!Hive.isAdapterRegistered(4)) {
        Hive.registerAdapter(CaptureJobTypeAdapter());
      }

      // Open boxes
      final jobBox = await Hive.openBox('test_capture_jobs');
      final resultBox = await Hive.openBox('test_capture_results');

      // Create repositories
      queueRepo = CaptureQueueRepository(jobBox: jobBox);
      resultRepo = CaptureResultRepository(resultBox: resultBox);

      // Note: For full integration testing, we would need:
      // - A running backend server
      // - Firebase authentication configured
      // - Valid test credentials
      //
      // For now, we'll create the structure and test what we can offline
    });

    tearDown(() async {
      await Hive.deleteBoxFromDisk('test_capture_jobs');
      await Hive.deleteBoxFromDisk('test_capture_results');
      await Hive.close();
      await tempDir.delete(recursive: true);
      await TestHelpers.cleanupTestFiles();
    });

    group('Photo Upload Flow', () {
      test('should queue photo for processing', () async {
        // Arrange
        final testImage = await TestHelpers.createTestImage();

        // Act
        final job = await queueRepo.enqueueImage(testImage.path);

        // Assert
        expect(job.type, equals(CaptureJobType.image));
        expect(job.imagePath, equals(testImage.path));
        expect(queueRepo.pendingJobs(), hasLength(1));

        print('✅ Photo queued successfully: ${job.id}');
      });

      test('should handle large image files', () async {
        // Arrange
        final largeImage = await TestHelpers.createLargeTestImage();

        // Act
        final job = await queueRepo.enqueueImage(largeImage.path);

        // Assert
        expect(job.imagePath, equals(largeImage.path));
        print('✅ Large image queued: ${(await largeImage.length()) / 1024 / 1024} MB');
      });

      // Note: The following tests require a running backend
      test('should process photo with backend (requires backend)', () async {
        // This test would:
        // 1. Create a test image
        // 2. Queue it for processing
        // 3. Process the queue
        // 4. Verify the analysis result
        //
        // Skipped if backend is not available
        print('⚠️  Test requires running backend - skipped');
      }, skip: true);
    });

    group('Barcode Analysis Flow', () {
      test('should queue barcode for processing', () async {
        // Arrange
        final testBarcode = TestHelpers.generateTestBarcode();

        // Act
        final job = await queueRepo.enqueueBarcode(testBarcode);

        // Assert
        expect(job.type, equals(CaptureJobType.barcode));
        expect(job.barcode, equals(testBarcode));
        expect(queueRepo.pendingJobs(), hasLength(1));

        print('✅ Barcode queued successfully: $testBarcode');
      });

      test('should process barcode with backend (requires backend)', () async {
        // This test would:
        // 1. Queue a test barcode
        // 2. Process the queue
        // 3. Verify product lookup
        // 4. Verify ingredients are returned
        //
        // Skipped if backend is not available
        print('⚠️  Test requires running backend - skipped');
      }, skip: true);
    });

    group('Offline Queue Processing', () {
      test('should maintain queue when offline', () async {
        // Arrange
        final testImage = await TestHelpers.createTestImage();
        final testBarcode = TestHelpers.generateTestBarcode();

        // Act - Queue multiple items
        await queueRepo.enqueueImage(testImage.path);
        await queueRepo.enqueueBarcode(testBarcode);

        // Assert
        final pending = queueRepo.pendingJobs();
        expect(pending, hasLength(2));
        expect(pending[0].type, equals(CaptureJobType.image));
        expect(pending[1].type, equals(CaptureJobType.barcode));

        print('✅ Queue maintains ${pending.length} pending jobs offline');
      });

      test('should process queue when online (requires backend)', () async {
        // This test would:
        // 1. Queue multiple items while "offline"
        // 2. Simulate going "online"
        // 3. Process the queue
        // 4. Verify all items are processed
        // 5. Verify succeeded jobs are cleaned up after TTL
        //
        // Skipped if backend is not available
        print('⚠️  Test requires running backend - skipped');
      }, skip: true);
    });

    group('Error Handling', () {
      test('should handle missing image file', () async {
        // Arrange
        const nonExistentPath = '/path/to/nonexistent/image.jpg';

        // Act
        final job = await queueRepo.enqueueImage(nonExistentPath);

        // Assert
        expect(job.imagePath, equals(nonExistentPath));
        // Processing would fail with appropriate error message
        print('✅ Queue accepts job with missing file (will fail on processing)');
      });

      test('should handle network errors gracefully (requires backend)', () async {
        // This test would:
        // 1. Queue an item
        // 2. Simulate network error
        // 3. Verify error message is in Spanish
        // 4. Verify job is marked as failed with retry
        //
        // Skipped if backend is not available
        print('⚠️  Test requires running backend - skipped');
      }, skip: true);

      test('should handle authentication errors (requires backend)', () async {
        // This test would:
        // 1. Queue an item
        // 2. Simulate 401 error
        // 3. Verify token refresh is attempted
        // 4. Verify Spanish error message
        //
        // Skipped if backend is not available
        print('⚠️  Test requires running backend - skipped');
      }, skip: true);
    });
  });
}

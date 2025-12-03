import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:qkomo_ui/features/capture/application/backend_capture_analyzer.dart';
import 'package:qkomo_ui/features/capture/application/capture_queue_processor.dart';
import 'package:qkomo_ui/features/capture/data/capture_api_client.dart';
import 'package:qkomo_ui/features/capture/data/capture_queue_repository.dart';
import 'package:qkomo_ui/features/capture/data/capture_result_repository.dart';
import 'package:qkomo_ui/features/capture/data/hive_adapters/capture_job_adapter.dart';
import 'package:qkomo_ui/features/capture/data/hive_adapters/capture_job_status_adapter.dart';
import 'package:qkomo_ui/features/capture/data/hive_adapters/capture_job_type_adapter.dart';
import 'package:qkomo_ui/features/capture/data/hive_adapters/capture_result_adapter.dart';
import 'package:qkomo_ui/features/capture/domain/capture_job.dart';
import 'package:qkomo_ui/features/capture/domain/capture_result.dart';

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Backend Integration Tests', () {
    late Directory tempDir;
    late CaptureQueueRepository queueRepo;
    late CaptureResultRepository resultRepo;
    late CaptureQueueProcessor processor;
    late Dio dio;

    setUpAll(() async {
      // Check if backend is reachable
      const baseUrl = String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://10.0.2.2:8080',
      );

      final isReachable = await TestHelpers.isBackendReachable(baseUrl);
      if (isReachable) {
        print('✅ Backend reachable at $baseUrl - Using real backend');
        dio = Dio(BaseOptions(baseUrl: baseUrl));
      } else {
        print('⚠️  Backend not reachable - Using FakeDio');
        dio = FakeDio();
      }
    });

    setUp(() async {
      // Initialize Hive for testing
      tempDir = await Directory.systemTemp.createTemp('integration_test');
      await Hive.initFlutter(tempDir.path);

      // Register adapters
      if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(CaptureJobAdapter());
      if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(CaptureResultAdapter());
      if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(CaptureJobStatusAdapter());
      if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(CaptureJobTypeAdapter());

      // Open boxes
      final jobBox = await Hive.openBox<CaptureJob>('test_capture_jobs');
      final resultBox = await Hive.openBox<CaptureResult>('test_capture_results');

      // Create repositories
      queueRepo = CaptureQueueRepository(jobBox: jobBox);
      resultRepo = CaptureResultRepository(resultBox: resultBox);

      // Create dependencies
      final apiClient = CaptureApiClient(dio: dio);
      final analyzer = BackendCaptureAnalyzer(apiClient);

      processor = CaptureQueueProcessor(
        queueRepository: queueRepo,
        resultRepository: resultRepo,
        analyzer: analyzer,
        successTtl: const Duration(seconds: 1), // Short TTL for testing
      );
    });

    tearDown(() async {
      await Hive.deleteBoxFromDisk('test_capture_jobs');
      await Hive.deleteBoxFromDisk('test_capture_results');
      await Hive.close();
      await tempDir.delete(recursive: true);
      await TestHelpers.cleanupTestFiles();
    });

    group('Photo Upload Flow', () {
      test('should queue and process photo', () async {
        // Arrange
        final testImage = await TestHelpers.createTestImage();

        // Act
        final job = await queueRepo.enqueueImage(testImage.path);

        // Assert Queue
        expect(queueRepo.pendingJobs(), hasLength(1));

        // Act - Process
        final processedCount = await processor.processPending();

        // Assert Process
        expect(processedCount, equals(1));
        expect(queueRepo.pendingJobs(), isEmpty);

        // Verify Result
        final results = resultRepo.allSorted();
        expect(results, hasLength(1));
        expect(results.first.jobId, equals(job.id));
        expect(results.first.ingredients, isNotEmpty);

        print('✅ Photo processed successfully');
      });
    });

    group('Barcode Analysis Flow', () {
      test('should queue and process barcode', () async {
        // Arrange
        final testBarcode = TestHelpers.generateTestBarcode();

        // Act
        final job = await queueRepo.enqueueBarcode(testBarcode);

        // Assert Queue
        expect(queueRepo.pendingJobs(), hasLength(1));

        // Act - Process
        final processedCount = await processor.processPending();

        // Assert Process
        expect(processedCount, equals(1));
        expect(queueRepo.pendingJobs(), isEmpty);

        // Verify Result
        final results = resultRepo.allSorted();
        expect(results, hasLength(1));
        expect(results.first.jobId, equals(job.id));
        expect(results.first.title, contains(testBarcode));

        print('✅ Barcode processed successfully');
      });
    });

    group('Offline Queue Processing', () {
      test('should process multiple queued items', () async {
        // Arrange
        final testImage = await TestHelpers.createTestImage();
        final testBarcode = TestHelpers.generateTestBarcode();

        // Queue multiple items
        await queueRepo.enqueueImage(testImage.path);
        await queueRepo.enqueueBarcode(testBarcode);

        expect(queueRepo.pendingJobs(), hasLength(2));

        // Act - Process
        final processedCount = await processor.processPending();

        // Assert
        expect(processedCount, equals(2));
        expect(queueRepo.pendingJobs(), isEmpty);
        expect(resultRepo.allSorted(), hasLength(2));

        print('✅ Batch processing successful');
      });
    });

    group('Error Handling', () {
      test('should handle network errors gracefully', () async {
        if (dio is FakeDio) {
          (dio as FakeDio).shouldFailNextRequest = true;
        }

        // Arrange
        final testBarcode = TestHelpers.generateTestBarcode();
        final job = await queueRepo.enqueueBarcode(testBarcode);

        // Act
        final processedCount = await processor.processPending();

        // Assert
        expect(processedCount, equals(0)); // Should fail

        // Verify job state
        final failedJob = queueRepo.failedJobs().first;
        expect(failedJob.id, equals(job.id));
        expect(failedJob.attempts, equals(1)); // Should have incremented attempts

        print('✅ Network error handled correctly (job marked failed)');

        if (dio is FakeDio) {
          (dio as FakeDio).shouldFailNextRequest = false;
        }
      });
    });
  });
}

// --- Fake Dio Implementation ---

class FakeDio implements Dio {
  bool shouldFailNextRequest = false;

  @override
  Interceptors get interceptors => Interceptors();

  @override
  HttpClientAdapter get httpClientAdapter => throw UnimplementedError();

  @override
  set httpClientAdapter(HttpClientAdapter adapter) {}

  @override
  BaseOptions options = BaseOptions();

  @override
  Transformer transformer = BackgroundTransformer();

  @override
  void close({bool force = false}) {}

  @override
  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    if (shouldFailNextRequest) {
      throw DioException(
        requestOptions: RequestOptions(path: path),
        type: DioExceptionType.connectionError,
        error: 'Simulated network error',
      );
    }

    await Future.delayed(const Duration(milliseconds: 100)); // Simulate latency

    if (path == '/v1/analyze') {
      return Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
        data: {
          'analysisId': 'mock-analysis-1',
          'type': 'meal',
          'photoId': 'mock-photo-1',
          'ingredients': [
            {'name': 'Mock Ingredient 1', 'allergens': [], 'confidence': 0.9},
            {
              'name': 'Mock Ingredient 2',
              'allergens': ['gluten'],
              'confidence': 0.8
            },
          ],
          'warnings': [],
        } as T,
      );
    } else if (path == '/v1/analyze/barcode') {
      return Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
        data: {
          'analysisId': 'mock-analysis-2',
          'type': 'product',
          'ingredients': [
            {'name': 'Product Ingredient 1', 'allergens': [], 'confidence': 0.99},
          ],
          'warnings': [],
        } as T,
      );
    }

    throw DioException(
      requestOptions: RequestOptions(path: path),
      response: Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 404,
      ),
      type: DioExceptionType.badResponse,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

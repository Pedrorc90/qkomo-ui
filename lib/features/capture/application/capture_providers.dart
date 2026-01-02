import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qkomo_ui/core/http/dio_provider.dart';
import 'package:qkomo_ui/core/utils/hive_stream_utils.dart';
import 'package:qkomo_ui/features/capture/application/backend_capture_analyzer.dart';
import 'package:qkomo_ui/features/capture/application/capture_controller.dart';
import 'package:qkomo_ui/features/capture/application/capture_permissions.dart';
import 'package:qkomo_ui/features/capture/application/capture_review_controller.dart';
import 'package:qkomo_ui/features/capture/application/capture_state.dart';
import 'package:qkomo_ui/features/capture/application/direct_analyze_controller.dart';
import 'package:qkomo_ui/features/capture/application/text_entry_controller.dart';
import 'package:qkomo_ui/features/capture/data/capture_api_client.dart';
import 'package:qkomo_ui/features/capture/data/capture_result_repository.dart'
    as impl;
import 'package:qkomo_ui/features/capture/data/hive_boxes.dart';
import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';
import 'package:qkomo_ui/features/capture/domain/repositories/capture_result_repository.dart';
import 'package:qkomo_ui/features/capture/domain/usecases/create_manual_entry.dart';
import 'package:qkomo_ui/features/capture/domain/usecases/get_month_results.dart';
import 'package:qkomo_ui/features/capture/domain/usecases/get_results_by_date_range.dart';
import 'package:qkomo_ui/features/capture/domain/usecases/get_today_results.dart';
import 'package:qkomo_ui/features/capture/domain/usecases/get_week_results.dart';
import 'package:qkomo_ui/features/capture/domain/usecases/save_capture_result.dart';
import 'package:qkomo_ui/features/entry/application/entry_providers.dart';

final imagePickerProvider = Provider<ImagePicker>((ref) {
  return ImagePicker();
});

final capturePermissionsProvider = Provider<CapturePermissions>((ref) {
  return CapturePermissions();
});

final captureControllerProvider =
    StateNotifierProvider.autoDispose<CaptureController, CaptureState>((ref) {
  final picker = ref.watch(imagePickerProvider);
  final permissions = ref.watch(capturePermissionsProvider);
  return CaptureController(picker, permissions);
});

final captureResultBoxProvider = Provider<Box<CaptureResult>>((ref) {
  return Hive.box<CaptureResult>(HiveBoxes.captureResults);
});

final captureResultRepositoryProvider =
    Provider<CaptureResultRepository>((ref) {
  final box = ref.watch(captureResultBoxProvider);
  return impl.CaptureResultRepositoryImpl(resultBox: box);
});

final captureApiClientProvider = Provider<CaptureApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return CaptureApiClient(dio: dio);
});

final captureAnalyzerProvider = Provider((ref) {
  final apiClient = ref.watch(captureApiClientProvider);
  return BackendCaptureAnalyzer(apiClient);
});

final captureResultsProvider = StreamProvider<List<CaptureResult>>((ref) {
  final box = ref.watch(captureResultBoxProvider);

  return createHiveStream(
    ref: ref,
    box: box,
    transformer: (box) {
      final items = box.values.toList();
      items.sort((a, b) => b.savedAt.compareTo(a.savedAt));
      return items;
    },
  );
});

// UseCase providers
final createManualEntryProvider = Provider<CreateManualEntry>((ref) {
  return CreateManualEntry();
});

final saveCaptureResultProvider = Provider<SaveCaptureResult>((ref) {
  final repository = ref.watch(captureResultRepositoryProvider);
  return SaveCaptureResult(repository);
});

final getTodayResultsProvider = Provider<GetTodayResults>((ref) {
  final repository = ref.watch(captureResultRepositoryProvider);
  return GetTodayResults(repository);
});

final getWeekResultsProvider = Provider<GetWeekResults>((ref) {
  final repository = ref.watch(captureResultRepositoryProvider);
  return GetWeekResults(repository);
});

final getMonthResultsProvider = Provider<GetMonthResults>((ref) {
  final repository = ref.watch(captureResultRepositoryProvider);
  return GetMonthResults(repository);
});

final getResultsByDateRangeProvider = Provider<GetResultsByDateRange>((ref) {
  final repository = ref.watch(captureResultRepositoryProvider);
  return GetResultsByDateRange(repository);
});

final textEntryControllerProvider =
    StateNotifierProvider<TextEntryController, AsyncValue<CaptureResult?>>(
        (ref) {
  final createManualEntry = ref.watch(createManualEntryProvider);
  final saveCaptureResult = ref.watch(saveCaptureResultProvider);
  return TextEntryController(createManualEntry, saveCaptureResult);
});

final captureReviewControllerProvider = StateNotifierProvider.family<
    CaptureReviewController, CaptureReviewState, String>((ref, resultId) {
  final resultRepo = ref.watch(captureResultRepositoryProvider);
  final entryRepo = ref.watch(entryRepositoryProvider);
  return CaptureReviewController(
    resultId: resultId,
    resultRepository: resultRepo,
    entryRepository: entryRepo,
  );
});

final directAnalyzeControllerProvider = StateNotifierProvider.autoDispose<
    DirectAnalyzeController, AsyncValue<String?>>((ref) {
  final analyzer = ref.watch(captureAnalyzerProvider);
  final resultRepo = ref.watch(captureResultRepositoryProvider);
  final entryRepo = ref.watch(entryRepositoryProvider);
  return DirectAnalyzeController(analyzer, resultRepo, entryRepo);
});

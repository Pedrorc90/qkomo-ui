import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../menu/domain/meal_type.dart';
import '../data/capture_result_repository.dart';
import '../domain/capture_result.dart';

class TextEntryController extends StateNotifier<AsyncValue<CaptureResult?>> {
  TextEntryController(this._captureResultRepository)
      : super(const AsyncValue.data(null));

  final CaptureResultRepository _captureResultRepository;
  final Uuid _uuid = const Uuid();

  Future<void> saveTextEntry({
    required String title,
    required List<String> ingredients,
    List<String>? allergens,
    String? notes,
    MealType? mealType,
  }) async {
    state = const AsyncValue.loading();
    try {
      final result = CaptureResult(
        jobId: _uuid.v4(),
        savedAt: DateTime.now(),
        title: title,
        ingredients: ingredients,
        allergens: allergens ?? [],
        notes: notes,
        mealType: mealType,
        isManualEntry: true,
      );

      await _captureResultRepository.saveResult(result);
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

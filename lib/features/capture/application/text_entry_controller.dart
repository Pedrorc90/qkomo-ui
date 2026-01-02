import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';
import 'package:qkomo_ui/features/capture/domain/usecases/create_manual_entry.dart';
import 'package:qkomo_ui/features/capture/domain/usecases/save_capture_result.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';

class TextEntryController extends StateNotifier<AsyncValue<CaptureResult?>> {
  TextEntryController(this._createManualEntry, this._saveCaptureResult)
      : super(const AsyncValue.data(null));

  final CreateManualEntry _createManualEntry;
  final SaveCaptureResult _saveCaptureResult;

  Future<void> saveTextEntry({
    required String title,
    required List<String> ingredients,
    List<String>? allergens,
    String? notes,
    MealType? mealType,
  }) async {
    state = const AsyncValue.loading();
    try {
      // Create manual entry using UseCase
      final result = _createManualEntry(CreateManualEntryParams(
        title: title,
        ingredients: ingredients,
        allergens: allergens,
        notes: notes,
        mealType: mealType,
      ));

      // Save using UseCase
      await _saveCaptureResult(result);
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

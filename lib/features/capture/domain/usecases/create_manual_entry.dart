import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';
import 'package:uuid/uuid.dart';

/// Parameters for creating a manual entry
class CreateManualEntryParams {
  const CreateManualEntryParams({
    required this.title,
    required this.ingredients,
    this.allergens,
    this.notes,
    this.mealType,
  });

  final String title;
  final List<String> ingredients;
  final List<String>? allergens;
  final String? notes;
  final MealType? mealType;
}

/// UseCase: Create a manual text entry (no image/barcode)
///
/// Allows users to manually input food data without scanning.
class CreateManualEntry {
  CreateManualEntry({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;

  CaptureResult call(CreateManualEntryParams params) {
    return CaptureResult(
      jobId: _uuid.v4(),
      title: params.title,
      ingredients: params.ingredients,
      allergens: params.allergens ?? [],
      savedAt: DateTime.now(),
      notes: params.notes,
      mealType: params.mealType,
      isManualEntry: true,
    );
  }
}

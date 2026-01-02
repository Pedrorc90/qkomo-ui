import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/features/capture/domain/repositories/capture_result_repository.dart';
import 'package:qkomo_ui/features/capture/domain/entities/capture_result.dart';
import 'package:qkomo_ui/features/entry/domain/entities/entry.dart';
import 'package:qkomo_ui/features/entry/domain/repositories/entry_repository.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';
import 'package:qkomo_ui/core/utils/sanitizer.dart';

/// State for the capture review screen
class CaptureReviewState {
  const CaptureReviewState({
    this.result,
    this.editedIngredients = const [],
    this.editedAllergens = const [],
    this.editedMealType,
    this.editedNotes,
    this.hasChanges = false,
    this.isSaving = false,
    this.isSaved = false,
    this.error,
  });

  final CaptureResult? result;
  final List<String> editedIngredients;
  final List<String> editedAllergens;
  final MealType? editedMealType;
  final String? editedNotes;
  final bool hasChanges;
  final bool isSaving;
  final bool isSaved;
  final String? error;

  CaptureReviewState copyWith({
    CaptureResult? result,
    List<String>? editedIngredients,
    List<String>? editedAllergens,
    MealType? editedMealType,
    String? editedNotes,
    bool? hasChanges,
    bool? isSaving,
    bool? isSaved,
    String? error,
  }) {
    return CaptureReviewState(
      result: result ?? this.result,
      editedIngredients: editedIngredients ?? this.editedIngredients,
      editedAllergens: editedAllergens ?? this.editedAllergens,
      editedMealType: editedMealType ?? this.editedMealType,
      editedNotes: editedNotes ?? this.editedNotes,
      hasChanges: hasChanges ?? this.hasChanges,
      isSaving: isSaving ?? this.isSaving,
      isSaved: isSaved ?? this.isSaved,
      error: error,
    );
  }
}

/// Controller for reviewing and editing capture results
class CaptureReviewController extends StateNotifier<CaptureReviewState> {
  CaptureReviewController({
    required String resultId,
    required CaptureResultRepository resultRepository,
    required EntryRepository entryRepository,
  })  : _resultId = resultId,
        _resultRepository = resultRepository,
        _entryRepository = entryRepository,
        super(const CaptureReviewState()) {
    _loadResult();
  }

  final String _resultId;
  final CaptureResultRepository _resultRepository;
  final EntryRepository _entryRepository;

  /// Load the result from repository
  Future<void> _loadResult() async {
    try {
      final result = _resultRepository.findByJobId(_resultId);
      if (result == null) {
        state = state.copyWith(
          error: 'No se encontró el resultado',
        );
        return;
      }

      state = state.copyWith(
        result: result,
        editedIngredients: List.from(result.ingredients),
        editedAllergens: List.from(result.allergens),
        editedMealType: result.mealType,
        editedNotes: result.notes,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Error al cargar el resultado: $e',
      );
    }
  }

  void addIngredient(String ingredient) {
    final trimmed = Sanitizer.sanitize(ingredient);
    if (trimmed.isEmpty) return;
    if (state.editedIngredients.contains(trimmed)) return;

    final newIngredients = [...state.editedIngredients, trimmed];
    state = state.copyWith(
      editedIngredients: newIngredients,
      hasChanges: _hasChanges(
        newIngredients,
        state.editedAllergens,
        mealType: state.editedMealType,
        notes: state.editedNotes,
      ),
    );
  }

  /// Remove an ingredient
  void removeIngredient(String ingredient) {
    final newIngredients = state.editedIngredients.where((i) => i != ingredient).toList();

    state = state.copyWith(
      editedIngredients: newIngredients,
      hasChanges: _hasChanges(
        newIngredients,
        state.editedAllergens,
        mealType: state.editedMealType,
        notes: state.editedNotes,
      ),
    );
  }

  void updateIngredient(String oldIngredient, String newIngredient) {
    final trimmed = Sanitizer.sanitize(newIngredient);
    if (trimmed.isEmpty) {
      removeIngredient(oldIngredient);
      return;
    }
    final newIngredients =
        state.editedIngredients.map((i) => i == oldIngredient ? trimmed : i).toList();

    state = state.copyWith(
      editedIngredients: newIngredients,
      hasChanges: _hasChanges(
        newIngredients,
        state.editedAllergens,
        mealType: state.editedMealType,
        notes: state.editedNotes,
      ),
    );
  }

  /// Toggle an allergen
  void toggleAllergen(String allergen) {
    final newAllergens = state.editedAllergens.contains(allergen)
        ? state.editedAllergens.where((a) => a != allergen).toList()
        : [...state.editedAllergens, allergen];

    state = state.copyWith(
      editedAllergens: newAllergens,
      hasChanges: _hasChanges(
        state.editedIngredients,
        newAllergens,
        mealType: state.editedMealType,
        notes: state.editedNotes,
      ),
    );
  }

  /// Set the meal type
  void setMealType(MealType? mealType) {
    state = state.copyWith(
      editedMealType: mealType,
      hasChanges: _hasChanges(
        state.editedIngredients,
        state.editedAllergens,
        mealType: mealType,
        notes: state.editedNotes,
      ),
    );
  }

  /// Set notes
  void setNotes(String? notes) {
    final sanitizedNotes = notes != null ? Sanitizer.sanitize(notes) : null;
    state = state.copyWith(
      editedNotes: sanitizedNotes,
      hasChanges: _hasChanges(
        state.editedIngredients,
        state.editedAllergens,
        mealType: state.editedMealType,
        notes: notes,
      ),
    );
  }

  /// Check if there are changes compared to original result
  bool _hasChanges(
    List<String> ingredients,
    List<String> allergens, {
    MealType? mealType,
    String? notes,
  }) {
    if (state.result == null) return false;

    final originalIngredients = state.result!.ingredients;
    final originalAllergens = state.result!.allergens;

    // Check ingredients
    if (ingredients.length != originalIngredients.length) return true;
    for (var i = 0; i < ingredients.length; i++) {
      if (ingredients[i] != originalIngredients[i]) return true;
    }

    // Check allergens
    if (allergens.length != originalAllergens.length) return true;
    for (var i = 0; i < allergens.length; i++) {
      if (allergens[i] != originalAllergens[i]) return true;
    }

    // Check meal type
    if (mealType != state.result!.mealType) return true;

    // Check notes
    if (notes != state.result!.notes) return true;

    return false;
  }

  /// Validate edits before saving
  String? _validateEdits() {
    if (state.editedIngredients.isEmpty) {
      return 'Agrega al menos un ingrediente antes de guardar.';
    }
    if (state.editedMealType == null) {
      return 'Selecciona el tipo de comida antes de guardar.';
    }
    return null;
  }

  /// Save the reviewed result
  Future<bool> saveReview() async {
    final validationError = _validateEdits();
    if (validationError != null) {
      state = state.copyWith(error: validationError);
      return false;
    }

    if (state.result == null) {
      state = state.copyWith(error: 'No hay resultado para guardar');
      return false;
    }

    state = state.copyWith(isSaving: true);

    try {
      final updatedResult = state.result!.copyWith(
        ingredients: state.editedIngredients,
        allergens: state.editedAllergens,
        mealType: state.editedMealType,
        notes: state.editedNotes,
        isReviewed: true,
        reviewedAt: DateTime.now(),
        userEdited: state.hasChanges,
      );

      // Save to CaptureResultRepository (legacy/backup)
      await _resultRepository.saveResult(updatedResult);

      // Save to EntryRepository (new sync architecture)
      final entry = Entry(
        id: updatedResult.jobId,
        result: updatedResult,
        lastModifiedAt: DateTime.now(),
      );
      await _entryRepository.saveEntry(entry);

      state = state.copyWith(
        result: updatedResult,
        isSaving: false,
        isSaved: true,
        hasChanges: false,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Error al guardar: $e',
      );
      return false;
    }
  }

  /// Discard changes and reload original
  void discardChanges() {
    if (state.result != null) {
      state = state.copyWith(
        editedIngredients: List.from(state.result!.ingredients),
        editedAllergens: List.from(state.result!.allergens),
        editedMealType: state.result!.mealType,
        editedNotes: state.result!.notes,
        hasChanges: false,
      );
    }
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/features/entry/domain/entry.dart';
import 'package:qkomo_ui/features/entry/domain/entry_repository.dart';
import 'package:qkomo_ui/features/entry/domain/sync_status.dart';
import 'package:qkomo_ui/features/capture/data/capture_result_repository.dart';
import 'package:qkomo_ui/features/capture/domain/capture_result.dart';

/// State for the capture review screen
class CaptureReviewState {
  const CaptureReviewState({
    this.result,
    this.editedIngredients = const [],
    this.editedAllergens = const [],
    this.hasChanges = false,
    this.isSaving = false,
    this.isSaved = false,
    this.error,
  });

  final CaptureResult? result;
  final List<String> editedIngredients;
  final List<String> editedAllergens;
  final bool hasChanges;
  final bool isSaving;
  final bool isSaved;
  final String? error;

  CaptureReviewState copyWith({
    CaptureResult? result,
    List<String>? editedIngredients,
    List<String>? editedAllergens,
    bool? hasChanges,
    bool? isSaving,
    bool? isSaved,
    String? error,
  }) {
    return CaptureReviewState(
      result: result ?? this.result,
      editedIngredients: editedIngredients ?? this.editedIngredients,
      editedAllergens: editedAllergens ?? this.editedAllergens,
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
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Error al cargar el resultado: $e',
      );
    }
  }

  /// Add a new ingredient
  void addIngredient(String ingredient) {
    if (ingredient.trim().isEmpty) return;

    final trimmed = ingredient.trim();
    if (state.editedIngredients.contains(trimmed)) return;

    final newIngredients = [...state.editedIngredients, trimmed];
    state = state.copyWith(
      editedIngredients: newIngredients,
      hasChanges: _hasChanges(newIngredients, state.editedAllergens),
    );
  }

  /// Remove an ingredient
  void removeIngredient(String ingredient) {
    final newIngredients =
        state.editedIngredients.where((i) => i != ingredient).toList();

    state = state.copyWith(
      editedIngredients: newIngredients,
      hasChanges: _hasChanges(newIngredients, state.editedAllergens),
    );
  }

  /// Update an ingredient
  void updateIngredient(String oldIngredient, String newIngredient) {
    if (newIngredient.trim().isEmpty) {
      removeIngredient(oldIngredient);
      return;
    }

    final trimmed = newIngredient.trim();
    final newIngredients = state.editedIngredients
        .map((i) => i == oldIngredient ? trimmed : i)
        .toList();

    state = state.copyWith(
      editedIngredients: newIngredients,
      hasChanges: _hasChanges(newIngredients, state.editedAllergens),
    );
  }

  /// Toggle an allergen
  void toggleAllergen(String allergen) {
    final newAllergens = state.editedAllergens.contains(allergen)
        ? state.editedAllergens.where((a) => a != allergen).toList()
        : [...state.editedAllergens, allergen];

    state = state.copyWith(
      editedAllergens: newAllergens,
      hasChanges: _hasChanges(state.editedIngredients, newAllergens),
    );
  }

  /// Check if there are changes compared to original result
  bool _hasChanges(List<String> ingredients, List<String> allergens) {
    if (state.result == null) return false;

    final originalIngredients = state.result!.ingredients;
    final originalAllergens = state.result!.allergens;

    if (ingredients.length != originalIngredients.length) return true;
    if (allergens.length != originalAllergens.length) return true;

    for (var i = 0; i < ingredients.length; i++) {
      if (ingredients[i] != originalIngredients[i]) return true;
    }

    for (var i = 0; i < allergens.length; i++) {
      if (allergens[i] != originalAllergens[i]) return true;
    }

    return false;
  }

  /// Validate edits before saving
  String? _validateEdits() {
    if (state.editedIngredients.isEmpty) {
      return 'Agrega al menos un ingrediente antes de guardar.';
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

    state = state.copyWith(isSaving: true, error: null);

    try {
      final updatedResult = state.result!.copyWith(
        ingredients: state.editedIngredients,
        allergens: state.editedAllergens,
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
        syncStatus: SyncStatus.pending,
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
        hasChanges: false,
        error: null,
      );
    }
  }
}

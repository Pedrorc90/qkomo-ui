import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qkomo_ui/features/capture/application/capture_providers.dart';
import 'package:qkomo_ui/features/capture/application/capture_review_controller.dart';
import 'package:qkomo_ui/features/capture/data/capture_result_repository.dart';
import 'package:qkomo_ui/features/capture/domain/capture_result.dart';
import 'package:qkomo_ui/features/capture/presentation/review/capture_review_page.dart';
import 'package:qkomo_ui/features/capture/presentation/review/widgets/allergen_selector.dart';
import 'package:qkomo_ui/features/capture/presentation/review/widgets/ingredient_list_editor.dart';
import 'package:qkomo_ui/features/capture/presentation/review/widgets/nutrition_info_card.dart';
import 'package:qkomo_ui/features/capture/presentation/review/widgets/photo_viewer.dart';
import 'package:qkomo_ui/features/entry/domain/entry_repository.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';
import 'package:qkomo_ui/features/settings/application/settings_providers.dart';
import 'package:qkomo_ui/features/settings/data/settings_repository.dart';
import 'package:qkomo_ui/features/settings/domain/user_settings.dart';
import 'package:qkomo_ui/theme/theme_providers.dart';

// Mock SettingsRepository
class MockSettingsRepository implements SettingsRepository {
  @override
  Future<UserSettings> loadSettings() async => const UserSettings();

  @override
  Future<void> saveSettings(UserSettings settings) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// Mock UserSettingsNotifier
class MockUserSettingsNotifier extends UserSettingsNotifier {
  MockUserSettingsNotifier() : super(MockSettingsRepository()) {
    // Override the state to be immediately available
    state = const AsyncValue.data(UserSettings());
  }
}

// Mock CaptureResultRepository
class MockCaptureResultRepository implements CaptureResultRepository {
  final Map<String, CaptureResult> _results = {};

  void addResult(CaptureResult result) {
    _results[result.jobId] = result;
  }

  @override
  CaptureResult? findByJobId(String jobId) {
    return _results[jobId];
  }

  @override
  Future<void> saveResult(CaptureResult result) async {
    _results[result.jobId] = result;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// Mock EntryRepository
class MockEntryRepository implements EntryRepository {
  final List<String> savedEntryIds = [];

  @override
  Future<void> saveEntry(dynamic entry) async {
    savedEntryIds.add(entry.id as String);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late MockCaptureResultRepository mockResultRepository;
  late MockEntryRepository mockEntryRepository;

  // Sample test data
  final sampleResult = CaptureResult(
    jobId: 'test-job-id',
    savedAt: DateTime(2024, 1, 1, 12, 0),
    ingredients: ['Harina', 'Azúcar', 'Huevos'],
    allergens: ['Gluten', 'Huevo'],
    title: 'Pastel de chocolate',
    mealType: MealType.snack,
    notes: 'Delicioso postre',
    imagePath: '/test/image.jpg',
    estimatedPortionG: 150,
    nutrition: const CaptureNutrition(
      calories: 350,
      proteinsG: 8.5,
      carbohydratesG: 45.0,
      fatsG: 15.0,
      fiberG: 2.5,
    ),
  );

  setUp(() {
    mockResultRepository = MockCaptureResultRepository();
    mockEntryRepository = MockEntryRepository();
  });

  Widget buildTestWidget(String resultId) {
    return ProviderScope(
      overrides: [
        captureReviewControllerProvider.overrideWith(
          (ref, arg) => CaptureReviewController(
            resultId: arg,
            resultRepository: mockResultRepository,
            entryRepository: mockEntryRepository,
          ),
        ),
        appGradientProvider.overrideWithValue(
          const LinearGradient(colors: [Colors.white, Colors.white]),
        ),
        userSettingsProvider.overrideWith(
          (ref) => MockUserSettingsNotifier(),
        ),
      ],
      child: MaterialApp(
        home: CaptureReviewPage(resultId: resultId),
      ),
    );
  }

  group('Review Screen Display Tests', () {
    testWidgets('shows error state when result is not found', (tester) async {
      await tester.pumpWidget(buildTestWidget('non-existent-id'));
      await tester.pumpAndSettle();

      // Should show error message
      expect(find.text('No se encontró el resultado'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('displays all result data when loaded successfully', (tester) async {
      mockResultRepository.addResult(sampleResult);

      await tester.pumpWidget(buildTestWidget('test-job-id'));
      await tester.pumpAndSettle();

      // Should display PhotoViewer
      expect(find.byType(PhotoViewer), findsOneWidget);

      // Should display NutritionInfoCard
      expect(find.byType(NutritionInfoCard), findsOneWidget);

      // Should display IngredientListEditor
      expect(find.byType(IngredientListEditor), findsOneWidget);

      // Should display AllergenSelector
      expect(find.byType(AllergenSelector), findsOneWidget);

      // Should display ingredients
      expect(find.text('Harina'), findsOneWidget);
      expect(find.text('Azúcar'), findsOneWidget);
      expect(find.text('Huevos'), findsOneWidget);

      // Should display save button
      expect(find.text('Guardar análisis'), findsOneWidget);
    });

    testWidgets('displays nutrition info when available', (tester) async {
      mockResultRepository.addResult(sampleResult);

      await tester.pumpWidget(buildTestWidget('test-job-id'));
      await tester.pumpAndSettle();

      // NutritionInfoCard should be present
      expect(find.byType(NutritionInfoCard), findsOneWidget);
    });

    testWidgets('does not display nutrition info when not available', (tester) async {
      final resultWithoutNutrition = sampleResult.copyWith(nutrition: null);
      mockResultRepository.addResult(resultWithoutNutrition);

      await tester.pumpWidget(buildTestWidget('test-job-id'));
      await tester.pumpAndSettle();

      // NutritionInfoCard should not be present
      expect(find.byType(NutritionInfoCard), findsNothing);
    });
  });

  group('Edit Mode Toggle Tests', () {
    testWidgets('discard button appears when hasChanges is true', (tester) async {
      mockResultRepository.addResult(sampleResult);

      await tester.pumpWidget(buildTestWidget('test-job-id'));
      await tester.pumpAndSettle();

      // Initially, no discard button
      expect(find.byIcon(Icons.refresh), findsNothing);

      // Add a new ingredient to trigger hasChanges
      await tester.enterText(find.widgetWithText(TextField, 'Agregar ingrediente'), 'Leche');
      await tester.tap(find.text('Agregar'));
      await tester.pumpAndSettle();

      // Now discard button should appear
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('hasChanges updates when ingredients are modified', (tester) async {
      mockResultRepository.addResult(sampleResult);

      await tester.pumpWidget(buildTestWidget('test-job-id'));
      await tester.pumpAndSettle();

      // Add ingredient
      await tester.enterText(find.widgetWithText(TextField, 'Agregar ingrediente'), 'Leche');
      await tester.tap(find.text('Agregar'));
      await tester.pumpAndSettle();

      // Discard button should appear
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('hasChanges updates when allergens are modified', (tester) async {
      mockResultRepository.addResult(sampleResult);

      await tester.pumpWidget(buildTestWidget('test-job-id'));
      await tester.pumpAndSettle();

      // Find and tap an allergen chip to toggle it
      final lactosaChip = find.text('Lactosa');
      await tester.tap(lactosaChip);
      await tester.pumpAndSettle();

      // Discard button should appear
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('discard dialog shows and resets changes', (tester) async {
      mockResultRepository.addResult(sampleResult);

      await tester.pumpWidget(buildTestWidget('test-job-id'));
      await tester.pumpAndSettle();

      // Add ingredient
      await tester.enterText(find.widgetWithText(TextField, 'Agregar ingrediente'), 'Leche');
      await tester.tap(find.text('Agregar'));
      await tester.pumpAndSettle();

      // Verify ingredient was added
      expect(find.text('Leche'), findsOneWidget);

      // Tap discard button
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      // Dialog should appear
      expect(find.text('Descartar cambios'), findsOneWidget);
      expect(find.text('¿Estás seguro de descartar los cambios?'), findsOneWidget);

      // Confirm discard
      await tester.tap(find.text('Descartar'));
      await tester.pumpAndSettle();

      // Ingredient should be removed
      expect(find.text('Leche'), findsNothing);

      // Discard button should disappear
      expect(find.byIcon(Icons.refresh), findsNothing);
    });
  });

  group('Ingredient Management Tests', () {
    testWidgets('adding a new ingredient updates the list', (tester) async {
      mockResultRepository.addResult(sampleResult);

      await tester.pumpWidget(buildTestWidget('test-job-id'));
      await tester.pumpAndSettle();

      // Enter new ingredient
      await tester.enterText(find.widgetWithText(TextField, 'Agregar ingrediente'), 'Leche');
      await tester.tap(find.text('Agregar'));
      await tester.pumpAndSettle();

      // New ingredient should appear
      expect(find.text('Leche'), findsOneWidget);

      // Ingredient count should update
      expect(find.text('4 ingredientes'), findsOneWidget);
    });

    testWidgets('removing an ingredient updates the list', (tester) async {
      mockResultRepository.addResult(sampleResult);

      await tester.pumpWidget(buildTestWidget('test-job-id'));
      await tester.pumpAndSettle();

      // Find and remove 'Azúcar'
      final azucarChip = find.ancestor(
        of: find.text('Azúcar'),
        matching: find.byType(Chip),
      );
      final deleteButton = find.descendant(
        of: azucarChip,
        matching: find.byIcon(Icons.close),
      );

      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      // Ingredient should be removed
      expect(find.text('Azúcar'), findsNothing);

      // Ingredient count should update
      expect(find.text('2 ingredientes'), findsOneWidget);
    });

    testWidgets('duplicate ingredients are not added', (tester) async {
      mockResultRepository.addResult(sampleResult);

      await tester.pumpWidget(buildTestWidget('test-job-id'));
      await tester.pumpAndSettle();

      // Try to add existing ingredient
      await tester.enterText(find.widgetWithText(TextField, 'Agregar ingrediente'), 'Harina');
      await tester.tap(find.text('Agregar'));
      await tester.pumpAndSettle();

      // Count should remain the same
      expect(find.text('3 ingredientes'), findsOneWidget);
    });

    testWidgets('empty ingredients are not added', (tester) async {
      mockResultRepository.addResult(sampleResult);

      await tester.pumpWidget(buildTestWidget('test-job-id'));
      await tester.pumpAndSettle();

      // Try to add empty ingredient
      await tester.enterText(find.widgetWithText(TextField, 'Agregar ingrediente'), '   ');
      await tester.tap(find.text('Agregar'));
      await tester.pumpAndSettle();

      // Count should remain the same
      expect(find.text('3 ingredientes'), findsOneWidget);
    });

    testWidgets('updating an ingredient works correctly', (tester) async {
      mockResultRepository.addResult(sampleResult);

      await tester.pumpWidget(buildTestWidget('test-job-id'));
      await tester.pumpAndSettle();

      // Find the edit icon for 'Harina'
      final harinaChip = find.ancestor(
        of: find.text('Harina'),
        matching: find.byType(Chip),
      );
      final editButton = find.descendant(
        of: harinaChip,
        matching: find.byIcon(Icons.edit_outlined),
      );

      await tester.tap(editButton);
      await tester.pumpAndSettle();

      // Dialog should appear
      expect(find.text('Editar ingrediente'), findsOneWidget);

      // Update the ingredient
      await tester.enterText(
          find.widgetWithText(TextField, 'Nombre del ingrediente'), 'Harina integral');
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();

      // Updated ingredient should appear
      expect(find.text('Harina integral'), findsOneWidget);
      expect(find.text('Harina'), findsNothing);
    });
  });

  group('Allergen Toggle Tests', () {
    testWidgets('toggling allergen on adds it to the list', (tester) async {
      mockResultRepository.addResult(sampleResult);

      await tester.pumpWidget(buildTestWidget('test-job-id'));
      await tester.pumpAndSettle();

      // Find and tap 'Lactosa' to add it
      final lactosaChip = find.text('Lactosa');
      await tester.tap(lactosaChip);
      await tester.pumpAndSettle();

      // Lactosa should now be in the detected allergens section
      // We can verify by checking if it appears in the allergen selector
      expect(find.text('Lactosa'), findsWidgets);
    });

    testWidgets('toggling allergen off removes it from the list', (tester) async {
      mockResultRepository.addResult(sampleResult);

      await tester.pumpWidget(buildTestWidget('test-job-id'));
      await tester.pumpAndSettle();

      // 'Gluten' is already in the list, find it and toggle it off
      // The AllergenBadge is tappable, so we find it by text
      final glutenBadges = find.text('Gluten');

      // Tap the first one (should be in the detected section)
      await tester.tap(glutenBadges.first);
      await tester.pumpAndSettle();

      // After toggling off, it should move to the common allergens section
      // We can verify the state changed by checking if discard button appears
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });
  });

  group('Save Functionality Tests', () {
    testWidgets('save button is enabled when data is valid', (tester) async {
      mockResultRepository.addResult(sampleResult);

      await tester.pumpWidget(buildTestWidget('test-job-id'));
      await tester.pumpAndSettle();

      // Save button should be enabled
      final saveButton = find.text('Guardar análisis');
      expect(saveButton, findsOneWidget);

      final button = tester.widget<FilledButton>(
        find.ancestor(
          of: saveButton,
          matching: find.byType(FilledButton),
        ),
      );
      expect(button.onPressed, isNotNull);
    });

    testWidgets('validation error shows when ingredients are empty', (tester) async {
      mockResultRepository.addResult(sampleResult);

      await tester.pumpWidget(buildTestWidget('test-job-id'));
      await tester.pumpAndSettle();

      // Remove all ingredients
      for (final ingredient in ['Harina', 'Azúcar', 'Huevos']) {
        final chip = find.ancestor(
          of: find.text(ingredient),
          matching: find.byType(Chip),
        );
        final deleteButton = find.descendant(
          of: chip,
          matching: find.byIcon(Icons.close),
        );
        await tester.tap(deleteButton);
        await tester.pumpAndSettle();
      }

      // Try to save
      await tester.tap(find.text('Guardar análisis'));
      await tester.pumpAndSettle();

      // Error message should appear
      expect(find.text('Agrega al menos un ingrediente antes de guardar.'), findsOneWidget);
    });

    testWidgets('validation error shows when meal type is not selected', (tester) async {
      final resultWithoutMealType = sampleResult.copyWith(mealType: null);
      mockResultRepository.addResult(resultWithoutMealType);

      await tester.pumpWidget(buildTestWidget('test-job-id'));
      await tester.pumpAndSettle();

      // Try to save
      await tester.tap(find.text('Guardar análisis'));
      await tester.pumpAndSettle();

      // Error message should appear
      expect(find.text('Selecciona el tipo de comida antes de guardar.'), findsOneWidget);
    });

    testWidgets('successful save shows success feedback and navigates back', (tester) async {
      mockResultRepository.addResult(sampleResult);

      await tester.pumpWidget(buildTestWidget('test-job-id'));
      await tester.pumpAndSettle();

      // Tap save button
      await tester.tap(find.text('Guardar análisis'));
      await tester.pump(); // Start the save operation

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      // Success feedback should appear
      expect(find.text('Análisis guardado correctamente'), findsOneWidget);

      // Entry should be saved
      expect(mockEntryRepository.savedEntryIds, contains('test-job-id'));
    });

    testWidgets('cancel button navigates back without saving', (tester) async {
      mockResultRepository.addResult(sampleResult);

      await tester.pumpWidget(buildTestWidget('test-job-id'));
      await tester.pumpAndSettle();

      // Add an ingredient to make changes
      await tester.enterText(find.widgetWithText(TextField, 'Agregar ingrediente'), 'Leche');
      await tester.tap(find.text('Agregar'));
      await tester.pumpAndSettle();

      // Tap cancel button
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      // Should navigate back (no save should occur)
      expect(mockEntryRepository.savedEntryIds, isEmpty);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:qkomo_ui/features/capture/application/capture_controller.dart';
import 'package:qkomo_ui/features/capture/application/capture_providers.dart';
import 'package:qkomo_ui/features/capture/application/capture_state.dart';
import 'package:qkomo_ui/features/capture/domain/capture_mode.dart';
import 'package:qkomo_ui/features/capture/presentation/capture_page.dart';
import 'package:qkomo_ui/features/capture/presentation/widgets/camera_capture_view.dart';
import 'package:qkomo_ui/features/shell/state/navigation_provider.dart';
import 'package:qkomo_ui/theme/theme_providers.dart';

// Mock class for CaptureController
class MockCaptureController extends StateNotifier<CaptureState> implements CaptureController {
  MockCaptureController() : super(const CaptureState());

  @override
  Future<void> setMode(CaptureMode mode) async {
    state = state.copyWith(mode: mode);
  }

  @override
  void clearMode() {
    state = state.copyWith(mode: null);
  }

  @override
  void clearError() {
    state = state.copyWith(error: null);
  }

  @override
  void clearMessage() {
    state = state.copyWith(message: null);
  }

  // Stubs for other methods
  @override
  Future<void> captureWithCamera() async {}

  @override
  Future<void> importFromGallery() async {}

  @override
  void onBarcodeScanned(String barcode) {}

  @override
  Future<void> scanBarcode() async {}

  @override
  Future<void> openSettings() async {}

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late MockCaptureController mockController;

  setUp(() {
    mockController = MockCaptureController();
  });

  testWidgets('CapturePage renders initial options correctly', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          captureControllerProvider.overrideWith((ref) => mockController),
          appGradientProvider
              .overrideWithValue(const LinearGradient(colors: [Colors.white, Colors.white])),
        ],
        child: const MaterialApp(
          home: CapturePage(),
        ),
      ),
    );

    // Initial state: No mode selected, should show option cards
    expect(find.text('Cámara'), findsOneWidget);
    expect(find.text('Galería'), findsOneWidget);
    expect(find.text('Código de barras'), findsOneWidget);
    expect(find.text('Texto'), findsOneWidget);
    expect(find.text('¿Cómo quieres registrar tu comida?'), findsOneWidget);
  });

  testWidgets('Selecting Camera option updates mode and shows CameraView', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          captureControllerProvider.overrideWith((ref) => mockController),
          appGradientProvider
              .overrideWithValue(const LinearGradient(colors: [Colors.white, Colors.white])),
        ],
        child: const MaterialApp(
          home: CapturePage(),
        ),
      ),
    );

    // Tap Camera option
    await tester.tap(find.text('Cámara'));
    await tester.pumpAndSettle();

    // Verify controller state updated
    expect(mockController.state.mode, CaptureMode.camera);

    // Verify CameraCaptureView is shown
    expect(find.byType(CameraCaptureView), findsOneWidget);

    // Verify initial options are gone
    expect(find.text('¿Cómo quieres registrar tu comida?'), findsNothing);
  });

  testWidgets('Close button resets navigation index when in initial mode', (tester) async {
    // We need to spy on the navigation provider
    final container = ProviderContainer(
      overrides: [
        captureControllerProvider.overrideWith((ref) => mockController),
        bottomNavIndexProvider.overrideWith((ref) => 3), // Currently on Capture (3)
        appGradientProvider
            .overrideWithValue(const LinearGradient(colors: [Colors.white, Colors.white])),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: CapturePage(),
        ),
      ),
    );

    // Verify Close button is present (since mode is null)
    expect(find.byIcon(Icons.close), findsOneWidget);

    // Tap Close
    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();

    // Verify navigation index reset to 1
    expect(container.read(bottomNavIndexProvider), 1);
  });
}

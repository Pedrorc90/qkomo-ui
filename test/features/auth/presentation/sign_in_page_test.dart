import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qkomo_ui/features/auth/application/auth_controller.dart';
import 'package:qkomo_ui/features/auth/application/auth_providers.dart';
import 'package:qkomo_ui/features/auth/presentation/sign_in/email_auth_dialog.dart';
import 'package:qkomo_ui/features/auth/presentation/sign_in/sign_in_page.dart';
import 'package:qkomo_ui/theme/theme_providers.dart';

// Fakes
class FakeAuthController implements AuthController {
  @override
  Future<void> signInWithGoogle() async {}

  @override
  Future<void> signInWithApple() async {}

  @override
  Future<void> signInWithEmail(String email, String password, {bool register = false}) async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<void> refreshIdToken() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeAuthController mockController;

  setUp(() {
    mockController = FakeAuthController();
  });

  Widget buildTestWidget({bool inProgress = false}) {
    return ProviderScope(
      overrides: [
        authControllerProvider.overrideWithValue(mockController),
        authInProgressProvider.overrideWith((ref) => inProgress),
        appGradientProvider.overrideWithValue(
          const LinearGradient(colors: [Colors.white, Colors.white]),
        ),
      ],
      child: const MaterialApp(
        home: SignInPage(),
      ),
    );
  }

  testWidgets('SignInPage renders Google and Email buttons', (tester) async {
    await tester.pumpWidget(buildTestWidget());

    expect(find.text('Continuar con Google'), findsOneWidget);
    expect(find.text('Continuar con email'), findsOneWidget);
    expect(find.text('Tu copiloto nutricional'), findsOneWidget);
  });

  testWidgets('Tapping Email button opens EmailAuthDialog', (tester) async {
    await tester.pumpWidget(buildTestWidget());

    // Tap Email button
    await tester.tap(find.text('Continuar con email'));
    await tester.pumpAndSettle();

    // Verify dialog is shown
    expect(find.byType(EmailAuthDialog), findsOneWidget);
    expect(find.text('Bienvenido de nuevo'), findsOneWidget);
  });

  testWidgets('Shows loading state when in progress', (tester) async {
    await tester.pumpWidget(buildTestWidget(inProgress: true));

    // Should show progress indicator instead of buttons or overlaid
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}

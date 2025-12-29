import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qkomo_ui/features/auth/presentation/sign_in/email_auth_dialog.dart';
import 'package:qkomo_ui/features/auth/presentation/sign_in/email_auth_result.dart';

void main() {
  testWidgets('EmailAuthDialog returns SignIn result when submitted', (tester) async {
    EmailAuthResult? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () async {
                  result = await showDialog<EmailAuthResult>(
                    context: context,
                    builder: (context) => const EmailAuthDialog(),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    // Fill form
    await tester.enterText(find.byType(TextField).first, 'test@example.com');
    await tester.enterText(find.byType(TextField).last, 'password123');
    await tester.pumpAndSettle();

    // Tap SignIn button
    await tester.tap(find.text('Iniciar sesión'));
    await tester.pumpAndSettle();

    expect(result, isNotNull);
    expect(result!.email, 'test@example.com');
    expect(result!.password, 'password123');
    expect(result!.mode, EmailAuthMode.signIn);
  });

  testWidgets('EmailAuthDialog can toggle to Register mode', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: EmailAuthDialog()),
      ),
    );

    // Initial title
    expect(find.text('Bienvenido de nuevo'), findsOneWidget);

    // Tap toggle text (in EmailAuthForm)
    await tester.tap(find.text('¿No tienes cuenta? Regístrate'));
    await tester.pumpAndSettle();

    // New title
    expect(find.text('Únete a qkomo'), findsOneWidget);
    expect(find.text('Crear cuenta'), findsOneWidget);
  });

  testWidgets('EmailAuthDialog returns Register result when submitted', (tester) async {
    EmailAuthResult? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () async {
                  result = await showDialog<EmailAuthResult>(
                    context: context,
                    builder: (context) => const EmailAuthDialog(),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    // Toggle to register
    await tester.tap(find.text('¿No tienes cuenta? Regístrate'));
    await tester.pumpAndSettle();

    // Fill form
    await tester.enterText(find.byType(TextField).first, 'new@example.com');
    await tester.enterText(find.byType(TextField).last, 'newpassword');
    await tester.pumpAndSettle();

    // Tap Register button
    await tester.tap(find.text('Crear cuenta'));
    await tester.pumpAndSettle();

    expect(result, isNotNull);
    expect(result!.email, 'new@example.com');
    expect(result!.password, 'newpassword');
    expect(result!.mode, EmailAuthMode.register);
  });
}

# qkomo UI

Flutter client for the AI-assisted food logging MVP.

## Stack

- Flutter 3 / Dart 3
- Riverpod for state management
- Dio for networking
- Firebase Auth (Apple, Google, email/password)
- Hive for offline-first storage (entries + queued tasks)

## Firebase setup

1. Install the Firebase CLI and run `flutterfire configure` for your Apple/Android projects.  
2. Replace the placeholder values in `lib/firebase_options.dart` or pass secrets at build time:

```bash
flutter run \
  --dart-define=FIREBASE_API_KEY=xxx \
  --dart-define=FIREBASE_PROJECT_ID=your-project \
  --dart-define=FIREBASE_APP_ID=1:...:android:...
```

3. Enable Google, Apple, and Email/Password providers in Firebase Auth.
4. Create at least one test user to verify the flow.

The app stores the issued Firebase ID token in the secure keystore/keychain so it can be reused for backend calls.

## TODO roadmap

1. Camera + gallery capture with permission handling.
2. Barcode scanner flow (mobile_scanner) before fallback to photo analysis.
3. Local queue of analyze tasks; upload to backend when online.
4. Review screen: show AI ingredients (Spanish), edit, highlight allergens.
5. Today + history views (calendar/list) backed by Hive.
6. Sync engine (later) to POST entries to backend once cloud persistence lands.

Run locally (after configuring Firebase):

```bash
flutter pub get
# Emulador Android: backend en localhost -> usa 10.0.2.2
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080
```

### Llamadas al backend

- La app usa Firebase ID token en Authorization Bearer para `/v1/analyze` (multipart) y `/v1/analyze/barcode`.
- Configura `API_BASE_URL` con `--dart-define` (default `http://10.0.2.2:8080`).
- Se espera que el backend acepte ambos endpoints y devuelva `AnalyzeResponse`.

Para desarrollo rápido (sin backend) puedes desactivar la cola o apuntar a un mock, pero por defecto se usará el backend real al procesar la cola offline.

```bash
flutter run
```

## Testing

For detailed testing instructions, please refer to [TESTING.md](TESTING.md).

Run all tests:
```bash
flutter test
```

Run integration tests:
```bash
flutter test integration_test/backend_integration_test.dart
```
Para arrancar el emulador de Android, ejecuta:
```bash
flutter emulators --launch android_emulator
```

Después de arrancar el emulador, ejecuta:
```bash
flutter run
``` 
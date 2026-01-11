# qkomo UI

AI-powered weekly meal planner mobile app.

## Project Status

**Current Phase:** MVP - AI Weekly Menu Generation

## Stack

- Flutter 3 / Dart 3
- Riverpod 2.5 for state management
- Dio 5.4 for networking
- Firebase Auth (Apple, Google, email/password)
- Hive 2.2 for offline-first encrypted storage
- Freezed for immutable models
- Workmanager for background sync

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

## Features

### Authentication
- Firebase Auth with Google, Apple, and email/password providers
- User profile management (name, photo, email)
- Secure token storage in keystore/keychain

### AI Weekly Menu
- Automatic weekly meal plan generation
- Interactive weekly calendar widget
- Meal cards with nutritional information
- Allergen alerts and dietary warnings
- Support for custom recipes

### User Preferences
- Allergen and dietary restriction configuration
- Feature toggle system
- Theme and app preferences

### Offline-First Sync
- Encrypted local storage with Hive
- Automatic background sync with backend
- Connectivity monitoring and auto-retry
- Background worker with Workmanager

## Architecture

Feature-based structure (`lib/features/<feature>/`):
- `domain/` → Entities, interfaces
- `application/` → Controllers (StateNotifier), UseCases
- `data/` → Repositories, API clients, Hive adapters
- `presentation/` → Widgets, Pages

### Implemented Features
- **auth** - Firebase authentication
- **home** - Main page with meal summary
- **menu** - AI-powered weekly menu management
- **profile** - User profile and preferences
- **settings** - App configuration
- **sync** - Background synchronization
- **feature_toggles** - Feature flag system
- **shell** - Root navigation

## Development Setup

Run locally (after configuring Firebase):

```bash
flutter pub get
# Android emulator: use 10.0.2.2 for localhost backend
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080
```

### Backend Integration

- App uses Firebase ID token in Authorization Bearer header
- Configure `API_BASE_URL` with `--dart-define` (default: `http://10.0.2.2:8080`)
- Development server: `flutter run --dart-define=API_BASE_URL=https://qkomo-backend.onrender.com`

## Testing

For detailed testing instructions, see [TESTING.md](TESTING.md).

```bash
# Run all tests
flutter test

# Run integration tests
flutter test integration_test/backend_integration_test.dart

# Launch Android emulator
flutter emulators --launch android_emulator

# Run app
flutter run
```

## Additional Documentation

- [CLAUDE.md](CLAUDE.md) - Architecture guidelines and working rules
- [TODO.md](TODO.md) - Pending tasks and roadmap
- [TESTING.md](TESTING.md) - Testing strategy and instructions 
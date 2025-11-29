# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

**Note:** For comprehensive project overview including both backend and mobile, see `../CLAUDE.md` in the parent directory.

## qkomo-ui (Flutter Mobile App)

Spanish-first AI food logging app with offline-first architecture.

### Stack
- Flutter 3 / Dart 3
- Riverpod (state management)
- Dio (networking with Firebase token interceptor)
- Firebase Auth (Apple, Google, email/password)
- Hive (offline-first local storage)
- `image_picker`, `camera`, `mobile_scanner` (capture flows)

### Common Commands

**Get dependencies:**
```bash
flutter pub get
```

**Run app (default: Android emulator with backend at 10.0.2.2:8080):**
```bash
flutter run
```

**Run with custom backend URL:**
```bash
# Android emulator (backend on host machine)
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080

# iOS simulator (backend on host machine)
flutter run --dart-define=API_BASE_URL=http://localhost:8080

# Physical device or production
flutter run --dart-define=API_BASE_URL=https://api.example.com
```

**Run tests:**
```bash
flutter test
```

**Run specific test:**
```bash
flutter test test/features/capture/application/capture_queue_processor_test.dart
```

**Analyze code:**
```bash
flutter analyze
```

**Format code:**
```bash
dart format .
```

**Generate code (Freezed, JSON serialization, Hive adapters):**
```bash
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for development
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Architecture

**Feature-based structure** (`lib/features/<feature>/`):
- `domain/` — Models, entities, and business logic interfaces (e.g., `CaptureJob`, `CaptureAnalyzer`)
- `application/` — Controllers (Riverpod `StateNotifier`s), services, business logic (e.g., `CaptureController`, `CaptureQueueProcessor`)
- `data/` — Repositories, API clients, Hive adapters, DTOs (e.g., `CaptureQueueRepository`, `CaptureApiClient`)
- `presentation/` — UI widgets and pages (e.g., `CapturePage`, `HomePage`)

**Key architectural patterns:**

1. **Dependency Injection via Riverpod Providers**
   - All providers in `*_providers.dart` files (e.g., `lib/features/capture/application/capture_providers.dart`)
   - Controllers, repositories, services injected via `ref.watch()`
   - Providers compose dependencies (e.g., `captureQueueProcessorProvider` depends on `captureQueueRepositoryProvider`, `captureResultRepositoryProvider`, `captureAnalyzerProvider`)

2. **Offline-First Queue System**
   - `CaptureQueueRepository` stores pending analysis jobs in Hive
   - `CaptureQueueProcessor` processes jobs asynchronously using `CaptureAnalyzer`
   - `BackendCaptureAnalyzer` calls backend `/v1/analyze` endpoints
   - Jobs remain queued when offline and process when connectivity returns
   - Results persisted locally in `CaptureResultRepository` (Hive)

3. **State Management Flow**
   - UI components consume `StateNotifierProvider`s
   - User actions trigger controller methods
   - Controllers update state and trigger side effects (e.g., enqueue job, start processing)
   - UI rebuilds reactively via Riverpod
   - Example: `CaptureController` manages camera/gallery/barcode UI state, `CaptureEnqueueController` manages job queuing, `CaptureQueueProcessController` manages queue processing

4. **Firebase Authentication**
   - `AuthController` handles sign-in/sign-out flows
   - `SecureTokenStore` persists Firebase ID tokens in secure storage
   - Dio interceptor in `dio_provider.dart` adds ID token to all backend requests (note: interceptor not yet implemented in current code)

**Core Features:**

- **`auth/`** — Firebase authentication with Apple, Google, and email/password
- **`capture/`** — Photo/barcode capture and offline analysis queue
- **`home/`** — Main screen with capture actions
- **`profile/`** — User profile and settings
- **`history/`** — Daily log and history views (Hive-backed)
- **`shell/`** — Bottom navigation shell

**Storage (Hive):**
- `HiveBoxes.captureJobs` — Stores `CaptureJob` (pending/processing/succeeded/failed analysis tasks)
- `HiveBoxes.captureResults` — Stores `CaptureResult` (analysis results with ingredients, allergens, etc.)
- Type adapters registered in `main.dart` on app initialization
- Adapters in `lib/features/capture/data/hive_adapters/`

**Networking:**
- `ApiConfig.baseUrl` — Backend URL from `--dart-define=API_BASE_URL` (default: `http://10.0.2.2:8080`)
- `dioProvider` — Dio client with 5s connect timeout, 15s receive timeout
- `CaptureApiClient` — Calls `/v1/analyze` (multipart photo) and `/v1/analyze/barcode` endpoints

### Code Generation

This project uses code generation for:
- **Freezed** — Immutable data classes with `copyWith`, `==`, `toString()`
- **json_serializable** — JSON serialization for DTOs
- **Hive** — Type adapters for local storage models

After modifying models with `@freezed`, `@JsonSerializable`, or `@HiveType` annotations, run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Testing

Tests follow the same feature structure:
- `test/features/<feature>/domain/` — Domain model tests
- `test/features/<feature>/application/` — Business logic and controller tests
- `test/features/<feature>/data/` — Repository and API client tests

Current test coverage:
- `capture_queue_repository_test.dart` — Hive-backed queue operations
- `capture_result_repository_test.dart` — Hive-backed result storage
- `capture_queue_processor_test.dart` — Job processing with mocked analyzer

### Firebase Configuration

**Option 1: Using flutterfire configure (recommended)**
```bash
# Install Firebase CLI tools
npm install -g firebase-tools
dart pub global activate flutterfire_cli

# Configure Firebase for your project
flutterfire configure
```

**Option 2: Manual configuration via dart-define**
```bash
flutter run \
  --dart-define=FIREBASE_API_KEY=xxx \
  --dart-define=FIREBASE_PROJECT_ID=your-project \
  --dart-define=FIREBASE_APP_ID=1:...:android:...
```

Enable Apple, Google, and Email/Password sign-in providers in Firebase Console and create test users.

### Development Workflow

1. Start backend (see `../CLAUDE.md` for backend setup)
2. Run Flutter app with appropriate `API_BASE_URL`
3. Sign in with Firebase test account
4. Capture photo or scan barcode → job queued locally → processed when online → results stored in Hive

### Spanish-First UX

All user-facing strings must be in Spanish. This includes:
- Error messages
- UI labels and buttons
- Analysis result prompts
- Form validation messages

### Current Status (see PLAN.md)

✅ Completed:
- Firebase auth & token persistence
- Camera, gallery, barcode scanner flows
- Offline queue with Hive storage
- Backend integration for `/v1/analyze` endpoints

⏳ Pending:
- Review/edit UI for analysis results
- Today & History tab implementation
- Sync architecture for cloud persistence
- Widget and integration tests

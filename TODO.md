# qkomo-ui TODO

This file tracks implementation tasks and technical debt for the qkomo-ui Flutter mobile app.

**Last Updated:** 2025-11-27
**Project Phase:** MVP - Core capture flow complete, pending review/history features

---

## High Priority - MVP Completion

### Infra - Flutter Development Environment
**Status:** Pending
**Goal:** Ensure development tooling is properly configured

- [ ] Install `unzip` utility (Windows MSYS environment)
- [ ] Verify Dart/Flutter SDK is properly installed and current
- [ ] Run `flutter pub get` to ensure dependencies are resolved
- [ ] Run `flutter pub run build_runner build --delete-conflicting-outputs` to regenerate code
- [ ] Run `dart format .` on entire codebase
- [ ] Run `flutter analyze` and fix any warnings/errors
- [ ] Run `flutter test` and ensure all existing tests pass
- [ ] Verify app builds and runs on Android emulator
- [ ] Verify app builds and runs on iOS simulator (if available)

**Dependencies:** None

---

### M4 - Complete Analyze Flow Integration
**Status:** Partial - Core implementation exists, authentication integration pending
**Goal:** Complete end-to-end backend integration with Firebase authentication

#### Authentication Integration
- [ ] Implement Firebase ID token interceptor in Dio client
  - [ ] Create `FirebaseTokenInterceptor` class
  - [ ] Inject `SecureTokenStore` to retrieve current token
  - [ ] Add Authorization header: `Bearer {idToken}`
  - [ ] Handle token expiration (401 responses)
  - [ ] Refresh token when expired
  - [ ] Add interceptor to `dioProvider` in `lib/core/http/dio_provider.dart`
  - [ ] Add unit tests for interceptor logic

**Files to create/modify:**
- `lib/core/http/firebase_token_interceptor.dart` (new)
- `lib/core/http/dio_provider.dart` (modify)
- `test/core/http/firebase_token_interceptor_test.dart` (new)

#### Backend Integration Testing
- [ ] Test photo upload to `/v1/analyze` with real backend
  - [ ] Verify multipart file upload works
  - [ ] Verify Firebase token is sent correctly
  - [ ] Verify response parsing works
  - [ ] Handle successful analysis response
  - [ ] Handle network errors gracefully
  - [ ] Handle 401 authentication errors
  - [ ] Handle 4xx/5xx server errors
- [ ] Test barcode analysis to `/v1/analyze/barcode` with real backend
  - [ ] Verify JSON payload is sent correctly
  - [ ] Verify Firebase token authentication
  - [ ] Verify response parsing works
  - [ ] Handle missing product scenarios
  - [ ] Handle network/auth errors
- [ ] Test offline queue processing
  - [ ] Verify jobs queue when offline
  - [ ] Verify jobs process when back online
  - [ ] Verify failed jobs are marked correctly
  - [ ] Verify succeeded jobs are cleaned up after TTL
- [ ] Run integration tests with backend running locally
- [ ] Document test scenarios in README

**Test Cases:**
```dart
// test/features/capture/integration/backend_integration_test.dart
- Photo capture → queue → process → success
- Photo capture → queue → process → network error → retry
- Photo capture → queue → process → auth error → fail
- Barcode scan → queue → process → success
- Queue builds up offline → comes online → batch processes
```

#### Error Handling & UX
- [ ] Add user-friendly Spanish error messages for:
  - [ ] Network errors: "No hay conexión. La captura se guardó y se procesará cuando vuelva la conexión."
  - [ ] Authentication errors: "Sesión expirada. Por favor, inicia sesión nuevamente."
  - [ ] Server errors: "Error del servidor. Intenta de nuevo más tarde."
  - [ ] Invalid image format: "Formato de imagen no válido. Usa JPG o PNG."
  - [ ] File too large: "La imagen es demasiado grande. Máximo 10MB."
- [ ] Show processing status in UI
  - [ ] Pending jobs count badge
  - [ ] Processing spinner when queue is active
  - [ ] Success/failure notifications
- [ ] Add retry logic for transient failures
  - [ ] Exponential backoff for network errors
  - [ ] Max retry attempts (e.g., 3)
  - [ ] Manual retry button for failed jobs

**Dependencies:** Backend B3 (OpenAI Vision integration) must be deployed

---

### M5 - Review & Edit UI
**Status:** Not started
**Goal:** Provide user interface to review, edit, and confirm analysis results before saving

#### Review Screen Design
- [ ] Create `CaptureReviewPage` widget
  - [ ] Display photo/barcode source image
  - [ ] Show analysis title/product name
  - [ ] List all detected ingredients with confidence scores
  - [ ] Highlight allergens with warning badges
  - [ ] Show additional warnings section
  - [ ] Add edit mode toggle
  - [ ] Add save/discard buttons
- [ ] Create `IngredientListEditor` widget
  - [ ] Display ingredients as editable chips
  - [ ] Allow adding new ingredients (text input)
  - [ ] Allow removing ingredients (swipe to delete)
  - [ ] Allow editing ingredient names (tap to edit)
  - [ ] Show confidence scores (read-only)
- [ ] Create `AllergenToggleList` widget
  - [ ] Display allergen flags with toggle switches
  - [ ] Use prominent warning icons/colors
  - [ ] Allow user to override allergen detection
  - [ ] Show "why" explanations (which ingredient triggered)
- [ ] Add photo zoom/pan capability
  - [ ] Use `photo_view` package
  - [ ] Allow pinch-to-zoom
  - [ ] Allow pan to inspect details

**Files to create:**
- `lib/features/capture/presentation/review/capture_review_page.dart`
- `lib/features/capture/presentation/review/widgets/ingredient_list_editor.dart`
- `lib/features/capture/presentation/review/widgets/allergen_toggle_list.dart`
- `lib/features/capture/presentation/review/widgets/photo_viewer.dart`
- `lib/features/capture/presentation/review/capture_review_controller.dart`

#### Review Business Logic
- [ ] Create `CaptureReviewController` (StateNotifier)
  - [ ] Load analysis result by ID
  - [ ] Track edit state (edited ingredients, allergens)
  - [ ] Validate edits before saving
  - [ ] Save confirmed result back to `CaptureResultRepository`
  - [ ] Mark job as reviewed/confirmed
  - [ ] Navigate back after save
- [ ] Update `CaptureResult` model to track review status
  - [ ] Add `isReviewed` boolean field
  - [ ] Add `reviewedAt` timestamp
  - [ ] Add `userEdited` boolean flag
  - [ ] Update Hive adapter
- [ ] Add navigation from History page to Review page
  - [ ] Tap on result card → open review page
  - [ ] Pass result ID as route parameter

**Files to create/modify:**
- `lib/features/capture/application/capture_review_controller.dart` (new)
- `lib/features/capture/domain/capture_result.dart` (modify - add review fields)
- `lib/features/capture/data/hive_adapters/capture_result_adapter.dart` (regenerate)

#### Spanish-First UX Copy
- [ ] Add Spanish labels and help text:
  - "Revisa los ingredientes"
  - "Toca para editar"
  - "Desliza para eliminar"
  - "Alérgenos detectados"
  - "Advertencias adicionales"
  - "Guardar análisis"
  - "Descartar cambios"
  - "¿Estás seguro de descartar los cambios?"
- [ ] Add empty state messages:
  - "No se detectaron ingredientes. Puedes agregarlos manualmente."
  - "No se detectaron alérgenos."
- [ ] Add validation messages:
  - "Agrega al menos un ingrediente antes de guardar."

**Dependencies:** M4 must be complete and tested

---

### M6 - Today & History Tabs
**Status:** Partial - Basic history list exists, needs enhancement
**Goal:** Complete daily food log with filtering, grouping, and detail views

#### History Feed Enhancement
- [ ] Enhance `HistoryPage` with proper date grouping
  - [ ] Group results by date (today, yesterday, this week, older)
  - [ ] Add section headers for date groups
  - [ ] Show day-of-week labels
  - [ ] Add summary statistics per day (total entries, unique ingredients)
- [ ] Add date range filter
  - [ ] "Today" tab (default view)
  - [ ] "This Week" filter
  - [ ] "This Month" filter
  - [ ] Custom date range picker
  - [ ] Filter results from Hive by date
- [ ] Improve result cards
  - [ ] Show thumbnail of photo/barcode
  - [ ] Display product name/title prominently
  - [ ] Show ingredient count and top 3 ingredients
  - [ ] Show allergen badges if any
  - [ ] Add review status indicator (reviewed vs. pending review)
  - [ ] Add tap action to open review page
- [ ] Add pull-to-refresh
  - [ ] Refresh local Hive data
  - [ ] Trigger queue processing
  - [ ] Show sync status (when M7 is implemented)
- [ ] Add search functionality
  - [ ] Search by product name
  - [ ] Search by ingredient
  - [ ] Search by allergen
  - [ ] Filter results based on search query
- [ ] Add empty states
  - [ ] No entries today: "Aún no has registrado comidas hoy. ¡Empieza capturando una foto!"
  - [ ] No entries in date range: "No hay entradas en este período."
  - [ ] No search results: "No se encontraron resultados para '{query}'."

**Files to modify:**
- `lib/features/history/presentation/history_page.dart` (major refactor)

**Files to create:**
- `lib/features/history/presentation/widgets/date_group_header.dart`
- `lib/features/history/presentation/widgets/result_card.dart`
- `lib/features/history/presentation/widgets/date_filter_tabs.dart`
- `lib/features/history/presentation/widgets/search_bar.dart`
- `lib/features/history/application/history_controller.dart`
- `lib/features/history/application/history_providers.dart`

#### Today Tab Implementation
- [ ] Create dedicated "Today" view (alternative to filtered history)
  - [ ] Show today's entries prominently
  - [ ] Add daily summary card (total meals, calories if available)
  - [ ] Show timeline view (breakfast, lunch, dinner, snacks)
  - [ ] Add quick capture actions
- [ ] Or: Simplify by making History page default to "today" filter
  - [ ] Use tab bar: Today | This Week | All
  - [ ] Keep single `HistoryPage` with filter state

**Decision needed:** Separate Today tab vs. filtered History page? (Ask user or default to filtered approach)

#### Statistics & Insights (Optional Enhancement)
- [ ] Add summary cards
  - [ ] Total entries this week/month
  - [ ] Most common ingredients
  - [ ] Allergen exposure frequency
  - [ ] Streak counter (days logged)
- [ ] Add charts/visualizations (consider `fl_chart` package)
  - [ ] Entries per day (bar chart)
  - [ ] Ingredient frequency (pie chart)
  - [ ] Allergen warnings over time

**Dependencies:** M5 (Review UI) should be complete for best UX, but can proceed in parallel

---

### M7 - Sync-Ready Architecture
**Status:** Not started
**Goal:** Prepare data layer for cloud sync once backend entries API is available

#### Repository Abstraction
- [ ] Define `EntryRepository` interface
  - [ ] `Future<List<Entry>> getEntries({DateTime? from, DateTime? to})`
  - [ ] `Future<Entry> getEntryById(String id)`
  - [ ] `Future<void> saveEntry(Entry entry)`
  - [ ] `Future<void> deleteEntry(String id)`
  - [ ] `Future<SyncStatus> syncPending()`
- [ ] Implement `LocalEntryRepository` (Hive-based)
  - [ ] Wraps existing `CaptureResultRepository`
  - [ ] Adds sync metadata (syncStatus, lastSyncedAt)
  - [ ] Tracks local-only vs. cloud-synced entries
- [ ] Implement `RemoteEntryRepository` (backend API)
  - [ ] Calls `/v1/entries` endpoints (when B6 is complete)
  - [ ] Uses Dio client with Firebase auth
  - [ ] Handles pagination
  - [ ] Handles date range queries
- [ ] Implement `HybridEntryRepository` (orchestrator)
  - [ ] Write-through: save locally first, queue for sync
  - [ ] Read-through: check local cache, fall back to remote
  - [ ] Sync pending entries to backend
  - [ ] Handle conflicts (last-write-wins or user prompt)

**Files to create:**
- `lib/features/entry/domain/entry_repository.dart` (interface)
- `lib/features/entry/data/local_entry_repository.dart`
- `lib/features/entry/data/remote_entry_repository.dart`
- `lib/features/entry/data/hybrid_entry_repository.dart`
- `lib/features/entry/domain/entry.dart` (domain model)
- `lib/features/entry/domain/sync_status.dart` (enum: pending, synced, failed)

#### Sync Metadata & Conflict Resolution
- [ ] Add sync fields to `CaptureResult` or new `Entry` model
  - [ ] `syncStatus` (pending, synced, conflict, failed)
  - [ ] `lastSyncedAt` timestamp
  - [ ] `cloudVersion` (for conflict detection)
  - [ ] `pendingChanges` (track local edits)
- [ ] Implement conflict resolution strategy
  - [ ] Last-write-wins (default, simple)
  - [ ] User prompt to choose version (advanced)
  - [ ] Merge changes intelligently (complex)
- [ ] Add sync queue similar to capture queue
  - [ ] Queue entries for upload when created/edited
  - [ ] Process queue when online
  - [ ] Retry failed syncs with exponential backoff
  - [ ] Mark conflicts for user resolution

**Files to create:**
- `lib/features/entry/data/sync_queue_repository.dart`
- `lib/features/entry/application/sync_service.dart`

#### Background Sync Worker
- [ ] Implement background sync service
  - [ ] Use `workmanager` package for Android/iOS background tasks
  - [ ] Schedule periodic sync (e.g., every 30 minutes when online)
  - [ ] Trigger sync on connectivity change
  - [ ] Show sync status in UI (syncing, last synced time)
- [ ] Add sync settings
  - [ ] Enable/disable auto-sync
  - [ ] Sync only on Wi-Fi vs. any connection
  - [ ] Sync frequency preference
  - [ ] Manual sync trigger button

**Files to create:**
- `lib/core/sync/background_sync_worker.dart`
- `lib/features/settings/presentation/sync_settings_page.dart`

#### Migration Plan
- [ ] Create migration script for existing Hive data
  - [ ] Add sync metadata to existing `CaptureResult` entries
  - [ ] Set initial `syncStatus` to `pending`
  - [ ] Preserve existing data integrity
- [ ] Add feature flag for cloud sync
  - [ ] Allow gradual rollout
  - [ ] Fall back to local-only if backend unavailable
  - [ ] Environment variable: `ENABLE_CLOUD_SYNC`

**Dependencies:**
- **Backend B6** (Entries & History API) must be complete
- **Backend B5** (Analysis persistence) must be complete for B6

---

## Medium Priority - Quality Assurance

### M8 - Mobile QA
**Status:** Minimal - Some unit tests exist, needs expansion
**Goal:** Comprehensive test coverage for critical user flows

#### Unit Tests
- [ ] Test `CaptureQueueProcessor`
  - [x] Basic processing flow (already exists)
  - [ ] Error handling and retry logic
  - [ ] TTL cleanup of succeeded jobs
  - [ ] Concurrent processing prevention
- [ ] Test `BackendCaptureAnalyzer`
  - [ ] Successful photo analysis response parsing
  - [ ] Successful barcode analysis response parsing
  - [ ] Network error handling
  - [ ] Auth error handling (401)
  - [ ] Invalid response handling
- [ ] Test `CaptureQueueRepository`
  - [x] Basic CRUD operations (already exists)
  - [ ] Status transitions (pending → processing → succeeded/failed)
  - [ ] Query methods (pendingJobs, failedJobs)
- [ ] Test `CaptureResultRepository`
  - [x] Basic save/retrieve (already exists)
  - [ ] Query by date range
  - [ ] Delete operations
- [ ] Test `FirebaseTokenInterceptor` (once implemented)
  - [ ] Token injection in requests
  - [ ] Token refresh on 401
  - [ ] Error handling when token unavailable

**Files to create/expand:**
- `test/features/capture/application/capture_queue_processor_test.dart` (expand)
- `test/features/capture/data/backend_capture_analyzer_test.dart` (new)
- `test/core/http/firebase_token_interceptor_test.dart` (new)

#### Widget Tests
- [ ] Test `CapturePage` components
  - [ ] Camera view renders correctly
  - [ ] Gallery picker triggers
  - [ ] Barcode scanner navigation works
  - [ ] Error states display properly
- [ ] Test `CaptureReviewPage` (once M5 is complete)
  - [ ] Review screen displays result data
  - [ ] Edit mode toggles correctly
  - [ ] Ingredient add/remove works
  - [ ] Allergen toggles work
  - [ ] Save button persists changes
- [ ] Test `HistoryPage`
  - [ ] Empty state displays correctly
  - [ ] Result cards render with data
  - [ ] Queue processing button works
  - [ ] Navigation to review page works
- [ ] Test auth flows
  - [ ] Sign-in page renders
  - [ ] Email/password form validation
  - [ ] Google/Apple sign-in buttons trigger correctly

**Files to create:**
- `test/features/capture/presentation/capture_page_test.dart`
- `test/features/capture/presentation/review/capture_review_page_test.dart`
- `test/features/history/presentation/history_page_test.dart`
- `test/features/auth/presentation/sign_in_page_test.dart`

#### Integration Tests
- [ ] End-to-end smoke tests
  - [ ] Sign in → capture photo → queue → process → review → save
  - [ ] Sign in → scan barcode → queue → process → review → save
  - [ ] Offline queue → go online → auto-process → success
  - [ ] Auth token expiration → refresh → continue operation
- [ ] Test offline scenarios
  - [ ] Capture works offline
  - [ ] Queue builds up
  - [ ] Jobs process when connectivity returns
  - [ ] Failed jobs can be retried
- [ ] Test error recovery
  - [ ] Network interruption during upload
  - [ ] Backend returns 500 error
  - [ ] Invalid auth token
  - [ ] App restart with pending queue

**Files to create:**
- `integration_test/app_test.dart` (Flutter integration tests)
- `integration_test/offline_flow_test.dart`
- `integration_test/error_recovery_test.dart`

#### Test Coverage Goals
- [ ] Set up test coverage reporting
  - [ ] Add `flutter test --coverage` to CI
  - [ ] Use `lcov` to generate coverage reports
  - [ ] Set minimum coverage thresholds (e.g., 70%)
- [ ] Achieve coverage targets
  - [ ] Domain layer: 90%+ (pure business logic)
  - [ ] Application layer: 80%+ (controllers, services)
  - [ ] Data layer: 70%+ (repositories, API clients)
  - [ ] Presentation layer: 60%+ (widgets, UI logic)

**Dependencies:** M4, M5 should be complete for comprehensive testing

---

## Low Priority - Technical Debt & Enhancements

### Code Quality & Tooling
- [ ] Add linting configuration
  - [ ] Configure `analysis_options.yaml` with strict rules
  - [ ] Enable recommended Flutter lints
  - [ ] Add custom rules for consistency
  - [ ] Fix any existing lint warnings
- [ ] Add code formatting enforcement
  - [ ] Set up pre-commit hook for `dart format`
  - [ ] Document code style guidelines
- [ ] Add dependency management
  - [ ] Document all package dependencies and their purpose
  - [ ] Review for unused dependencies
  - [ ] Update to latest stable versions
  - [ ] Set up `dependabot` or similar for updates
- [ ] Add performance profiling
  - [ ] Identify any performance bottlenecks
  - [ ] Optimize widget rebuilds
  - [ ] Lazy-load data where appropriate
  - [ ] Profile memory usage

### Security Enhancements
- [ ] Add secure storage audit
  - [ ] Verify Firebase tokens are stored securely
  - [ ] Ensure no sensitive data in logs
  - [ ] Review Hive encryption needs
  - [ ] Implement Hive encryption for sensitive data if needed
- [ ] Add input validation
  - [ ] Validate file types before upload
  - [ ] Validate file sizes (max 10MB)
  - [ ] Sanitize user input in edit forms
  - [ ] Validate barcode format
- [ ] Add network security
  - [ ] Enforce HTTPS for all API calls
  - [ ] Implement certificate pinning (production)
  - [ ] Add request timeout limits

### UX Improvements
- [ ] Add onboarding flow
  - [ ] Welcome screen explaining app purpose
  - [ ] Tutorial for capture flows
  - [ ] Allergen preference setup
  - [ ] Skip option for returning users
- [ ] Add user preferences/settings
  - [ ] Allergen profile (common allergens to watch)
  - [ ] Dietary restrictions
  - [ ] Language preference (future multi-language)
  - [ ] Theme preference (light/dark mode)
  - [ ] Notification preferences
- [ ] Add accessibility features
  - [ ] Screen reader support (Semantics widgets)
  - [ ] High contrast mode
  - [ ] Font size scaling
  - [ ] Voice input for ingredient editing
- [ ] Add haptic feedback
  - [ ] Capture button feedback
  - [ ] Error vibration
  - [ ] Success confirmation
- [ ] Add animations and transitions
  - [ ] Smooth page transitions
  - [ ] Loading animations
  - [ ] Success/error animations (Lottie)
  - [ ] Microinteractions for better UX

### Feature Enhancements (Post-MVP)
- [ ] Add batch capture mode
  - [ ] Capture multiple products in one session
  - [ ] Queue all for processing
  - [ ] Review all before saving
- [ ] Add meal tagging
  - [ ] Tag as breakfast, lunch, dinner, snack
  - [ ] Custom tags
  - [ ] Filter history by tags
- [ ] Add notes and annotations
  - [ ] Add text notes to entries
  - [ ] Voice notes
  - [ ] Favorite/star important entries
- [ ] Add sharing functionality
  - [ ] Share entry as text/image
  - [ ] Export history to PDF
  - [ ] Share with nutritionist/doctor
- [ ] Add nutrition tracking (if backend provides data)
  - [ ] Calorie counting
  - [ ] Macro tracking
  - [ ] Daily goals
  - [ ] Progress charts

### Infrastructure & DevOps
- [ ] Add CI/CD pipeline
  - [ ] GitHub Actions or similar
  - [ ] Run tests on PR
  - [ ] Build and sign APK/IPA
  - [ ] Deploy to internal testing tracks
- [ ] Add error tracking
  - [ ] Integrate Sentry or Firebase Crashlytics
  - [ ] Track non-fatal errors
  - [ ] Add user context to errors
  - [ ] Set up error alerts
- [ ] Add analytics
  - [ ] Firebase Analytics for user behavior
  - [ ] Track feature usage
  - [ ] Track conversion funnels
  - [ ] A/B testing framework
- [ ] Add app distribution
  - [ ] Set up Firebase App Distribution for beta testing
  - [ ] Configure TestFlight (iOS)
  - [ ] Google Play Internal Testing (Android)
- [ ] Add environment management
  - [ ] Separate dev/staging/prod configurations
  - [ ] Environment-specific Firebase projects
  - [ ] Environment-specific backend URLs
  - [ ] Build flavors for different environments

---

## Notes

### Current Implementation Status

✅ **Completed:**
- Firebase authentication (Apple, Google, email/password)
- Token persistence with `SecureTokenStore`
- Camera, gallery, and barcode scanner capture flows
- Offline queue system with Hive storage
- Queue processor with retry logic
- Backend API client for analyze endpoints
- Basic history page with queue and results lists

⚠️ **Partial:**
- M4 (Analyze flow) - Core logic exists, but missing Firebase token interceptor in Dio
- History page - Basic list exists, needs date grouping, filtering, and detail navigation

❌ **Not Started:**
- Review & edit UI (M5)
- Complete history/today tabs (M6)
- Sync-ready architecture (M7)
- Comprehensive test suite (M8)

### Dependencies Map

```
M4 (Analyze flow completion)
  ↓
M5 (Review UI) ← can start after M4 validation
  ↓
M6 (History enhancement) ← can run parallel with M5
  ↓
M7 (Sync architecture) ← requires Backend B6 (Entries API)
                      ← requires Backend B5 (Analysis persistence)
  ↓
M8 (Testing) ← should cover M5, M6, M7 once complete
```

### Immediate Next Steps (Recommended Order)

1. **Infra:** Run `flutter analyze` and `flutter test` to check current code health
2. **M4:** Implement Firebase token interceptor in Dio
3. **M4:** Test backend integration end-to-end with real Firebase auth
4. **M5:** Build review & edit UI
5. **M6:** Enhance history page with grouping and filters
6. **M7:** Start sync architecture (while waiting for backend B5/B6)
7. **M8:** Add comprehensive test coverage

### Key Reminders

- **Spanish-first:** All user-facing text must be in Spanish
- **Offline-first:** Always queue operations, sync when online
- **Security:** Never log sensitive data (tokens, user info)
- **Testing:** Write tests before marking tasks complete
- **Documentation:** Update CLAUDE.md when adding new features
- **Code generation:** Run `build_runner` after model changes

### Environment Variables Reference

**Firebase (required for auth):**
- `FIREBASE_API_KEY`
- `FIREBASE_PROJECT_ID`
- `FIREBASE_APP_ID`

**Backend API:**
- `API_BASE_URL` (default: `http://10.0.2.2:8080` for Android emulator)

**Feature flags (future):**
- `ENABLE_CLOUD_SYNC` (for M7)
- `ENABLE_ANALYTICS`
- `ENABLE_CRASHLYTICS`

---

**Maintainer:** Update this file when completing tasks and mirror changes to `../PLAN.md` and `../TODOs.md`.

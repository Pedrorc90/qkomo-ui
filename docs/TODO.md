# qkomo-ui TODO

This file tracks pending implementation tasks for the qkomo-ui Flutter mobile app.

**Last Updated:** 2025-12-03
**Project Phase:** MVP - Core capture flow complete, pending review/history features

---

## High Priority - MVP Completion





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
  - [ ] Status transitions (pending → processing → succeeded/failed)
  - [ ] Query methods (pendingJobs, failedJobs)
- [ ] Test `CaptureResultRepository`
  - [ ] Query by date range
  - [ ] Delete operations
- [ ] Test `FirebaseTokenInterceptor`
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
- [ ] Test `CaptureReviewPage`
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

**Dependencies:** M4, M5, M6 should be complete for comprehensive testing

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

### Dependencies Map

```
M4 (Analyze flow completion)
  ↓
M7 (Sync architecture) ← requires Backend B6 (Entries API)
                      ← requires Backend B5 (Analysis persistence)
  ↓
M8 (Testing) ← should cover M4, M7 once complete
```

### Immediate Next Steps (Recommended Order)

1. **Infra:** Run `flutter analyze` and `flutter test` to check current code health
2. **M4:** Test backend integration end-to-end with real Firebase auth
3. **M7:** Start sync architecture (while waiting for backend B5/B6)
4. **M8:** Add comprehensive test coverage

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

**Maintainer:** Update this file when completing tasks. Move completed tasks to DONE.md.

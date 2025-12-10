# qkomo-ui TODO

This file tracks pending implementation tasks for the qkomo-ui Flutter mobile app.

**Last Updated:** 2025-12-10
**Project Phase:** MVP - Core capture flow complete, pending review/history features

## Project Milestones (from PLAN.md)

- [x] **M1 – Firebase auth & profile gating:** Configure Apple/Google/email sign-in, persist ID tokens, and guard app access.
- [x] **M2 – Capture surfaces:** Build camera, gallery import, and barcode scanner flows with Spanish-first messaging.
- [x] **M3 – Offline queue & storage:** Queue analyze jobs locally (Hive) and persist drafts/results for offline use.
- [x] **M4 – Analyze flow wiring:** Call backend `/v1/analyze` and `/v1/analyze/barcode`, show progress, and reconcile queued items.
  - Pendiente: probar contra backend real con token Firebase y correr `flutter analyze`/`flutter test`.
- [x] **M5 – Review & edit UI:** Let users edit ingredient/allergen lists and confirm before saving.
- [x] **M6 – Today & History tabs:** Implement log views backed by local storage, ready for future sync.
- [ ] **M7 – Sync-ready architecture:** Abstract data layer for easy switch to online/offline hybrid when backend exposes entry APIs.
- [ ] **M8 – Mobile QA:** Add widget/state tests plus smoke tests for capture → review → save.
- [ ] **Infra – Flutter tooling:** Instalar `unzip`, regenerar Dart/Flutter SDK, ejecutar `flutter pub get`, `dart format`, `flutter analyze` y `flutter test`. (Partially covered by Technical Debt tasks)

---

## High Priority - MVP Completion

### M7 - Sync-Ready Architecture
**Status:** In Progress
**Goal:** Prepare data layer for cloud sync once backend entries API is available

#### Sync Metadata & Conflict Resolution
- [ ] `cloudVersion` (for conflict detection)
- [ ] `pendingChanges` (track local edits)
- [ ] Implement conflict resolution strategy
  - [ ] User prompt to choose version (advanced)
  - [ ] Merge changes intelligently (complex)
- [ ] Retry failed syncs with exponential backoff
- [ ] Mark conflicts for user resolution

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

## Propuestas de Mejora - Análisis Técnico (2025-12-10)

Las siguientes propuestas surgen del análisis del código actual y buscan mejorar la calidad, mantenibilidad y rendimiento de la aplicación.

### 🔴 Alta Prioridad - Arquitectura y Patrones

#### P1 - Eliminar código duplicado en StreamProviders
**Ubicación:** `lib/features/capture/application/capture_providers.dart:107-224`
**Problema:** Los providers `pendingCaptureJobsProvider`, `failedCaptureJobsProvider`, `processingCaptureJobsProvider` y `queueStatsProvider` tienen lógica casi idéntica para crear StreamControllers y escuchar cambios en Hive.
**Propuesta:**
- Crear un helper genérico `HiveStreamProvider<T>` que encapsule el patrón común
- Reducir ~120 líneas de código duplicado a ~30 líneas
- Beneficio: Menos bugs por inconsistencias, más fácil de mantener

```dart
// Ejemplo de abstracción propuesta
StreamProvider<List<T>> createFilteredHiveStreamProvider<T>(
  Box<T> box,
  bool Function(T) filter,
  int Function(T, T)? comparator,
)
```

#### P2 - Usar Freezed consistentemente para modelos de dominio
**Ubicación:** `lib/features/capture/domain/capture_result.dart`, `lib/features/entry/domain/entry.dart`
**Problema:** Algunos modelos usan `copyWith` manual mientras que otros usan Freezed. `CaptureResult` y `Entry` tienen implementaciones manuales propensas a errores.
**Propuesta:**
- Migrar `CaptureResult` y `Entry` a Freezed
- Beneficio: Generación automática de `==`, `hashCode`, `toString()`, `copyWith`, y serialización JSON
- Reducción de código boilerplate ~50%

#### P3 - Evitar uso de `dynamic` en CaptureReviewPage (Completed)
**Ubicación:** `lib/features/capture/presentation/review/capture_review_page.dart:76-131`
**Problema:** Los parámetros `state` y `controller` están tipados como `dynamic`, perdiendo type-safety.
**Propuesta:**
- [x] Tipar correctamente: `CaptureReviewState state, CaptureReviewController controller`
- [x] Beneficio: Detección de errores en tiempo de compilación

#### P4 - Implementar logging estructurado en lugar de `print()` (Completed)
**Ubicación:** `lib/features/capture/application/capture_queue_processor.dart:46-56,93-94`
**Problema:** Se usa `print()` para logging, lo cual no es apropiado para producción.
**Propuesta:**
- [x] Implementar un servicio de logging con niveles (debug, info, warning, error)
- [x] Integrar con Firebase Crashlytics para errores en producción
- [x] Usar `debugPrint` o `logger` package para desarrollo
- [x] Beneficio: Mejor debugging y monitoreo en producción

### 🟡 Media Prioridad - Mejoras de Código

#### P5 - Extraer constantes mágicas a configuración (Completed)
**Ubicación:** Múltiples archivos
**Problema:** Valores hardcodeados dispersos:
- `Duration(seconds: 30)` para timeouts en Dio (`dio_provider.dart:18`)
- `Duration(days: 7)` para TTL de jobs (`capture_queue_processor.dart:20`)
- `3` max retry attempts (`capture_queue_processor.dart:21`)
- `30000ms` cap para backoff (`capture_queue_processor.dart:77`)
**Propuesta:**
- [x] Crear `lib/config/app_constants.dart` con todas las constantes
- [x] Permitir override vía variables de entorno para testing
- [x] Beneficio: Configuración centralizada y fácil de ajustar

#### P6 - Mejorar manejo de errores en HybridEntryRepository
**Ubicación:** `lib/features/entry/data/hybrid_entry_repository.dart:103-108`
**Problema:** El catch silencia errores con un TODO comment, sin logging apropiado ni notificación al usuario.
**Propuesta:**
- Implementar `Result<T>` pattern o `Either<Failure, Success>`
- Propagar errores de sync al usuario cuando sea relevante
- Agregar logging estructurado
- Beneficio: Mejor experiencia de usuario y debugging

#### P7 - Implementar rate limiting para sync automático
**Ubicación:** `lib/features/sync/application/sync_service.dart:46-61`
**Problema:** Cada cambio de conectividad dispara sync, potencialmente causando muchas requests.
**Propuesta:**
- Implementar debouncing/throttling (ej: máximo 1 sync cada 30 segundos)
- Agregar backoff exponencial cuando hay errores consecutivos
- Beneficio: Reducción de carga en backend y batería del dispositivo

#### P8 - Separar widgets en archivos más pequeños
**Ubicación:** `lib/features/capture/presentation/capture_page.dart` (315 líneas)
**Problema:** El archivo contiene `CapturePage` y `_CaptureOptionCard` en el mismo archivo, violando single-responsibility.
**Propuesta:**
- Extraer `_CaptureOptionCard` a `widgets/capture_option_card.dart`
- Beneficio: Mejor organización, widgets reutilizables

### 🟢 Baja Prioridad - Optimizaciones

#### P9 - Optimizar queries de Hive con índices
**Ubicación:** `lib/features/capture/application/capture_providers.dart`
**Problema:** Los providers filtran datos iterando sobre todos los valores del box cada vez.
**Propuesta:**
- Mantener índices secundarios en memoria para filtros frecuentes (por status, por fecha)
- Usar `box.listenable()` con `ValueListenableBuilder` en lugar de StreamController manual
- Beneficio: Mejor rendimiento con grandes volúmenes de datos

#### P10 - Implementar caché de imágenes
**Ubicación:** `lib/features/capture/presentation/review/widgets/photo_viewer.dart`
**Problema:** No hay estrategia visible de caché de imágenes.
**Propuesta:**
- Usar `cached_network_image` para imágenes remotas
- Implementar LRU cache para imágenes locales procesadas
- Beneficio: Mejor rendimiento y experiencia de usuario

#### P11 - Expandir configuración de analysis_options.yaml (Completed)
**Ubicación:** `analysis_options.yaml`
**Problema:** Solo tiene 2 reglas de linting activas.
**Propuesta:**
- [x] Habilitar reglas adicionales de flutter_lints:
  ```yaml
  linter:
    rules:
      avoid_print: true
      avoid_type_to_string: true
      cancel_subscriptions: true
      close_sinks: true
      prefer_const_constructors: true
      prefer_const_declarations: true
      prefer_final_fields: true
      prefer_final_locals: true
      unawaited_futures: true
      unnecessary_await_in_return: true
  ```
- Beneficio: Detección temprana de problemas comunes

#### P12 - Añadir documentación de código público
**Ubicación:** Múltiples archivos (repositories, controllers, services)
**Problema:** Falta documentación en clases y métodos públicos de la capa de dominio y aplicación.
**Propuesta:**
- Documentar todas las clases públicas con `///` dartdoc
- Agregar ejemplos de uso donde sea apropiado
- Beneficio: Mejor mantenibilidad y onboarding

### 🔵 Mejoras de Testing

#### P13 - Aumentar cobertura de tests unitarios
**Estado actual:** 13 archivos de test
**Propuesta:**
- [ ] Tests para `AuthController` (sign in flows, error handling)
- [ ] Tests para `CaptureController` (state transitions, error states)
- [ ] Tests para `HistoryController` (filtering, search)
- [ ] Tests para `DirectAnalyzeController`
- Meta: 80% cobertura en capa de aplicación

#### P14 - Implementar tests de widget
**Propuesta:**
- [ ] `CapturePage` - renderizado de opciones, navegación
- [ ] `CaptureReviewPage` - edición de ingredientes, guardado
- [ ] `HistoryPage` - filtros, agrupación, empty states
- [ ] `SignInPage` - formularios, validación
- Meta: Cobertura de flujos críticos de usuario

#### P15 - Configurar CI/CD con GitHub Actions
**Propuesta:**
- Workflow para `flutter analyze` y `flutter test` en cada PR
- Build automático de APK/IPA para releases
- Publicación automática a Firebase App Distribution

### 📋 Resumen de Impacto

| Propuesta | Esfuerzo | Impacto | Riesgo |
|-----------|----------|---------|--------|
| P1 - Eliminar código duplicado | Medio | Alto | Bajo |
| P2 - Freezed para modelos | Medio | Alto | Bajo |
| P3 - Eliminar `dynamic` | Bajo | Medio | Bajo |
| P4 - Logging estructurado | Medio | Alto | Bajo |
| P5 - Constantes centralizadas | Bajo | Medio | Bajo |
| P6 - Manejo de errores | Medio | Alto | Medio |
| P7 - Rate limiting sync | Bajo | Medio | Bajo |
| P8 - Separar widgets | Bajo | Bajo | Bajo |
| P9 - Optimizar Hive queries | Alto | Medio | Medio |
| P10 - Caché de imágenes | Medio | Medio | Bajo |
| P11 - Linting estricto | Bajo | Medio | Bajo |
| P12 - Documentación | Alto | Medio | Bajo |
| P13 - Tests unitarios | Alto | Alto | Bajo |
| P14 - Tests de widget | Alto | Alto | Bajo |
| P15 - CI/CD | Medio | Alto | Bajo |

**Recomendación de orden de implementación:**
1. P3, P4, P5 (quick wins, bajo riesgo)
2. P11 (habilitar linting estricto para prevenir nuevos issues)
3. P1, P2 (refactoring de alto impacto)
4. P6, P7 (robustez del sistema)
5. P13, P14, P15 (testing y CI/CD)
6. P8, P9, P10, P12 (optimizaciones y polish)

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

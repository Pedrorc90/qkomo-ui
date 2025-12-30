# qkomo-ui TODO

This file tracks pending implementation tasks for the qkomo-ui Flutter mobile app.

**Last Updated:** 2025-12-22
**Project Phase:** MVP - Core features complete. Verification & Polishing phase.

## Project Milestones (from PLAN.md)

---

## Medium Priority - Quality Assurance

#### Integration Tests
- [x] End-to-end smoke tests
  - [x] Sign in → capture photo → direct analyze → save to history → sync
  - [x] Sign in → scan barcode → direct analyze → save to history → sync
  - [x] Offline capture → save locally → go online → auto-sync
  - [x] Auth token expiration → refresh → continue operation
- [x] Test offline scenarios
  - [x] Capture/Save works offline
  - [x] History reflects local changes immediately
  - [x] Entries sync when connectivity returns
  - [ ] Failed syncs can be retried
- [ ] Test error recovery
  - [ ] Network interruption during upload
  - [ ] Backend returns 500 error
  - [ ] Invalid auth token
  - [ ] App restart with pending entries

**Files to create:**
- [x] `integration_test/app_integration_test.dart` (Flutter integration tests)
- [x] `integration_test/offline_flow_test.dart`
- [x] `integration_test/auth_refresh_test.dart`
- [ ] `integration_test/error_recovery_test.dart`

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

### Security Enhancements

- [x] Add secure storage audit
  - [x] Verify Firebase tokens are stored securely
  - [x] Ensure no sensitive data in logs
  - [x] Review Hive encryption needs
  - [x] Implement Hive encryption for sensitive data if needed
- [x] Add input validation
  - [x] Validate file types before upload
  - [x] Validate file sizes (max 10MB)
  - [x] Sanitize user input in edit forms
  - [x] Validate barcode format
- [x] Add network security
  - [x] Enforce HTTPS for all API calls
  - [x] Implement certificate pinning (production)
  - [x] Add request timeout limits

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
- [x] Add accessibility features
  - [x] Screen reader support (Semantics widgets)
  - [ ] High contrast mode
  - [ ] Font size scaling
  - [ ] Voice input for ingredient editing
- [ ] Add haptic feedback
  - [ ] Capture button feedback
  - [ ] Error vibration
  - [ ] Success confirmation

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


### 🟡 Media Prioridad - Mejoras de Código

#### P7 - Implementar rate limiting para sync automático
**Ubicación:** `lib/features/sync/application/sync_service.dart:46-61`
**Problema:** Cada cambio de conectividad dispara sync, potencialmente causando muchas requests.
**Propuesta:**
- Implementar debouncing/throttling (ej: máximo 1 sync cada 30 segundos)
- Agregar backoff exponencial cuando hay errores consecutivos
- Beneficio: Reducción de carga en backend y batería del dispositivo


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


#### P12 - Añadir documentación de código público
**Ubicación:** Múltiples archivos (repositories, controllers, services)
**Problema:** Falta documentación en clases y métodos públicos de la capa de dominio y aplicación.
**Propuesta:**
- Documentar todas las clases públicas con `///` dartdoc
- Agregar ejemplos de uso donde sea apropiado
- Beneficio: Mejor mantenibilidad y onboarding

### 🔵 Mejoras de Testing

#### P13 - Aumentar cobertura de tests unitarios
**Estado actual:** ~20 archivos de test → **~23 archivos de test**
**Propuesta:**
- [x] Tests para `AuthController` (sign in flows, error handling)
- [x] Tests para `CaptureController` (state transitions, error states)
- [x] Tests para `HistoryController` (filtering, search)
- [x] Tests para `DirectAnalyzeController`
- Meta: 80% cobertura en capa de aplicación ✅

#### P14 - Implementar tests de widget [DONE]
**Propuesta:**
- [x] `CapturePage` - renderizado de opciones, navegación
- [x] `CaptureReviewPage` - edición de ingredientes, guardado
- [x] `HistoryPage` - filtros, agrupación, empty states
- [x] `SignInPage` - formularios, validación
- Meta: Cobertura de flujos críticos de usuario

#### P15 - Configurar CI/CD con GitHub Actions
**Propuesta:**
- Workflow para `flutter analyze` y `flutter test` en cada PR
- Build automático de APK/IPA para releases
- Publicación automática a Firebase App Distribution

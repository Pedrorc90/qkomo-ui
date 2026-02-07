# qkomo-ui TODO

This file tracks pending implementation tasks for the qkomo-ui Flutter mobile app.

**Last Updated:** 2025-12-22
**Project Phase:** MVP - Core features complete. Verification & Polishing phase.

## Project Milestones (from PLAN.md)

---

## Medium Priority - Quality Assurance


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
- [] Add accessibility features
  - [ ] High contrast mode
  - [ ] Font size scaling

### Feature Enhancements (Post-MVP)
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

#### P10 - Implementar caché de imágenes
**Ubicación:** `lib/features/capture/presentation/review/widgets/photo_viewer.dart`
**Problema:** No hay estrategia visible de caché de imágenes.
**Propuesta:**
- Usar `cached_network_image` para imágenes remotas
- Implementar LRU cache para imágenes locales procesadas
- Beneficio: Mejor rendimiento y experiencia de usuario


### 🔵 Mejoras de Testing

#### P15 - Configurar CI/CD con GitHub Actions
**Propuesta:**
- Workflow para `flutter analyze` y `flutter test` en cada PR
- Build automático de APK/IPA para releases
- Publicación automática a Firebase App Distribution

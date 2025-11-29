# Flutter Expert Agent Guidelines

## Role & Focus
- Act as a senior Flutter engineer who optimizes for readability, maintainability, and testability.
- Favor clean architecture: keep UI (widgets), state management, domain logic, and data layers separated.
- Assume work happens inside `lib/` unless a task states otherwise; reflect widget or feature hierarchy in folders.
- Document assumptions and trade‑offs briefly in PRs or change notes so reviewers can follow the reasoning.

## Coding & Widget Practices
- Default to composing new widgets whenever a build method grows beyond ~40 lines or mixes more than one responsibility. Give each widget a single, descriptive purpose.
- Use immutable `const` widgets and constructors whenever possible; avoid storing state in UI layers unless it truly belongs there.
- Follow Dart style (flutter format) and add concise doc comments for public classes/methods that aren’t self‑explanatory.
- Keep files focused: one primary class/widget per file plus small private helpers. Name files with snake_case mirroring the widget or service.
- Prefer dependency injection (constructor parameters or providers) over singletons. Surface interfaces for services if multiple implementations may exist.

## Architecture & State Management
- Choose predictable state solutions (e.g., Riverpod, Bloc, or ValueNotifier) based on existing project patterns; don’t mix paradigms without justification.
- Keep asynchronous calls out of `build` methods; trigger them through lifecycle hooks, controllers, or state providers.
- Structure features as `feature_name/view`, `feature_name/widgets`, `feature_name/state`, etc., so future contributors immediately see boundaries.
- When modifying navigation, centralize routes in a dedicated router or `GoRouter` configuration to avoid ad hoc `Navigator` calls.
- Layering we follow here: `domain` (errores/entidades puras), `application` (controladores/almacenamiento/DI), `presentation` (widgets/UI por feature). Mantén un archivo por clase y usa carpetas por feature (`feature_name/presentation/...`).

## Testing & Quality
- Write widget tests for new UI components and unit tests for pure logic. Use golden tests only when visual regressions are critical.
- Mock or fake platform/services boundaries; do not hit live APIs in automated tests.
- Run `flutter analyze` and `flutter test` before handoff. Mention skipped tests or known issues explicitly.

## Tooling & Workflow
- Common commands:
  - `flutter pub get` to sync dependencies.
  - `flutter analyze` for static checks (treat warnings as failures).
  - `flutter test --coverage` when measuring impact on coverage.
  - `flutter run -d chrome` (web) or the appropriate device when manual verification is needed.
- Keep `pubspec.yaml` tidy: group dependencies logically and document reasons for new packages in PR descriptions.

## Communication & Documentation
- Explain architectural decisions inline with short comments only where the reasoning isn’t obvious (avoid noise).
- Update README or feature docs when adding workflows, environment variables, or setup steps.
- When delivering changes, include a brief outline of the widget tree or data flow so reviewers can trace the structure quickly.

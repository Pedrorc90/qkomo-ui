# qkomo-ui (Flutter)

AI-powered food logging mobile app. UI in Spanish, code in English.

## Stack
Flutter 3 / Dart 3, Riverpod, Dio, Firebase Auth, Hive (offline-first)

## Mandatory Architecture

Feature-based structure (`lib/features/<feature>/`):
- `domain/` → Entities, interfaces
- `application/` → Controllers (StateNotifier), UseCases
- `data/` → Repositories, API clients, Hive adapters
- `presentation/` → Widgets, Pages

Implementation order: Domain → Data → Presentation

## Forbidden
- Business logic in Widgets
- Data layer imports in Presentation
- Widgets > 100 lines
- Nesting > 4 levels

## Working Rules

- Concise responses: code first
- DO NOT generate tests unless requested
- DO NOT document extensively unless requested
- Surgical edits, don't regenerate entire files
- Confirm plan before changes affecting +3 files

## Feature-level CLAUDE.md

When working on a specific feature:
1. Check if `CLAUDE.md` exists in the feature directory
2. If it doesn't exist and context is complex, **ask me** if I want to create one before proceeding
3. If it exists, read it for specific context

## Common Commands

```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080
flutter pub run build_runner build --delete-conflicting-outputs
```

## Current Status

See `TODO.md` for pending tasks.
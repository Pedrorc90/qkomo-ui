# QKomo UI - Dependencies Documentation

This document provides an overview of all package dependencies used in the QKomo UI project and their purposes.

## Production Dependencies

### Core Flutter & State Management
- **flutter** - Flutter SDK
- **flutter_riverpod** (^2.5.1) - State management solution using Riverpod
- **cupertino_icons** (^1.0.5) - iOS-style icons

### Networking & API
- **dio** (^5.4.3+1) - HTTP client for API requests
- **dio_smart_retry** (^6.0.0) - Automatic retry logic for failed requests

### Data Serialization
- **freezed_annotation** (^2.4.4) - Annotations for code generation with Freezed
- **json_annotation** (^4.9.0) - Annotations for JSON serialization

### Camera & Media
- **camera** (^0.11.0+2) - Camera access for food capture
- **image_picker** (^1.0.7) - Image selection from gallery
- **mobile_scanner** (^3.5.5) - Barcode/QR code scanning
- **image** (^4.1.0) - Image manipulation utilities
- **photo_view** (^0.14.0) - Zoomable image viewer

### Permissions
- **permission_handler** (^11.3.1) - Runtime permission handling

### Authentication
- **firebase_core** (^2.30.1) - Firebase core functionality
- **firebase_auth** (^4.19.6) - Firebase authentication
- **google_sign_in** (^6.2.1) - Google Sign-In integration
- **sign_in_with_apple** (7.0.1) - Apple Sign-In integration

### Local Storage
- **hive** (^2.2.3) - Lightweight NoSQL database
- **hive_flutter** (^1.1.0) - Hive integration for Flutter
- **flutter_secure_storage** (^9.2.2) - Secure storage for sensitive data
- **path_provider** (^2.1.2) - Access to common file system locations
- **path** (^1.9.0) - Path manipulation utilities

### UI & Styling
- **google_fonts** (^6.1.0) - Google Fonts integration
- **flutter_svg** (^2.2.3) - SVG rendering
- **shimmer** (^3.0.0) - Shimmer loading effect
- **lottie** (^3.1.2) - Lottie animations

### Data Visualization
- **fl_chart** (^1.1.1) - Charts and graphs for nutrition data

### Utilities
- **uuid** (^4.4.0) - UUID generation
- **intl** (^0.19.0) - Internationalization and localization
- **workmanager** (^0.9.0+3) - Background task scheduling
- **connectivity_plus** (^7.0.0) - Network connectivity monitoring

## Development Dependencies

### Testing
- **flutter_test** - Flutter testing framework
- **integration_test** - Integration testing support
- **mockito** (^5.4.4) - Mocking framework for tests

### Code Generation
- **build_runner** (^2.4.9) - Code generation runner
- **freezed** (^2.5.2) - Code generation for immutable classes
- **json_serializable** (^6.8.0) - JSON serialization code generation
- **hive_generator** (^2.0.1) - Hive type adapter generation

### Code Quality
- **flutter_lints** (^3.0.1) - Recommended lints for Flutter projects

### Assets
- **flutter_launcher_icons** (^0.13.1) - App icon generation

## Dependency Management

### Updating Dependencies

To check for outdated dependencies:
```bash
flutter pub outdated
```

To update all dependencies to their latest compatible versions:
```bash
flutter pub upgrade
```

To update a specific package:
```bash
flutter pub upgrade package_name
```

### Automated Updates

This project uses Dependabot (configured in `.github/dependabot.yml`) to automatically:
- Check for dependency updates weekly (every Monday)
- Create pull requests for updates
- Group related packages together (Flutter, Firebase, dev dependencies)

### Adding New Dependencies

When adding a new dependency:
1. Add it to `pubspec.yaml` under the appropriate section
2. Run `flutter pub get` to install it
3. Document its purpose in this file
4. Update the implementation plan if it's a significant addition

### Removing Dependencies

Before removing a dependency:
1. Search the codebase to ensure it's not used: `grep -r "package_name" lib/`
2. Remove it from `pubspec.yaml`
3. Run `flutter pub get`
4. Update this documentation

## Dependency Review Checklist

- [x] All dependencies documented with their purpose
- [ ] Review for unused dependencies (run `flutter pub deps` and analyze)
- [ ] All dependencies on latest stable versions
- [x] Dependabot configured for automatic updates

## Notes

- **Firebase packages** are grouped together for easier management
- **Dev dependencies** are kept separate and only used during development
- **Code generation packages** (freezed, json_serializable, hive_generator) require `build_runner` to function

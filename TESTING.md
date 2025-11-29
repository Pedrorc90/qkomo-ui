# Testing Guide

This document provides instructions for running tests in the qkomo-ui project.

## Unit Tests

Unit tests cover individual classes and logic that do not require a running device or backend.

### Running Unit Tests

Run all unit tests:
```bash
flutter test
```

Run a specific test file:
```bash
flutter test test/features/capture/data/backend_capture_analyzer_test.dart
```

## Integration Tests

Integration tests verify the interaction between components and, in some cases, the backend server. These tests reside in the `integration_test` directory.

### Prerequisites

1.  **Backend Server**: For full integration testing, you need a running instance of the backend server.
    *   Default URL: `http://10.0.2.2:8080` (Android Emulator localhost)
    *   To override: `flutter test --dart-define=API_BASE_URL=http://your-api-url ...`

2.  **Device/Emulator**: Integration tests run on a real device or emulator. Connect one before running.

### Running Integration Tests

Run the backend integration suite:
```bash
flutter test integration_test/backend_integration_test.dart
```

### Test Scenarios

The `backend_integration_test.dart` suite covers:

1.  **Photo Upload Flow**:
    *   Queues a photo for processing.
    *   Verifies Hive storage.
    *   (Requires Backend) Uploads photo and verifies analysis.

2.  **Barcode Analysis Flow**:
    *   Queues a barcode.
    *   (Requires Backend) Sends barcode and verifies product data.

3.  **Offline Queue Processing**:
    *   Verifies that jobs are queued locally when offline.
    *   (Requires Backend) Verifies processing resumes when online.

4.  **Error Handling**:
    *   Verifies system handles missing files gracefully.
    *   (Requires Backend) Verifies handling of Network, Auth (401), and Server (5xx) errors.

### Troubleshooting

*   **Backend Not Reachable**: Ensure the backend is running and accessible from the device. For Android emulator, use `10.0.2.2`.
*   **Skipped Tests**: Tests marked with `skip: true` require a backend. To run them, you may need to modify the test file to remove the skip flag or ensure the backend check passes.

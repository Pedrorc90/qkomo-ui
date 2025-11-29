import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// Helper utilities for integration tests
class TestHelpers {
  /// Create a test image file for upload testing
  static Future<File> createTestImage({
    String filename = 'test_image.jpg',
    int width = 100,
    int height = 100,
  }) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$filename');

    // Create a simple 1x1 pixel JPEG (minimal valid JPEG)
    // This is a minimal valid JPEG file structure
    final bytes = Uint8List.fromList([
      0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10, 0x4A, 0x46, // JPEG header
      0x49, 0x46, 0x00, 0x01, 0x01, 0x00, 0x00, 0x01,
      0x00, 0x01, 0x00, 0x00, 0xFF, 0xDB, 0x00, 0x43,
      0x00, 0x08, 0x06, 0x06, 0x07, 0x06, 0x05, 0x08,
      0x07, 0x07, 0x07, 0x09, 0x09, 0x08, 0x0A, 0x0C,
      0x14, 0x0D, 0x0C, 0x0B, 0x0B, 0x0C, 0x19, 0x12,
      0x13, 0x0F, 0x14, 0x1D, 0x1A, 0x1F, 0x1E, 0x1D,
      0x1A, 0x1C, 0x1C, 0x20, 0x24, 0x2E, 0x27, 0x20,
      0x22, 0x2C, 0x23, 0x1C, 0x1C, 0x28, 0x37, 0x29,
      0x2C, 0x30, 0x31, 0x34, 0x34, 0x34, 0x1F, 0x27,
      0x39, 0x3D, 0x38, 0x32, 0x3C, 0x2E, 0x33, 0x34,
      0x32, 0xFF, 0xC0, 0x00, 0x0B, 0x08, 0x00, 0x01,
      0x00, 0x01, 0x01, 0x01, 0x11, 0x00, 0xFF, 0xC4,
      0x00, 0x14, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x03, 0xFF, 0xC4, 0x00, 0x14,
      0x10, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0xFF, 0xDA, 0x00, 0x08, 0x01, 0x01,
      0x00, 0x00, 0x3F, 0x00, 0x37, 0xFF, 0xD9, // JPEG end
    ]);

    await file.writeAsBytes(bytes);
    return file;
  }

  /// Create a large test image file (for testing file size limits)
  static Future<File> createLargeTestImage({
    String filename = 'large_test_image.jpg',
  }) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$filename');

    // Create a file larger than 10MB
    final bytes = Uint8List(11 * 1024 * 1024); // 11 MB
    await file.writeAsBytes(bytes);
    return file;
  }

  /// Generate a test barcode
  static String generateTestBarcode({String? code}) {
    return code ?? '1234567890123'; // Standard EAN-13 barcode
  }

  /// Check if backend is reachable
  static Future<bool> isBackendReachable(String baseUrl) async {
    try {
      final socket = await Socket.connect(
        Uri.parse(baseUrl).host,
        Uri.parse(baseUrl).port,
        timeout: const Duration(seconds: 5),
      );
      socket.destroy();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Wait for a condition to be true with timeout
  static Future<bool> waitFor(
    Future<bool> Function() condition, {
    Duration timeout = const Duration(seconds: 30),
    Duration pollInterval = const Duration(milliseconds: 500),
  }) async {
    final endTime = DateTime.now().add(timeout);

    while (DateTime.now().isBefore(endTime)) {
      if (await condition()) {
        return true;
      }
      await Future.delayed(pollInterval);
    }

    return false;
  }

  /// Clean up test files
  static Future<void> cleanupTestFiles() async {
    final tempDir = await getTemporaryDirectory();
    final testFiles = tempDir.listSync().where((file) {
      return file.path.contains('test_image') ||
          file.path.contains('test_');
    });

    for (final file in testFiles) {
      try {
        await file.delete();
      } catch (e) {
        // Ignore cleanup errors
      }
    }
  }
}

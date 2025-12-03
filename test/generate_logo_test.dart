import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qkomo_ui/core/widgets/qkomo_logo.dart';
import 'package:qkomo_ui/theme/app_theme.dart';
import 'package:qkomo_ui/theme/theme_type.dart';

void main() {
  testWidgets('Generate high-res logo', (WidgetTester tester) async {
    // Define the size for the icon (1024x1024 is good for high-res source)
    const double size = 1024.0;

    // Get the primary color from the warm theme
    final theme = AppTheme.theme(AppThemeType.warm);
    final primaryColor = theme.colorScheme.primary;

    // Build the widget
    final boundaryKey = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: RepaintBoundary(
              key: boundaryKey,
              child: QkomoLogo(
                size: size,
                color: primaryColor,
              ),
            ),
          ),
        ),
      ),
    );

    // Wait for rendering - pump multiple times to ensure layout and paint
    await tester.pump();
    await tester.pump();

    // Capture the image
    final finder = find.byKey(boundaryKey);
    final element = finder.evaluate().single as RenderObjectElement;
    final renderObject = element.renderObject as RenderRepaintBoundary;

    // Convert to image
    // Use runAsync to allow async image operations
    await tester.runAsync(() async {
      final image = await renderObject.toImage(pixelRatio: 1.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw Exception('Failed to get byte data from image');
      }

      final buffer = byteData.buffer.asUint8List();
      print('Captured image size: ${buffer.length} bytes');

      // Create assets directory if it doesn't exist
      final assetsDir = Directory('assets');
      if (!assetsDir.existsSync()) {
        assetsDir.createSync();
      }

      // Save to file
      final file = File('assets/icon_generated.png');
      await file.writeAsBytes(buffer);

      print('Icon generated at: ${file.absolute.path}');
    });
  });
}

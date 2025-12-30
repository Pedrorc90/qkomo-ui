import 'package:flutter/material.dart';

/// Stub for PlatformImage (should not be called on web due to kIsWeb check)
Widget buildFileImage({
  required String path,
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
  String? semanticLabel,
  Widget Function(BuildContext, Object, StackTrace?)? errorBuilder,
}) {
  throw UnsupportedError('File images are not supported on this platform');
}

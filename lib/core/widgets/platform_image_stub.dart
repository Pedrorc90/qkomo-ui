import 'package:flutter/material.dart';

/// Stub para PlatformImage (no debería ser llamado en web debido a kIsWeb check)
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

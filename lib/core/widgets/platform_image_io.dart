import 'dart:io';
import 'package:flutter/material.dart';

/// Implementación de IO para PlatformImage
Widget buildFileImage({
  required String path,
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
  String? semanticLabel,
  Widget Function(BuildContext, Object, StackTrace?)? errorBuilder,
}) {
  return Image.file(
    File(path),
    width: width,
    height: height,
    fit: fit,
    semanticLabel: semanticLabel,
    errorBuilder: errorBuilder,
  );
}

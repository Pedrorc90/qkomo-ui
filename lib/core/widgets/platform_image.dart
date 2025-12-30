import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qkomo_ui/core/widgets/platform_image_stub.dart'
    if (dart.library.io) 'package:qkomo_ui/core/widgets/platform_image_io.dart'
    as platform;

/// Widget para mostrar imágenes de forma compatible con todas las plataformas
class PlatformImage extends StatelessWidget {
  const PlatformImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorBuilder,
    this.semanticLabel,
  });

  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    // On web, we can't use File, so we show the placeholder
    if (kIsWeb) {
      return errorBuilder?.call(
            context,
            'Web platform does not support file paths',
            null,
          ) ??
          Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: const Icon(Icons.image_not_supported),
          );
    }

    // On native platforms, we use the IO-specific implementation
    return platform.buildFileImage(
      path: path,
      width: width,
      height: height,
      fit: fit,
      semanticLabel: semanticLabel,
      errorBuilder: errorBuilder,
    );
  }
}

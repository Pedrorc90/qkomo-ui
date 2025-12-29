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
    // En web, no podemos usar File, así que mostramos el placeholder
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

    // En plataformas nativas, usamos la implementación específica de IO
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

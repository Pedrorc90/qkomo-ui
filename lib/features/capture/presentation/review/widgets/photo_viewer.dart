import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

/// Widget for viewing photos with zoom and pan capabilities
class PhotoViewer extends StatelessWidget {
  const PhotoViewer({
    super.key,
    this.imagePath,
    this.title,
  });

  final String? imagePath;
  final String? title;

  @override
  Widget build(BuildContext context) {
    if (imagePath == null || imagePath!.isEmpty) {
      return _buildPlaceholder(context);
    }

    final file = File(imagePath!);
    if (!file.existsSync()) {
      return _buildPlaceholder(context);
    }

    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: PhotoView(
        imageProvider: FileImage(file),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 3,
        initialScale: PhotoViewComputedScale.contained,
        backgroundDecoration: const BoxDecoration(
          color: Colors.black,
        ),
        loadingBuilder: (context, event) => Center(
          child: CircularProgressIndicator(
            value:
                event == null ? 0 : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
          ),
        ),
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder(context);
        },
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 8),
          Text(
            title ?? 'Sin imagen',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

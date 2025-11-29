import 'package:flutter/material.dart';

import '../../application/capture_state.dart';
import 'picked_image_preview.dart';

class GalleryImportView extends StatelessWidget {
  const GalleryImportView({
    super.key,
    required this.state,
    required this.onImport,
  });

  final CaptureState state;
  final Future<void> Function() onImport;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Selecciona una foto de tu galería para analizarla.',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          PickedImagePreview(file: state.imageFile),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: state.isProcessing ? null : onImport,
            icon: const Icon(Icons.photo_library_outlined),
            label: Text(state.isProcessing
                ? 'Abriendo galería...'
                : 'Elegir desde galería'),
          ),
          if (state.isProcessing)
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

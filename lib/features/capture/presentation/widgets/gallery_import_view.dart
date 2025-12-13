import 'package:flutter/material.dart';

import 'package:qkomo_ui/features/capture/application/capture_state.dart';
import 'package:qkomo_ui/features/capture/presentation/widgets/picked_image_preview.dart';

class GalleryImportView extends StatelessWidget {
  const GalleryImportView({
    super.key,
    required this.state,
    required this.onImport,
    required this.onAnalyze,
    this.scrollable = true,
  });

  final CaptureState state;
  final Future<void> Function() onImport;
  final Future<void> Function() onAnalyze;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    if (scrollable) {
      return SingleChildScrollView(
        child: _buildContent(context),
      );
    }
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
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
            label: Text(state.isProcessing ? 'Abriendo galería...' : 'Elegir desde galería'),
          ),
          if (state.imageFile != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: FilledButton.icon(
                onPressed: state.isProcessing ? null : onAnalyze,
                icon: const Icon(Icons.analytics),
                label: Text(state.isProcessing ? 'Analizando...' : 'Analizar imagen'),
              ),
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

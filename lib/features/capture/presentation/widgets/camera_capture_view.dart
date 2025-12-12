import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:qkomo_ui/features/capture/application/capture_state.dart';
import 'package:qkomo_ui/features/capture/presentation/widgets/picked_image_preview.dart';

class CameraCaptureView extends StatelessWidget {
  const CameraCaptureView({
    super.key,
    required this.state,
    required this.onCapture,
    this.scrollable = true,
  });

  final CaptureState state;
  final Future<void> Function() onCapture;
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
            'Toma una foto enfocando los ingredientes o el producto.',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          PickedImagePreview(file: state.imageFile),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: state.isProcessing ? null : onCapture,
            icon: const Icon(Icons.camera_alt),
            label: Text(state.isProcessing ? 'Abriendo cámara...' : 'Abrir cámara'),
          ),
          if (!kIsWeb)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Asegúrate de conceder permisos de cámara.',
                style: Theme.of(context).textTheme.bodySmall,
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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:qkomo_ui/features/capture/application/capture_state.dart';
import 'package:qkomo_ui/features/capture/presentation/widgets/picked_image_preview.dart';

class CameraCaptureView extends StatelessWidget {
  const CameraCaptureView({
    super.key,
    required this.state,
    required this.onCapture,
    required this.onAnalyze,
    this.scrollable = true,
  });

  final CaptureState state;
  final Future<void> Function() onCapture;
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
          Text(
            'Toma una foto enfocando los ingredientes o el producto.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          _CameraPreviewPlaceholder(
            state: state,
            onCapture: onCapture,
          ),
          const SizedBox(height: 16),
          _CaptureButton(
            isProcessing: state.isProcessing,
            onPressed: state.isProcessing ? null : onCapture,
            label: state.isProcessing ? 'Abriendo cámara...' : 'Abrir cámara',
          ),
          if (state.imageFile != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: _AnalyzeButton(
                isProcessing: state.isProcessing,
                onPressed: state.isProcessing ? null : onAnalyze,
                label: state.isProcessing ? 'Analizando...' : 'Analizar foto',
              ),
            ),
          if (!kIsWeb)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Asegúrate de conceder permisos de cámara.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
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

class _CameraPreviewPlaceholder extends StatelessWidget {
  const _CameraPreviewPlaceholder({
    required this.state,
    required this.onCapture,
  });

  final CaptureState state;
  final Future<void> Function() onCapture;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: state.imageFile == null ? onCapture : null,
      child: Stack(
        children: [
          PickedImagePreview(file: state.imageFile),
          if (state.imageFile == null)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black.withAlpha((0.3 * 255).round()),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 48,
                        color: Colors.white.withAlpha((0.7 * 255).round()),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Abre la cámara para comenzar',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withAlpha((0.7 * 255).round()),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (state.imageFile != null)
            Positioned.fill(
              child: _GridOverlay(),
            ),
        ],
      ),
    );
  }
}

class _GridOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CustomPaint(
          painter: _GridPainter(),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha((0.3 * 255).round())
      ..strokeWidth = 1;

    // Líneas verticales
    final verticalDistance = size.width / 3;
    for (int i = 1; i < 3; i++) {
      canvas.drawLine(
        Offset(verticalDistance * i, 0),
        Offset(verticalDistance * i, size.height),
        paint,
      );
    }

    // Líneas horizontales
    final horizontalDistance = size.height / 3;
    for (int i = 1; i < 3; i++) {
      canvas.drawLine(
        Offset(0, horizontalDistance * i),
        Offset(size.width, horizontalDistance * i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CaptureButton extends StatelessWidget {
  const _CaptureButton({
    required this.isProcessing,
    required this.onPressed,
    required this.label,
  });

  final bool isProcessing;
  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.camera_alt),
      label: Text(label),
    );
  }
}

class _AnalyzeButton extends StatefulWidget {
  const _AnalyzeButton({
    required this.isProcessing,
    required this.onPressed,
    required this.label,
  });

  final bool isProcessing;
  final VoidCallback? onPressed;
  final String label;

  @override
  State<_AnalyzeButton> createState() => _AnalyzeButtonState();
}

class _AnalyzeButtonState extends State<_AnalyzeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(_AnalyzeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isProcessing && !oldWidget.isProcessing) {
      _controller.repeat(reverse: true);
    } else if (!widget.isProcessing && oldWidget.isProcessing) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.6, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: FilledButton.icon(
        onPressed: widget.onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
        icon: widget.isProcessing
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(
                    Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              )
            : const Icon(Icons.analytics),
        label: Text(widget.label),
      ),
    );
  }
}

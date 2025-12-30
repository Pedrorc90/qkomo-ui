import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:qkomo_ui/features/capture/application/capture_state.dart';
import 'package:qkomo_ui/theme/app_colors.dart';

class BarcodeScannerView extends StatefulWidget {
  const BarcodeScannerView({
    super.key,
    required this.state,
    required this.onBarcodeScanned,
    required this.onAnalyze,
  });

  final CaptureState state;
  final void Function(String barcode) onBarcodeScanned;
  final Future<void> Function() onAnalyze;

  @override
  State<BarcodeScannerView> createState() => _BarcodeScannerViewState();
}

class _BarcodeScannerViewState extends State<BarcodeScannerView>
    with TickerProviderStateMixin {
  late MobileScannerController _scannerController;
  late AnimationController _successController;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
    _successController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _successController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Enfoca el código de barras o QR con la cámara',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: widget.state.scannedBarcode == null
                ? Stack(
                    children: [
                      MobileScanner(
                        controller: _scannerController,
                        onDetect: (capture) {
                          final barcodes = capture.barcodes;
                          if (barcodes.isNotEmpty) {
                            final barcode = barcodes.first.rawValue;
                            if (barcode != null && barcode.isNotEmpty) {
                              _successController.forward();
                              widget.onBarcodeScanned(barcode);
                            }
                          }
                        },
                      ),
                      CustomPaint(
                        painter: _ScannerOverlayPainter(),
                      ),
                    ],
                  )
                : _ScannedBarcodeDisplay(
                    barcode: widget.state.scannedBarcode ?? '',
                    animationController: _successController,
                  ),
          ),
          const SizedBox(height: 16),
          if (widget.state.scannedBarcode != null) ...[
            _AnalyzeButton(
              isProcessing: widget.state.isProcessing,
              onPressed: widget.state.isProcessing ? null : widget.onAnalyze,
              label: widget.state.isProcessing
                  ? 'Analizando...'
                  : 'Analizar código',
            ),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: widget.state.isProcessing
                  ? null
                  : () {
                      _successController.reset();
                      setState(() {
                        // Reset scanner for new barcode
                      });
                    },
              child: const Text('Escanear otro código'),
            ),
          ],
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
          if (widget.state.isProcessing)
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.neutralWhite.withAlpha((0.4 * 255).round())
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Marco central para enfocar
    const margin = 50.0;
    const left = margin;
    final top = (size.height - (size.width - 2 * margin)) / 2;
    final right = size.width - margin;
    final bottom = top + (size.width - 2 * margin);

    // Main rectangle
    canvas.drawRect(Rect.fromLTRB(left, top, right, bottom), paint);

    // Esquinas redondeadas
    final cornerPaint = Paint()
      ..color = AppColors.neutralWhite.withAlpha((0.8 * 255).round())
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    const cornerSize = 30.0;

    // Top-left corner
    canvas.drawPath(
      Path()
        ..moveTo(left, top + cornerSize)
        ..lineTo(left, top)
        ..lineTo(left + cornerSize, top),
      cornerPaint,
    );

    // Top-right corner
    canvas.drawPath(
      Path()
        ..moveTo(right - cornerSize, top)
        ..lineTo(right, top)
        ..lineTo(right, top + cornerSize),
      cornerPaint,
    );

    // Bottom-left corner
    canvas.drawPath(
      Path()
        ..moveTo(left, bottom - cornerSize)
        ..lineTo(left, bottom)
        ..lineTo(left + cornerSize, bottom),
      cornerPaint,
    );

    // Bottom-right corner
    canvas.drawPath(
      Path()
        ..moveTo(right - cornerSize, bottom)
        ..lineTo(right, bottom)
        ..lineTo(right, bottom - cornerSize),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ScannedBarcodeDisplay extends StatelessWidget {
  const _ScannedBarcodeDisplay({
    required this.barcode,
    required this.animationController,
  });

  final String barcode;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.elasticOut),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withAlpha(
                  (0.3 * 255).round(),
                ),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animationController,
                    curve: Curves.easeOutBack,
                  ),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppColors.semanticSuccess,
                  size: 80,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Código escaneado',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  barcode,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
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

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../application/capture_permissions.dart';
import '../../application/capture_state.dart';

class BarcodeScannerView extends StatefulWidget {
  const BarcodeScannerView({
    super.key,
    required this.state,
    required this.onBarcode,
    this.onReset,
    required this.onRequestPermission,
    required this.onOpenSettings,
  });

  final CaptureState state;
  final ValueChanged<String> onBarcode;
  final VoidCallback? onReset;
  final Future<PermissionOutcome> Function() onRequestPermission;
  final Future<void> Function() onOpenSettings;

  @override
  State<BarcodeScannerView> createState() => _BarcodeScannerViewState();
}

class _BarcodeScannerViewState extends State<BarcodeScannerView> {
  late final MobileScannerController _scannerController;
  bool _locked = false;
  bool _permissionGranted = false;
  bool _needsSettings = false;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );
    _initPermissions();
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasBarcode = widget.state.barcode != null;
    if (!_permissionGranted) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.photo_camera_back_outlined, size: 48),
            const SizedBox(height: 12),
            Text(
              _needsSettings
                  ? 'Activa el permiso de cámara en Ajustes para escanear códigos.'
                  : 'Necesitamos acceso a la cámara para escanear códigos.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _needsSettings ? widget.onOpenSettings : _initPermissions,
              child: Text(_needsSettings ? 'Abrir ajustes' : 'Conceder acceso'),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Apunta al código de barras y espera a que se detecte automáticamente.',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          AspectRatio(
            aspectRatio: 3 / 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: MobileScanner(
                controller: _scannerController,
                onDetect: _handleDetection,
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (hasBarcode) ...[
            Text(
              'Código detectado:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            SelectableText(widget.state.barcode!),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: hasBarcode ? _restartScanner : null,
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Escanear de nuevo'),
              ),
              OutlinedButton.icon(
                onPressed: _toggleTorch,
                icon: const Icon(Icons.flash_on),
                label: const Text('Linterna'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleDetection(BarcodeCapture capture) {
    if (_locked) return;
    for (final code in capture.barcodes) {
      final value = code.rawValue;
      if (value != null && value.isNotEmpty) {
        _locked = true;
        _scannerController.stop();
        widget.onBarcode(value);
        break;
      }
    }
  }

  void _restartScanner() {
    _locked = false;
    widget.onReset?.call();
    _scannerController.start();
  }

  Future<void> _toggleTorch() async {
    await _scannerController.toggleTorch();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _initPermissions() async {
    final outcome = await widget.onRequestPermission();
    if (!mounted) return;
    setState(() {
      _permissionGranted = outcome.granted;
      _needsSettings = outcome.needsSettings;
    });
    if (outcome.granted) {
      _scannerController.start();
    }
  }
}

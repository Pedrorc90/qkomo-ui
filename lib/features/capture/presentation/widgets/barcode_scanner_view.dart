import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:qkomo_ui/features/capture/application/capture_state.dart';

class BarcodeScannerView extends StatefulWidget {
  const BarcodeScannerView({
    super.key,
    required this.state,
    required this.onBarcodeScanned,
  });

  final CaptureState state;
  final void Function(String barcode) onBarcodeScanned;

  @override
  State<BarcodeScannerView> createState() => _BarcodeScannerViewState();
}

class _BarcodeScannerViewState extends State<BarcodeScannerView> {
  late MobileScannerController _scannerController;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Enfoca el código de barras o QR con la cámara',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: widget.state.scannedBarcode == null
                ? MobileScanner(
                    controller: _scannerController,
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      if (barcodes.isNotEmpty) {
                        final barcode = barcodes.first.rawValue;
                        if (barcode != null && barcode.isNotEmpty) {
                          widget.onBarcodeScanned(barcode);
                        }
                      }
                    },
                  )
                : Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 64,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Código guardado: ${widget.state.scannedBarcode}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          if (widget.state.scannedBarcode != null)
            FilledButton(
              onPressed: widget.state.isProcessing
                  ? null
                  : () {
                      setState(() {
                        // Reset scanner for new barcode
                      });
                    },
              child: const Text('Escanear otro código'),
            ),
          if (!kIsWeb)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Asegúrate de conceder permisos de cámara.',
                style: Theme.of(context).textTheme.bodySmall,
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

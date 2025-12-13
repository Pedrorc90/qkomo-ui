import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/core/widgets/qkomo_navbar.dart';
import 'package:qkomo_ui/features/shell/state/navigation_provider.dart';
import 'package:qkomo_ui/theme/theme_providers.dart';

import 'package:qkomo_ui/features/capture/application/capture_controller.dart';
import 'package:qkomo_ui/features/capture/application/capture_providers.dart';
import 'package:qkomo_ui/features/capture/application/capture_state.dart';
import 'package:qkomo_ui/features/capture/domain/capture_mode.dart';
import 'package:qkomo_ui/features/capture/presentation/widgets/barcode_scanner_view.dart';
import 'package:qkomo_ui/features/capture/presentation/widgets/camera_capture_view.dart';
import 'package:qkomo_ui/features/capture/presentation/widgets/capture_status_banner.dart';
import 'package:qkomo_ui/features/capture/presentation/widgets/gallery_import_view.dart';
import 'package:qkomo_ui/features/capture/presentation/widgets/text_entry_view.dart';

class CapturePage extends ConsumerStatefulWidget {
  const CapturePage({super.key});

  @override
  ConsumerState<CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends ConsumerState<CapturePage> {
  ProviderSubscription<CaptureState>? _captureSubscription;
  ProviderSubscription<AsyncValue<String?>>? _analyzeSubscription;

  @override
  void initState() {
    super.initState();
    final controller = ref.read(captureControllerProvider.notifier);

    _captureSubscription = ref.listenManual<CaptureState>(
      captureControllerProvider,
      (previous, next) {
        if (next.error != null && next.error != previous?.error) {
          _showSnackBar(next.error!, isError: true);
          controller.clearError();
        } else if (next.message != null && next.message != previous?.message) {
          _showSnackBar(next.message!);
          controller.clearMessage();
        }
      },
    );

    _analyzeSubscription = ref.listenManual<AsyncValue<String?>>(
      directAnalyzeControllerProvider,
      (previous, next) {
        next.when(
          data: (jobId) {
            if (jobId != null) {
              _showSnackBar('Análisis completado. ID: $jobId');
            }
          },
          error: (error, _) => _showSnackBar('Error al analizar: $error', isError: true),
          loading: () {},
        );
      },
    );
  }

  @override
  void dispose() {
    _captureSubscription?.close();
    _analyzeSubscription?.close();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final captureState = ref.watch(captureControllerProvider);
    final controller = ref.read(captureControllerProvider.notifier);
    final gradient = ref.watch(appGradientProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: SafeArea(
          child: Column(
            children: [
              // Qkomo NavBar
              QkomoNavBar(
                leading: captureState.mode != null
                    ? IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => controller.clearMode(),
                      )
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => ref.read(bottomNavIndexProvider.notifier).state = 1,
                      ),
              ),
              Expanded(
                child: captureState.mode == null
                    ? _buildActionButtons(context, controller)
                    : _buildSelectedModeView(captureState),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, CaptureController controller) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '¿Cómo quieres registrar tu comida?',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            _CaptureOptionCard(
              icon: Icons.camera_alt_outlined,
              label: 'Cámara',
              description: 'Tomar una foto ahora',
              color: Colors.blue,
              onPressed: () => controller.setMode(CaptureMode.camera),
            ),
            const SizedBox(height: 16),
            _CaptureOptionCard(
              icon: Icons.photo_library_outlined,
              label: 'Galería',
              description: 'Elegir de tus fotos',
              color: Colors.green,
              onPressed: () => controller.setMode(CaptureMode.gallery),
            ),
            const SizedBox(height: 16),
            _CaptureOptionCard(
              icon: Icons.qr_code_2_outlined,
              label: 'Código de barras',
              description: 'Escanear código o QR',
              color: Colors.purple,
              onPressed: () => controller.setMode(CaptureMode.barcode),
            ),
            const SizedBox(height: 16),
            _CaptureOptionCard(
              icon: Icons.edit_note_outlined,
              label: 'Texto',
              description: 'Escribir ingredientes',
              color: Colors.orange,
              onPressed: () => controller.setMode(CaptureMode.text),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedModeView(CaptureState state) {
    final mode = state.mode;
    if (mode == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CaptureStatusBanner(
            mode: mode,
            hasImage: state.imageFile != null,
            message: state.message,
            error: state.error,
          ),
          _buildModeContent(mode),
        ],
      ),
    );
  }

  Widget _buildModeContent(CaptureMode mode) {
    final captureState = ref.watch(captureControllerProvider);
    final controller = ref.read(captureControllerProvider.notifier);
    final analyzeController = ref.read(directAnalyzeControllerProvider.notifier);

    Future<void> analyze() async {
      await analyzeController.analyze(captureState);
      if (mounted) {
        controller.clearMode();
      }
    }

    switch (mode) {
      case CaptureMode.camera:
        return CameraCaptureView(
          state: captureState,
          onCapture: controller.captureWithCamera,
          onAnalyze: analyze,
          scrollable: false,
        );
      case CaptureMode.gallery:
        return GalleryImportView(
          state: captureState,
          onImport: controller.importFromGallery,
          onAnalyze: analyze,
          scrollable: false,
        );
      case CaptureMode.barcode:
        return BarcodeScannerView(
          state: captureState,
          onBarcodeScanned: controller.onBarcodeScanned,
          onAnalyze: analyze,
        );
      case CaptureMode.text:
        return const TextEntryView();
    }
  }
}

class _CaptureOptionCard extends StatelessWidget {
  const _CaptureOptionCard({
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final String description;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: scheme.surface.withAlpha((0.7 * 255).round()),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: scheme.outlineVariant.withAlpha((0.5 * 255).round())),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: scheme.onSurfaceVariant.withAlpha((0.5 * 255).round()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

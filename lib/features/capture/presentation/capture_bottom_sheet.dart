import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/features/capture/application/capture_controller.dart';
import 'package:qkomo_ui/features/capture/application/capture_providers.dart';
import 'package:qkomo_ui/features/capture/application/capture_state.dart';
import 'package:qkomo_ui/features/capture/domain/entities/capture_mode.dart';
import 'package:qkomo_ui/features/capture/presentation/review/capture_review_page.dart';
import 'package:qkomo_ui/features/capture/presentation/widgets/barcode_scanner_view.dart';
import 'package:qkomo_ui/features/capture/presentation/widgets/camera_capture_view.dart';
import 'package:qkomo_ui/features/capture/presentation/widgets/capture_option_card.dart';
import 'package:qkomo_ui/features/capture/presentation/widgets/capture_status_banner.dart';
import 'package:qkomo_ui/features/capture/presentation/widgets/gallery_import_view.dart';
import 'package:qkomo_ui/features/capture/presentation/widgets/text_entry_view.dart';
import 'package:qkomo_ui/theme/app_colors.dart';
import 'package:qkomo_ui/theme/theme_providers.dart';

class CaptureBottomSheet extends ConsumerStatefulWidget {
  const CaptureBottomSheet({
    super.key,
    this.scrollController,
  });

  final ScrollController? scrollController;

  @override
  ConsumerState<CaptureBottomSheet> createState() => _CaptureBottomSheetState();
}

class _CaptureBottomSheetState extends ConsumerState<CaptureBottomSheet> {
  ProviderSubscription<CaptureState>? _captureSubscription;
  ProviderSubscription<AsyncValue<String?>>? _analyzeSubscription;
  DateTime? _analyzeStartTime;

  @override
  void initState() {
    super.initState();

    _captureSubscription = ref.listenManual<CaptureState>(
      captureControllerProvider,
      (previous, next) {
        final controller = ref.read(captureControllerProvider.notifier);
        if (next.error != null && next.error != previous?.error) {
          _showSnackBar(next.error!, isError: true);
          Future(() => controller.clearError());
        } else if (next.message != null && next.message != previous?.message) {
          _showSnackBar(next.message!);
          Future(() => controller.clearMessage());
        }
      },
    );

    _analyzeSubscription = ref.listenManual<AsyncValue<String?>>(
      directAnalyzeControllerProvider,
      (previous, next) {
        // Only process state transitions, not repeated same states
        next.when(
          data: (jobId) {
            // Guard: Only navigate if previous wasn't already success
            final wasSuccess = previous?.asData != null;
            if (jobId != null && !wasSuccess) {
              // Log analysis time
              if (_analyzeStartTime != null) {
                final duration = DateTime.now().difference(_analyzeStartTime!);
                debugPrint(
                    '⏱️  Tiempo de análisis: ${duration.inMilliseconds}ms (${duration.inSeconds}s)');
                _analyzeStartTime = null;
              }

              _showSnackBar('Análisis completado');
              // Navigate to review page after brief delay for user feedback
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) {
                  final navigator = Navigator.of(context);
                  navigator.pop(); // Close bottom sheet
                  navigator.push(
                    MaterialPageRoute(
                      builder: (_) => CaptureReviewPage(resultId: jobId),
                    ),
                  );
                }
              });
            }
          },
          error: (error, _) {
            // Guard: Only show error if previous wasn't already error
            final wasError = previous?.asError != null;
            if (!wasError) {
              // Log analysis time even on error
              if (_analyzeStartTime != null) {
                final duration = DateTime.now().difference(_analyzeStartTime!);
                debugPrint(
                    '⏱️  Tiempo de análisis (fallido): ${duration.inMilliseconds}ms (${duration.inSeconds}s)');
                _analyzeStartTime = null;
              }

              final errorMessage = error.toString();
              _showSnackBar(
                'Análisis fallido. $errorMessage',
                isError: true,
              );
            }
          },
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

    final hasActiveCapture =
        captureState.imageFile != null || captureState.scannedBarcode != null;

    return PopScope(
      canPop: !hasActiveCapture,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldClose = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('¿Descartar captura?'),
            content: const Text('Perderás la imagen o información capturada.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Descartar'),
              ),
            ],
          ),
        );

        if (shouldClose == true && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _DragHandle(),
            _ModalHeader(
              showBack: captureState.mode != null,
              onBack: () => controller.clearMode(),
              onClose: () => Navigator.of(context).pop(),
              mode: captureState.mode,
            ),
            Flexible(
              child: SingleChildScrollView(
                controller: widget.scrollController,
                physics: const BouncingScrollPhysics(),
                child: captureState.mode == null
                    ? _buildActionButtons(context, controller)
                    : _buildSelectedModeView(captureState),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context, CaptureController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '¿Cómo quieres registrar tu comida?',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          CaptureOptionCard(
            icon: Icons.camera_alt_outlined,
            label: 'Cámara',
            description: 'Tomar una foto',
            color: Theme.of(context).colorScheme.primary,
            onPressed: () => controller.setMode(CaptureMode.camera),
          ),
          const SizedBox(height: 10),
          CaptureOptionCard(
            icon: Icons.photo_library_outlined,
            label: 'Galería',
            description: 'Elegir de tus fotos',
            color: AppColors.semanticSuccess,
            onPressed: () => controller.setMode(CaptureMode.gallery),
          ),
          const SizedBox(height: 10),
          CaptureOptionCard(
            icon: Icons.qr_code_2_outlined,
            label: 'Código QR',
            description: 'Escanear código',
            color: Theme.of(context).colorScheme.tertiary,
            onPressed: () => controller.setMode(CaptureMode.barcode),
          ),
          const SizedBox(height: 10),
          CaptureOptionCard(
            icon: Icons.edit_note_outlined,
            label: 'Texto',
            description: 'Escribir ingredientes',
            color: AppColors.semanticWarning,
            onPressed: () => controller.setMode(CaptureMode.text),
          ),
          const SizedBox(height: 8),
        ],
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
    final analyzeState = ref.watch(directAnalyzeControllerProvider);
    final controller = ref.read(captureControllerProvider.notifier);
    final analyzeController =
        ref.read(directAnalyzeControllerProvider.notifier);

    final isAnalyzing = analyzeState.isLoading;

    Future<void> analyze() async {
      _analyzeStartTime = DateTime.now();
      debugPrint('🚀 Starting analysis...');
      await analyzeController.analyze(captureState);
      // The listener handles navigation, so we don't close the modal here
    }

    return Stack(
      children: [
        switch (mode) {
          CaptureMode.camera => CameraCaptureView(
              state: captureState,
              onCapture: controller.captureWithCamera,
              onAnalyze: analyze,
              scrollable: false,
            ),
          CaptureMode.gallery => GalleryImportView(
              state: captureState,
              onImport: controller.importFromGallery,
              onAnalyze: analyze,
              scrollable: false,
            ),
          CaptureMode.barcode => BarcodeScannerView(
              state: captureState,
              onBarcodeScanned: controller.onBarcodeScanned,
              onAnalyze: analyze,
            ),
          CaptureMode.text => const TextEntryView(),
        },
        // Loading overlay during analysis
        if (isAnalyzing)
          Container(
            color: Colors.black.withAlpha((0.4 * 255).round()),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Analizando imagen...',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 12, bottom: 8),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _ModalHeader extends StatelessWidget {
  const _ModalHeader({
    required this.showBack,
    required this.onBack,
    required this.onClose,
    this.mode,
  });

  final bool showBack;
  final VoidCallback onBack;
  final VoidCallback onClose;
  final CaptureMode? mode;

  String _getTitle() {
    if (mode == null) return 'Registrar comida';

    switch (mode!) {
      case CaptureMode.camera:
        return 'Cámara';
      case CaptureMode.gallery:
        return 'Galería';
      case CaptureMode.barcode:
        return 'Código de barras';
      case CaptureMode.text:
        return 'Escribir ingredientes';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (showBack)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack,
            )
          else
            const SizedBox(width: 48),
          Expanded(
            child: Text(
              _getTitle(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

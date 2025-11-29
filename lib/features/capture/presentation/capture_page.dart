import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/theme/theme_providers.dart';

import '../application/capture_controller.dart';
import '../application/capture_providers.dart';
import '../application/capture_state.dart';
import '../domain/capture_job.dart';
import '../domain/capture_job_type.dart';
import '../domain/capture_mode.dart';
import 'widgets/camera_capture_view.dart';
import 'widgets/capture_queue_action.dart';
import 'widgets/capture_status_banner.dart';
import 'widgets/gallery_import_view.dart';
import 'widgets/text_entry_view.dart';

class CapturePage extends ConsumerStatefulWidget {
  const CapturePage({super.key});

  @override
  ConsumerState<CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends ConsumerState<CapturePage> {
  ProviderSubscription<CaptureState>? _captureSubscription;
  ProviderSubscription<AsyncValue<CaptureJob?>>? _enqueueSubscription;

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

    _enqueueSubscription = ref.listenManual<AsyncValue<CaptureJob?>>(
      captureEnqueueControllerProvider,
      (previous, next) {
        next.when(
          data: (job) {
            if (job != null) {
              final isImage = job.type == CaptureJobType.image;
              _showSnackBar(
                isImage ? 'Foto guardada en cola offline' : 'Código guardado en cola offline',
              );
            }
          },
          error: (error, _) =>
              _showSnackBar('No se pudo encolar la captura: $error', isError: true),
          loading: () {},
        );
      },
    );
  }

  @override
  void dispose() {
    _captureSubscription?.close();
    _enqueueSubscription?.close();
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
              // Custom Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    if (captureState.mode != null)
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => controller.clearMode(),
                      ),
                    Expanded(
                      child: Text(
                        captureState.mode == null ? 'Registrar Comida' : 'Nueva Captura',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: captureState.mode == null ? TextAlign.center : TextAlign.start,
                      ),
                    ),
                    if (captureState.mode != null) const SizedBox(width: 48), // Balance back button
                  ],
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

    return Column(
      children: [
        CaptureStatusBanner(
          mode: mode,
          hasImage: state.imageFile != null,
          message: state.message,
          error: state.error,
        ),
        Expanded(
          child: _buildModeContent(mode),
        ),
        if (mode != CaptureMode.text && state.imageFile != null)
          CaptureQueueAction(
            state: state,
          ),
      ],
    );
  }

  Widget _buildModeContent(CaptureMode mode) {
    final captureState = ref.watch(captureControllerProvider);
    final controller = ref.read(captureControllerProvider.notifier);

    switch (mode) {
      case CaptureMode.camera:
        return CameraCaptureView(
          state: captureState,
          onCapture: controller.captureWithCamera,
        );
      case CaptureMode.gallery:
        return GalleryImportView(
          state: captureState,
          onImport: controller.importFromGallery,
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
      color: scheme.surface.withOpacity(0.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: scheme.outlineVariant.withOpacity(0.5)),
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
                  color: color.withOpacity(0.1),
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
                color: scheme.onSurfaceVariant.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

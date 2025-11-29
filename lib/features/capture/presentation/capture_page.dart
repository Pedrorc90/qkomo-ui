import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/theme/theme_providers.dart';

import '../application/capture_controller.dart';
import '../application/capture_providers.dart';
import '../application/capture_state.dart';
import '../domain/capture_job.dart';
import '../domain/capture_job_type.dart';
import '../domain/capture_mode.dart';
import 'widgets/barcode_scanner_view.dart';
import 'widgets/camera_capture_view.dart';
import 'widgets/capture_queue_action.dart';
import 'widgets/capture_status_banner.dart';
import 'widgets/gallery_import_view.dart';

class CapturePage extends ConsumerStatefulWidget {
  const CapturePage({super.key, this.initialMode = CaptureMode.camera});

  final CaptureMode initialMode;

  @override
  ConsumerState<CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends ConsumerState<CapturePage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  ProviderSubscription<CaptureState>? _captureSubscription;
  ProviderSubscription<AsyncValue<CaptureJob?>>? _enqueueSubscription;

  @override
  void initState() {
    super.initState();
    final controller = ref.read(captureControllerProvider.notifier);
    controller.setMode(widget.initialMode);
    final initialIndex = widget.initialMode.index;
    _tabController = TabController(
      length: CaptureMode.values.length,
      vsync: this,
      initialIndex: initialIndex,
    );
    _tabController.addListener(_handleTabChange);

    _captureSubscription = ref.listenManual<CaptureState>(captureControllerProvider, (
      previous,
      next,
    ) {
      if (mounted && next.mode.index != _tabController.index) {
        _tabController.index = next.mode.index;
      }
      if (next.error != null && next.error != previous?.error) {
        _showSnackBar(next.error!, isError: true);
        controller.clearError();
      } else if (next.message != null && next.message != previous?.message) {
        _showSnackBar(next.message!);
        controller.clearMessage();
      }
    });

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
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _captureSubscription?.close();
    _enqueueSubscription?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(captureControllerProvider);
    final controller = ref.read(captureControllerProvider.notifier);
    final gradient = ref.watch(appGradientProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Captura'),
        backgroundColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(58),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(icon: Icon(Icons.camera_alt), text: 'Cámara'),
                  Tab(icon: Icon(Icons.photo_library_outlined), text: 'Galería'),
                  Tab(icon: Icon(Icons.qr_code_scanner), text: 'Código'),
                ],
              ),
            ),
          ),
        ),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: gradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: CaptureStatusBanner(state: state),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    CameraCaptureView(state: state, onCapture: controller.captureWithCamera),
                    GalleryImportView(state: state, onImport: controller.importFromGallery),
                    BarcodeScannerView(
                      state: state,
                      onBarcode: controller.registerBarcode,
                      onReset: controller.clearBarcode,
                      onRequestPermission: controller.ensureScannerPermission,
                      onOpenSettings: controller.openSettings,
                    ),
                  ],
                ),
              ),
              CaptureQueueAction(state: state),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;
    final newMode = CaptureMode.values[_tabController.index];
    ref.read(captureControllerProvider.notifier).setMode(newMode);
  }

  void _showSnackBar(String message, {bool isError = false}) {
    final color = isError ? Colors.red : null;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }
}

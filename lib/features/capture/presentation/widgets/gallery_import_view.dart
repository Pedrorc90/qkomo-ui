import 'package:flutter/material.dart';

import 'package:qkomo_ui/features/capture/application/capture_state.dart';
import 'package:qkomo_ui/features/capture/presentation/widgets/picked_image_preview.dart';
import 'package:qkomo_ui/theme/app_colors.dart';

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
    final scheme = Theme.of(context).colorScheme;
    const borderRadius = BorderRadius.all(Radius.circular(16));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Selecciona una foto de tu galería para analizarla.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: state.imageFile == null ? onImport : null,
            child: ClipRRect(
              borderRadius: borderRadius,
              child: Stack(
                children: [
                  PickedImagePreview(file: state.imageFile),
                  if (state.imageFile == null)
                    Positioned.fill(
                      child: Container(
                        color: AppColors.overlayBlack30,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_outlined,
                                size: 48,
                                color: AppColors.neutralWhite
                                    .withAlpha((0.7 * 255).round()),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Abre la galería para comenzar',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColors.neutralWhite
                                          .withAlpha((0.7 * 255).round()),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _ImportButton(
            isProcessing: state.isProcessing,
            onPressed: state.isProcessing ? null : onImport,
            label: state.isProcessing
                ? 'Abriendo galería...'
                : 'Elegir desde galería',
          ),
          if (state.imageFile != null) ...[
            const SizedBox(height: 12),
            _AnalyzeButton(
              isProcessing: state.isProcessing,
              onPressed: state.isProcessing ? null : onAnalyze,
              label: state.isProcessing ? 'Analizando...' : 'Analizar imagen',
            ),
          ],
        ],
      ),
    );
  }
}

class _ImportButton extends StatefulWidget {
  const _ImportButton({
    required this.isProcessing,
    required this.onPressed,
    required this.label,
  });

  final bool isProcessing;
  final VoidCallback? onPressed;
  final String label;

  @override
  State<_ImportButton> createState() => _ImportButtonState();
}

class _ImportButtonState extends State<_ImportButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 1.0, end: 0.98).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: FilledButton.icon(
        onPressed: widget.onPressed,
        onLongPress: null,
        icon: const Icon(Icons.photo_library_outlined),
        label: Text(widget.label),
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

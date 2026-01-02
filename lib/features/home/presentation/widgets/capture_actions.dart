import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/features/capture/application/capture_providers.dart';
import 'package:qkomo_ui/features/capture/domain/entities/capture_mode.dart';
import 'package:qkomo_ui/features/shell/state/navigation_provider.dart';

class CaptureActions extends ConsumerWidget {
  const CaptureActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Captura una foto de tu comida o producto y deja que la IA liste los ingredientes.',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => _openCapture(ref),
          icon: const Icon(Icons.camera_alt),
          label: const Text('Tomar foto'),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => _openCapture(ref, initialMode: CaptureMode.gallery),
          icon: const Icon(Icons.photo_library),
          label: const Text('Seleccionar de galería'),
        ),
      ],
    );
  }

  void _openCapture(WidgetRef ref,
      {CaptureMode initialMode = CaptureMode.camera}) {
    ref.read(captureControllerProvider.notifier).setMode(initialMode);
    ref.read(bottomNavIndexProvider.notifier).state = 1;
  }
}

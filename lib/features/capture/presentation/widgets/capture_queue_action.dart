import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/capture_providers.dart';
import '../../application/capture_state.dart';

class CaptureQueueAction extends ConsumerWidget {
  const CaptureQueueAction({super.key, required this.state});

  final CaptureState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enqueueState = ref.watch(captureEnqueueControllerProvider);
    final pending = ref.watch(pendingCaptureJobsProvider);
    final hasImage = state.imageFile != null;
    final hasBarcode = state.barcode != null;
    final isLoading = enqueueState.isLoading;
    final canQueue = (hasImage || hasBarcode) && !state.isProcessing && !isLoading;
    final label = hasImage
        ? 'Guardar foto en cola offline'
        : hasBarcode
            ? 'Guardar código en cola offline'
            : 'Selecciona una foto o código';

    return Card(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.cloud_off),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Sin conexión? Encola tus capturas para procesarlas después.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: canQueue
                  ? () => _enqueue(ref, hasImage: hasImage, hasBarcode: hasBarcode)
                  : null,
              icon: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_alt),
              label: Text(label),
            ),
            const SizedBox(height: 8),
            pending.when(
              data: (jobs) {
                final pendingCount = jobs.length;
                return Text(
                  pendingCount == 0
                      ? 'No tienes capturas pendientes.'
                      : 'Pendientes en cola: $pendingCount',
                  style: Theme.of(context).textTheme.bodySmall,
                );
              },
              error: (error, _) => Text(
                'No se pudo leer la cola: $error',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.red),
              ),
              loading: () => const Text('Leyendo cola...'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _enqueue(
    WidgetRef ref, {
    required bool hasImage,
    required bool hasBarcode,
  }) async {
    final notifier = ref.read(captureEnqueueControllerProvider.notifier);
    if (hasImage) {
      await notifier.enqueueImage(state.imageFile!.path);
    } else if (hasBarcode) {
      await notifier.enqueueBarcode(state.barcode!);
    }
  }
}

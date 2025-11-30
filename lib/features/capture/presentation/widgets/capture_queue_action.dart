import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/features/capture/application/capture_providers.dart';
import 'package:qkomo_ui/features/capture/application/capture_state.dart';

class CaptureQueueAction extends ConsumerWidget {
  const CaptureQueueAction({super.key, required this.state});

  final CaptureState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enqueueState = ref.watch(captureEnqueueControllerProvider);
    final pending = ref.watch(pendingCaptureJobsProvider);
    final hasImage = state.imageFile != null;
    final hasBarcode = state.scannedBarcode != null;
    final hasCapture = hasImage || hasBarcode;
    final isLoading = enqueueState.isLoading;
    final canQueue = hasCapture && !state.isProcessing && !isLoading;

    final analyzeState = ref.watch(directAnalyzeControllerProvider);
    final isAnalyzing = analyzeState.isLoading;
    final canAnalyze = hasCapture && !state.isProcessing && !isAnalyzing;

    final queueLabel = hasImage || hasBarcode ? 'Guardar Offline' : 'Guardar';

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
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: canQueue ? () => _enqueue(ref) : null,
                    icon: isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_alt),
                    label: Text(queueLabel),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: canAnalyze ? () => _analyze(ref) : null,
                    icon: isAnalyzing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.analytics),
                    label: const Text('Analizar'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                      foregroundColor: Theme.of(context).colorScheme.onTertiary,
                    ),
                  ),
                ),
              ],
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

  Future<void> _enqueue(WidgetRef ref) async {
    final notifier = ref.read(captureEnqueueControllerProvider.notifier);
    if (state.imageFile != null) {
      await notifier.enqueueImage(state.imageFile!.path);
    } else if (state.scannedBarcode != null) {
      await notifier.enqueueBarcode(state.scannedBarcode!);
    }
  }

  Future<void> _analyze(WidgetRef ref) async {
    final notifier = ref.read(directAnalyzeControllerProvider.notifier);
    await notifier.analyze(state);
  }
}

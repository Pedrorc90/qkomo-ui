import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/features/capture/application/capture_providers.dart';
import 'package:qkomo_ui/features/capture/domain/capture_job.dart';
import 'package:qkomo_ui/features/capture/domain/capture_job_type.dart';
import 'package:qkomo_ui/features/capture/domain/capture_result.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingCaptureJobsProvider);
    final resultsAsync = ref.watch(captureResultsProvider);
    final processState = ref.watch(captureQueueProcessControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Historial'), backgroundColor: Colors.transparent),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              'Capturas en cola',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            _ProcessQueueButton(state: processState),
            const SizedBox(height: 12),
            pendingAsync.when(
              data: (jobs) => _QueueList(jobs: jobs),
              loading: () => const Card(
                child: ListTile(
                  leading: CircularProgressIndicator(),
                  title: Text('Cargando cola...'),
                ),
              ),
              error: (error, _) => Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: ListTile(
                  leading: const Icon(Icons.error_outline),
                  title: Text('Error al leer la cola: $error'),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Resultados guardados',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            resultsAsync.when(
              data: (results) => _ResultList(results: results),
              loading: () => const Card(
                child: ListTile(
                  leading: CircularProgressIndicator(),
                  title: Text('Cargando historial...'),
                ),
              ),
              error: (error, _) => Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: ListTile(
                  leading: const Icon(Icons.error_outline),
                  title: Text('Error al leer historial: $error'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QueueList extends StatelessWidget {
  const _QueueList({required this.jobs});

  final List<CaptureJob> jobs;

  @override
  Widget build(BuildContext context) {
    if (jobs.isEmpty) {
      return Card(
        child: ListTile(
          leading: const Icon(Icons.inbox_outlined),
          title: const Text('No hay capturas pendientes'),
          subtitle: const Text('Cuando tomes fotos o escanees etiquetas aparecerán aquí.'),
        ),
      );
    }

    return Column(
      children: jobs
          .map(
            (job) => Card(
              child: ListTile(
                leading: Icon(_iconForType(job.type)),
                title: Text(
                  job.type == CaptureJobType.image ? 'Foto en espera' : 'Código en espera',
                ),
                subtitle: Text('Creado: ${_formatDate(job.createdAt)} • Intentos: ${job.attempts}'),
                trailing: Chip(
                  label: Text(job.status.name),
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _ResultList extends StatelessWidget {
  const _ResultList({required this.results});

  final List<CaptureResult> results;

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return Card(
        child: ListTile(
          leading: const Icon(Icons.fastfood),
          title: const Text('Sin resultados aún'),
          subtitle: const Text('Cuando se procese una captura, verás el resumen aquí.'),
        ),
      );
    }

    return Column(
      children: results
          .map(
            (result) => Card(
              child: ListTile(
                leading: const Icon(Icons.fact_check_outlined),
                title: Text(result.title ?? 'Captura ${result.jobId.substring(0, 6)}'),
                subtitle: Text(
                  '${result.ingredients.length} ingredientes • ${result.allergens.length} alérgenos',
                ),
                trailing: Text(_formatDate(result.savedAt)),
              ),
            ),
          )
          .toList(),
    );
  }
}

IconData _iconForType(CaptureJobType type) {
  switch (type) {
    case CaptureJobType.image:
      return Icons.photo_camera_outlined;
    case CaptureJobType.barcode:
      return Icons.qr_code;
  }
}

String _formatDate(DateTime date) {
  final d = date.toLocal();
  final twoDigits = (int n) => n.toString().padLeft(2, '0');
  return '${twoDigits(d.day)}/${twoDigits(d.month)} ${twoDigits(d.hour)}:${twoDigits(d.minute)}';
}

class _ProcessQueueButton extends ConsumerWidget {
  const _ProcessQueueButton({required this.state});

  final AsyncValue<int> state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = state.isLoading;
    final lastCount = state.valueOrNull;
    final error = state.asError;

    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: isLoading
                ? null
                : () => ref.read(captureQueueProcessControllerProvider.notifier).processPending(),
            icon: isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.playlist_add_check),
            label: Text(isLoading ? 'Procesando cola...' : 'Procesar cola offline'),
          ),
        ),
        const SizedBox(width: 12),
        if (error != null)
          IconButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al procesar: ${error.error}'),
                backgroundColor: Colors.red,
              ),
            ),
            icon: const Icon(Icons.error_outline, color: Colors.red),
            tooltip: 'Ver error',
          )
        else if (lastCount != null)
          Chip(
            label: Text('Último proceso: $lastCount'),
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          ),
      ],
    );
  }
}

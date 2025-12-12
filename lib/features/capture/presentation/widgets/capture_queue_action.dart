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
            // Mostrar resultado del análisis si está disponible
            analyzeState.when(
              data: (jobId) {
                if (jobId == null) return const SizedBox.shrink();

                final resultRepo = ref.watch(captureResultRepositoryProvider);
                final result = resultRepo.findByJobId(jobId);

                if (result == null) return const SizedBox.shrink();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            result.title ?? 'Análisis completado',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        if (result.estimatedPortionG != null)
                          Chip(
                            label: Text('${result.estimatedPortionG}g'),
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            labelStyle: Theme.of(context).textTheme.labelSmall,
                          ),
                      ],
                    ),
                    if (result.nutrition != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                              .withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: Theme.of(context).dividerColor.withOpacity(0.5)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            if (result.nutrition!.calories != null)
                              _buildNutritionItem(context, 'Kcal', '${result.nutrition!.calories}',
                                  Icons.local_fire_department, Colors.orange),
                            if (result.nutrition!.proteinsG != null)
                              _buildNutritionItem(
                                  context,
                                  'Prot',
                                  '${result.nutrition!.proteinsG}g',
                                  Icons.fitness_center,
                                  Colors.blue),
                            if (result.nutrition!.carbohydratesG != null)
                              _buildNutritionItem(
                                  context,
                                  'Carbs',
                                  '${result.nutrition!.carbohydratesG}g',
                                  Icons.grass,
                                  Colors.brown),
                            if (result.nutrition!.fatsG != null)
                              _buildNutritionItem(context, 'Grasas', '${result.nutrition!.fatsG}g',
                                  Icons.opacity, Colors.yellow[800]!),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    if (result.ingredients.isNotEmpty) ...[
                      Text(
                        'Ingredientes det.:',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        result.ingredients.join(', '),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (result.allergens.isNotEmpty) ...[
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: result.allergens.map((allergen) {
                          return Chip(
                            avatar: const Icon(Icons.warning_amber, size: 14),
                            label: Text(allergen),
                            backgroundColor: Theme.of(context).colorScheme.errorContainer,
                            labelStyle:
                                TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (result.medicalAlerts != null) ...[
                      if (result.medicalAlerts!.diabetes != null ||
                          result.medicalAlerts!.hypertension != null ||
                          result.medicalAlerts!.cholesterol != null) ...[
                        Text('Alertas Médicas:',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(color: Theme.of(context).colorScheme.error)),
                        const SizedBox(height: 4),
                        if (result.medicalAlerts!.diabetes != null)
                          _buildAlertRow(context, 'Diabetes', result.medicalAlerts!.diabetes!),
                        if (result.medicalAlerts!.hypertension != null)
                          _buildAlertRow(
                              context, 'Hipertensión', result.medicalAlerts!.hypertension!),
                        if (result.medicalAlerts!.cholesterol != null)
                          _buildAlertRow(context, 'Colesterol', result.medicalAlerts!.cholesterol!),
                        const SizedBox(height: 12),
                      ],
                    ],
                    if (result.suitableFor != null) ...[
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          if (result.suitableFor!.vegetarian)
                            _buildTag(context, 'Vegetariano', Icons.eco, Colors.green),
                          if (result.suitableFor!.vegan)
                            _buildTag(context, 'Vegano', Icons.eco, Colors.green[800]!),
                          if (result.suitableFor!.glutenFree)
                            _buildTag(context, 'Sin Gluten', Icons.check, Colors.blue),
                          if (result.suitableFor!.lowFodmap)
                            _buildTag(context, 'Low FODMAP', Icons.check, Colors.teal),
                          if (result.suitableFor!.children)
                            _buildTag(context, 'Apto Niños', Icons.child_care, Colors.orange),
                        ],
                      ),
                    ],
                    if (result.improvementSuggestions.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Sugerencias de mejora:',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      ...result.improvementSuggestions.map((suggestion) => Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.lightbulb_outline,
                                    size: 14, color: Theme.of(context).colorScheme.primary),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    suggestion,
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                    if (result.notes != null && result.notes!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Notas:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        result.notes!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ],
                );
              },
              error: (_, __) => const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionItem(
      BuildContext context, String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 4),
        Text(value,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
        Text(label,
            style:
                Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget _buildAlertRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 16, color: Theme.of(context).colorScheme.error),
          const SizedBox(width: 8),
          Expanded(
              child: Text('$label: $value',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Theme.of(context).colorScheme.error))),
        ],
      ),
    );
  }

  Widget _buildTag(BuildContext context, String label, IconData icon, Color color) {
    return Chip(
      avatar: Icon(icon, size: 14, color: color),
      label: Text(label),
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
      side: BorderSide(color: color.withOpacity(0.3)),
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
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

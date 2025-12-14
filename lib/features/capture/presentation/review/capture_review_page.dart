import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/features/capture/application/capture_providers.dart';
import 'package:qkomo_ui/features/capture/application/capture_review_controller.dart';
import 'package:qkomo_ui/features/capture/presentation/review/widgets/allergen_toggle_list.dart';
import 'package:qkomo_ui/features/capture/presentation/review/widgets/ingredient_list_editor.dart';
import 'package:qkomo_ui/features/capture/presentation/review/widgets/photo_viewer.dart';

/// Page for reviewing and editing capture results
class CaptureReviewPage extends ConsumerWidget {
  const CaptureReviewPage({
    super.key,
    required this.resultId,
  });

  final String resultId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(captureReviewControllerProvider(resultId));
    final controller =
        ref.read(captureReviewControllerProvider(resultId).notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Revisar captura'),
        backgroundColor: Colors.transparent,
        actions: [
          if (state.hasChanges)
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Descartar cambios',
              onPressed: () => _showDiscardDialog(context, controller),
            ),
        ],
      ),
      body: state.result == null
          ? _buildLoading(context, state.error)
          : _buildContent(context, ref, state, controller),
      bottomNavigationBar: state.result != null
          ? _buildBottomBar(context, state, controller)
          : null,
    );
  }

  Widget _buildLoading(BuildContext context, String? error) {
    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                error,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    CaptureReviewState state,
    CaptureReviewController controller,
  ) {
    final result = state.result!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo viewer
          PhotoViewer(
            imagePath: result.jobId, // TODO: Get actual image path from job
            title: result.title,
          ),

          const SizedBox(height: 24),

          // Title
          if (result.title != null) ...[
            Text(
              result.title!,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
          ],

          // Ingredient editor
          IngredientListEditor(
            ingredients: state.editedIngredients,
            onAdd: controller.addIngredient,
            onRemove: controller.removeIngredient,
            onUpdate: controller.updateIngredient,
          ),

          const SizedBox(height: 24),

          // Allergen toggles
          AllergenToggleList(
            selectedAllergens: state.editedAllergens,
            onToggle: controller.toggleAllergen,
          ),

          const SizedBox(height: 100), // Space for bottom bar
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, CaptureReviewState state,
      CaptureReviewController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (state.error != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        state.error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed:
                        state.isSaving ? null : () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: state.isSaving
                        ? null
                        : () => _saveReview(context, controller),
                    child: state.isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Guardar análisis'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveReview(
      BuildContext context, CaptureReviewController controller) async {
    final success = await controller.saveReview();
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Análisis guardado correctamente'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  void _showDiscardDialog(
      BuildContext context, CaptureReviewController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Descartar cambios'),
        content: const Text('¿Estás seguro de descartar los cambios?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              controller.discardChanges();
              Navigator.pop(context);
            },
            child: const Text('Descartar'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/core/animations/feedback_animations.dart';
import 'package:qkomo_ui/core/widgets/qkomo_navbar.dart';
import 'package:qkomo_ui/features/capture/application/capture_providers.dart';
import 'package:qkomo_ui/features/capture/application/capture_review_controller.dart';
import 'package:qkomo_ui/features/capture/presentation/review/widgets/allergen_selector.dart';
import 'package:qkomo_ui/features/capture/presentation/review/widgets/ingredient_list_editor.dart';
import 'package:qkomo_ui/features/capture/presentation/review/widgets/nutrition_info_card.dart';
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
      appBar: QkomoNavBar(
        title: 'Revisar captura',
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
          // Photo viewer with metadata and meal type selector
          PhotoViewer(
            imagePath: result.imagePath,
            title: result.title,
            capturedAt: result.savedAt,
            estimatedPortionG: result.estimatedPortionG,
            selectedMealType: state.editedMealType,
            onMealTypeChanged: controller.setMealType,
          ),

          const SizedBox(height: 24),

          // Nutrition info card
          if (result.nutrition != null) ...[
            NutritionInfoCard(nutrition: result.nutrition!),
            const SizedBox(height: 16),
          ],

          // Ingredient editor with origin badges
          IngredientListEditor(
            ingredients: state.editedIngredients,
            originalIngredients: result.ingredients,
            onAdd: controller.addIngredient,
            onRemove: controller.removeIngredient,
            onUpdate: controller.updateIngredient,
          ),

          const SizedBox(height: 24),

          // Allergen selector (replaces AllergenToggleList)
          AllergenSelector(
            selectedAllergens: state.editedAllergens,
            onToggle: controller.toggleAllergen,
          ),

          const SizedBox(height: 24),

          // Notes section
          _buildNotesSection(context, state, controller),

          const SizedBox(height: 24),

          const SizedBox(height: 100), // Space for bottom bar
        ],
      ),
    );
  }

  Widget _buildNotesSection(
    BuildContext context,
    CaptureReviewState state,
    CaptureReviewController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notas adicionales',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: state.editedNotes),
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Agrega comentarios sobre esta comida...',
            border: OutlineInputBorder(),
          ),
          onChanged: controller.setNotes,
        ),
      ],
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
            color: Theme.of(context)
                .colorScheme
                .outline
                .withAlpha((0.1 * 255).round()),
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
      await SuccessFeedback.show(
        context,
        message: 'Análisis guardado correctamente',
      );
      if (context.mounted) {
        Navigator.pop(context);
      }
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

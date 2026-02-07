import 'package:flutter/material.dart';

/// Footer section with action buttons (Cancel, Save as Recipe, Save/Add)
class MealFormFooter extends StatelessWidget {
  const MealFormFooter({
    required this.isLoading,
    required this.isSavingAsRecipe,
    required this.isEditing,
    required this.showSaveAsRecipe,
    required this.onCancel,
    required this.onSaveAsRecipe,
    required this.onSave,
    super.key,
  });

  final bool isLoading;
  final bool isSavingAsRecipe;
  final bool isEditing;
  final bool showSaveAsRecipe;
  final VoidCallback onCancel;
  final VoidCallback onSaveAsRecipe;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final isDisabled = isLoading || isSavingAsRecipe;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: isDisabled ? null : onCancel,
            child: const Text('Cancelar'),
          ),
          const SizedBox(width: 8),
          if (showSaveAsRecipe) ...[
            IconButton(
              onPressed: isDisabled ? null : onSaveAsRecipe,
              icon: isSavingAsRecipe
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.bookmark_add),
            ),
          ],
          FilledButton(
            onPressed: isDisabled ? null : onSave,
            child: isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(isEditing ? 'Guardar' : 'Añadir'),
          ),
        ],
      ),
    );
  }
}

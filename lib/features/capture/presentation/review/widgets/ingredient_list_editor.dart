import 'package:flutter/material.dart';

/// Widget for editing a list of ingredients
class IngredientListEditor extends StatefulWidget {
  const IngredientListEditor({
    super.key,
    required this.ingredients,
    required this.onAdd,
    required this.onRemove,
    required this.onUpdate,
    this.originalIngredients = const [],
  });

  final List<String> ingredients;
  final List<String> originalIngredients;
  final Function(String) onAdd;
  final Function(String) onRemove;
  final Function(String oldValue, String newValue) onUpdate;

  @override
  State<IngredientListEditor> createState() => _IngredientListEditorState();
}

class _IngredientListEditorState extends State<IngredientListEditor> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _addIngredient() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      widget.onAdd(text);
      _textController.clear();
    }
  }

  void _showEditDialog(String ingredient) {
    final controller = TextEditingController(text: ingredient);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar ingrediente'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Nombre del ingrediente',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              widget.onUpdate(ingredient, value.trim());
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              final newValue = controller.text.trim();
              if (newValue.isNotEmpty) {
                widget.onUpdate(ingredient, newValue);
                Navigator.pop(context);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with count
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ingredientes',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${widget.ingredients.length} ingredientes',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Ingredient chips
        if (widget.ingredients.isEmpty)
          Card(
            color: scheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: scheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'No se detectaron ingredientes. Puedes agregarlos manualmente.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.ingredients.map((ingredient) {
              final isAIDetected =
                  widget.originalIngredients.contains(ingredient);

              return Chip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Badge of origin
                    if (isAIDetected)
                      Icon(
                        Icons.auto_awesome,
                        size: 14,
                        color: scheme.primary,
                      )
                    else
                      Icon(
                        Icons.edit,
                        size: 14,
                        color: scheme.tertiary,
                      ),
                    const SizedBox(width: 6),
                    Text(ingredient),
                  ],
                ),
                avatar: GestureDetector(
                  onTap: () => _showEditDialog(ingredient),
                  child: Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: scheme.primary,
                  ),
                ),
                onDeleted: () => widget.onRemove(ingredient),
                deleteIcon: const Icon(Icons.close, size: 18),
                backgroundColor: isAIDetected
                    ? scheme.primaryContainer.withValues(alpha: 0.3)
                    : scheme.surfaceContainerHighest,
              );
            }).toList(),
          ),

        const SizedBox(height: 12),

        // Add ingredient input
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'Agregar ingrediente',
                  hintText: 'Ej: Harina de trigo',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.add),
                ),
                onSubmitted: (_) => _addIngredient(),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: _addIngredient,
              child: const Text('Agregar'),
            ),
          ],
        ),

        const SizedBox(height: 8),
        Text(
          'Detectados por IA (⨯): Añadidos manualmente (✎)',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

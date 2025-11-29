import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/menu_providers.dart';
import '../../domain/meal.dart';
import '../../domain/meal_type.dart';

class MealFormDialog extends ConsumerStatefulWidget {
  const MealFormDialog({
    super.key,
    required this.date,
    required this.mealType,
    this.existingMeal,
  });

  final DateTime date;
  final MealType mealType;
  final Meal? existingMeal;

  @override
  ConsumerState<MealFormDialog> createState() => _MealFormDialogState();
}

class _MealFormDialogState extends ConsumerState<MealFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  final List<TextEditingController> _ingredientControllers = [];

  @override
  void initState() {
    super.initState();
    if (widget.existingMeal != null) {
      _nameController.text = widget.existingMeal!.name;
      _notesController.text = widget.existingMeal!.notes ?? '';
      for (final ingredient in widget.existingMeal!.ingredients) {
        final controller = TextEditingController(text: ingredient);
        _ingredientControllers.add(controller);
      }
    }
    if (_ingredientControllers.isEmpty) {
      _ingredientControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    for (final controller in _ingredientControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addIngredient() {
    setState(() {
      _ingredientControllers.add(TextEditingController());
    });
  }

  void _removeIngredient(int index) {
    if (_ingredientControllers.length > 1) {
      setState(() {
        _ingredientControllers[index].dispose();
        _ingredientControllers.removeAt(index);
      });
    }
  }

  Future<void> _saveMeal() async {
    if (!_formKey.currentState!.validate()) return;

    final ingredients = _ingredientControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    if (ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes agregar al menos un ingrediente')),
      );
      return;
    }

    final controller = ref.read(menuControllerProvider.notifier);

    if (widget.existingMeal != null) {
      await controller.updateMeal(
        id: widget.existingMeal!.id,
        name: _nameController.text.trim(),
        ingredients: ingredients,
        mealType: widget.mealType,
        scheduledFor: widget.date,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );
    } else {
      await controller.createMeal(
        name: _nameController.text.trim(),
        ingredients: ingredients,
        mealType: widget.mealType,
        scheduledFor: widget.date,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuControllerProvider);

    return AlertDialog(
      title: Text(
        widget.existingMeal != null
            ? 'Editar ${widget.mealType.displayName}'
            : 'Agregar ${widget.mealType.displayName}',
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la comida',
                  hintText: 'Ej: Ensalada César',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Ingredientes',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._ingredientControllers.asMap().entries.map((entry) {
                final index = entry.key;
                final controller = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller,
                          decoration: InputDecoration(
                            hintText: 'Ingrediente ${index + 1}',
                          ),
                        ),
                      ),
                      if (_ingredientControllers.length > 1)
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => _removeIngredient(index),
                        ),
                    ],
                  ),
                );
              }),
              TextButton.icon(
                onPressed: _addIngredient,
                icon: const Icon(Icons.add),
                label: const Text('Agregar ingrediente'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notas (opcional)',
                  hintText: 'Ej: Sin cebolla',
                ),
                maxLines: 2,
              ),
              if (menuState.errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  menuState.errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed:
              menuState.isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: menuState.isLoading ? null : _saveMeal,
          child: menuState.isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Guardar'),
        ),
      ],
    );
  }
}

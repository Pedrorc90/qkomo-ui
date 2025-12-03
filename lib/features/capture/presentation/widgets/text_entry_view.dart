import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/features/menu/domain/meal_type.dart';
import 'package:qkomo_ui/features/capture/application/capture_providers.dart';
import 'package:qkomo_ui/features/capture/domain/capture_result.dart';

class TextEntryView extends ConsumerStatefulWidget {
  const TextEntryView({super.key});

  @override
  ConsumerState<TextEntryView> createState() => _TextEntryViewState();
}

class _TextEntryViewState extends ConsumerState<TextEntryView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  final _allergensController = TextEditingController();
  final List<TextEditingController> _ingredientControllers = [
    TextEditingController()
  ];
  MealType? _selectedMealType;

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _allergensController.dispose();
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

  Future<void> _saveEntry() async {
    if (!_formKey.currentState!.validate()) return;

    final ingredients = _ingredientControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    if (ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes agregar al menos un ingrediente'),
        ),
      );
      return;
    }

    final allergens = _allergensController.text
        .trim()
        .split(',')
        .map((a) => a.trim())
        .where((a) => a.isNotEmpty)
        .toList();

    await ref.read(textEntryControllerProvider.notifier).saveTextEntry(
          title: _titleController.text.trim(),
          ingredients: ingredients,
          allergens: allergens.isEmpty ? null : allergens,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          mealType: _selectedMealType,
        );
  }

  void _clearForm() {
    _titleController.clear();
    _notesController.clear();
    _allergensController.clear();
    for (final controller in _ingredientControllers) {
      controller.dispose();
    }
    setState(() {
      _ingredientControllers.clear();
      _ingredientControllers.add(TextEditingController());
      _selectedMealType = null;
    });
    ref.read(textEntryControllerProvider.notifier).reset();
  }

  @override
  Widget build(BuildContext context) {
    final textEntryState = ref.watch(textEntryControllerProvider);

    ref.listen<AsyncValue<CaptureResult?>>(
      textEntryControllerProvider,
      (previous, next) {
        next.whenData((result) {
          if (result != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Entrada guardada: ${result.title ?? "Sin título"}'),
                backgroundColor: Colors.green,
              ),
            );
            _clearForm();
          }
        });
        next.whenOrNull(
          error: (error, stack) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al guardar: $error'),
                backgroundColor: Colors.red,
              ),
            );
          },
        );
      },
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Registrar comida manualmente',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título de la comida *',
                hintText: 'Ej: Ensalada César',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El título es obligatorio';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Ingredientes *',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
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
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.fastfood),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (_ingredientControllers.length > 1)
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        color: Colors.red,
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
              controller: _allergensController,
              decoration: const InputDecoration(
                labelText: 'Alérgenos (opcional)',
                hintText: 'Separados por comas: gluten, lactosa',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.warning_amber),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notas adicionales (opcional)',
                hintText: 'Cualquier observación...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<MealType>(
              value: _selectedMealType,
              decoration: const InputDecoration(
                labelText: 'Tipo de comida (opcional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.restaurant_menu),
              ),
              items: MealType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.displayName),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMealType = value;
                });
              },
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: textEntryState.isLoading ? null : _saveEntry,
              icon: textEntryState.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save),
              label: const Text('Guardar entrada'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

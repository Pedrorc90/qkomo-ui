import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/features/menu/application/image_picker_service.dart';
import 'package:qkomo_ui/features/menu/application/menu_providers.dart';
import 'package:qkomo_ui/features/menu/data/preset_recipes.dart';
import 'package:qkomo_ui/features/menu/domain/meal.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/preset_recipe_dialog.dart';

class MealFormDialog extends ConsumerStatefulWidget {
  const MealFormDialog({
    super.key,
    required this.date,
    this.mealType,
    this.existingMeal,
  });

  final DateTime date;
  final MealType? mealType;
  final Meal? existingMeal;

  @override
  ConsumerState<MealFormDialog> createState() => _MealFormDialogState();
}

class _MealFormDialogState extends ConsumerState<MealFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  final List<TextEditingController> _ingredientControllers = [];
  final _imagePickerService = ImagePickerService();

  late MealType _selectedMealType;
  String? _photoPath;

  @override
  void initState() {
    super.initState();
    _selectedMealType = widget.mealType ?? widget.existingMeal?.mealType ?? MealType.breakfast;

    if (widget.existingMeal != null) {
      _nameController.text = widget.existingMeal!.name;
      _notesController.text = widget.existingMeal!.notes ?? '';
      _photoPath = widget.existingMeal!.photoPath;

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

  Future<void> _showImageSourceDialog() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galería'),
              onTap: () async {
                Navigator.pop(context);
                final path = await _imagePickerService.pickImageFromGallery();
                if (path != null) {
                  setState(() => _photoPath = path);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Cámara'),
              onTap: () async {
                Navigator.pop(context);
                final path = await _imagePickerService.pickImageFromCamera();
                if (path != null) {
                  setState(() => _photoPath = path);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showPresetRecipes() async {
    final PresetRecipe? selected = await showDialog<PresetRecipe>(
      context: context,
      builder: (context) => const PresetRecipeDialog(),
    );

    if (selected != null) {
      setState(() {
        _nameController.text = selected.name;
        _selectedMealType = selected.suggestedMealType;
        _photoPath = selected.photoPath;

        // Clear current ingredients and add from recipe
        for (var controller in _ingredientControllers) {
          controller.dispose();
        }
        _ingredientControllers.clear();

        for (final ingredient in selected.ingredients) {
          _ingredientControllers.add(TextEditingController(text: ingredient));
        }
      });
    }
  }

  Future<void> _saveMeal() async {
    if (!_formKey.currentState!.validate()) return;

    final ingredients =
        _ingredientControllers.map((c) => c.text.trim()).where((text) => text.isNotEmpty).toList();

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
        mealType: _selectedMealType,
        scheduledFor: widget.date,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        photoPath: _photoPath,
      );
    } else {
      await controller.createMeal(
        name: _nameController.text.trim(),
        ingredients: ingredients,
        mealType: _selectedMealType,
        scheduledFor: widget.date,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        photoPath: _photoPath,
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
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      title: Text(
        widget.existingMeal != null ? 'Editar ${_selectedMealType.displayName}' : 'Agregar comida',
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Photo Section
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          image: _photoPath != null
                              ? DecorationImage(
                                  image: _photoPath!.startsWith('assets/')
                                      ? AssetImage(_photoPath!) as ImageProvider
                                      : FileImage(File(_photoPath!)),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _photoPath == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt, size: 40, color: Colors.grey[400]),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Añadir foto',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              )
                            : null,
                      ),
                      Positioned.fill(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: _showImageSourceDialog,
                          ),
                        ),
                      ),
                      if (_photoPath != null)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: CircleAvatar(
                            backgroundColor: Colors.black54,
                            radius: 16,
                            child: IconButton(
                              icon: const Icon(Icons.close, size: 16, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _photoPath = null;
                                });
                              },
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Preset Recipe Button (only for new meals)
                if (widget.existingMeal == null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _showPresetRecipes,
                        icon: const Icon(Icons.restaurant_menu),
                        label: const Text('Usar receta preconfigurada'),
                      ),
                    ),
                  ),

                // Meal Type Selector
                DropdownButtonFormField<MealType>(
                  value: _selectedMealType,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de comida',
                  ),
                  items: MealType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.displayName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedMealType = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
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
      ),
      actions: [
        TextButton(
          onPressed: menuState.isLoading ? null : () => Navigator.of(context).pop(),
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

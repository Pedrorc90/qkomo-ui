import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/core/utils/sanitizer.dart';
import 'package:qkomo_ui/features/auth/application/auth_providers.dart';
import 'package:qkomo_ui/features/menu/application/image_picker_service.dart';
import 'package:qkomo_ui/features/menu/application/menu_providers.dart';
import 'package:qkomo_ui/features/menu/domain/entities/preset_recipe.dart';
import 'package:qkomo_ui/features/menu/domain/meal.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/meal_form_action_buttons.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/meal_ingredients_input.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/meal_photo_picker.dart';
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
  bool _showForm = false;
  bool _isSavingAsRecipe = false;
  bool _isCreatingCustom = false;

  @override
  void initState() {
    super.initState();
    _selectedMealType = widget.mealType ?? widget.existingMeal?.mealType ?? MealType.breakfast;

    // Listen to name changes to update the bookmark button visibility
    _nameController.addListener(() {
      setState(() {});
    });

    if (widget.existingMeal != null) {
      _showForm = true; // Show form when editing existing meal
      _isCreatingCustom = true; // Allow editing photo for existing meals
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
    final selected = await showDialog<dynamic>(
      context: context,
      builder: (context) => const PresetRecipeDialog(),
    );

    if (selected != null) {
      setState(() {
        _showForm = true; // Show form when recipe is selected
        _isCreatingCustom = false; // Hide photo section for preset recipes

        // Handle both PresetRecipe and custom recipe Map
        if (selected is PresetRecipe) {
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
        } else if (selected is Map<String, dynamic>) {
          // Custom recipe
          _nameController.text = selected['name'] as String? ?? '';
          _selectedMealType = selected['mealType'] as MealType? ?? MealType.breakfast;
          _photoPath = selected['photoPath'] as String?;

          // Clear current ingredients and add from recipe
          for (var controller in _ingredientControllers) {
            controller.dispose();
          }
          _ingredientControllers.clear();

          final ingredients = selected['ingredients'] as List<dynamic>? ?? [];
          for (final ingredient in ingredients.cast<String>()) {
            _ingredientControllers.add(TextEditingController(text: ingredient));
          }
        }
      });
    }
  }

  Future<void> _saveMeal() async {
    if (!_formKey.currentState!.validate()) return;

    final ingredients =
        _ingredientControllers.map((c) => c.text.trim()).where((text) => text.isNotEmpty).toList();

    if (ingredients.isEmpty) {
      // Form validation should catch this now with the validator on the first field
      return;
    }

    final controller = ref.read(menuControllerProvider.notifier);
    final user = ref.read(firebaseAuthProvider).currentUser;
    final userId = user?.uid ?? '';

    if (widget.existingMeal != null) {
      await controller.updateMeal(
        id: widget.existingMeal!.id,
        name: Sanitizer.sanitize(_nameController.text),
        ingredients: ingredients,
        mealType: _selectedMealType,
        scheduledFor: widget.date,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        photoPath: _photoPath,
      );
    } else {
      await controller.createMeal(
        userId: userId,
        name: Sanitizer.sanitize(_nameController.text),
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

  Future<void> _saveAsRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    final ingredients =
        _ingredientControllers.map((c) => c.text.trim()).where((text) => text.isNotEmpty).toList();

    if (ingredients.isEmpty) {
      return;
    }

    setState(() {
      _isSavingAsRecipe = true;
    });

    final controller = ref.read(menuControllerProvider.notifier);

    await controller.saveAsRecipe(
      name: Sanitizer.sanitize(_nameController.text),
      ingredients: ingredients,
      mealType: _selectedMealType,
      photoPath: _photoPath,
    );

    setState(() {
      _isSavingAsRecipe = false;
    });

    final updatedState = ref.read(menuControllerProvider);

    if (mounted) {
      if (updatedState.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${updatedState.errorMessage}'),
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        // Show confirmation message and close dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Receta guardada en tu lista'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  bool _recipeAlreadyExists(String name) {
    final trimmedName = name.trim().toLowerCase();

    // Check custom recipes
    final customRecipes = ref.read(userRecipesProvider).value ?? [];
    final existsInCustom = customRecipes.any(
      (recipe) => recipe.name.toLowerCase() == trimmedName,
    );

    if (existsInCustom) return true;

    // Check preset recipes (excluding deleted ones)
    final deletedPresetRecipes = ref.read(deletedPresetRecipesStreamProvider).value ?? [];
    final existsInPreset = PresetRecipes.all.any(
      (recipe) =>
          recipe.name.toLowerCase() == trimmedName && !deletedPresetRecipes.contains(recipe.name),
    );

    return existsInPreset;
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
                // Action Buttons (only for new meals)
                if (widget.existingMeal == null && !_showForm)
                  MealFormActionButtons(
                    onShowPresetRecipes: _showPresetRecipes,
                    onCreateCustom: () {
                      setState(() {
                        _showForm = true;
                        _isCreatingCustom = true;
                      });
                    },
                  ),

                // Form content (shown when editing or when user clicks "Add")
                if (_showForm) ...[
                  // Meal Type Selector
                  DropdownButtonFormField<MealType>(
                    initialValue: _selectedMealType,
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
                  MealIngredientsInput(
                    controllers: _ingredientControllers,
                    formKey: _formKey,
                    onAddIngredient: _addIngredient,
                    onRemoveIngredient: _removeIngredient,
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
                  if (_isCreatingCustom) ...[
                    const SizedBox(height: 16),
                    MealPhotoPicker(
                      photoPath: _photoPath,
                      onPickPhoto: _showImageSourceDialog,
                      onRemovePhoto: () => setState(() => _photoPath = null),
                    ),
                  ],
                ], // End of _showForm

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
          onPressed:
              menuState.isLoading || _isSavingAsRecipe ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        if (_showForm && !_recipeAlreadyExists(_nameController.text)) ...[
          IconButton(
            onPressed: (menuState.isLoading || _isSavingAsRecipe) ? null : _saveAsRecipe,
            icon: _isSavingAsRecipe
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.bookmark_add),
          )
        ],
        FilledButton(
          onPressed: (menuState.isLoading || _isSavingAsRecipe) ? null : _saveMeal,
          child: menuState.isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.existingMeal != null ? 'Guardar' : 'Añadir'),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qkomo_ui/core/utils/sanitizer.dart';
import 'package:qkomo_ui/features/auth/application/auth_providers.dart';
import 'package:qkomo_ui/features/menu/application/menu_providers.dart';
import 'package:qkomo_ui/features/menu/domain/entities/preset_recipe.dart';
import 'package:qkomo_ui/features/menu/domain/meal.dart';
import 'package:qkomo_ui/features/menu/domain/meal_type.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/meal_form_action_buttons.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/meal_form_footer.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/meal_form_header.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/meal_ingredients_input.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/meal_name_field.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/meal_notes_field.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/meal_photo_picker.dart';
import 'package:qkomo_ui/features/menu/presentation/widgets/meal_type_selector.dart';
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
  final _imagePicker = ImagePicker();

  late MealType _selectedMealType;
  String? _photoPath;
  bool _showForm = false;
  bool _isSavingAsRecipe = false;
  bool _isCreatingCustom = false;

  @override
  void initState() {
    super.initState();
    _selectedMealType =
        widget.mealType ?? widget.existingMeal?.mealType ?? MealType.lunch;

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
                final image = await _imagePicker.pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  setState(() => _photoPath = image.path);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Cámara'),
              onTap: () async {
                Navigator.pop(context);
                final image = await _imagePicker.pickImage(
                  source: ImageSource.camera,
                );
                if (image != null) {
                  setState(() => _photoPath = image.path);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _clearIngredientControllers() {
    for (var controller in _ingredientControllers) {
      controller.dispose();
    }
    _ingredientControllers.clear();
  }

  void _applyPresetRecipe(PresetRecipe recipe) {
    _nameController.text = recipe.name;
    _selectedMealType = recipe.suggestedMealType;
    _photoPath = recipe.photoPath;
    _clearIngredientControllers();
    for (final ingredient in recipe.ingredients) {
      _ingredientControllers.add(TextEditingController(text: ingredient));
    }
  }

  void _applyCustomRecipe(Map<String, dynamic> recipe) {
    _nameController.text = recipe['name'] as String? ?? '';
    _selectedMealType = recipe['mealType'] as MealType? ?? MealType.lunch;
    _photoPath = recipe['photoPath'] as String?;
    _clearIngredientControllers();
    final ingredients = recipe['ingredients'] as List<dynamic>? ?? [];
    for (final ingredient in ingredients.cast<String>()) {
      _ingredientControllers.add(TextEditingController(text: ingredient));
    }
  }

  Future<void> _showPresetRecipes() async {
    final selected = await showDialog<dynamic>(
      context: context,
      builder: (context) => const PresetRecipeDialog(),
    );

    if (selected == null) return;

    setState(() {
      _showForm = true;
      _isCreatingCustom = false;

      if (selected is PresetRecipe) {
        _applyPresetRecipe(selected);
      } else if (selected is Map<String, dynamic>) {
        _applyCustomRecipe(selected);
      }
    });
  }

  Future<void> _saveMeal() async {
    if (!_formKey.currentState!.validate()) return;

    final ingredients = _ingredientControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

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
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        photoPath: _photoPath,
      );
    } else {
      await controller.createMeal(
        userId: userId,
        name: Sanitizer.sanitize(_nameController.text),
        ingredients: ingredients,
        mealType: _selectedMealType,
        scheduledFor: widget.date,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        photoPath: _photoPath,
      );
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _saveAsRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    final ingredients = _ingredientControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

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
    final deletedPresetRecipes =
        ref.read(deletedPresetRecipesStreamProvider).value ?? [];
    final existsInPreset = PresetRecipes.all.any(
      (recipe) =>
          recipe.name.toLowerCase() == trimmedName &&
          !deletedPresetRecipes.contains(recipe.name),
    );

    return existsInPreset;
  }

  void _handleBack() {
    // If showing form and not editing existing meal, go back to initial state
    if (_showForm && widget.existingMeal == null) {
      setState(() {
        _showForm = false;
        _isCreatingCustom = false;
        // Clear form data
        _nameController.clear();
        _notesController.clear();
        _photoPath = null;
        for (var controller in _ingredientControllers) {
          controller.dispose();
        }
        _ingredientControllers.clear();
        _ingredientControllers.add(TextEditingController());
      });
    } else {
      // Otherwise close the dialog
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuControllerProvider);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MealFormHeader(
            isEditing: widget.existingMeal != null,
            selectedMealType: _selectedMealType,
            showingForm: _showForm,
            onBack: _handleBack,
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
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
                      MealTypeSelector(
                        selectedMealType: _selectedMealType,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedMealType = value);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      MealNameField(controller: _nameController),
                      const SizedBox(height: 16),
                      MealIngredientsInput(
                        controllers: _ingredientControllers,
                        formKey: _formKey,
                        onAddIngredient: _addIngredient,
                        onRemoveIngredient: _removeIngredient,
                      ),
                      const SizedBox(height: 16),
                      MealNotesField(controller: _notesController),
                      if (_isCreatingCustom) ...[
                        const SizedBox(height: 16),
                        MealPhotoPicker(
                          photoPath: _photoPath,
                          onPickPhoto: _showImageSourceDialog,
                          onRemovePhoto: () =>
                              setState(() => _photoPath = null),
                        ),
                      ],
                    ], // End of _showForm

                    if (menuState.errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        menuState.errorMessage!,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          MealFormFooter(
            isLoading: menuState.isLoading,
            isSavingAsRecipe: _isSavingAsRecipe,
            isEditing: widget.existingMeal != null,
            showSaveAsRecipe:
                _showForm && !_recipeAlreadyExists(_nameController.text),
            onCancel: () => Navigator.of(context).pop(),
            onSaveAsRecipe: _saveAsRecipe,
            onSave: _saveMeal,
          ),
        ],
      ),
    );
  }
}

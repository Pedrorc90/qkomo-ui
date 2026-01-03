import 'package:flutter/material.dart';

class MealIngredientsInput extends StatelessWidget {
  const MealIngredientsInput({
    super.key,
    required this.controllers,
    required this.formKey,
    required this.onAddIngredient,
    required this.onRemoveIngredient,
  });

  final List<TextEditingController> controllers;
  final GlobalKey<FormState> formKey;
  final VoidCallback onAddIngredient;
  final void Function(int index) onRemoveIngredient;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ingredientes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        ...controllers.asMap().entries.map((entry) {
          final index = entry.key;
          final controller = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    onChanged: (value) {
                      if (index != 0) {
                        formKey.currentState?.validate();
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Ingrediente ${index + 1}',
                    ),
                    validator: index == 0
                        ? (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Agrega al menos un ingrediente';
                            }
                            return null;
                          }
                        : null,
                  ),
                ),
                if (controllers.length > 1)
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => onRemoveIngredient(index),
                  ),
              ],
            ),
          );
        }),
        TextButton.icon(
          onPressed: onAddIngredient,
          icon: const Icon(Icons.add),
          label: const Text('Agregar ingrediente'),
        ),
      ],
    );
  }
}

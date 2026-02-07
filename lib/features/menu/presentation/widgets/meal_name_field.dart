import 'package:flutter/material.dart';

/// Text field for meal name input with validation
class MealNameField extends StatelessWidget {
  const MealNameField({
    required this.controller,
    super.key,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
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
    );
  }
}

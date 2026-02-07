import 'package:flutter/material.dart';

/// Text field for optional meal notes
class MealNotesField extends StatelessWidget {
  const MealNotesField({
    required this.controller,
    super.key,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Notas (opcional)',
        hintText: 'Ej: Sin cebolla',
      ),
      maxLines: 2,
    );
  }
}

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickedImagePreview extends StatelessWidget {
  const PickedImagePreview({super.key, required this.file});

  final XFile? file;

  @override
  Widget build(BuildContext context) {
    if (file == null) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: const Center(
          child: Text('Aún no hay imagen seleccionada'),
        ),
      );
    }

    if (kIsWeb) {
      return _UnsupportedPreview();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.file(
        File(file!.path),
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _UnsupportedPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text('Vista previa no soportada en web'),
      ),
    );
  }
}

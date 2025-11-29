import 'package:flutter/material.dart';

import '../../application/capture_state.dart';
import '../../domain/capture_mode.dart';

class CaptureStatusBanner extends StatelessWidget {
  const CaptureStatusBanner({super.key, required this.state});

  final CaptureState state;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final baseCard = Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.lightbulb_outline, color: scheme.primary),
            const SizedBox(width: 12),
            Expanded(child: Text(_hintForMode(state.mode))),
          ],
        ),
      ),
    );

    if (state.error != null) {
      return _StatusCard(
        icon: Icons.error_outline,
        color: scheme.errorContainer,
        text: state.error!,
      );
    }
    if (state.message != null) {
      return _StatusCard(
        icon: Icons.info_outline,
        color: scheme.primaryContainer,
        text: state.message!,
      );
    }
    if (state.imageFile != null) {
      return _StatusCard(
        icon: Icons.photo,
        color: scheme.surfaceVariant,
        text: 'Imagen preparada desde ${_modeLabel(state.mode)}',
      );
    }
    if (state.barcode != null) {
      return _StatusCard(
        icon: Icons.check_circle_outline,
        color: scheme.surfaceVariant,
        text: 'Código listo: ${state.barcode}',
      );
    }
    return baseCard;
  }

  String _hintForMode(CaptureMode mode) {
    switch (mode) {
      case CaptureMode.camera:
        return 'Abre la cámara y encuadra el plato o producto.';
      case CaptureMode.gallery:
        return 'Importa una foto desde tu galería para analizarla.';
      case CaptureMode.barcode:
        return 'Apunta al código de barras y espera a que se detecte.';
    }
  }

  String _modeLabel(CaptureMode mode) {
    switch (mode) {
      case CaptureMode.camera:
        return 'cámara';
      case CaptureMode.gallery:
        return 'galería';
      case CaptureMode.barcode:
        return 'escáner';
    }
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.icon,
    required this.color,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: color,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

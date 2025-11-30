import 'package:flutter/material.dart';

import 'package:qkomo_ui/features/capture/domain/capture_mode.dart';

class CaptureStatusBanner extends StatelessWidget {
  const CaptureStatusBanner({
    super.key,
    required this.mode,
    required this.hasImage,
    this.message,
    this.error,
  });

  final CaptureMode mode;
  final bool hasImage;
  final String? message;
  final String? error;

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
            Expanded(child: Text(_hintForMode(mode))),
          ],
        ),
      ),
    );

    if (error != null) {
      return _StatusCard(
        icon: Icons.error_outline,
        color: scheme.errorContainer,
        text: error!,
      );
    }
    if (message != null) {
      return _StatusCard(
        icon: Icons.info_outline,
        color: scheme.primaryContainer,
        text: message!,
      );
    }
    if (hasImage) {
      return _StatusCard(
        icon: Icons.photo,
        color: scheme.surfaceVariant,
        text: 'Imagen preparada desde ${_modeLabel(mode)}',
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
        return 'Enfoca el código de barras o código QR para escanear.';
      case CaptureMode.text:
        return 'Escribe el título e ingredientes de tu comida.';
    }
  }

  String _modeLabel(CaptureMode mode) {
    switch (mode) {
      case CaptureMode.camera:
        return 'cámara';
      case CaptureMode.gallery:
        return 'galería';
      case CaptureMode.barcode:
        return 'código de barras';
      case CaptureMode.text:
        return 'texto';
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

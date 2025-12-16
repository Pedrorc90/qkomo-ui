import 'package:flutter/material.dart';

import 'package:qkomo_ui/features/capture/domain/capture_result.dart';
import 'package:qkomo_ui/theme/design_tokens.dart';

/// Card para mostrar alertas médicas (diabetes, hipertensión, colesterol)
class MedicalAlertsCard extends StatelessWidget {
  const MedicalAlertsCard({
    super.key,
    required this.medicalAlerts,
  });

  final CaptureMedicalAlerts medicalAlerts;

  @override
  Widget build(BuildContext context) {
    final hasAlerts = medicalAlerts.diabetes != null ||
        medicalAlerts.hypertension != null ||
        medicalAlerts.cholesterol != null;

    if (!hasAlerts) return const SizedBox.shrink();

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.errorContainer.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        side: BorderSide(
          color: colorScheme.error,
          width: DesignTokens.borderWidthThin,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.health_and_safety,
                  size: 20,
                  color: colorScheme.error,
                ),
                const SizedBox(width: 8),
                Text(
                  'Alertas médicas',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (medicalAlerts.diabetes != null)
              _buildAlertItem(
                context,
                'Diabetes',
                medicalAlerts.diabetes!,
                Icons.water_drop,
              ),
            if (medicalAlerts.hypertension != null)
              _buildAlertItem(
                context,
                'Hipertensión',
                medicalAlerts.hypertension!,
                Icons.favorite,
              ),
            if (medicalAlerts.cholesterol != null)
              _buildAlertItem(
                context,
                'Colesterol',
                medicalAlerts.cholesterol!,
                Icons.heart_broken,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertItem(
    BuildContext context,
    String title,
    String message,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

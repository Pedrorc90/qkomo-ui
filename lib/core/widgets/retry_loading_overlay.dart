import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qkomo_ui/core/http/retry_state_notifier.dart';
import 'package:qkomo_ui/theme/app_colors.dart';

/// Overlay visual amigable para mostrar estado de reintentos
class RetryLoadingOverlay extends ConsumerWidget {
  const RetryLoadingOverlay({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final retryState = ref.watch(retryStateProvider);

    return Stack(
      children: [
        child,
        if (retryState.isRetrying)
          Positioned.fill(
            child: IgnorePointer(
              ignoring: false,
              child: Container(
                color: AppColors.overlayBlack50
                    .withAlpha((0.4 / 0.5 * 255 * 0.5).round()),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Spinner animado
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Círculo de fondo con degradado
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.neutralWhite,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.overlayBlack30.withAlpha(
                                        (0.2 / 0.3 * 255 * 0.3).round()),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                            // Spinner animado
                            CircularProgressIndicator(
                              strokeWidth: 4,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Texto de estado
                      Text(
                        'Conectando...',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors.neutralWhite,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      const SizedBox(height: 12)
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/core/http/retry_state_notifier.dart';
import 'package:qkomo_ui/theme/app_colors.dart';

/// Widget que muestra un indicador cuando se están reintentando conexiones
class RetryNotificationWidget extends ConsumerWidget {
  final Widget child;

  const RetryNotificationWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final retryState = ref.watch(retryStateProvider);

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        child,
        if (retryState.isRetrying)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Material(
              elevation: 4,
              color: AppColors.semanticWarning,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.neutralWhite,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Conectando con el servidor... '
                          '(intento ${retryState.retryCount} de 3)',
                          style: const TextStyle(
                            color: AppColors.neutralWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
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

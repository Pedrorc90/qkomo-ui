import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qkomo_ui/theme/design_tokens.dart';

/// A success feedback dialog with a delightful animation.
///
/// Uses Lottie for the animation if the asset is provided,
/// otherwise falls back to a built-in scale animation.
class SuccessFeedback extends StatelessWidget {
  const SuccessFeedback({
    super.key,
    this.message,
    this.lottieAsset = 'assets/animations/success.json',
    this.duration = const Duration(seconds: 2),
  });
  final String? message;
  final String lottieAsset;
  final Duration duration;

  /// Static helper to show the success dialog easily.
  static Future<void> show(BuildContext context, {String? message}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SuccessFeedback(message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacingLg),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
            ),
            child: Column(
              children: [
                Lottie.asset(
                  lottieAsset,
                  width: 150,
                  height: 150,
                  repeat: false,
                  onLoaded: (composition) {
                    Future.delayed(composition.duration, () {
                      if (context.mounted) Navigator.of(context).pop();
                    });
                  },
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to Icon animation if Lottie fails (e.g. file missing)
                    return _FallbackSuccessIcon(duration: duration);
                  },
                ),
                if (message != null) ...[
                  const SizedBox(height: DesignTokens.spacingMd),
                  Text(
                    message!,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FallbackSuccessIcon extends StatefulWidget {
  const _FallbackSuccessIcon({required this.duration});
  final Duration duration;

  @override
  State<_FallbackSuccessIcon> createState() => _FallbackSuccessIconState();
}

class _FallbackSuccessIconState extends State<_FallbackSuccessIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();

    Future.delayed(widget.duration, () {
      if (mounted) {
        // Only pop if we are still the top route
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Icon(
        Icons.check_circle,
        color: Theme.of(context).colorScheme.primary,
        size: 100,
      ),
    );
  }
}

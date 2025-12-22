import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qkomo_ui/theme/design_tokens.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key, this.message});

  final String? message;

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: child,
                  ),
                );
              },
              child: SvgPicture.asset(
                'assets/images/icon_qk_hybrid.svg',
                width: 120,
                height: 120,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingLg),
            if (widget.message != null) ...[
              Text(
                widget.message!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: DesignTokens.spacingMd),
            ],
            SizedBox(
              width: 140,
              child: LinearProgressIndicator(
                backgroundColor:
                    theme.colorScheme.primaryContainer.withAlpha(50),
                valueColor:
                    AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

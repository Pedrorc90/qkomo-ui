import 'package:flutter/material.dart';
import 'package:qkomo_ui/theme/design_tokens.dart';

/// A card wrapper widget with a subtle scale micro-interaction on tap.
///
/// Wraps a Card with optional animation and InkWell for interactive feedback.
/// When tapped, the card scales from 1.0 to 0.98 creating a press effect.
///
/// Features:
/// - Smooth 200ms scale animation on tap (easeInOut curve)
/// - Optional InkWell for tap feedback (only when onTap is provided)
/// - Configurable elevation, border radius, and color
/// - Can be disabled with enableAnimation = false
/// - Proper semantic labeling for accessibility
///
/// Example:
/// ```dart
/// // Simple card with tap animation
/// AnimatedCard(
///   onTap: () => print('Card tapped'),
///   child: Padding(
///     padding: EdgeInsets.all(16),
///     child: Text('Tap me!'),
///   ),
/// )
///
/// // Card with custom styling
/// AnimatedCard(
///   elevation: 2,
///   borderRadius: BorderRadius.circular(16),
///   color: Colors.blue.shade50,
///   onTap: () => navigateToDetails(),
///   child: MyCustomContent(),
/// )
///
/// // Static card without animation
/// AnimatedCard(
///   enableAnimation: false,
///   child: StaticContent(),
/// )
/// ```
class AnimatedCard extends StatefulWidget {
  const AnimatedCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.elevation,
    this.borderRadius,
    this.color,
    this.enableAnimation = true,
  });

  /// The widget to display inside the card
  final Widget child;

  /// Optional callback when the card is tapped
  final VoidCallback? onTap;

  /// Optional padding inside the card. If null, uses no padding.
  final EdgeInsets? padding;

  /// Optional card elevation. Default: 0 (flat design)
  final double? elevation;

  /// Optional border radius. Default: 12dp (radiusMd)
  final BorderRadius? borderRadius;

  /// Optional card background color
  final Color? color;

  /// Whether to enable the scale animation on tap. Default: true
  final bool enableAnimation;

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  double _currentScale = 1.0;

  @override
  void initState() {
    super.initState();

    if (widget.enableAnimation) {
      _animationController = AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      );

      _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );

      _scaleAnimation.addListener(() {
        setState(() {
          _currentScale = _scaleAnimation.value;
        });
      });
    }
  }

  @override
  void dispose() {
    if (widget.enableAnimation) {
      _animationController.dispose();
    }
    super.dispose();
  }

  void _onTapDown() {
    if (widget.enableAnimation && widget.onTap != null) {
      _animationController.forward();
    }
  }

  void _onTapUp() {
    if (widget.enableAnimation && widget.onTap != null) {
      _animationController.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.enableAnimation && widget.onTap != null) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final card = Card(
      elevation: widget.elevation ?? 0,
      shape: RoundedRectangleBorder(
        borderRadius:
            widget.borderRadius ?? BorderRadius.circular(DesignTokens.radiusMd),
      ),
      color: widget.color,
      clipBehavior: Clip.antiAlias,
      child: widget.padding != null
          ? Padding(
              padding: widget.padding!,
              child: widget.child,
            )
          : widget.child,
    );

    // If no onTap or animation disabled, return plain card
    if (widget.onTap == null || !widget.enableAnimation) {
      return Semantics(
        button: widget.onTap != null,
        enabled: widget.onTap != null,
        onTap: widget.onTap,
        child: GestureDetector(
          onTap: widget.onTap,
          child: card,
        ),
      );
    }

    // Return card with animation and gesture detection
    return Semantics(
      button: true,
      enabled: true,
      onTap: widget.onTap,
      child: GestureDetector(
        onTapDown: (_) => _onTapDown(),
        onTapUp: (_) => _onTapUp(),
        onTapCancel: _onTapCancel,
        onTap: widget.onTap,
        child: Transform.scale(
          scale: _currentScale,
          child: card,
        ),
      ),
    );
  }
}

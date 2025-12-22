import 'package:flutter/material.dart';
import 'package:qkomo_ui/theme/design_tokens.dart';

/// Custom page route with slide transition from the right.
///
/// Commonly used for moving forward in a linear flow or opening details.
class SlidePageRoute<T> extends PageRouteBuilder<T> {
  SlidePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.fastOutSlowIn;

            final tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: DesignTokens.durationBase,
        );
  final Widget page;
}

/// Custom page route with fade transition.
///
/// Commonly used for modal-like experiences or subtle navigation changes.
class FadePageRoute<T> extends PageRouteBuilder<T> {
  FadePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: DesignTokens.durationBase,
        );
  final Widget page;
}

/// Custom page route with scale transition.
///
/// Commonly used for opening specific items or hero-like transitions.
class ScalePageRoute<T> extends PageRouteBuilder<T> {
  ScalePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
          transitionDuration: DesignTokens.durationBase,
        );
  final Widget page;
}

/// Extension for easier navigation with custom transitions
extension PageNavigation on BuildContext {
  /// Navigate to a new page with a slide transition
  Future<T?> pushSlide<T>(Widget page) {
    return Navigator.of(this).push<T>(SlidePageRoute(page: page));
  }

  /// Navigate to a new page with a fade transition
  Future<T?> pushFade<T>(Widget page) {
    return Navigator.of(this).push<T>(FadePageRoute(page: page));
  }
}

import 'package:flutter/material.dart';
import 'package:qkomo_ui/core/widgets/qkomo_logo.dart';

/// Reusable navbar component with centered Qkomo logo and title
///
/// Provides a consistent header across all app screens with:
/// - Centered Qkomo logo and app name
/// - Optional leading widget (e.g., back button)
/// - Optional action buttons
class QkomoNavBar extends StatelessWidget implements PreferredSizeWidget {
  const QkomoNavBar({
    super.key,
    this.leading,
    this.actions,
    this.title,
  });

  /// Leading widget (e.g., back button, menu button)
  final Widget? leading;

  /// Action buttons to show on the right
  final List<Widget>? actions;

  final String? title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Use provided actions or empty list
    final allActions = actions ?? [];

    return AppBar(
      leading: leading,
      title: title != null
          ? Text(
              title!,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const QkomoLogo(size: 32),
                const SizedBox(width: 12),
                Text(
                  'Qkomo',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
      centerTitle: true,
      actions: allActions,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}

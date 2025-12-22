import 'package:flutter/material.dart';
import 'package:qkomo_ui/theme/design_tokens.dart';
import 'package:shimmer/shimmer.dart';

/// A generic skeleton container with shimmer effect.
///
/// Used as a base building block for complex skeleton loading states.
class SkeletonContainer extends StatelessWidget {
  const SkeletonContainer({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Use theme colors for shimmer to ensure consistency
    final baseColor = isDark ? Colors.grey[850]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 20,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              borderRadius ?? BorderRadius.circular(DesignTokens.radiusSm),
        ),
      ),
    );
  }
}

/// A skeleton loader representing a standard Card.
///
/// Matches the proportions of typical list items in the app.
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingMd),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
      ),
      child: const Padding(
        padding: EdgeInsets.all(DesignTokens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image/Hero Area
            SkeletonContainer(
              height: 120,
              borderRadius:
                  BorderRadius.all(Radius.circular(DesignTokens.radiusSm)),
            ),
            SizedBox(height: DesignTokens.spacingMd),
            // Title
            SkeletonContainer(
              width: 180,
              height: 20,
            ),
            SizedBox(height: DesignTokens.spacingSm),
            // Subtitle
            SkeletonContainer(
              width: 120,
              height: 14,
            ),
          ],
        ),
      ),
    );
  }
}

/// A skeleton loader for a list of items.
class SkeletonList extends StatelessWidget {
  const SkeletonList({
    super.key,
    this.itemCount = 5,
    this.padding = const EdgeInsets.all(DesignTokens.spacingMd),
  });
  final int itemCount;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: padding,
      itemCount: itemCount,
      itemBuilder: (context, index) => const SkeletonCard(),
    );
  }
}

/// A skeleton loader for the Home Header sections.
class SkeletonHeader extends StatelessWidget {
  const SkeletonHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonContainer(width: 140, height: 24),
        SizedBox(height: DesignTokens.spacingSm),
        SkeletonContainer(width: 200, height: 16),
      ],
    );
  }
}

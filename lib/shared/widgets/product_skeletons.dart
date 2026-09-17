import 'package:flutter/material.dart';

import '../../core/layout/responsive_grid.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import 'skeleton.dart';

/// One shimmering product-card placeholder.
class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key, this.width});

  final double? width;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: AppRadius.circular(AppRadius.md),
        border: Border.all(color: c.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(child: Skeleton(height: double.infinity, radius: 0)),
          SizedBox(
            height: ProductGrid.infoExtent(context),
            child: const Padding(
              padding: EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Skeleton(height: 12, width: 120),
                  SizedBox(height: AppSpacing.xs),
                  Skeleton(height: 10, width: 80),
                  SizedBox(height: AppSpacing.xs),
                  Skeleton(height: 14, width: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// `pvj-product-skeleton`: a grid of placeholders.
class ProductGridSkeleton extends StatelessWidget {
  const ProductGridSkeleton({super.key, this.count = 6});

  final int count;

  @override
  Widget build(BuildContext context) => ResponsiveGrid(
    itemCount: count,
    mainAxisExtentBuilder: ProductGrid.extent,
    itemBuilder: (_, __) => const ProductCardSkeleton(),
  );
}

/// `pvj-rail-skeleton`: horizontal placeholders.
class RailSkeleton extends StatelessWidget {
  const RailSkeleton({
    super.key,
    this.count = 3,
    required this.gutter,
    this.cardWidth = 176,
  });

  final int count;
  final double gutter;
  final double cardWidth;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: ProductRail.height(context),
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: gutter),
      itemCount: count,
      separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
      itemBuilder: (_, __) => ProductCardSkeleton(width: cardWidth),
    ),
  );
}

/// Layout constants shared by grids and rails so skeletons match content.
///
/// A card is a square image over a text block. The text block's height is
/// fixed here (scaled with the user's font size) and the image absorbs the
/// rest, so cells never overflow by a sub-pixel at odd widths.
abstract final class ProductGrid {
  /// Fixed, unscaled parts of the text block: paddings (12 + 8), gaps
  /// (2 + 4 + 4), the 34 px price row, and 4 px of slack.
  // Padding, gaps, the quick-add button, and 6px of slack for font metrics.
  static const _fixed = 12.0 + 8 + 3 + 4 + 4 + 34 + 4 + 6;

  /// Height of the text block for the current theme, locale and font scale:
  /// name (titleSmall) + meta (labelSmall) + rating row (labelLarge) on top
  /// of the fixed parts. Line heights are exact because every theme style
  /// sets `height`, so a fallback font (Lao) cannot change them.
  static double infoExtent(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scale = MediaQuery.textScalerOf(context).scale(1);
    double line(TextStyle? style) =>
        (style?.fontSize ?? 14) * (style?.height ?? 1.2) * scale;
    return _fixed +
        line(text.titleSmall) +
        line(text.labelSmall) +
        line(text.labelLarge).clamp(12, double.infinity);
  }

  static double extent(BuildContext context, double cellWidth) =>
      cellWidth + infoExtent(context);
}

abstract final class ProductRail {
  static const cardWidth = 176.0;

  static double height(BuildContext context) =>
      ProductGrid.extent(context, cardWidth);
}

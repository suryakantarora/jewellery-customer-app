import 'package:flutter/widgets.dart';

import '../theme/tokens.dart';
import 'breakpoints.dart';

/// A 2 → 3 → 4 column grid that sizes itself from the available width, so it
/// works inside a scroll view without the caller knowing the form factor.
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.childAspectRatio = .72,
    this.mainAxisExtentBuilder,
    this.spacing = AppSpacing.sm,
    this.padding = EdgeInsets.zero,
    this.shrinkWrap = true,
    this.physics = const NeverScrollableScrollPhysics(),
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double childAspectRatio;

  /// When set, each cell is exactly this tall for the given cell width and
  /// [childAspectRatio] is ignored. Lets cards with a fixed text block sit
  /// under a square image without sub-pixel overflow.
  final double Function(BuildContext context, double cellWidth)?
  mainAxisExtentBuilder;
  final double spacing;
  final EdgeInsetsGeometry padding;
  final bool shrinkWrap;
  final ScrollPhysics physics;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = Breakpoints.gridColumns(constraints.maxWidth);
      final cellWidth =
          (constraints.maxWidth - spacing * (columns - 1)) / columns;
      final extent = mainAxisExtentBuilder?.call(context, cellWidth);
      return GridView.builder(
        padding: padding,
        shrinkWrap: shrinkWrap,
        physics: physics,
        itemCount: itemCount,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          childAspectRatio: extent == null ? childAspectRatio : 1,
          mainAxisExtent: extent,
        ),
        itemBuilder: itemBuilder,
      );
    },
  );
}

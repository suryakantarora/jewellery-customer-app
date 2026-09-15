import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/motion/motion.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';

/// A shimmering placeholder built from surface2 → border → surface2, so it
/// reads correctly in dark mode too (survey `u-shimmer`).
class Skeleton extends StatelessWidget {
  const Skeleton({
    super.key,
    this.width,
    this.height = 16,
    this.radius = AppRadius.sm,
    this.child,
  });

  /// A circle of [size].
  const Skeleton.circle({super.key, required double size})
    : width = size,
      height = size,
      radius = AppRadius.pill,
      child = null;

  final double? width;
  final double? height;
  final double radius;

  /// Optional shape to shimmer instead of a rounded box.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final box =
        child ??
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: c.surface2,
            borderRadius: AppRadius.circular(radius),
          ),
        );
    if (AppMotion.reduced(context)) return box;
    return Shimmer.fromColors(
      baseColor: c.surface2,
      highlightColor: c.border,
      period: const Duration(milliseconds: 1500),
      child: box,
    );
  }
}

/// A block of text-like skeleton lines.
class SkeletonLines extends StatelessWidget {
  const SkeletonLines({super.key, this.lines = 3, this.lastWidthFactor = .6});

  final int lines;
  final double lastWidthFactor;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < lines; i++) ...[
          Skeleton(
            width: i == lines - 1
                ? constraints.maxWidth * lastWidthFactor
                : constraints.maxWidth,
            height: 12,
          ),
          if (i < lines - 1) const SizedBox(height: AppSpacing.xs),
        ],
      ],
    ),
  );
}

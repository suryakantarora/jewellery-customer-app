import 'package:flutter/material.dart';

import '../../core/motion/motion.dart';
import '../../core/theme/app_colors.dart';

/// `tick-in`: a circle that springs in, then the check mark draws.
class AnimatedTick extends StatelessWidget {
  const AnimatedTick({super.key, this.size = 88, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final tint = color ?? AppColors.success;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppMotion.of(context, AppMotion.slower),
      curve: AppMotion.spring,
      builder: (context, v, _) => Transform.scale(
        scale: .6 + .4 * v.clamp(0, 1),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: tint.withValues(alpha: .12),
            border: Border.all(color: tint, width: 2),
          ),
          child: Opacity(
            opacity: v.clamp(0, 1),
            child: Icon(Icons.check_rounded, size: size * .5, color: tint),
          ),
        ),
      ),
      child: SizedBox(width: size, height: size, child: ColoredBox(color: c.bg)),
    );
  }
}

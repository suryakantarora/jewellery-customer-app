import 'package:flutter/material.dart';

import '../../core/motion/motion.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import 'press_scale.dart';

/// `.u-chip`: pill, 1px border, scale .95 on press; active = filled primary.
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.active = false,
    this.onTap,
    this.leading,
  });

  final String label;
  final bool active;
  final VoidCallback? onTap;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final style = Theme.of(context).textTheme.bodyMedium!.copyWith(
      fontWeight: FontWeight.w500,
      color: active ? Colors.white : c.text,
    );
    return PressScale(
      scale: .95,
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppMotion.of(context, AppMotion.fast),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? c.primary : c.surface,
          borderRadius: AppRadius.circular(AppRadius.pill),
          border: Border.all(color: active ? c.primary : c.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[
              IconTheme(
                data: IconThemeData(size: 16, color: style.color),
                child: leading!,
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(label, style: style),
          ],
        ),
      ),
    );
  }
}

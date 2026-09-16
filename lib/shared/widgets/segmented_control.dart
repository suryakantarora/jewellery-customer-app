import 'package:flutter/material.dart';

import '../../core/motion/motion.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';

/// A pill segmented control (Active / All, Ring / Bangle / Length).
class SegmentedControl extends StatelessWidget {
  const SegmentedControl({
    super.key,
    required this.labels,
    required this.index,
    required this.onChanged,
    this.icons,
  });

  final List<String> labels;
  final List<IconData>? icons;
  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: c.surface2,
        borderRadius: AppRadius.circular(AppRadius.pill),
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: AppMotion.of(context, AppMotion.normal),
                  curve: AppMotion.easeOut,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: i == index ? c.surface : Colors.transparent,
                    borderRadius: AppRadius.circular(AppRadius.pill),
                    boxShadow: i == index ? AppShadows.sm(c.shadow) : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icons != null) ...[
                        Icon(
                          icons![i],
                          size: 16,
                          color: i == index ? c.primary : c.textMuted,
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        labels[i],
                        style: text.labelLarge!.copyWith(
                          color: i == index ? c.text : c.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

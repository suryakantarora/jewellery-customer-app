import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';

enum PillTone { neutral, ok, bad, live }

/// Status pill with tones: neutral, ok (green), bad (red), live (primary).
class StatusPill extends StatelessWidget {
  const StatusPill(this.label, {super.key, this.tone = PillTone.neutral});

  final String label;
  final PillTone tone;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (bg, fg) = switch (tone) {
      PillTone.neutral => (c.surface2, c.textSecondary),
      PillTone.ok => (AppColors.success.withValues(alpha: .12), AppColors.success),
      PillTone.bad => (AppColors.danger.withValues(alpha: .12), AppColors.danger),
      PillTone.live => (c.primary.withValues(alpha: .12), c.primary),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium!.copyWith(color: fg),
      ),
    );
  }
}

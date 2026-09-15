import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';

enum BadgeTone {
  /// Ink on paper (NEW).
  neutral,

  /// Primary (−N%).
  sale,

  /// Champagne accent.
  accent,

  /// 10% primary tint.
  ghost,
}

/// `.u-badge` variants.
class AppBadge extends StatelessWidget {
  const AppBadge(this.label, {super.key, this.tone = BadgeTone.neutral});

  final String label;
  final BadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (bg, fg) = switch (tone) {
      BadgeTone.neutral => (c.text, c.bg),
      BadgeTone.sale => (c.primary, Colors.white),
      BadgeTone.accent => (c.accentSoft, c.text),
      BadgeTone.ghost => (c.primary.withValues(alpha: .10), c.primary),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.circular(AppRadius.xs),
      ),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium!.copyWith(color: fg),
      ),
    );
  }
}

/// The small count pip on header icon buttons.
class BadgePip extends StatelessWidget {
  const BadgePip({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();
    final c = context.colors;
    return Container(
      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: c.primary,
        borderRadius: AppRadius.circular(AppRadius.pill),
        border: Border.all(color: c.surface, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        count > 99 ? '99+' : '$count',
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          height: 1,
        ),
      ),
    );
  }
}

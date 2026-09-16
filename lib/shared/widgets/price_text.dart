import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format/formatters_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';

/// `.u-price` + `.u-price-was` + `.u-price-off`: bold tabular price, struck
/// original and an accent "-N%".
class PriceText extends ConsumerWidget {
  const PriceText(
    this.price, {
    super.key,
    this.original,
    this.discountPercent,
    this.style,
    this.compact = false,
  });

  final num price;
  final num? original;
  final int? discountPercent;
  final TextStyle? style;

  /// One line, smaller (product cards).
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final money = ref.watch(moneyFormatterProvider);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final main = (style ?? (compact ? text.titleSmall : text.titleLarge))!
        .copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
    final hasOriginal = original != null && original! > price;
    final children = <Widget>[
      Text(money.format(price), style: main),
      if (hasOriginal)
        Text(
          money.format(original!),
          style: (compact ? text.labelSmall : text.bodySmall)!.copyWith(
            decoration: TextDecoration.lineThrough,
            color: c.textMuted,
          ),
        ),
      if (discountPercent != null && discountPercent! > 0 && !compact)
        Text(
          '-$discountPercent%',
          style: text.labelLarge!.copyWith(color: c.accent),
        ),
    ];
    if (compact) {
      // One line that shrinks to fit rather than wrapping or overflowing.
      return FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) const SizedBox(width: AppSpacing.xs),
              children[i],
            ],
          ],
        ),
      );
    }
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.xs,
      runSpacing: 2,
      children: children,
    );
  }
}

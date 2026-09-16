import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Five stars filled to [rating], optionally followed by the score and count.
class RatingStars extends StatelessWidget {
  const RatingStars({
    super.key,
    required this.rating,
    this.size = 14,
    this.count,
    this.showValue = false,
    this.color,
  });

  final double rating;
  final double size;
  final int? count;
  final bool showValue;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final star = color ?? c.accent;
    final text = Theme.of(context).textTheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 5; i++)
          Icon(
            rating >= i + 1
                ? Icons.star_rounded
                : rating > i
                ? Icons.star_half_rounded
                : Icons.star_outline_rounded,
            size: size,
            color: star,
          ),
        if (showValue) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: text.labelLarge!.copyWith(letterSpacing: 0),
          ),
        ],
        if (count != null) ...[
          const SizedBox(width: 4),
          Text('($count)', style: text.labelSmall),
        ],
      ],
    );
  }
}

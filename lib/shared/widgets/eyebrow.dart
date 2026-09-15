import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// `.u-eyebrow`: 10px, 600, .28em tracking, uppercase, accent colour.
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: Theme.of(context).textTheme.labelMedium!.copyWith(
      color: color ?? context.colors.accent,
    ),
  );
}

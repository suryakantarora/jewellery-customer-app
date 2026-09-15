import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// `.u-rule`: the 34×1 accent hairline under headings and the wordmark.
class GoldRule extends StatelessWidget {
  const GoldRule({super.key, this.width = 34, this.color});

  final double width;
  final Color? color;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: 1,
    color: color ?? context.colors.accent,
  );
}

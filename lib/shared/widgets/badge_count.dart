import 'package:flutter/material.dart';

import 'app_badge.dart';

/// Overlays a count pip on the top-right of [child] when count > 0.
class BadgeCount extends StatelessWidget {
  const BadgeCount({super.key, required this.count, required this.child});

  final int count;
  final Widget child;

  @override
  Widget build(BuildContext context) => Stack(
    clipBehavior: Clip.none,
    children: [
      child,
      if (count > 0)
        Positioned(top: -6, right: -6, child: IgnorePointer(child: BadgePip(count: count))),
    ],
  );
}

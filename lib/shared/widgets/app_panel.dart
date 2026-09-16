import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';

/// `.u-card`: card bg, 1px border, radius-md, shadow-sm. Children are laid
/// out vertically; use [padding] for free-form content.
class AppPanel extends StatelessWidget {
  const AppPanel({
    super.key,
    this.children = const [],
    this.child,
    this.padding = EdgeInsets.zero,
    this.color,
  });

  final List<Widget> children;
  final Widget? child;
  final EdgeInsetsGeometry padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: color ?? c.card,
        borderRadius: AppRadius.circular(AppRadius.md),
        border: Border.all(color: c.border),
        boxShadow: AppShadows.sm(c.shadow),
      ),
      clipBehavior: Clip.antiAlias,
      // ListTiles paint on the nearest Material; give them one so ink and
      // selection stay visible above the panel's own background.
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: padding,
          child:
              child ??
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
        ),
      ),
    );
  }
}

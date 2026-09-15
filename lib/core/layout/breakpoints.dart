import 'package:flutter/widgets.dart';

import '../theme/tokens.dart';

enum FormFactor { phone, tablet, wide }

abstract final class Breakpoints {
  static const tablet = 600.0;
  static const wide = 1024.0;

  /// The product grid grows 2 → 3 → 4 columns at 640 → 1024 (survey `.u-grid`).
  static const gridThree = 640.0;

  static FormFactor of(BuildContext context) =>
      fromWidth(MediaQuery.sizeOf(context).width);

  static FormFactor fromWidth(double width) {
    if (width >= wide) return FormFactor.wide;
    if (width >= tablet) return FormFactor.tablet;
    return FormFactor.phone;
  }

  static bool isPhone(BuildContext context) =>
      of(context) == FormFactor.phone;

  static int gridColumns(double width) {
    if (width >= wide) return 4;
    if (width >= gridThree) return 3;
    return 2;
  }

  static double gutter(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 768
      ? AppLayout.gutterWide
      : AppLayout.gutter;
}

/// Centres content at the design's maximum width (1180) on tablets.
class ContentWidth extends StatelessWidget {
  const ContentWidth({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: AppLayout.contentMax),
      child: child,
    ),
  );
}

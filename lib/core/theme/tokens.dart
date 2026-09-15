import 'package:flutter/widgets.dart';

/// Design tokens ported 1:1 from the Ionic `tokens.scss` (colour-free).
abstract final class AppRadius {
  static const xs = 6.0;
  static const sm = 10.0;
  static const md = 14.0;
  static const lg = 20.0;
  static const xl = 28.0;
  static const pill = 999.0;

  static BorderRadius circular(double r) => BorderRadius.circular(r);
}

abstract final class AppSpacing {
  static const xxxs = 2.0;
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
  static const xxxl = 64.0;
}

abstract final class AppType {
  static const xxs = 10.0;
  static const xs = 11.0;
  static const sm = 13.0;
  static const md = 15.0;
  static const lg = 17.0;
  static const xl = 21.0;
  static const xxl = 26.0;
  static const xxxl = 32.0;
  static const xxxxl = 40.0;

  /// The 4xl step grows on wide layouts (38 → 52 above 768px in the source).
  static const xxxxlWide = 52.0;

  static const lineTight = 1.18;
  static const lineSnug = 1.35;
  static const lineNormal = 1.6;

  /// Tracking in em; multiply by the font size for `letterSpacing`.
  static const trackWide = 0.08;
  static const trackWider = 0.16;
  static const trackWidest = 0.28;

  static double tracking(double fontSize, double em) => fontSize * em;
}

abstract final class AppLayout {
  static const gutter = 16.0;
  static const gutterWide = 24.0;
  static const contentMax = 1180.0;
  static const headerHeight = 56.0;
  static const tabBarHeight = 62.0;
  static const fabSize = 56.0;
}

/// Elevation recipes; each takes the tenant's tinted shadow colour.
abstract final class AppShadows {
  static List<BoxShadow> sm(Color Function(double opacity) tint) => [
    BoxShadow(color: tint(.06), offset: const Offset(0, 1), blurRadius: 2),
    BoxShadow(color: tint(.05), offset: const Offset(0, 2), blurRadius: 6),
  ];

  static List<BoxShadow> md(Color Function(double opacity) tint) => [
    BoxShadow(color: tint(.08), offset: const Offset(0, 2), blurRadius: 8),
    BoxShadow(color: tint(.07), offset: const Offset(0, 10), blurRadius: 24),
  ];

  static List<BoxShadow> lg(Color Function(double opacity) tint) => [
    BoxShadow(color: tint(.10), offset: const Offset(0, 6), blurRadius: 18),
    BoxShadow(color: tint(.12), offset: const Offset(0, 22), blurRadius: 48),
  ];
}

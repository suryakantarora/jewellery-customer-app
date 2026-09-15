import 'package:flutter/widgets.dart';

/// Three-speed motion system from the Ionic tokens.
abstract final class AppMotion {
  static const fast = Duration(milliseconds: 160);
  static const normal = Duration(milliseconds: 280);
  static const slow = Duration(milliseconds: 520);
  static const slower = Duration(milliseconds: 900);

  /// Page transition length (survey §6).
  static const page = Duration(milliseconds: 380);

  static const easeOut = Cubic(.22, 1, .36, 1);
  static const easeInOut = Cubic(.65, 0, .35, 1);
  static const spring = Cubic(.34, 1.56, .64, 1);

  /// Reveal stagger: `index × 70 ms`, capped at 600 ms.
  static Duration stagger(int index) =>
      Duration(milliseconds: (index * 70).clamp(0, 600));

  /// Honour the platform's reduced-motion setting.
  static bool reduced(BuildContext context) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  /// [duration], or zero when animations are disabled.
  static Duration of(BuildContext context, Duration duration) =>
      reduced(context) ? Duration.zero : duration;
}

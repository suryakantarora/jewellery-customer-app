import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Photo scrim: transparent → tenant scrim colour, bottom-weighted.
class Scrim extends StatelessWidget {
  const Scrim({
    super.key,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
    this.stops = const [.25, 1],
    this.strength = 1,
  });

  final Alignment begin;
  final Alignment end;
  final List<double> stops;
  final double strength;

  @override
  Widget build(BuildContext context) {
    final scrim = context.colors.scrim;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          stops: stops,
          colors: [
            Colors.transparent,
            scrim.withValues(alpha: (scrim.a * strength).clamp(0, 1)),
          ],
        ),
      ),
    );
  }
}

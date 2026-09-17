import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/motion/motion.dart';
import '../../core/theme/app_colors.dart';
import 'app_art.dart';

/// The jeweller's "display tray" behind the tinted header, the drawer
/// banner, the profile banner and the splash: the themed ground gradient, a
/// filigree corner, and a slow diagonal gold sheen that drifts across every
/// nine seconds (paused under reduced motion).
class BannerGround extends StatefulWidget {
  const BannerGround({
    super.key,
    required this.child,
    this.filigree = true,
    this.filigreeSize = 190,
    this.filigreeAlignment = Alignment.topRight,
    this.sheen = true,
    this.hairline = false,
  });

  final Widget child;
  final bool filigree;
  final double filigreeSize;
  final Alignment filigreeAlignment;
  final bool sheen;

  /// Draws a gold hairline along the bottom edge (headers).
  final bool hairline;

  @override
  State<BannerGround> createState() => _BannerGroundState();
}

class _BannerGroundState extends State<BannerGround>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 9),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduced = AppMotion.reduced(context);
    if (!reduced && widget.sheen && !_c.isAnimating) {
      _c.repeat();
    } else if (reduced && _c.isAnimating) {
      _c.stop();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.bannerGround,
        gradient: c.bannerGradient,
        border: widget.hairline
            ? Border(bottom: BorderSide(color: c.bannerHairline))
            : null,
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          if (widget.filigree)
            Positioned.fill(
              child: Align(
                alignment: widget.filigreeAlignment,
                child: Transform.translate(
                  offset: Offset(
                    widget.filigreeAlignment.x * widget.filigreeSize * .22,
                    widget.filigreeAlignment.y * -widget.filigreeSize * .18,
                  ),
                  child: Opacity(
                    opacity: c.isDark ? .40 : .55,
                    child: AppArt.filigreeCorner(
                      color: c.bannerGold,
                      size: widget.filigreeSize,
                    ),
                  ),
                ),
              ),
            ),
          if (widget.sheen)
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _c,
                  builder: (context, _) => CustomPaint(
                    painter: _SheenPainter(
                      t: _c.value,
                      gold: c.bannerGold,
                      strength: c.isDark ? .16 : .26,
                    ),
                  ),
                ),
              ),
            ),
          widget.child,
        ],
      ),
    );
  }
}

/// A soft diagonal band of gold light sweeping left → right.
class _SheenPainter extends CustomPainter {
  const _SheenPainter({
    required this.t,
    required this.gold,
    required this.strength,
  });

  final double t;
  final Color gold;
  final double strength;

  @override
  void paint(Canvas canvas, Size size) {
    // Ease the sweep so it lingers off-screen between passes.
    final eased = Curves.easeInOutSine.transform(t);
    final x = -size.width * .6 + eased * size.width * 2.2;
    final band = size.width * .55;
    final rect = Rect.fromLTWH(x - band / 2, 0, band, size.height);
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          gold.withValues(alpha: 0),
          gold.withValues(alpha: strength),
          gold.withValues(alpha: 0),
        ],
      ).createShader(rect)
      ..blendMode = BlendMode.plus;
    canvas.save();
    // Lean the band 20° like light across a facet.
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(-20 * math.pi / 180);
    canvas.translate(-size.width / 2, -size.height / 2);
    canvas.drawRect(rect.inflate(size.height), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_SheenPainter old) =>
      old.t != t || old.gold != gold || old.strength != strength;
}

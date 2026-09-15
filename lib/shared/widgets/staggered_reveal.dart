import 'package:flutter/material.dart';

import '../../core/motion/motion.dart';

/// `pvjReveal`: opacity 0 + 16px rise → settled over 520 ms, delayed by
/// `index × 70 ms` (capped at 600 ms).
class StaggeredReveal extends StatefulWidget {
  const StaggeredReveal({
    super.key,
    required this.child,
    this.index = 0,
    this.duration = AppMotion.slow,
    this.rise = 16,
    this.axis = Axis.vertical,
  });

  final Widget child;
  final int index;
  final Duration duration;
  final double rise;

  /// Vertical rises from below; horizontal slides in from the leading edge
  /// (the drawer rows).
  final Axis axis;

  @override
  State<StaggeredReveal> createState() => _StaggeredRevealState();
}

class _StaggeredRevealState extends State<StaggeredReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: AppMotion.easeOut,
  );
  bool _scheduled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_scheduled) return;
    _scheduled = true;
    if (AppMotion.reduced(context)) {
      _controller.value = 1;
      return;
    }
    Future<void>.delayed(AppMotion.stagger(widget.index), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _curve,
    builder: (context, child) {
      final t = _curve.value;
      final offset = widget.rise * (1 - t);
      return Opacity(
        opacity: t,
        child: Transform.translate(
          offset: widget.axis == Axis.vertical
              ? Offset(0, offset)
              : Offset(-offset, 0),
          child: child,
        ),
      );
    },
    child: widget.child,
  );
}

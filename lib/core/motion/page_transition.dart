import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'motion.dart';

/// The survey's `pvjNavAnimation`: 380 ms ease-out. The entering page slides
/// in from the right; the page beneath moves −28%, scales to .96 and dims to
/// .6. Mirrored on pop, so the returning page comes back from that state.
class AppPage<T> extends CustomTransitionPage<T> {
  const AppPage({
    required super.child,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  }) : super(
         transitionDuration: AppMotion.page,
         reverseTransitionDuration: AppMotion.page,
         transitionsBuilder: _build,
       );

  static Widget _build(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (AppMotion.reduced(context)) {
      return FadeTransition(opacity: animation, child: child);
    }
    final enter = CurvedAnimation(parent: animation, curve: AppMotion.easeOut);
    final leave = CurvedAnimation(
      parent: secondaryAnimation,
      curve: AppMotion.easeOut,
    );

    // As this page is covered: translate to -28%, scale .96, opacity .6.
    final covered = SlideTransition(
      position: Tween(
        begin: Offset.zero,
        end: const Offset(-.28, 0),
      ).animate(leave),
      child: ScaleTransition(
        scale: Tween(begin: 1.0, end: .96).animate(leave),
        child: FadeTransition(
          opacity: Tween(begin: 1.0, end: .6).animate(leave),
          child: child,
        ),
      ),
    );

    // As this page enters: slide from the right edge.
    return SlideTransition(
      position: Tween(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(enter),
      child: covered,
    );
  }
}

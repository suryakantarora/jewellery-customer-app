import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/motion/motion.dart';
import '../../core/theme/app_colors.dart';
import '../../features/wishlist/wishlist_provider.dart';
import '../../l10n/app_localizations.dart';
import 'app_toast.dart';

/// The blurred circular wishlist heart: fills and pops (1 → 1.35 → 1) when
/// toggled. Reads and writes the wishlist itself.
class HeartButton extends ConsumerStatefulWidget {
  const HeartButton({super.key, required this.productId, this.size = 34, this.onSurface = false});

  final String productId;
  final double size;

  /// On a plain surface (not over a photo): no blur, bordered.
  final bool onSurface;

  @override
  ConsumerState<HeartButton> createState() => _HeartButtonState();
}

class _HeartButtonState extends ConsumerState<HeartButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pop = AnimationController(
    vsync: this,
    duration: AppMotion.of(context, const Duration(milliseconds: 420)),
  );

  @override
  void dispose() {
    _pop.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    final l10n = AppL10n.of(context);
    final added = await ref.read(wishlistProvider.notifier).toggle(widget.productId);
    if (!mounted) return;
    if (added) unawaited(_pop.forward(from: 0));
    showToast(
      context,
      added ? l10n.wishlistAdded : l10n.wishlistRemoved,
      icon: added ? Icons.favorite_rounded : Icons.favorite_border_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final active = ref.watch(isWishlistedProvider(widget.productId));
    final l10n = AppL10n.of(context);
    final icon = AnimatedBuilder(
      animation: _pop,
      builder: (context, child) {
        final t = _pop.value;
        final scale = t < .5 ? 1 + .35 * (t / .5) : 1.35 - .35 * ((t - .5) / .5);
        return Transform.scale(scale: scale, child: child);
      },
      child: Icon(
        active ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        size: widget.size * .53,
        color: active ? c.primary : (widget.onSurface ? c.text : Colors.white),
      ),
    );
    final circle = Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.onSurface
            ? c.surface
            : Colors.white.withValues(alpha: c.isDark ? .18 : .32),
        border: widget.onSurface ? Border.all(color: c.border) : null,
      ),
      alignment: Alignment.center,
      child: icon,
    );
    return Semantics(
      button: true,
      label: l10n.actionWishlist,
      toggled: active,
      child: GestureDetector(
        onTap: _toggle,
        child: widget.onSurface
            ? circle
            : ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: circle,
                ),
              ),
      ),
    );
  }
}

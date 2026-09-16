import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/motion/motion.dart';
import '../../core/router/app_routes.dart';
import '../../core/tenant/tenant_provider.dart';
import '../../features/cart/cart_provider.dart';
import '../../features/wishlist/wishlist_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_badge.dart';
import '../../shared/widgets/gold_rule.dart';

/// The app header in its two variants.
///
/// `brand`: hamburger + wordmark (display face, gold rule) + search / wishlist
/// / bag icon buttons with badge pips. `page`: back + centred title.
class FinoHeader extends ConsumerWidget implements PreferredSizeWidget {
  const FinoHeader.brand({
    super.key,
    this.showSearch = true,
    this.showWishlist = true,
    this.showCart = true,
    this.tinted = false,
  }) : _isBrand = true,
       title = null;

  const FinoHeader.page({super.key, required this.title, this.tinted = false})
    : _isBrand = false,
      showSearch = false,
      showWishlist = false,
      showCart = false;

  final bool _isBrand;
  final String? title;
  final bool showSearch;
  final bool showWishlist;
  final bool showCart;

  /// Swaps the toolbar for the banner gradient ground.
  final bool tinted;

  @override
  Size get preferredSize => const Size.fromHeight(AppLayout.headerHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final ink = tinted ? AppColors.bannerInk : c.text;
    final wishlistCount = _isBrand ? ref.watch(wishlistCountProvider) : 0;
    final cartCount = _isBrand ? ref.watch(cartCountProvider) : 0;

    final Widget leading;
    final Widget middle;
    if (_isBrand) {
      leading = IconButton(
        tooltip: l10n.actionMenu,
        icon: Icon(Icons.menu_rounded, color: ink),
        // The drawer belongs to the shell's Scaffold, not the tab's own, so
        // open the outermost one.
        onPressed: () =>
            context.findRootAncestorStateOfType<ScaffoldState>()?.openDrawer(),
      );
      final mark = ref.watch(tenantProvider).valueOrNull?.brandMark ?? '';
      middle = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            mark,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: ink,
              letterSpacing: AppType.tracking(AppType.lg, AppType.trackWide),
            ),
          ),
          const SizedBox(height: 3),
          GoldRule(color: tinted ? c.accent : null),
        ],
      );
    } else {
      leading = IconButton(
        tooltip: l10n.actionBack,
        icon: Icon(Icons.arrow_back_rounded, color: ink),
        onPressed: () =>
            context.canPop() ? context.pop() : context.go(AppRoutes.home),
      );
      middle = Text(
        title!,
        style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: ink),
        overflow: TextOverflow.ellipsis,
      );
    }

    return Container(
      decoration: tinted
          ? BoxDecoration(
              color: c.bannerGround,
              gradient: c.bannerGradient,
            )
          : BoxDecoration(
              color: c.surface,
              border: Border(bottom: BorderSide(color: c.border)),
            ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: AppLayout.headerHeight,
          child: Row(
            children: [
              leading,
              Expanded(child: Center(child: middle)),
              if (showSearch)
                _HeaderIcon(
                  icon: Icons.search_rounded,
                  tooltip: l10n.actionSearch,
                  color: ink,
                  onTap: () => context.push(AppRoutes.search),
                ),
              if (showWishlist)
                _HeaderIcon(
                  icon: Icons.favorite_border_rounded,
                  tooltip: l10n.actionWishlist,
                  color: ink,
                  count: wishlistCount,
                  onTap: () => context.push(AppRoutes.wishlist),
                ),
              if (showCart)
                _HeaderIcon(
                  icon: Icons.shopping_bag_outlined,
                  tooltip: l10n.actionBag,
                  color: ink,
                  count: cartCount,
                  onTap: () => context.push(AppRoutes.cart),
                ),
              if (!_isBrand) const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onTap,
    this.count = 0,
  });

  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onTap;
  final int count;

  @override
  Widget build(BuildContext context) => Stack(
    clipBehavior: Clip.none,
    children: [
      IconButton(
        tooltip: tooltip,
        icon: Icon(icon, color: color),
        onPressed: onTap,
      ),
      if (count > 0)
        Positioned(
          top: 6,
          right: 4,
          child: IgnorePointer(child: _PopOnChange(count: count)),
        ),
    ],
  );
}

/// `u-pop`: the pip scales 1 → 1.35 → 1 whenever its count changes.
class _PopOnChange extends StatefulWidget {
  const _PopOnChange({required this.count});

  final int count;

  @override
  State<_PopOnChange> createState() => _PopOnChangeState();
}

class _PopOnChangeState extends State<_PopOnChange>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  @override
  void didUpdateWidget(_PopOnChange old) {
    super.didUpdateWidget(old);
    if (old.count != widget.count && !AppMotion.reduced(context)) {
      _c.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    builder: (context, child) {
      final t = _c.value;
      final scale = t < .5 ? 1 + .35 * (t / .5) : 1.35 - .35 * ((t - .5) / .5);
      return Transform.scale(scale: scale, child: child);
    },
    child: BadgePip(count: widget.count),
  );
}

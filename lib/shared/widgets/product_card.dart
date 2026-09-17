import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/media/app_image.dart';
import '../../core/motion/motion.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../data/models/catalogue_item.dart';
import '../../data/models/retail_attributes.dart';
import '../../features/cart/cart_provider.dart';
import '../../l10n/app_localizations.dart';
import 'app_badge.dart';
import 'app_toast.dart';
import 'heart_button.dart';
import 'press_scale.dart';
import 'price_text.dart';
import 'product_skeletons.dart';
import 'rating_stars.dart';

/// `pvj-product-card`: image with second-image cross-fade on press, NEW /
/// −N% badges, blurred heart, sold-out overlay, name, `purity · category`,
/// rating, price and a quick-add button with an idle → adding → added
/// state machine (420 ms + 1400 ms reset).
class ProductCard extends ConsumerStatefulWidget {
  const ProductCard({super.key, required this.item, this.width});

  final CatalogueItem item;

  /// Fixed width inside a horizontal rail; null fills the grid cell.
  final double? width;

  @override
  ConsumerState<ProductCard> createState() => _ProductCardState();
}

enum _AddState { idle, adding, added }

class _ProductCardState extends ConsumerState<ProductCard> {
  bool _pressed = false;
  _AddState _add = _AddState.idle;

  Future<void> _quickAdd() async {
    final item = widget.item;
    final l10n = AppL10n.of(context);
    if (item.retail.sizeKind != SizeKind.none) {
      // Sized pieces need a choice first.
      await context.push(AppRoutes.productPath(item.id));
      return;
    }
    if (_add != _AddState.idle) return;
    setState(() => _add = _AddState.adding);
    await Future<void>.delayed(
      AppMotion.of(context, const Duration(milliseconds: 420)),
    );
    await ref.read(cartProvider.notifier).add(item);
    if (!mounted) return;
    setState(() => _add = _AddState.added);
    showToast(
      context,
      l10n.cartAddedToast(item.productName),
      icon: Icons.shopping_bag_outlined,
    );
    await Future<void>.delayed(const Duration(milliseconds: 1400));
    if (mounted) setState(() => _add = _AddState.idle);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final item = widget.item;
    final r = item.retail;
    final second = item.images.length > 1 ? item.images[1] : null;

    final card = Container(
      width: widget.width,
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: AppRadius.circular(AppRadius.md),
        border: Border.all(color: c.border),
        boxShadow: AppShadows.sm(c.shadow),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                AppImage(item.heroImage),
                if (second != null)
                  AnimatedOpacity(
                    opacity: _pressed ? 1 : 0,
                    duration: AppMotion.of(context, AppMotion.slow),
                    child: AppImage(second),
                  ),
                if (!r.inStock)
                  ColoredBox(
                    color: c.scrim,
                    child: Center(
                      child: AppBadge(
                        l10n.productSoldOut,
                        tone: BadgeTone.neutral,
                      ),
                    ),
                  ),
                Positioned(
                  top: AppSpacing.xs,
                  left: AppSpacing.xs,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (r.isNew) AppBadge(l10n.badgeNew),
                      if (r.discountPercent != null &&
                          r.discountPercent! > 0) ...[
                        if (r.isNew) const SizedBox(height: 4),
                        AppBadge(
                          '-${r.discountPercent}%',
                          tone: BadgeTone.sale,
                        ),
                      ],
                    ],
                  ),
                ),
                Positioned(
                  top: AppSpacing.xs,
                  right: AppSpacing.xs,
                  child: HeartButton(productId: item.id),
                ),
              ],
            ),
          ),
          SizedBox(
            height: ProductGrid.infoExtent(context),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sm,
                AppSpacing.sm,
                AppSpacing.sm,
                AppSpacing.xs,
              ),
              // Every row is either single-line or shrink-to-fit, so the
              // block can never overflow whatever the width or font scale.
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and meta keep their full line height (a Flexible
                  // here let the meta row paint over the name's descenders).
                  Text(
                    item.productName,
                    style: text.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${item.purityName} · ${item.categoryName}',
                    style: text.labelSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Flexible(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: RatingStars(
                          rating: r.rating,
                          size: 12,
                          showValue: true,
                          count: r.reviewCount,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: PriceText(
                            item.price,
                            original: r.originalPrice,
                            compact: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xxs),
                      _QuickAdd(
                        state: _add,
                        enabled: r.inStock,
                        onTap: _quickAdd,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    return Listener(
      onPointerDown: (_) => setState(() => _pressed = true),
      onPointerUp: (_) => setState(() => _pressed = false),
      onPointerCancel: (_) => setState(() => _pressed = false),
      child: PressScale(
        onTap: () => context.push(AppRoutes.productPath(item.id)),
        child: card,
      ),
    );
  }
}

class _QuickAdd extends StatelessWidget {
  const _QuickAdd({
    required this.state,
    required this.enabled,
    required this.onTap,
  });

  final _AddState state;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final added = state == _AddState.added;
    final Widget child = switch (state) {
      _AddState.idle => const Icon(
        Icons.add_rounded,
        size: 18,
        key: ValueKey('idle'),
      ),
      _AddState.adding => const SizedBox(
        key: ValueKey('adding'),
        width: 14,
        height: 14,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      ),
      _AddState.added => const Icon(
        Icons.check_rounded,
        size: 18,
        key: ValueKey('added'),
      ),
    };
    return Semantics(
      button: true,
      label: added ? l10n.cartAdded : l10n.cartAddToBag,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: AnimatedContainer(
          duration: AppMotion.of(context, AppMotion.fast),
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: !enabled
                ? c.border
                : added
                ? AppColors.success
                : c.primary,
          ),
          child: IconTheme(
            data: const IconThemeData(color: Colors.white),
            child: AnimatedSwitcher(
              duration: AppMotion.of(context, AppMotion.fast),
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}

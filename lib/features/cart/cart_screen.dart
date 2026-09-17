import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format/formatters_provider.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/media/app_image.dart';
import '../../core/media/image_ref.dart';
import '../../core/motion/motion.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../data/models/commerce.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_panel.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/app_toast.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/price_text.dart';
import '../../shared/widgets/quantity_stepper.dart';
import '../../shared/widgets/skeleton.dart';
import '../../shared/widgets/staggered_reveal.dart';
import '../auth/auth_gate.dart';
import '../shell/fino_header.dart';
import '../wishlist/wishlist_provider.dart';
import 'cart_provider.dart';

/// Bag (survey: CartPage): free-delivery progress, lines with stepper /
/// move-to-wishlist / remove, price summary, sticky checkout footer.
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final money = ref.watch(moneyFormatterProvider);
    final gutter = Breakpoints.gutter(context);
    final cart = ref.watch(cartProvider);
    final totals = ref.watch(cartTotalsProvider);

    return Scaffold(
      appBar: FinoHeader.page(title: l10n.cartTitle),
      body: cart.when(
        loading: () => ListView(
          padding: EdgeInsets.all(gutter),
          children: const [
            Skeleton(height: 56, radius: AppRadius.md),
            SizedBox(height: AppSpacing.md),
            Skeleton(height: 96, radius: AppRadius.md),
            SizedBox(height: AppSpacing.sm),
            Skeleton(height: 96, radius: AppRadius.md),
          ],
        ),
        error: (_, __) =>
            ErrorState(onRetry: () => ref.invalidate(cartProvider)),
        data: (lines) => lines.isEmpty
            ? EmptyState(
                image: const ImageRef.asset('images/ui/nodata.png'),
                title: l10n.cartEmptyTitle,
                body: l10n.cartEmptyBody,
                primaryLabel: l10n.actionContinueShopping,
                onPrimary: () => context.go(AppRoutes.home),
                secondaryLabel: l10n.actionWishlist,
                onSecondary: () => context.push(AppRoutes.wishlist),
              )
            : Column(
                children: [
                  Expanded(
                    child: ContentWidth(
                      child: ListView(
                        padding: EdgeInsets.fromLTRB(
                          gutter,
                          AppSpacing.md,
                          gutter,
                          AppSpacing.xl,
                        ),
                        children: [
                          _FreeDelivery(totals: totals),
                          const SizedBox(height: AppSpacing.md),
                          for (var i = 0; i < lines.length; i++)
                            StaggeredReveal(
                              key: ValueKey(
                                '${lines[i].product.id}-${lines[i].size}',
                              ),
                              index: i,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.sm,
                                ),
                                child: _LineCard(line: lines[i]),
                              ),
                            ),
                          const SizedBox(height: AppSpacing.md),
                          const CouponPanel(),
                          const SizedBox(height: AppSpacing.sm),
                          AppPanel(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Column(
                              children: [
                                _SummaryRow(
                                  l10n.cartSubtotal,
                                  money.format(totals.subtotal),
                                ),
                                if (totals.savings > 0)
                                  _SummaryRow(
                                    l10n.cartSavings,
                                    '−${money.format(totals.savings)}',
                                    color: AppColors.success,
                                  ),
                                _SummaryRow(
                                  l10n.cartShipping,
                                  totals.freeDelivery
                                      ? l10n.cartFree
                                      : money.format(totals.shipping),
                                  color: totals.freeDelivery
                                      ? AppColors.success
                                      : null,
                                ),
                                if (totals.discount > 0)
                                  _SummaryRow(
                                    l10n.cartDiscount(totals.offer!.code),
                                    '−${money.format(totals.discount)}',
                                    color: AppColors.success,
                                  ),
                                _SummaryRow(
                                  l10n.cartTax,
                                  money.format(totals.tax),
                                ),
                                Divider(color: c.border, height: AppSpacing.lg),
                                _SummaryRow(
                                  l10n.cartTotal,
                                  money.format(totals.total),
                                  bold: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      gutter,
                      AppSpacing.sm,
                      gutter,
                      AppSpacing.sm + MediaQuery.paddingOf(context).bottom,
                    ),
                    decoration: BoxDecoration(
                      color: c.surface,
                      border: Border(top: BorderSide(color: c.border)),
                      boxShadow: AppShadows.md(c.shadow),
                    ),
                    child: ContentWidth(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l10n.cartTotal, style: text.labelSmall),
                                Text(
                                  money.format(totals.total),
                                  style: text.titleLarge,
                                ),
                              ],
                            ),
                          ),
                          FilledButton.icon(
                            onPressed: () async {
                              if (await ensureSignedIn(context, ref) &&
                                  context.mounted) {
                                await context.push(AppRoutes.checkout);
                              }
                            },
                            icon: const Icon(
                              Icons.lock_outline_rounded,
                              size: 16,
                            ),
                            label: Text(l10n.cartCheckout),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _FreeDelivery extends ConsumerWidget {
  const _FreeDelivery({required this.totals});

  final CartTotals totals;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final money = ref.watch(moneyFormatterProvider);
    if (totals.freeDeliveryThreshold <= 0) return const SizedBox.shrink();
    return AppPanel(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                totals.freeDelivery
                    ? Icons.check_circle_rounded
                    : Icons.local_shipping_outlined,
                size: 18,
                color: totals.freeDelivery ? AppColors.success : c.accent,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  totals.freeDelivery
                      ? l10n.cartFreeDeliveryUnlocked
                      : l10n.cartFreeDeliveryHint(
                          money.format(totals.remainingForFreeDelivery),
                        ),
                  style: text.bodySmall!.copyWith(color: c.text),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: AppRadius.circular(AppRadius.pill),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: totals.freeDeliveryProgress),
              duration: AppMotion.of(context, AppMotion.slow),
              curve: AppMotion.easeOut,
              builder: (context, v, _) => LinearProgressIndicator(
                value: v,
                minHeight: 6,
                color: totals.freeDelivery ? AppColors.success : c.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LineCard extends ConsumerWidget {
  const _LineCard({required this.line});

  final CartLine line;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final p = line.product;
    final meta = [
      p.purityName,
      p.metalName,
      if (line.size != null) l10n.cartSize(line.size!),
    ].join(' · ');

    return AppPanel(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => context.push(AppRoutes.productPath(p.id)),
            child: AppImage(
              p.heroImage,
              width: 84,
              height: 84,
              borderRadius: AppRadius.circular(AppRadius.sm),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        p.productName,
                        style: text.titleSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 18,
                        tooltip: l10n.cartRemove,
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          color: c.textMuted,
                        ),
                        onPressed: () =>
                            ref.read(cartProvider.notifier).remove(line),
                      ),
                    ),
                  ],
                ),
                Text(meta, style: text.labelSmall),
                const SizedBox(height: AppSpacing.xs),
                PriceText(
                  p.price,
                  original: p.retail.originalPrice,
                  compact: true,
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    QuantityStepper(
                      value: line.quantity,
                      compact: true,
                      onChanged: (v) =>
                          ref.read(cartProvider.notifier).setQuantity(line, v),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                            ),
                            onPressed: () async {
                              if (!ref.read(isWishlistedProvider(p.id))) {
                                await ref
                                    .read(wishlistProvider.notifier)
                                    .toggle(p.id);
                              }
                              await ref
                                  .read(cartProvider.notifier)
                                  .remove(line);
                              if (context.mounted) {
                                showToast(
                                  context,
                                  l10n.cartMovedToWishlist,
                                  icon: Icons.favorite_rounded,
                                );
                              }
                            },
                            child: Text(l10n.cartMoveToWishlist),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value, {this.color, this.bold = false});

  final String label;
  final String value;
  final Color? color;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: bold
                  ? text.titleMedium
                  : text.bodyMedium!.copyWith(color: c.textSecondary),
            ),
          ),
          Text(
            value,
            style: (bold ? text.titleLarge : text.titleSmall)!.copyWith(
              color: color,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shared by checkout's review step.
class OrderSummaryLines extends ConsumerWidget {
  const OrderSummaryLines({super.key, required this.totals});

  final CartTotals totals;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final money = ref.watch(moneyFormatterProvider);
    return Column(
      children: [
        _SummaryRow(l10n.cartSubtotal, money.format(totals.subtotal)),
        if (totals.savings > 0)
          _SummaryRow(
            l10n.cartSavings,
            '−${money.format(totals.savings)}',
            color: AppColors.success,
          ),
        _SummaryRow(
          l10n.cartShipping,
          totals.freeDelivery ? l10n.cartFree : money.format(totals.shipping),
          color: totals.freeDelivery ? AppColors.success : null,
        ),
        if (totals.discount > 0)
          _SummaryRow(
            l10n.cartDiscount(totals.offer!.code),
            '−${money.format(totals.discount)}',
            color: AppColors.success,
          ),
        _SummaryRow(l10n.cartTax, money.format(totals.tax)),
        Divider(color: c.border, height: AppSpacing.lg),
        _SummaryRow(l10n.cartTotal, money.format(totals.total), bold: true),
      ],
    );
  }
}

/// A compact thumbnail row used by checkout and order screens.
class LineThumbRow extends StatelessWidget {
  const LineThumbRow({
    super.key,
    required this.image,
    required this.name,
    required this.meta,
    required this.trailing,
  });

  final ImageRef image;
  final String name;
  final String meta;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          AppImage(
            image,
            width: 48,
            height: 48,
            borderRadius: AppRadius.circular(AppRadius.xs),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: text.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(meta, style: text.labelSmall),
              ],
            ),
          ),
          Text(
            trailing,
            style: text.titleSmall!.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

/// Coupon entry: apply a code from the offers screen, see it as a chip,
/// remove it. Shows a hint when the bag is under the offer's minimum.
class CouponPanel extends ConsumerStatefulWidget {
  const CouponPanel({super.key});

  @override
  ConsumerState<CouponPanel> createState() => _CouponPanelState();
}

class _CouponPanelState extends ConsumerState<CouponPanel> {
  final _code = TextEditingController();
  var _busy = false;
  String? _error;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _apply() async {
    final l10n = AppL10n.of(context);
    if (_code.text.trim().isEmpty) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final ok = await ref.read(appliedOfferProvider.notifier).apply(_code.text);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = ok ? null : l10n.cartCouponInvalid;
    });
    if (ok) {
      _code.clear();
      FocusScope.of(context).unfocus();
      showToast(context, l10n.cartCouponApplied, icon: Icons.local_offer_outlined);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final money = ref.watch(moneyFormatterProvider);
    final totals = ref.watch(cartTotalsProvider);
    final offer = totals.offer;
    return AppPanel(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: offer != null
          ? Row(
              children: [
                Icon(Icons.local_offer_rounded, color: c.accent, size: 20),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(offer.code, style: text.titleSmall),
                      Text(
                        totals.offerIneligible
                            ? l10n.cartCouponMinimum(money.format(offer.minSubtotal))
                            : l10n.cartCouponActive,
                        style: text.labelSmall!.copyWith(
                          color: totals.offerIneligible ? AppColors.warning : AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => ref.read(appliedOfferProvider.notifier).clear(),
                  child: Text(l10n.actionRemove),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppTextField(
                    label: l10n.cartCoupon,
                    controller: _code,
                    icon: Icons.local_offer_outlined,
                    error: _error,
                    textCapitalization: TextCapitalization.characters,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _apply(),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: OutlinedButton(
                    onPressed: _busy ? null : _apply,
                    child: Text(l10n.cartCouponApply),
                  ),
                ),
              ],
            ),
    );
  }
}

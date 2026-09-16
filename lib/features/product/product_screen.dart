import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format/formatters_provider.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/media/app_image.dart';
import '../../core/motion/motion.dart';
import '../../core/router/app_routes.dart';
import '../../core/tenant/tenant_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../data/models/catalogue_item.dart';
import '../../data/models/retail_attributes.dart';
import '../../data/models/review.dart';
import '../../data/repository_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_badge.dart';
import '../../shared/widgets/app_chip.dart';
import '../../shared/widgets/app_toast.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/eyebrow.dart';
import '../../shared/widgets/heart_button.dart';
import '../../shared/widgets/price_text.dart';
import '../../shared/widgets/product_rail.dart';
import '../../shared/widgets/product_skeletons.dart';
import '../../shared/widgets/quantity_stepper.dart';
import '../../shared/widgets/rating_stars.dart';
import '../../shared/widgets/section_head.dart';
import '../../shared/widgets/skeleton.dart';
import '../auth/auth_gate.dart';
import '../cart/cart_provider.dart';
import '../shell/fino_header.dart';

/// Product detail (survey: ProductDetailPage).
class ProductScreen extends ConsumerStatefulWidget {
  const ProductScreen({super.key, required this.productId});

  final String productId;

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

enum _AddState { idle, adding, added }

class _ProductScreenState extends ConsumerState<ProductScreen>
    with SingleTickerProviderStateMixin {
  int _image = 0;
  String? _size;
  bool _sizeError = false;
  int _qty = 1;
  _AddState _add = _AddState.idle;
  final _sizeKey = GlobalKey();
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  bool _needsSize(CatalogueItem item) =>
      item.retail.sizeKind != SizeKind.none && item.retail.sizes.isNotEmpty;

  bool _validateSize(CatalogueItem item) {
    if (!_needsSize(item) || _size != null) return true;
    setState(() => _sizeError = true);
    unawaited(_shake.forward(from: 0));
    unawaited(HapticFeedback.mediumImpact());
    final ctx = _sizeKey.currentContext;
    if (ctx != null) {
      unawaited(
        Scrollable.ensureVisible(
          ctx,
          duration: AppMotion.normal,
          alignment: .2,
        ),
      );
    }
    return false;
  }

  Future<void> _addToBag(CatalogueItem item) async {
    if (_add != _AddState.idle || !_validateSize(item)) return;
    final l10n = AppL10n.of(context);
    setState(() => _add = _AddState.adding);
    await Future<void>.delayed(AppMotion.of(context, const Duration(milliseconds: 420)));
    await ref.read(cartProvider.notifier).add(item, quantity: _qty, size: _size);
    if (!mounted) return;
    setState(() => _add = _AddState.added);
    showToast(context, l10n.cartAddedToast(item.productName), icon: Icons.shopping_bag_outlined);
    await Future<void>.delayed(const Duration(milliseconds: 1400));
    if (mounted) setState(() => _add = _AddState.idle);
  }

  Future<void> _buyNow(CatalogueItem item) async {
    if (!_validateSize(item)) return;
    await ref.read(cartProvider.notifier).add(item, quantity: _qty, size: _size);
    if (!mounted) return;
    if (await ensureSignedIn(context, ref) && mounted) {
      unawaited(context.push(AppRoutes.checkout));
    }
  }

  Future<void> _share(CatalogueItem item) async {
    final l10n = AppL10n.of(context);
    final tenant = ref.read(tenantProvider).valueOrNull;
    final base = tenant?.storefrontUrl ?? '';
    final link = base.isEmpty ? '${item.productName} · ${item.itemCode}' : '$base/product/${item.id}';
    await Clipboard.setData(ClipboardData(text: link));
    if (mounted) showToast(context, l10n.productLinkCopied, icon: Icons.link_rounded);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final product = ref.watch(productProvider(widget.productId));
    return Scaffold(
      appBar: FinoHeader.page(title: product.valueOrNull?.productName ?? ''),
      body: product.when(
        loading: () => const _DetailSkeleton(),
        error: (_, __) => ErrorState(onRetry: () => ref.invalidate(productProvider(widget.productId))),
        data: (item) => item == null
            ? ErrorState(body: l10n.productNotFound)
            : _buildDetail(context, item),
      ),
    );
  }

  Widget _buildDetail(BuildContext context, CatalogueItem item) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final money = ref.watch(moneyFormatterProvider);
    final gutter = Breakpoints.gutter(context);
    final pad = EdgeInsets.symmetric(horizontal: gutter);
    final r = item.retail;
    final images = item.images.isEmpty ? [item.heroImage] : item.images;
    final reviews = ref.watch(productReviewsProvider(item.id));
    final related = ref.watch(relatedProductsProvider(item.id));
    final wide = !Breakpoints.isPhone(context);

    final gallery = _Gallery(
      images: images,
      index: _image,
      onIndex: (i) => setState(() => _image = i),
      item: item,
      onShare: () => _share(item),
    );

    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Eyebrow('${r.collection.isEmpty ? '' : '${r.collection} · '}${item.categoryName}'),
        const SizedBox(height: AppSpacing.xxs),
        Text(item.productName, style: text.displaySmall),
        const SizedBox(height: AppSpacing.xs),
        RatingStars(rating: r.rating, showValue: true, count: r.reviewCount, size: 16),
        const SizedBox(height: AppSpacing.sm),
        PriceText(item.price, original: r.originalPrice, discountPercent: r.discountPercent),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Icon(
              r.inStock ? Icons.check_circle_outline_rounded : Icons.remove_circle_outline_rounded,
              size: 16,
              color: r.inStock ? AppColors.success : AppColors.danger,
            ),
            const SizedBox(width: 6),
            Text(
              r.inStock ? l10n.productInStock : l10n.productSoldOut,
              style: text.bodySmall!.copyWith(color: r.inStock ? AppColors.success : AppColors.danger),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(r.description, style: text.bodyMedium!.copyWith(color: c.textSecondary)),
        if (_needsSize(item)) ...[
          const SizedBox(height: AppSpacing.lg),
          KeyedSubtree(
            key: _sizeKey,
            child: AnimatedBuilder(
              animation: _shake,
              builder: (context, child) {
                final t = _shake.value;
                final dx = t == 0 || t == 1 ? 0.0 : 6 * (1 - t) * ((t * 6).floor().isEven ? 1 : -1);
                return Transform.translate(offset: Offset(dx, 0), child: child);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Eyebrow(_sizeLabel(l10n, r.sizeKind))),
                      TextButton(
                        onPressed: () => context.push(AppRoutes.sizeGuidePath(r.sizeKind.name)),
                        child: Text(l10n.sizeGuideTitle),
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      for (final s in r.sizes)
                        AppChip(
                          label: s,
                          active: _size == s,
                          onTap: () => setState(() {
                            _size = s;
                            _sizeError = false;
                          }),
                        ),
                    ],
                  ),
                  AnimatedSize(
                    duration: AppMotion.of(context, AppMotion.fast),
                    child: _sizeError
                        ? Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.xs),
                            child: Text(
                              l10n.sizeRequired,
                              style: text.bodySmall!.copyWith(color: AppColors.danger),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(child: Eyebrow(l10n.productQuantity)),
            QuantityStepper(value: _qty, onChanged: (v) => setState(() => _qty = v)),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            for (final a in [
              (Icons.local_shipping_outlined, l10n.productDeliveryDays(r.deliveryDays)),
              (Icons.refresh_rounded, l10n.promiseReturns),
              if (r.certified) (Icons.verified_outlined, l10n.promiseCertified),
            ])
              Expanded(
                child: Column(
                  children: [
                    Icon(a.$1, color: c.accent, size: 22),
                    const SizedBox(height: 4),
                    Text(a.$2, style: text.labelSmall, textAlign: TextAlign.center),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        _SpecAccordion(
          rows: [
            (l10n.specMetal, item.metalName),
            (l10n.specPurity, item.purityName),
            (l10n.specWeight, l10n.specGrams(item.grossWeight.toStringAsFixed(2))),
            (l10n.specStone, r.stone == 'None' ? l10n.stoneNone : r.stone),
            if (r.collection.isNotEmpty) (l10n.specCollection, r.collection),
            (l10n.specSku, item.itemCode),
            if (item.hallmarkNumber != null) (l10n.specHallmark, item.hallmarkNumber!),
          ],
        ),
      ],
    );

    return Column(
      children: [
        Expanded(
          child: ContentWidth(
            child: ListView(
              padding: const EdgeInsets.only(bottom: AppSpacing.xl),
              children: [
                if (wide)
                  Padding(
                    padding: EdgeInsets.fromLTRB(gutter, AppSpacing.lg, gutter, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: AppRadius.circular(AppRadius.lg),
                            child: gallery,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xl),
                        Expanded(child: info),
                      ],
                    ),
                  )
                else ...[
                  gallery,
                  Padding(padding: pad.copyWith(top: AppSpacing.lg), child: info),
                ],
                const SizedBox(height: AppSpacing.xl),
                SectionHead(
                  eyebrow: l10n.homeReviewsEyebrow,
                  title: l10n.productReviews(r.reviewCount),
                  padding: pad,
                ),
                const SizedBox(height: AppSpacing.sm),
                Padding(
                  padding: pad,
                  child: reviews.when(
                    loading: () => const SkeletonLines(lines: 4),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (list) => list.isEmpty
                        ? Text(l10n.productNoReviews, style: text.bodySmall)
                        : Column(
                            children: [for (final rv in list) _ReviewRow(review: rv)],
                          ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                SectionHead(
                  eyebrow: l10n.productRelatedEyebrow,
                  title: l10n.productRelatedTitle,
                  padding: pad,
                ),
                const SizedBox(height: AppSpacing.md),
                related.when(
                  loading: () => RailSkeleton(gutter: gutter),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (items) => ProductRailView(items: items, gutter: gutter),
                ),
              ],
            ),
          ),
        ),
        // Sticky buy bar.
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.productTotal, style: text.labelSmall),
                    Text(money.format(item.price * _qty), style: text.titleLarge),
                  ],
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: OutlinedButton(
                    onPressed: r.inStock ? () => _addToBag(item) : null,
                    child: AnimatedSwitcher(
                      duration: AppMotion.of(context, AppMotion.fast),
                      child: switch (_add) {
                        _AddState.idle => Text(l10n.cartAddToBag, key: const ValueKey('i')),
                        _AddState.adding => const SizedBox(
                          key: ValueKey('a'),
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        _AddState.added => Row(
                          key: const ValueKey('d'),
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_rounded, size: 16, color: AppColors.success),
                            const SizedBox(width: 4),
                            Text(l10n.cartAdded),
                          ],
                        ),
                      },
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: FilledButton(
                    onPressed: r.inStock ? () => _buyNow(item) : null,
                    child: Text(l10n.productBuyNow),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static String _sizeLabel(AppL10n l10n, SizeKind kind) => switch (kind) {
    SizeKind.ring => l10n.sizeLabelRing,
    SizeKind.bangle => l10n.sizeLabelBangle,
    SizeKind.length => l10n.sizeLabelLength,
    SizeKind.none => '',
  };
}

class _Gallery extends StatelessWidget {
  const _Gallery({
    required this.images,
    required this.index,
    required this.onIndex,
    required this.item,
    required this.onShare,
  });

  final List images;
  final int index;
  final ValueChanged<int> onIndex;
  final CatalogueItem item;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final r = item.retail;
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Stack(
            fit: StackFit.expand,
            children: [
              GestureDetector(
                onHorizontalDragEnd: (d) {
                  if (images.length < 2) return;
                  final v = d.primaryVelocity ?? 0;
                  if (v < -200) onIndex((index + 1) % images.length);
                  if (v > 200) onIndex((index - 1 + images.length) % images.length);
                },
                child: AnimatedSwitcher(
                  duration: AppMotion.of(context, AppMotion.slow),
                  child: AppImage(images[index], key: ValueKey(index)),
                ),
              ),
              Positioned(
                top: AppSpacing.md,
                left: AppSpacing.md,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (r.isNew) AppBadge(l10n.badgeNew),
                    if (r.discountPercent != null && r.discountPercent! > 0) ...[
                      if (r.isNew) const SizedBox(height: 4),
                      AppBadge('-${r.discountPercent}%', tone: BadgeTone.sale),
                    ],
                  ],
                ),
              ),
              Positioned(
                top: AppSpacing.md,
                right: AppSpacing.md,
                child: Column(
                  children: [
                    HeartButton(productId: item.id, size: 40),
                    const SizedBox(height: AppSpacing.xs),
                    _BlurButton(icon: Icons.ios_share_rounded, tooltip: l10n.productShare, onTap: onShare),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (images.length > 1)
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(AppLayout.gutter, AppSpacing.sm, AppLayout.gutter, 0),
              itemCount: images.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
              itemBuilder: (context, i) => GestureDetector(
                onTap: () => onIndex(i),
                child: AnimatedContainer(
                  duration: AppMotion.of(context, AppMotion.fast),
                  width: 60,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.circular(AppRadius.sm),
                    border: Border.all(color: i == index ? c.primary : c.border, width: i == index ? 2 : 1),
                  ),
                  child: AppImage(images[i], borderRadius: AppRadius.circular(AppRadius.xs)),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _BlurButton extends StatelessWidget {
  const _BlurButton({required this.icon, required this.tooltip, required this.onTap});

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Material(
          color: Colors.white.withValues(alpha: context.colors.isDark ? .18 : .32),
          child: InkWell(
            onTap: onTap,
            child: SizedBox(width: 40, height: 40, child: Icon(icon, size: 20, color: Colors.white)),
          ),
        ),
      ),
    ),
  );
}

class _SpecAccordion extends StatefulWidget {
  const _SpecAccordion({required this.rows});

  final List<(String, String)> rows;

  @override
  State<_SpecAccordion> createState() => _SpecAccordionState();
}

class _SpecAccordionState extends State<_SpecAccordion> {
  bool _open = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: AppRadius.circular(AppRadius.md),
        border: Border.all(color: c.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _open = !_open),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Expanded(child: Text(l10n.productSpecifications, style: text.titleMedium)),
                  AnimatedRotation(
                    turns: _open ? .5 : 0,
                    duration: AppMotion.of(context, AppMotion.normal),
                    child: Icon(Icons.expand_more_rounded, color: c.textMuted),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: AppMotion.of(context, AppMotion.normal),
            curve: AppMotion.easeOut,
            alignment: Alignment.topCenter,
            child: !_open
                ? const SizedBox(width: double.infinity)
                : Column(
                    children: [
                      for (final row in widget.rows)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                          decoration: BoxDecoration(border: Border(top: BorderSide(color: c.border))),
                          child: Row(
                            children: [
                              Expanded(child: Text(row.$1, style: text.bodySmall)),
                              Text(row.$2, style: text.titleSmall),
                            ],
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _ReviewRow extends ConsumerWidget {
  const _ReviewRow({required this.review});

  final Review review;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final dates = ref.watch(dateFormatterProvider);
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: AppRadius.circular(AppRadius.md),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(child: AppImage(review.avatar, width: 32, height: 32)),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.author, style: text.titleSmall),
                    Text(dates.short(review.date), style: text.labelSmall),
                  ],
                ),
              ),
              if (review.verified)
                Row(
                  children: [
                    const Icon(Icons.verified_rounded, size: 14, color: AppColors.success),
                    const SizedBox(width: 3),
                    Text(l10n.reviewVerified, style: text.labelSmall),
                  ],
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          RatingStars(rating: review.rating),
          const SizedBox(height: AppSpacing.xs),
          Text(review.body, style: text.bodyMedium),
        ],
      ),
    );
  }
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) => ListView(
    children: const [
      AspectRatio(aspectRatio: 1, child: Skeleton(height: double.infinity, radius: 0)),
      Padding(
        padding: EdgeInsets.all(AppLayout.gutter),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Skeleton(width: 120, height: 10),
            SizedBox(height: AppSpacing.sm),
            Skeleton(width: 240, height: 24),
            SizedBox(height: AppSpacing.sm),
            Skeleton(width: 140, height: 14),
            SizedBox(height: AppSpacing.md),
            SkeletonLines(lines: 4),
          ],
        ),
      ),
    ],
  );
}

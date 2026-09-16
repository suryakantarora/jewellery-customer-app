import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/locale_provider.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/layout/responsive_grid.dart';
import '../../core/media/app_image.dart';
import '../../core/motion/motion.dart';
import '../../core/router/app_routes.dart';
import '../../core/tenant/tenant_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../data/models/banner.dart' as model;
import '../../data/models/catalogue_item.dart';
import '../../data/models/category.dart';
import '../../data/models/review.dart';
import '../../data/repository_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/eyebrow.dart';
import '../../shared/widgets/gold_rule.dart';
import '../../shared/widgets/press_scale.dart';
import '../../shared/widgets/product_card.dart';
import '../../shared/widgets/product_rail.dart';
import '../../shared/widgets/product_skeletons.dart';
import '../../shared/widgets/rating_stars.dart';
import '../../shared/widgets/scrim.dart';
import '../../shared/widgets/section_head.dart';
import '../../shared/widgets/skeleton.dart';
import '../../shared/widgets/staggered_reveal.dart';
import '../shell/fino_header.dart';
import 'hero_carousel.dart';

/// Home (survey: HomePage): hero carousel, category rail, featured rail,
/// new-arrivals grid, promo banner, trending rail, best-sellers grid,
/// reviews rail, brand promise.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final banners = ref.watch(bannersProvider);
    final categories = ref.watch(categoriesProvider);
    final featured = ref.watch(featuredProductsProvider);
    final newArrivals = ref.watch(newArrivalsProvider);
    final trending = ref.watch(trendingProductsProvider);
    final bestSellers = ref.watch(bestSellersProvider);
    final reviews = ref.watch(featuredReviewsProvider);
    final tenant = ref.watch(tenantProvider).valueOrNull;
    final gutter = Breakpoints.gutter(context);
    final pad = EdgeInsets.symmetric(horizontal: gutter);

    final failed = banners.hasError || categories.hasError;

    void retry() {
      ref
        ..invalidate(bannersProvider)
        ..invalidate(categoriesProvider)
        ..invalidate(featuredProductsProvider)
        ..invalidate(newArrivalsProvider)
        ..invalidate(trendingProductsProvider)
        ..invalidate(bestSellersProvider)
        ..invalidate(featuredReviewsProvider);
    }

    Widget rail(AsyncValue<List<CatalogueItem>> value) => value.when(
      loading: () => RailSkeleton(gutter: gutter),
      error: (_, __) => const SizedBox.shrink(),
      data: (items) => ProductRailView(items: items, gutter: gutter),
    );

    Widget grid(AsyncValue<List<CatalogueItem>> value, {int max = 4}) => Padding(
      padding: pad,
      child: value.when(
        loading: () => const ProductGridSkeleton(count: 4),
        error: (_, __) => const SizedBox.shrink(),
        data: (items) => ResponsiveGrid(
          itemCount: items.length.clamp(0, max),
          mainAxisExtentBuilder: ProductGrid.extent,
          itemBuilder: (context, i) =>
              StaggeredReveal(index: i, child: ProductCard(item: items[i])),
        ),
      ),
    );

    return Scaffold(
      appBar: const FinoHeader.brand(tinted: true),
      body: failed
          ? ErrorState(onRetry: retry)
          : ContentWidth(
              child: ListView(
                padding: const EdgeInsets.only(bottom: AppLayout.tabBarHeight + AppSpacing.lg),
                children: [
                  banners.when(
                    loading: () => const Skeleton(height: 320, radius: 0),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (list) => HeroCarousel(
                      banners: list
                          .where((b) => b.placement == model.BannerPlacement.hero)
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  SectionHead(
                    eyebrow: l10n.homeCollectionsEyebrow,
                    title: l10n.homeCollectionsTitle,
                    actionLabel: l10n.actionSeeAll,
                    onAction: () => context.go(AppRoutes.collections),
                    padding: pad,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 150,
                    child: categories.when(
                      loading: () => ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: pad,
                        itemCount: 4,
                        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                        itemBuilder: (_, __) =>
                            const Skeleton(width: 120, height: 150, radius: AppRadius.md),
                      ),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (list) => ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: pad,
                        itemCount: list.length,
                        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                        itemBuilder: (context, i) =>
                            StaggeredReveal(index: i, child: _CategoryTile(category: list[i])),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  SectionHead(
                    eyebrow: l10n.homeFeaturedEyebrow,
                    title: l10n.homeFeaturedTitle,
                    actionLabel: l10n.actionViewAll,
                    onAction: () => context.push(AppRoutes.categoryPath('all')),
                    padding: pad,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  rail(featured),
                  const SizedBox(height: AppSpacing.xl),
                  SectionHead(
                    eyebrow: l10n.homeNewEyebrow,
                    title: l10n.homeNewTitle,
                    subtitle: l10n.homeNewSubtitle,
                    padding: pad,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  grid(newArrivals),
                  const SizedBox(height: AppSpacing.xl),
                  banners.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (list) {
                      final promo = list
                          .where((b) => b.placement == model.BannerPlacement.promo)
                          .firstOrNull;
                      return promo == null
                          ? const SizedBox.shrink()
                          : Padding(padding: pad, child: _PromoBanner(banner: promo));
                    },
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  SectionHead(
                    eyebrow: l10n.homeTrendingEyebrow,
                    title: l10n.homeTrendingTitle,
                    padding: pad,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  rail(trending),
                  const SizedBox(height: AppSpacing.xl),
                  SectionHead(
                    eyebrow: l10n.homeBestEyebrow,
                    title: l10n.homeBestTitle,
                    padding: pad,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  grid(bestSellers),
                  if (tenant?.flag('reviews', orElse: true) ?? true) ...[
                    const SizedBox(height: AppSpacing.xl),
                    SectionHead(
                      eyebrow: l10n.homeReviewsEyebrow,
                      title: l10n.homeReviewsTitle,
                      padding: pad,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      height: 190,
                      child: reviews.when(
                        loading: () => ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: pad,
                          itemCount: 2,
                          separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                          itemBuilder: (_, __) =>
                              const Skeleton(width: 280, height: 190, radius: AppRadius.md),
                        ),
                        error: (_, __) => const SizedBox.shrink(),
                        data: (list) => ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: pad,
                          itemCount: list.length,
                          separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                          itemBuilder: (context, i) =>
                              StaggeredReveal(index: i, child: _ReviewCard(review: list[i])),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xxl),
                  Padding(
                    padding: pad,
                    child: Column(
                      children: [
                        Eyebrow(l10n.homePromiseEyebrow),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          l10n.homePromiseTitle(tenant?.brandName ?? ''),
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        const GoldRule(),
                        const SizedBox(height: AppSpacing.lg),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: AppSpacing.md,
                          runSpacing: AppSpacing.md,
                          children: [
                            for (final p in [
                              (Icons.verified_outlined, l10n.promiseCertified, l10n.promiseCertifiedSub),
                              (Icons.lock_outline_rounded, l10n.promiseSecure, l10n.promiseSecureSub),
                              (Icons.refresh_rounded, l10n.promiseReturns, l10n.promiseReturnsSub),
                              (Icons.card_giftcard_rounded, l10n.promisePackaging, l10n.promisePackagingSub),
                            ])
                              SizedBox(
                                width: 140,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: c.accentSoft,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(p.$1, color: c.accent, size: 22),
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      p.$2,
                                      style: Theme.of(context).textTheme.titleSmall,
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      p.$3,
                                      style: Theme.of(context).textTheme.bodySmall,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Padding(
                    padding: pad,
                    child: Text(
                      l10n.homeDemoNote,
                      style: Theme.of(context).textTheme.labelSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _CategoryTile extends ConsumerWidget {
  const _CategoryTile({required this.category});

  final Category category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final locale = ref.watch(localeProvider);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return PressScale(
      onTap: () => context.push(AppRoutes.categoryPath(category.id)),
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          borderRadius: AppRadius.circular(AppRadius.md),
          boxShadow: AppShadows.sm(c.shadow),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _SlowZoom(child: AppImage(category.image)),
            const Scrim(),
            Positioned(
              left: AppSpacing.sm,
              right: AppSpacing.sm,
              bottom: AppSpacing.sm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name.resolve(locale),
                    style: text.titleSmall!.copyWith(color: AppColors.bannerInk),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    l10n.piecesCount(category.productCount),
                    style: text.labelSmall!.copyWith(color: AppColors.bannerInkSoft),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// `u-zoom`: a 7 s slow scale to 1.06 and back.
class _SlowZoom extends StatefulWidget {
  const _SlowZoom({required this.child});

  final Widget child;

  @override
  State<_SlowZoom> createState() => _SlowZoomState();
}

class _SlowZoomState extends State<_SlowZoom> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 7),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!AppMotion.reduced(context) && !_c.isAnimating) _c.repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    builder: (context, child) =>
        Transform.scale(scale: 1 + .06 * _c.value, child: child),
    child: widget.child,
  );
}

class _PromoBanner extends ConsumerWidget {
  const _PromoBanner({required this.banner});

  final model.Banner banner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return PressScale(
      onTap: () => context.push(banner.link),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: AppRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.md(c.shadow),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AppImage(banner.image),
            const Scrim(begin: Alignment.centerRight, end: Alignment.centerLeft, stops: [0, 1], strength: 1.4),
            Positioned(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              top: 0,
              bottom: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Eyebrow(banner.eyebrow.resolve(locale)),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    banner.title.resolve(locale),
                    style: text.headlineLarge!.copyWith(color: AppColors.bannerInk),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    banner.subtitle.resolve(locale),
                    style: text.bodySmall!.copyWith(color: AppColors.bannerInkSoft),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    banner.cta.resolve(locale).toUpperCase(),
                    style: text.labelLarge!.copyWith(color: c.accent),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends ConsumerWidget {
  const _ReviewCard({required this.review});

  final Review review;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return Container(
      width: 280,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: AppRadius.circular(AppRadius.md),
        border: Border.all(color: c.border),
        boxShadow: AppShadows.sm(c.shadow),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RatingStars(rating: review.rating),
          const SizedBox(height: AppSpacing.xs),
          Expanded(
            child: Text(
              '“${review.body}”',
              style: text.bodyMedium!.copyWith(
                fontFamily: Theme.of(context).textTheme.headlineSmall!.fontFamily,
                fontStyle: FontStyle.italic,
                fontSize: AppType.md,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              ClipOval(child: AppImage(review.avatar, width: 28, height: 28)),
              const SizedBox(width: AppSpacing.xs),
              Expanded(child: Text(review.author, style: text.titleSmall)),
              if (review.verified)
                Row(
                  children: [
                    Icon(Icons.verified_rounded, size: 14, color: AppColors.success),
                    const SizedBox(width: 3),
                    Text(l10n.reviewVerified, style: text.labelSmall),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

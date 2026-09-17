import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format/formatters_provider.dart';
import '../../core/l10n/locale_provider.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/layout/responsive_grid.dart';
import '../../core/media/app_image.dart';
import '../../core/motion/motion.dart';
import '../../core/platform/launch.dart';
import '../../core/router/app_routes.dart';
import '../../core/tenant/tenant_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../data/models/banner.dart' as model;
import '../../data/models/catalogue_item.dart';
import '../../data/models/category.dart';
import '../../data/models/content.dart';
import '../../data/models/review.dart';
import '../../data/repository_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_art.dart';
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
import '../gold_rates/gold_rates_provider.dart';
import '../notifications/notifications_provider.dart';
import '../shell/fino_header.dart';
import 'hero_carousel.dart';
import 'home_providers.dart';

/// Home: rate ticker → search → promo strip → hero → What's trending →
/// Our brands → categories → curated for you → best sellers → promo banner
/// → Come visit us → About us → reviews → brand promise.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final banners = ref.watch(bannersProvider);
    final categories = ref.watch(categoriesProvider);
    final trendingCards = ref.watch(trendingCardsProvider);
    final brands = ref.watch(brandsProvider);
    final curated = ref.watch(curatedProductsProvider);
    final bestSellers = ref.watch(bestSellersProvider);
    final stores = ref.watch(storesProvider);
    final about = ref.watch(aboutProvider);
    final reviews = ref.watch(featuredReviewsProvider);
    final tenant = ref.watch(tenantProvider).valueOrNull;
    final gutter = Breakpoints.gutter(context);
    final pad = EdgeInsets.symmetric(horizontal: gutter);

    final failed = banners.hasError || categories.hasError;

    void retry() {
      ref
        ..invalidate(bannersProvider)
        ..invalidate(categoriesProvider)
        ..invalidate(trendingCardsProvider)
        ..invalidate(brandsProvider)
        ..invalidate(curatedProductsProvider)
        ..invalidate(bestSellersProvider)
        ..invalidate(storesProvider)
        ..invalidate(aboutProvider)
        ..invalidate(featuredReviewsProvider);
    }

    Widget rail(AsyncValue<List<CatalogueItem>> value) => value.when(
      loading: () => RailSkeleton(gutter: gutter),
      error: (_, __) => const SizedBox.shrink(),
      data: (items) => ProductRailView(items: items, gutter: gutter),
    );

    Widget grid(AsyncValue<List<CatalogueItem>> value, {int max = 4}) =>
        Padding(
          padding: pad,
          child: value.when(
            loading: () => const ProductGridSkeleton(count: 4),
            error: (_, __) => const SizedBox.shrink(),
            data: (items) => ResponsiveGrid(
              itemCount: items.length.clamp(0, max),
              mainAxisExtentBuilder: ProductGrid.extent,
              itemBuilder: (context, i) => StaggeredReveal(
                index: i,
                child: ProductCard(item: items[i]),
              ),
            ),
          ),
        );

    return Scaffold(
      appBar: const FinoHeader.brand(tinted: true),
      body: failed
          ? ErrorState(onRetry: retry)
          : ContentWidth(
              child: ListView(
                padding: const EdgeInsets.only(
                  bottom: AppLayout.tabBarHeight + AppSpacing.lg,
                ),
                children: [
                  const GoldRateDriftDriver(child: _RateTicker()),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      gutter,
                      AppSpacing.sm,
                      gutter,
                      AppSpacing.sm,
                    ),
                    child: const _SearchBar(),
                  ),
                  const _PromoStrip(),
                  banners.when(
                    loading: () => const Skeleton(height: 320, radius: 0),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (list) => HeroCarousel(
                      banners: list
                          .where(
                            (b) => b.placement == model.BannerPlacement.hero,
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  // --- What's trending ------------------------------------
                  _CentredTitle(l10n.homeTrendingTitle),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 300,
                    child: trendingCards.when(
                      loading: () => _RailSkeleton(
                        gutter: gutter,
                        width: 210,
                        height: 300,
                      ),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (cards) => ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: pad,
                        itemCount: cards.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: AppSpacing.sm),
                        itemBuilder: (context, i) => StaggeredReveal(
                          index: i,
                          child: _TrendingCard(card: cards[i]),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  // --- Our brands -----------------------------------------
                  _CentredTitle(l10n.homeBrandsTitle),
                  const SizedBox(height: AppSpacing.md),
                  Padding(
                    padding: pad,
                    child: brands.when(
                      loading: () =>
                          const Skeleton(height: 320, radius: AppRadius.md),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (list) => _BrandMosaic(brands: list),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  // --- Categories -----------------------------------------
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
                      loading: () => _RailSkeleton(
                        gutter: gutter,
                        width: 120,
                        height: 150,
                      ),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (list) => ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: pad,
                        itemCount: list.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: AppSpacing.sm),
                        itemBuilder: (context, i) => StaggeredReveal(
                          index: i,
                          child: _CategoryTile(category: list[i]),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  // --- Curated for you ------------------------------------
                  SectionHead(
                    eyebrow: l10n.homeCuratedEyebrow,
                    title: l10n.homeCuratedTitle,
                    subtitle: l10n.homeCuratedSubtitle,
                    actionLabel: l10n.actionViewAll,
                    onAction: () => context.push(AppRoutes.categoryPath('all')),
                    padding: pad,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  rail(curated),
                  const SizedBox(height: AppSpacing.xl),
                  // --- Best sellers ---------------------------------------
                  SectionHead(
                    eyebrow: l10n.homeBestEyebrow,
                    title: l10n.homeBestTitle,
                    padding: pad,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  grid(bestSellers),
                  const SizedBox(height: AppSpacing.xl),
                  banners.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (list) {
                      final promo = list
                          .where(
                            (b) => b.placement == model.BannerPlacement.promo,
                          )
                          .firstOrNull;
                      return promo == null
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: pad,
                              child: _PromoBanner(banner: promo),
                            );
                    },
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  // --- Come visit us --------------------------------------
                  _CentredTitle(
                    l10n.homeStoresTitle,
                    subtitle: l10n.homeStoresSubtitle,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 236,
                    child: stores.when(
                      loading: () => _RailSkeleton(
                        gutter: gutter,
                        width: 260,
                        height: 236,
                      ),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (list) => ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: pad,
                        itemCount: list.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: AppSpacing.sm),
                        itemBuilder: (context, i) => StaggeredReveal(
                          index: i,
                          child: _StoreCard(store: list[i]),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  // --- About us -------------------------------------------
                  Padding(
                    padding: pad,
                    child: about.when(
                      loading: () =>
                          const Skeleton(height: 260, radius: AppRadius.lg),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (a) =>
                          _AboutCard(about: a, brand: tenant?.brandName ?? ''),
                    ),
                  ),
                  if (tenant?.flag('reviews', orElse: true) ?? true) ...[
                    const SizedBox(height: AppSpacing.xxl),
                    SectionHead(
                      eyebrow: l10n.homeReviewsEyebrow,
                      title: l10n.homeReviewsTitle,
                      actionLabel: l10n.actionSeeAll,
                      onAction: () => context.push(AppRoutes.stories),
                      padding: pad,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      height: 190,
                      child: reviews.when(
                        loading: () => _RailSkeleton(
                          gutter: gutter,
                          width: 280,
                          height: 190,
                        ),
                        error: (_, __) => const SizedBox.shrink(),
                        data: (list) => ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: pad,
                          itemCount: list.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: AppSpacing.sm),
                          itemBuilder: (context, i) => StaggeredReveal(
                            index: i,
                            child: _ReviewCard(review: list[i]),
                          ),
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
                              (
                                Icons.verified_outlined,
                                l10n.promiseCertified,
                                l10n.promiseCertifiedSub,
                              ),
                              (
                                Icons.lock_outline_rounded,
                                l10n.promiseSecure,
                                l10n.promiseSecureSub,
                              ),
                              (
                                Icons.refresh_rounded,
                                l10n.promiseReturns,
                                l10n.promiseReturnsSub,
                              ),
                              (
                                Icons.card_giftcard_rounded,
                                l10n.promisePackaging,
                                l10n.promisePackagingSub,
                              ),
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
                                      child: Icon(
                                        p.$1,
                                        color: c.accent,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      p.$2,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleSmall,
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      p.$3,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
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

/// A centred display heading with a gold rule beneath, as in the reference
/// storefront's "What's trending" / "Our Brands".
class _CentredTitle extends StatelessWidget {
  const _CentredTitle(this.title, {this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          title,
          style: text.headlineLarge!.copyWith(
            color: context.colors.primaryDark,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),
        AppArt.flourish(color: context.colors.accent, size: 120),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Text(
              subtitle!,
              style: text.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }
}

class _RailSkeleton extends StatelessWidget {
  const _RailSkeleton({
    required this.gutter,
    required this.width,
    required this.height,
  });

  final double gutter;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) => ListView.separated(
    scrollDirection: Axis.horizontal,
    padding: EdgeInsets.symmetric(horizontal: gutter),
    itemCount: 3,
    separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
    itemBuilder: (_, __) =>
        Skeleton(width: width, height: height, radius: AppRadius.md),
  );
}

/// The live gold-rate strip under the header: "GOLD 22K / 1 g · ₭ 961,000"
/// with a delta arrow, a stores shortcut and the notification bell.
class _RateTicker extends ConsumerWidget {
  const _RateTicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final money = ref.watch(moneyFormatterProvider);
    final rate = ref.watch(headlineGoldRateProvider);
    final unread = ref.watch(unreadNotificationsProvider);
    final lak = rate?['LAK'];
    final up = (rate?.delta ?? 0) >= 0;

    return Material(
      color: c.surface2,
      child: InkWell(
        onTap: () => context.push(AppRoutes.goldRates),
        child: Container(
          height: 40,
          padding: const EdgeInsets.only(left: AppLayout.gutter, right: 4),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: c.border)),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: c.accent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: rate == null
                    ? const Skeleton(height: 12, width: 160)
                    : AnimatedSwitcher(
                        duration: AppMotion.of(context, AppMotion.normal),
                        child: FittedBox(
                          key: ValueKey(lak),
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                l10n.homeRateTicker(rate.label),
                                style: text.labelMedium!.copyWith(
                                  color: c.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                money.format(lak ?? 0),
                                style: text.titleSmall!.copyWith(
                                  color: c.primaryDark,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                up
                                    ? Icons.arrow_drop_up_rounded
                                    : Icons.arrow_drop_down_rounded,
                                size: 20,
                                color: up
                                    ? AppColors.success
                                    : AppColors.danger,
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              IconButton(
                tooltip: l10n.drawerStores,
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  Icons.storefront_outlined,
                  size: 20,
                  color: c.textSecondary,
                ),
                onPressed: () => context.push(AppRoutes.stores),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    tooltip: l10n.drawerNotifications,
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      Icons.notifications_none_rounded,
                      size: 20,
                      color: c.textSecondary,
                    ),
                    onPressed: () => context.push(AppRoutes.notifications),
                  ),
                  if (unread > 0)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: c.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A search field look-alike that opens the search screen.
class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    return Semantics(
      button: true,
      label: l10n.actionSearch,
      child: PressScale(
        onTap: () => context.push(AppRoutes.search),
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          decoration: BoxDecoration(
            color: c.surface2,
            borderRadius: AppRadius.circular(AppRadius.sm),
            border: Border.all(color: c.border),
          ),
          child: Row(
            children: [
              Icon(Icons.search_rounded, size: 20, color: c.textMuted),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  l10n.homeSearchHint,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(color: c.textMuted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The featured offer as a full-width strip in the primary colour.
class _PromoStrip extends ConsumerWidget {
  const _PromoStrip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final locale = ref.watch(localeProvider);
    final offer = ref
        .watch(offersProvider)
        .valueOrNull
        ?.where((o) => o.featured)
        .firstOrNull;
    if (offer == null) return const SizedBox.shrink();
    return Material(
      color: c.primaryDark,
      child: InkWell(
        onTap: () => context.push(AppRoutes.offers),
        child: Container(
          height: 36,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: AppLayout.gutter),
          child: Text(
            '${offer.subtitle.resolve(locale)} · ${offer.code}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

/// A tall editorial card: photo, large headline ("18 KT"), subline, and a
/// gold "View collection" button.
class _TrendingCard extends ConsumerWidget {
  const _TrendingCard({required this.card});

  final TrendingCard card;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final locale = ref.watch(localeProvider);
    return PressScale(
      onTap: () => context.push(card.link),
      child: Container(
        width: 210,
        decoration: BoxDecoration(
          borderRadius: AppRadius.circular(AppRadius.md),
          boxShadow: AppShadows.md(c.shadow),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            RepaintBoundary(child: _SlowZoom(child: AppImage(card.image))),
            const Scrim(stops: [.3, 1], strength: 1.35),
            Positioned(
              left: AppSpacing.md,
              right: AppSpacing.md,
              bottom: AppSpacing.md,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    card.headline.resolve(locale),
                    textAlign: TextAlign.center,
                    style: text.displayMedium!.copyWith(color: c.accent),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    card.subline.resolve(locale),
                    textAlign: TextAlign.center,
                    style: text.titleSmall!.copyWith(color: AppColors.photoInk),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: c.accent,
                      borderRadius: AppRadius.circular(AppRadius.xs),
                    ),
                    child: Text(
                      l10n.actionViewCollection.toUpperCase(),
                      style: text.labelSmall!.copyWith(
                        color: const Color(0xFF1C1416),
                        fontWeight: FontWeight.w700,
                        letterSpacing: AppType.tracking(
                          AppType.xxs,
                          AppType.trackWider,
                        ),
                      ),
                    ),
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

/// Two-column mosaic of brand cards; the first (tall) brand spans the full
/// height of the left column.
class _BrandMosaic extends StatelessWidget {
  const _BrandMosaic({required this.brands});

  final List<Brand> brands;

  @override
  Widget build(BuildContext context) {
    if (brands.isEmpty) return const SizedBox.shrink();
    final tall = brands.where((b) => b.tall).firstOrNull ?? brands.first;
    final rest = brands.where((b) => b != tall).toList();
    final wide = !Breakpoints.isPhone(context);
    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (i, b) in brands.indexed) ...[
            if (i > 0) const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: SizedBox(
                height: 240,
                child: _BrandCard(brand: b, index: i),
              ),
            ),
          ],
        ],
      );
    }
    return SizedBox(
      height: 336,
      child: Row(
        children: [
          Expanded(child: _BrandCard(brand: tall, index: 0)),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              children: [
                for (final (i, b) in rest.take(2).indexed) ...[
                  if (i > 0) const SizedBox(height: AppSpacing.sm),
                  Expanded(
                    child: _BrandCard(brand: b, index: i + 1),
                  ),
                ],
                if (rest.length > 2) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Expanded(child: _BrandCard(brand: rest[2], index: 3)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandCard extends ConsumerWidget {
  const _BrandCard({required this.brand, required this.index});

  final Brand brand;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final locale = ref.watch(localeProvider);
    return StaggeredReveal(
      index: index,
      child: PressScale(
        onTap: () =>
            context.push(AppRoutes.categoryPath('all', brand: brand.id)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: AppRadius.circular(AppRadius.md),
            border: Border.all(color: c.border),
            boxShadow: AppShadows.sm(c.shadow),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AppImage(brand.image),
              const Scrim(stops: [.4, 1], strength: 1.2),
              Positioned(
                left: AppSpacing.sm,
                right: AppSpacing.sm,
                bottom: AppSpacing.sm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      brand.name,
                      style: text.headlineSmall!.copyWith(
                        color: AppColors.photoInk,
                        fontStyle: FontStyle.italic,
                        height: 1.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      brand.tagline.resolve(locale),
                      style: text.labelSmall!.copyWith(color: c.accent),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
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
            RepaintBoundary(child: _SlowZoom(child: AppImage(category.image))),
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
                    style: text.titleSmall!.copyWith(color: AppColors.photoInk),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    l10n.piecesCount(category.productCount),
                    style: text.labelSmall!.copyWith(
                      color: AppColors.photoInkSoft,
                    ),
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

class _SlowZoomState extends State<_SlowZoom>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 7),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!AppMotion.reduced(context) && !_c.isAnimating) {
      _c.repeat(reverse: true);
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
            const Scrim(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              stops: [0, 1],
              strength: 1.4,
            ),
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
                    style: text.headlineLarge!.copyWith(
                      color: AppColors.photoInk,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    banner.subtitle.resolve(locale),
                    style: text.bodySmall!.copyWith(
                      color: AppColors.photoInkSoft,
                    ),
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

/// A boutique card: photo, name, city, hours and a Directions button.
class _StoreCard extends StatelessWidget {
  const _StoreCard({required this.store});

  final Store store;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return PressScale(
      onTap: () => context.push(AppRoutes.storePath(store.id)),
      child: Container(
        width: 260,
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
            SizedBox(
              height: 120,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AppImage(store.image),
                  if (store.flagship)
                    Positioned(
                      top: AppSpacing.xs,
                      left: AppSpacing.xs,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: c.accent,
                          borderRadius: AppRadius.circular(AppRadius.pill),
                        ),
                        child: Text(
                          l10n.storeFlagship.toUpperCase(),
                          style: text.labelSmall!.copyWith(
                            color: const Color(0xFF1C1416),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.name,
                      style: text.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(store.city, style: text.labelSmall, maxLines: 1),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 14,
                          color: c.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            store.hours,
                            style: text.labelSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          onPressed: () => Launch.maps(
                            store.latitude,
                            store.longitude,
                            label: store.name,
                          ),
                          icon: const Icon(Icons.directions_outlined, size: 16),
                          label: Text(l10n.storeDirections),
                        ),
                      ],
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

/// "About us" teaser: hero photo, the intro paragraph, stat chips and a
/// link to the full story.
class _AboutCard extends StatelessWidget {
  const _AboutCard({required this.about, required this.brand});

  final AboutContent about;
  final String brand;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: AppRadius.circular(AppRadius.lg),
        border: Border.all(color: c.border),
        boxShadow: AppShadows.sm(c.shadow),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                AppImage(about.hero),
                const Scrim(stops: [.2, 1], strength: 1.3),
                Positioned(
                  left: AppSpacing.md,
                  bottom: AppSpacing.sm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Eyebrow(l10n.homeAboutEyebrow, color: c.accent),
                      Text(
                        l10n.homeAboutTitle(brand),
                        style: text.headlineMedium!.copyWith(
                          color: AppColors.photoInk,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(about.intro, style: text.bodyMedium),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.xs,
                  children: [
                    for (final s in about.stats)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.value,
                            style: text.headlineSmall!.copyWith(
                              color: c.primaryDark,
                            ),
                          ),
                          Text(s.label.toUpperCase(), style: text.labelSmall),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => context.push(AppRoutes.about),
                    icon: Text(l10n.homeAboutCta),
                    label: const Icon(Icons.arrow_forward_rounded, size: 16),
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
                fontFamily: Theme.of(
                  context,
                ).textTheme.headlineSmall!.fontFamily,
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
                    Icon(
                      Icons.verified_rounded,
                      size: 14,
                      color: AppColors.success,
                    ),
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

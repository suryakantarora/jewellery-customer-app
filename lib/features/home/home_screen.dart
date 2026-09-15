import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/locale_provider.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/layout/responsive_grid.dart';
import '../../core/media/app_image.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../data/models/banner.dart' as model;
import '../../data/models/category.dart';
import '../../data/repository_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_badge.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/eyebrow.dart';
import '../../shared/widgets/press_scale.dart';
import '../../shared/widgets/section_head.dart';
import '../../shared/widgets/skeleton.dart';
import '../../shared/widgets/staggered_reveal.dart';
import '../shell/fino_header.dart';

/// C1 placeholder for Home: proves the skeleton → content pipeline with the
/// five banners and eight categories from the active repository.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final banners = ref.watch(bannersProvider);
    final categories = ref.watch(categoriesProvider);
    final gutter = Breakpoints.gutter(context);

    final failed = banners.hasError || categories.hasError;

    return Scaffold(
      appBar: const FinoHeader.brand(tinted: true),
      body: failed
          ? ErrorState(
              onRetry: () {
                ref.invalidate(bannersProvider);
                ref.invalidate(categoriesProvider);
              },
            )
          : ContentWidth(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                children: [
                  SectionHead(
                    eyebrow: l10n.homeStoriesEyebrow,
                    title: l10n.homeStoriesTitle,
                    padding: EdgeInsets.symmetric(horizontal: gutter),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 180,
                    child: banners.when(
                      loading: () => _BannerRailSkeleton(gutter: gutter),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (list) => ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: gutter),
                        itemCount: list.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: AppSpacing.sm),
                        itemBuilder: (context, i) => StaggeredReveal(
                          index: i,
                          child: _BannerCard(banner: list[i]),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  SectionHead(
                    eyebrow: l10n.homeCollectionsEyebrow,
                    title: l10n.homeCollectionsTitle,
                    subtitle: l10n.homeCollectionsSubtitle,
                    actionLabel: l10n.actionSeeAll,
                    onAction: () => context.go(AppRoutes.collections),
                    padding: EdgeInsets.symmetric(horizontal: gutter),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: gutter),
                    child: categories.when(
                      loading: () => ResponsiveGrid(
                        itemCount: 8,
                        childAspectRatio: 1.1,
                        itemBuilder: (_, __) => const Skeleton(
                          height: double.infinity,
                          radius: AppRadius.md,
                        ),
                      ),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (list) => ResponsiveGrid(
                        itemCount: list.length,
                        childAspectRatio: 1.1,
                        itemBuilder: (context, i) => StaggeredReveal(
                          index: i,
                          child: _CategoryTile(category: list[i]),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: gutter),
                    child: Text(
                      l10n.homeDemoNote,
                      style: Theme.of(context).textTheme.labelSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: AppLayout.tabBarHeight),
                ],
              ),
            ),
    );
  }
}

class _BannerRailSkeleton extends StatelessWidget {
  const _BannerRailSkeleton({required this.gutter});

  final double gutter;

  @override
  Widget build(BuildContext context) => ListView.separated(
    scrollDirection: Axis.horizontal,
    padding: EdgeInsets.symmetric(horizontal: gutter),
    itemCount: 3,
    separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
    itemBuilder: (_, __) =>
        const Skeleton(width: 280, height: 180, radius: AppRadius.lg),
  );
}

class _BannerCard extends ConsumerWidget {
  const _BannerCard({required this.banner});

  final model.Banner banner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return PressScale(
      onTap: () {},
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          borderRadius: AppRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.md(c.shadow),
        ),
        child: ClipRRect(
          borderRadius: AppRadius.circular(AppRadius.lg),
          child: Stack(
            fit: StackFit.expand,
            children: [
              AppImage(banner.image),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [.2, 1],
                    colors: [Colors.transparent, c.scrim],
                  ),
                ),
              ),
              Positioned(
                left: AppSpacing.md,
                right: AppSpacing.md,
                bottom: AppSpacing.md,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Eyebrow(banner.eyebrow.resolve(locale)),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      banner.title.resolve(locale),
                      style: text.headlineMedium!.copyWith(
                        color: AppColors.bannerInk,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (banner.placement == model.BannerPlacement.promo)
                const Positioned(
                  top: AppSpacing.sm,
                  left: AppSpacing.sm,
                  child: AppBadge('Promo', tone: BadgeTone.accent),
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
            Expanded(child: AppImage(category.image, width: double.infinity)),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name.resolve(locale),
                    style: text.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    l10n.piecesCount(category.productCount),
                    style: text.labelSmall,
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

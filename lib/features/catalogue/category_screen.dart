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
import '../../data/repositories/repositories.dart';
import '../../data/repository_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_chip.dart';
import '../../shared/widgets/badge_count.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/eyebrow.dart';
import '../../shared/widgets/product_card.dart';
import '../../shared/widgets/product_skeletons.dart';
import '../../shared/widgets/scrim.dart';
import '../../shared/widgets/skeleton.dart';
import '../../shared/widgets/staggered_reveal.dart';
import '../shell/fino_header.dart';
import 'filter_sheet.dart';

/// Category listing (survey: CategoryPage): banner (not for `all`), sort
/// chip rail + filter button with badge, count, responsive grid, filter
/// sheet, empty state.
class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key, required this.categoryId, this.audience});

  final String categoryId;
  final String? audience;

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  late CatalogueQuery _query = CatalogueQuery(
    categoryId: widget.categoryId,
    audience: widget.audience,
  );

  bool get _isAll => widget.categoryId == 'all';

  Future<void> _openFilter() async {
    final bounds = await ref.read(
      priceBoundsProvider('${widget.categoryId}|${widget.audience ?? ''}').future,
    );
    if (!mounted) return;
    final next = await showFilterSheet(context, query: _query, bounds: bounds);
    if (next != null && mounted) setState(() => _query = next);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final locale = ref.watch(localeProvider);
    final gutter = Breakpoints.gutter(context);
    final category = _isAll ? null : ref.watch(categoryProvider(widget.categoryId));
    final items = ref.watch(catalogueListProvider(_query));

    final title = _isAll
        ? (widget.audience == null ? l10n.collectionsAll : _audienceLabel(l10n, widget.audience!))
        : category?.valueOrNull?.name.resolve(locale) ?? '';

    final sorts = [
      (CatalogueSort.featured, l10n.sortFeatured),
      (CatalogueSort.newest, l10n.sortNewest),
      (CatalogueSort.priceAsc, l10n.sortPriceAsc),
      (CatalogueSort.priceDesc, l10n.sortPriceDesc),
      (CatalogueSort.rating, l10n.sortRating),
    ];

    return Scaffold(
      appBar: FinoHeader.page(title: title),
      body: ContentWidth(
        child: CustomScrollView(
          slivers: [
            if (category != null)
              SliverToBoxAdapter(
                child: category.when(
                  loading: () => const Skeleton(height: 160, radius: 0),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (cat) => cat == null
                      ? const SizedBox.shrink()
                      : SizedBox(
                          height: 160,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              AppImage(cat.image),
                              const Scrim(stops: [0, 1], strength: 1.3),
                              Positioned(
                                left: gutter,
                                right: gutter,
                                bottom: AppSpacing.md,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Eyebrow(l10n.collectionsEyebrow),
                                    Text(
                                      cat.name.resolve(locale),
                                      style: text.displaySmall!.copyWith(color: AppColors.bannerInk),
                                    ),
                                    Text(
                                      cat.description.resolve(locale),
                                      style: text.bodySmall!.copyWith(color: AppColors.bannerInkSoft),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _ControlsDelegate(
                height: 60,
                child: Container(
                  color: c.bg,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(left: gutter),
                          itemCount: sorts.length,
                          separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
                          itemBuilder: (_, i) => Center(
                            child: AppChip(
                              label: sorts[i].$2,
                              active: _query.sort == sorts[i].$1,
                              onTap: () => setState(() => _query = _query.copyWith(sort: sorts[i].$1)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: gutter),
                        child: BadgeCount(
                          count: _query.activeFacetCount,
                          child: AppChip(
                            label: l10n.filterButton,
                            leading: const Icon(Icons.tune_rounded),
                            active: _query.activeFacetCount > 0,
                            onTap: _openFilter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(gutter, AppSpacing.xs, gutter, AppLayout.tabBarHeight),
              sliver: items.when(
                loading: () => const SliverToBoxAdapter(child: ProductGridSkeleton()),
                error: (_, __) => SliverFillRemaining(
                  hasScrollBody: false,
                  child: ErrorState(onRetry: () => ref.invalidate(catalogueListProvider(_query))),
                ),
                data: (list) => list.isEmpty
                    ? SliverFillRemaining(
                        hasScrollBody: false,
                        child: EmptyState(
                          icon: Icons.filter_alt_off_outlined,
                          title: l10n.categoryEmptyTitle,
                          body: l10n.categoryEmptyBody,
                          primaryLabel: l10n.filterClearAll,
                          onPrimary: () => setState(() => _query = _query.cleared()),
                          secondaryLabel: l10n.actionContinueShopping,
                          onSecondary: () => context.go(AppRoutes.home),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildListDelegate([
                          Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: Text(l10n.searchResultCount(list.length), style: text.labelSmall),
                          ),
                          ResponsiveGrid(
                            itemCount: list.length,
                            mainAxisExtentBuilder: ProductGrid.extent,
                            itemBuilder: (context, i) =>
                                StaggeredReveal(index: i, child: ProductCard(item: list[i])),
                          ),
                        ]),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _audienceLabel(AppL10n l10n, String audience) => switch (audience) {
    'women' => l10n.audienceWomen,
    'men' => l10n.audienceMen,
    'kids' => l10n.audienceKids,
    _ => l10n.collectionsAll,
  };
}

class _ControlsDelegate extends SliverPersistentHeaderDelegate {
  const _ControlsDelegate({required this.child, required this.height});

  final Widget child;
  final double height;

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => child;

  @override
  bool shouldRebuild(_ControlsDelegate old) => old.child != child;
}

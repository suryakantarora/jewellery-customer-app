import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/layout/breakpoints.dart';
import '../../core/layout/responsive_grid.dart';
import '../../core/media/image_ref.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/tokens.dart';
import '../../data/models/retail_attributes.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_chip.dart';
import '../../shared/widgets/app_toast.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/product_card.dart';
import '../../shared/widgets/product_skeletons.dart';
import '../../shared/widgets/staggered_reveal.dart';
import '../cart/cart_provider.dart';
import '../shell/fino_header.dart';
import 'wishlist_provider.dart';

/// Wishlist (survey: WishlistPage): count + "Move all to bag", grid, empty.
class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final text = Theme.of(context).textTheme;
    final gutter = Breakpoints.gutter(context);
    final products = ref.watch(wishlistProductsProvider);

    Future<void> moveAll() async {
      final items = products.valueOrNull ?? const [];
      var moved = 0;
      for (final p in items) {
        // Sized pieces need a size; only unsized ones can be moved blind.
        if (p.retail.sizeKind != SizeKind.none || !p.retail.inStock) continue;
        await ref.read(cartProvider.notifier).add(p);
        await ref.read(wishlistProvider.notifier).remove(p.id);
        moved++;
      }
      if (!context.mounted) return;
      showToast(
        context,
        moved == items.length ? l10n.wishlistMovedAll : l10n.wishlistMovedSome(moved),
        icon: Icons.shopping_bag_outlined,
      );
    }

    return Scaffold(
      appBar: FinoHeader.page(title: l10n.wishlistTitle),
      body: ContentWidth(
        child: products.when(
          loading: () => Padding(
            padding: EdgeInsets.all(gutter),
            child: const ProductGridSkeleton(count: 4),
          ),
          error: (_, __) => ErrorState(onRetry: () => ref.invalidate(wishlistProductsProvider)),
          data: (list) => list.isEmpty
              ? EmptyState(
                  image: const ImageRef.asset('images/ui/nodata.png'),
                  title: l10n.wishlistEmptyTitle,
                  body: l10n.wishlistEmptyBody,
                  primaryLabel: l10n.actionContinueShopping,
                  onPrimary: () => context.go(AppRoutes.home),
                )
              : ListView(
                  padding: EdgeInsets.fromLTRB(gutter, AppSpacing.md, gutter, AppSpacing.xl),
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(l10n.wishlistCount(list.length), style: text.titleMedium)),
                        AppChip(
                          label: l10n.wishlistMoveAll,
                          leading: const Icon(Icons.shopping_bag_outlined),
                          onTap: moveAll,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ResponsiveGrid(
                      itemCount: list.length,
                      mainAxisExtentBuilder: ProductGrid.extent,
                      itemBuilder: (context, i) =>
                          StaggeredReveal(index: i, child: ProductCard(item: list[i])),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

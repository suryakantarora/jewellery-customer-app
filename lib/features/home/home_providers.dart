import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/catalogue_item.dart';
import '../../data/repositories/repositories.dart';
import '../../data/repository_providers.dart';
import '../cart/cart_provider.dart';
import '../wishlist/wishlist_provider.dart';

/// "Latest collection curated for you": pieces from the collections and
/// brands the customer has wished for or bagged, newest first; the featured
/// edit until there is enough signal.
final curatedProductsProvider = FutureProvider.autoDispose<List<CatalogueItem>>(
  (ref) async {
    final repo = ref.watch(catalogueRepositoryProvider);
    final wished = ref.watch(wishlistProvider).valueOrNull ?? const [];
    final bagged = ref.watch(cartProvider).valueOrNull ?? const [];
    final seedIds = {
      ...wished.map((w) => w.productId),
      ...bagged.map((l) => l.product.id),
    };
    if (seedIds.isEmpty) return repo.newArrivals();
    final seeds = await repo.byIds(seedIds.toList());
    final collections = seeds.map((s) => s.retail.collection).toSet();
    final brands = seeds.map((s) => s.retail.brand).toSet();
    final all = await repo.list(
      const CatalogueQuery(sort: CatalogueSort.newest),
    );
    final picks = all
        .where((i) => !seedIds.contains(i.id))
        .where(
          (i) =>
              collections.contains(i.retail.collection) ||
              brands.contains(i.retail.brand),
        )
        .take(10)
        .toList();
    return picks.length >= 4 ? picks : repo.newArrivals();
  },
);

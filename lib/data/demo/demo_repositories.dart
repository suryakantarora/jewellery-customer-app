import '../models/banner.dart';
import '../models/catalogue_item.dart';
import '../models/category.dart';
import '../models/commerce.dart';
import '../models/retail_attributes.dart';
import '../models/review.dart';
import '../repositories/repositories.dart';
import 'demo_store.dart';

class DemoCatalogueRepository implements CatalogueRepository {
  const DemoCatalogueRepository(this._store);

  final DemoStore _store;

  @override
  Future<List<CatalogueItem>> list([
    CatalogueQuery query = const CatalogueQuery(),
  ]) => _store.read((d) {
    var items = d.items.where((i) {
      final r = i.retail;
      if (query.categoryId != null &&
          query.categoryId != 'all' &&
          i.categoryId != query.categoryId) {
        return false;
      }
      if (query.audience != null &&
          r.audience.name != query.audience!.toLowerCase() &&
          r.audience != Audience.unisex) {
        return false;
      }
      if (query.metals.isNotEmpty && !query.metals.contains(i.metalName)) {
        return false;
      }
      if (query.purities.isNotEmpty && !query.purities.contains(i.purityCode)) {
        return false;
      }
      if (query.stones.isNotEmpty && !query.stones.contains(r.stone)) {
        return false;
      }
      if (query.minPrice != null && i.price < query.minPrice!) return false;
      if (query.maxPrice != null && i.price > query.maxPrice!) return false;
      if (query.minRating != null && r.rating < query.minRating!) return false;
      if (query.inStockOnly && !r.inStock) return false;
      final term = query.search?.trim().toLowerCase();
      if (term != null && term.isNotEmpty) {
        final hay = [
          i.productName,
          i.categoryName,
          i.metalName,
          i.purityName,
          r.stone,
          r.collection,
          r.audience.name,
        ].join(' ').toLowerCase();
        if (!hay.contains(term)) return false;
      }
      return true;
    }).toList();

    int byFeatured(CatalogueItem a, CatalogueItem b) {
      final fa = a.retail.isFeatured ? 0 : 1;
      final fb = b.retail.isFeatured ? 0 : 1;
      return fa != fb ? fa - fb : b.retail.rating.compareTo(a.retail.rating);
    }

    items = switch (query.sort) {
      CatalogueSort.featured => (items..sort(byFeatured)),
      CatalogueSort.newest => (items
        ..sort((a, b) => (b.retail.isNew ? 1 : 0) - (a.retail.isNew ? 1 : 0))),
      CatalogueSort.priceAsc => (items..sort((a, b) => a.price.compareTo(b.price))),
      CatalogueSort.priceDesc => (items..sort((a, b) => b.price.compareTo(a.price))),
      CatalogueSort.rating => (items
        ..sort((a, b) => b.retail.rating.compareTo(a.retail.rating))),
    };
    return items;
  });

  @override
  Future<CatalogueItem?> byId(String id) =>
      _store.read((d) => d.items.where((i) => i.id == id).firstOrNull);

  @override
  Future<List<CatalogueItem>> featured() =>
      _store.read((d) => d.items.where((i) => i.retail.isFeatured).toList());

  @override
  Future<List<CatalogueItem>> newArrivals() =>
      _store.read((d) => d.items.where((i) => i.retail.isNew).toList());

  @override
  Future<List<CatalogueItem>> trending() =>
      _store.read((d) => d.items.where((i) => i.retail.isTrending).toList());

  @override
  Future<List<CatalogueItem>> bestSellers() =>
      _store.read((d) => d.items.where((i) => i.retail.isBestSeller).toList());

  /// Affinity-scored like the reference: category 4, collection 3, stone 2,
  /// metal 1.
  @override
  Future<List<CatalogueItem>> related(String id, {int limit = 8}) =>
      _store.read((d) {
        final base = d.items.where((i) => i.id == id).firstOrNull;
        if (base == null) return const [];
        int score(CatalogueItem o) =>
            (o.categoryId == base.categoryId ? 4 : 0) +
            (o.retail.collection == base.retail.collection ? 3 : 0) +
            (o.retail.stone == base.retail.stone ? 2 : 0) +
            (o.metalName == base.metalName ? 1 : 0);
        final others = d.items.where((i) => i.id != id).toList()
          ..sort((a, b) => score(b).compareTo(score(a)));
        return others.take(limit).toList();
      });
}

class DemoCategoryRepository implements CategoryRepository {
  const DemoCategoryRepository(this._store);

  final DemoStore _store;

  @override
  Future<List<Category>> list() => _store.read((d) {
    // Counts are derived from the catalogue so the two never disagree.
    return d.categories
        .map(
          (c) => Category(
            id: c.id,
            name: c.name,
            description: c.description,
            image: c.image,
            icon: c.icon,
            productCount: d.items.where((i) => i.categoryId == c.id).length,
            featured: c.featured,
          ),
        )
        .toList();
  });

  @override
  Future<Category?> byId(String id) async =>
      (await list()).where((c) => c.id == id).firstOrNull;
}

class DemoBannerRepository implements BannerRepository {
  const DemoBannerRepository(this._store);

  final DemoStore _store;

  @override
  Future<List<Banner>> list() => _store.read((d) => d.banners);
}

class DemoReviewRepository implements ReviewRepository {
  const DemoReviewRepository(this._store);

  final DemoStore _store;

  @override
  Future<List<Review>> forProduct(String productId) =>
      _store.read((d) => d.reviews.where((r) => r.productId == productId).toList());

  @override
  Future<List<Review>> featured() => _store.read((d) => d.reviews);
}

// --- TODO(C5–C7): demo stubs, return empty until their phase lands. ----------

class DemoCartRepository implements CartRepository {
  const DemoCartRepository();
  @override
  Future<List<CartItem>> items() async => const [];
  @override
  Future<void> add(CartItem item) async {}
  @override
  Future<void> remove(String productId, {String? size}) async {}
  @override
  Future<void> clear() async {}
}

class DemoWishlistRepository implements WishlistRepository {
  const DemoWishlistRepository();
  @override
  Future<List<WishlistItem>> items() async => const [];
  @override
  Future<void> toggle(String productId) async {}
}

class DemoOrderRepository implements OrderRepository {
  const DemoOrderRepository();
  @override
  Future<List<Order>> list() async => const [];
  @override
  Future<Order?> byId(String id) async => null;
}

class DemoAccountRepository implements AccountRepository {
  const DemoAccountRepository();
  @override
  Future<Account?> current() async => null;
}

class DemoAddressRepository implements AddressRepository {
  const DemoAddressRepository();
  @override
  Future<List<Address>> list() async => const [];
}

class DemoGoldRateRepository implements GoldRateRepository {
  const DemoGoldRateRepository();
  @override
  Future<List<GoldRate>> current() async => const [];
}

class DemoPolicyRepository implements PolicyRepository {
  const DemoPolicyRepository();
  @override
  Future<List<PolicyDoc>> list() async => const [];
  @override
  Future<PolicyDoc?> byKey(String key) async => null;
}

import '../models/banner.dart';
import '../models/catalogue_item.dart';
import '../models/category.dart';
import '../models/commerce.dart';
import '../models/review.dart';

/// Query for a catalogue listing (sort + facets), mirrors the Ionic filter.
class CatalogueQuery {
  const CatalogueQuery({
    this.categoryId,
    this.audience,
    this.metals = const [],
    this.purities = const [],
    this.stones = const [],
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.inStockOnly = false,
    this.sort = CatalogueSort.featured,
    this.search,
  });

  final String? categoryId;
  final String? audience;
  final List<String> metals;
  final List<String> purities;
  final List<String> stones;
  final num? minPrice;
  final num? maxPrice;
  final double? minRating;
  final bool inStockOnly;
  final CatalogueSort sort;
  final String? search;
}

enum CatalogueSort { featured, newest, priceAsc, priceDesc, rating }

abstract interface class CatalogueRepository {
  Future<List<CatalogueItem>> list([CatalogueQuery query = const CatalogueQuery()]);
  Future<CatalogueItem?> byId(String id);
  Future<List<CatalogueItem>> featured();
  Future<List<CatalogueItem>> newArrivals();
  Future<List<CatalogueItem>> trending();
  Future<List<CatalogueItem>> bestSellers();
  Future<List<CatalogueItem>> related(String id, {int limit = 8});
}

abstract interface class CategoryRepository {
  Future<List<Category>> list();
  Future<Category?> byId(String id);
}

abstract interface class BannerRepository {
  Future<List<Banner>> list();
}

abstract interface class ReviewRepository {
  Future<List<Review>> forProduct(String productId);
  Future<List<Review>> featured();
}

abstract interface class CartRepository {
  Future<List<CartItem>> items();
  Future<void> add(CartItem item);
  Future<void> remove(String productId, {String? size});
  Future<void> clear();
}

abstract interface class WishlistRepository {
  Future<List<WishlistItem>> items();
  Future<void> toggle(String productId);
}

abstract interface class OrderRepository {
  Future<List<Order>> list();
  Future<Order?> byId(String id);
}

abstract interface class AccountRepository {
  Future<Account?> current();
}

abstract interface class AddressRepository {
  Future<List<Address>> list();
}

abstract interface class GoldRateRepository {
  Future<List<GoldRate>> current();
}

abstract interface class PolicyRepository {
  Future<List<PolicyDoc>> list();
  Future<PolicyDoc?> byKey(String key);
}

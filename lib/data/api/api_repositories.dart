import '../../core/network/api_client.dart';
import '../models/banner.dart';
import '../models/catalogue_item.dart';
import '../models/category.dart';
import '../models/commerce.dart';
import '../models/review.dart';
import '../repositories/repositories.dart';

/// Backend-backed repositories. C10 fills these in against the storefront
/// endpoints (plan §5); until then each call fails loudly so a build run in
/// `DATA_MODE=api` cannot silently show nothing.
Never _todo(String what) => throw UnimplementedError(
  'Api$what is not implemented until C10 (backend sync). '
  'Run with --dart-define=DATA_MODE=demo.',
);

class ApiCatalogueRepository implements CatalogueRepository {
  const ApiCatalogueRepository(this.client);
  final ApiClient client;
  @override
  Future<List<CatalogueItem>> list([CatalogueQuery query = const CatalogueQuery()]) =>
      _todo('CatalogueRepository.list');
  @override
  Future<CatalogueItem?> byId(String id) => _todo('CatalogueRepository.byId');
  @override
  Future<List<CatalogueItem>> featured() => _todo('CatalogueRepository.featured');
  @override
  Future<List<CatalogueItem>> newArrivals() => _todo('CatalogueRepository.newArrivals');
  @override
  Future<List<CatalogueItem>> trending() => _todo('CatalogueRepository.trending');
  @override
  Future<List<CatalogueItem>> bestSellers() => _todo('CatalogueRepository.bestSellers');
  @override
  Future<List<CatalogueItem>> related(String id, {int limit = 8}) =>
      _todo('CatalogueRepository.related');
}

class ApiCategoryRepository implements CategoryRepository {
  const ApiCategoryRepository(this.client);
  final ApiClient client;
  @override
  Future<List<Category>> list() => _todo('CategoryRepository.list');
  @override
  Future<Category?> byId(String id) => _todo('CategoryRepository.byId');
}

class ApiBannerRepository implements BannerRepository {
  const ApiBannerRepository(this.client);
  final ApiClient client;
  @override
  Future<List<Banner>> list() => _todo('BannerRepository.list');
}

class ApiReviewRepository implements ReviewRepository {
  const ApiReviewRepository(this.client);
  final ApiClient client;
  @override
  Future<List<Review>> forProduct(String productId) => _todo('ReviewRepository.forProduct');
  @override
  Future<List<Review>> featured() => _todo('ReviewRepository.featured');
}

class ApiCartRepository implements CartRepository {
  const ApiCartRepository(this.client);
  final ApiClient client;
  @override
  Future<List<CartItem>> items() => _todo('CartRepository.items');
  @override
  Future<void> add(CartItem item) => _todo('CartRepository.add');
  @override
  Future<void> remove(String productId, {String? size}) => _todo('CartRepository.remove');
  @override
  Future<void> clear() => _todo('CartRepository.clear');
}

class ApiWishlistRepository implements WishlistRepository {
  const ApiWishlistRepository(this.client);
  final ApiClient client;
  @override
  Future<List<WishlistItem>> items() => _todo('WishlistRepository.items');
  @override
  Future<void> toggle(String productId) => _todo('WishlistRepository.toggle');
}

class ApiOrderRepository implements OrderRepository {
  const ApiOrderRepository(this.client);
  final ApiClient client;
  @override
  Future<List<Order>> list() => _todo('OrderRepository.list');
  @override
  Future<Order?> byId(String id) => _todo('OrderRepository.byId');
}

class ApiAccountRepository implements AccountRepository {
  const ApiAccountRepository(this.client);
  final ApiClient client;
  @override
  Future<Account?> current() => _todo('AccountRepository.current');
}

class ApiAddressRepository implements AddressRepository {
  const ApiAddressRepository(this.client);
  final ApiClient client;
  @override
  Future<List<Address>> list() => _todo('AddressRepository.list');
}

class ApiGoldRateRepository implements GoldRateRepository {
  const ApiGoldRateRepository(this.client);
  final ApiClient client;
  @override
  Future<List<GoldRate>> current() => _todo('GoldRateRepository.current');
}

class ApiPolicyRepository implements PolicyRepository {
  const ApiPolicyRepository(this.client);
  final ApiClient client;
  @override
  Future<List<PolicyDoc>> list() => _todo('PolicyRepository.list');
  @override
  Future<PolicyDoc?> byKey(String key) => _todo('PolicyRepository.byKey');
}

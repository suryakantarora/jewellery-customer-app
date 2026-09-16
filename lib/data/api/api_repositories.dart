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
  Future<List<CatalogueItem>> byIds(List<String> ids) => _todo('CatalogueRepository.byIds');
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
  @override
  Future<PriceBounds> priceBounds({String? categoryId, String? audience}) =>
      _todo('CatalogueRepository.priceBounds');
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

class ApiAuthRepository implements AuthRepository {
  const ApiAuthRepository(this.client);
  final ApiClient client;
  @override
  Future<CustomerSession?> restore() => _todo('AuthRepository.restore');
  @override
  Future<OtpChallenge> requestOtp(String phone) => _todo('AuthRepository.requestOtp');
  @override
  Future<CustomerSession> verifyOtp(String phone, String code) =>
      _todo('AuthRepository.verifyOtp');
  @override
  Future<CustomerSession> continueAsGuest() => _todo('AuthRepository.continueAsGuest');
  @override
  Future<CustomerSession> updateProfile(Account account) =>
      _todo('AuthRepository.updateProfile');
  @override
  Future<void> signOut() => _todo('AuthRepository.signOut');
}

class ApiCartRepository implements CartRepository {
  const ApiCartRepository(this.client);
  final ApiClient client;
  @override
  Future<List<CartItem>> items() => _todo('CartRepository.items');
  @override
  Future<void> save(List<CartItem> items) => _todo('CartRepository.save');
}

class ApiWishlistRepository implements WishlistRepository {
  const ApiWishlistRepository(this.client);
  final ApiClient client;
  @override
  Future<List<WishlistItem>> items() => _todo('WishlistRepository.items');
  @override
  Future<void> save(List<WishlistItem> items) => _todo('WishlistRepository.save');
}

class ApiOrderRepository implements OrderRepository {
  const ApiOrderRepository(this.client);
  final ApiClient client;
  @override
  Future<List<Order>> list() => _todo('OrderRepository.list');
  @override
  Future<Order?> byId(String id) => _todo('OrderRepository.byId');
  @override
  Future<Order> place(OrderDraft draft) => _todo('OrderRepository.place');
}

class ApiAddressRepository implements AddressRepository {
  const ApiAddressRepository(this.client);
  final ApiClient client;
  @override
  Future<List<Address>> list() => _todo('AddressRepository.list');
  @override
  Future<List<Address>> save(Address address) => _todo('AddressRepository.save');
  @override
  Future<List<Address>> delete(String id) => _todo('AddressRepository.delete');
  @override
  Future<List<Address>> setDefault(String id) => _todo('AddressRepository.setDefault');
}

class ApiPaymentMethodRepository implements PaymentMethodRepository {
  const ApiPaymentMethodRepository(this.client);
  final ApiClient client;
  @override
  Future<List<PaymentMethod>> list() => _todo('PaymentMethodRepository.list');
  @override
  Future<List<PaymentMethod>> setDefault(String id) =>
      _todo('PaymentMethodRepository.setDefault');
  @override
  Future<List<PaymentMethod>> remove(String id) => _todo('PaymentMethodRepository.remove');
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

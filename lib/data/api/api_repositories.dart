import '../../core/network/api_client.dart';
import '../models/banner.dart';
import '../models/catalogue_item.dart';
import '../models/category.dart';
import '../models/commerce.dart';
import '../models/content.dart';
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
  Future<GoldRateSheet> current() => _todo('GoldRateRepository.current');
}

class ApiPolicyRepository implements PolicyRepository {
  const ApiPolicyRepository(this.client);
  final ApiClient client;
  @override
  Future<List<PolicyDoc>> list() => _todo('PolicyRepository.list');
  @override
  Future<PolicyDoc?> byKey(String key) => _todo('PolicyRepository.byKey');
}

class ApiStoreRepository implements StoreRepository {
  const ApiStoreRepository(this.client);
  final ApiClient client;
  @override
  Future<List<Store>> list() => _todo('StoreRepository.list');
  @override
  Future<Store?> byId(String id) => _todo('StoreRepository.byId');
}

class ApiOfferRepository implements OfferRepository {
  const ApiOfferRepository(this.client);
  final ApiClient client;
  @override
  Future<List<Offer>> list() => _todo('OfferRepository.list');
  @override
  Future<Offer?> byCode(String code) => _todo('OfferRepository.byCode');
}

class ApiContentRepository implements ContentRepository {
  const ApiContentRepository(this.client);
  final ApiClient client;
  @override
  Future<List<Brand>> brands() => _todo('ContentRepository.brands');
  @override
  Future<List<TrendingCard>> trending() => _todo('ContentRepository.trending');
  @override
  Future<List<Story>> stories() => _todo('ContentRepository.stories');
  @override
  Future<AboutContent> about() => _todo('ContentRepository.about');
}

class ApiFeedbackRepository implements FeedbackRepository {
  const ApiFeedbackRepository(this.client);
  final ApiClient client;
  @override
  Future<String> submit(FeedbackDraft draft) => _todo('FeedbackRepository.submit');
  @override
  Future<void> rate(int stars, {String? comment}) => _todo('FeedbackRepository.rate');
}

/// C10 will call the same `/notifications/devices` endpoints the staff app
/// uses, with the customer principal.
class ApiNotificationRepository implements NotificationRepository {
  const ApiNotificationRepository(this.client);
  final ApiClient client;
  @override
  Future<List<AppNotification>> list() => _todo('NotificationRepository.list');
  @override
  Future<List<AppNotification>> markRead(String id) => _todo('NotificationRepository.markRead');
  @override
  Future<List<AppNotification>> markAllRead() => _todo('NotificationRepository.markAllRead');
  @override
  Future<void> registerDevice({required String token, required String platform}) =>
      _todo('NotificationRepository.registerDevice');
  @override
  Future<void> unregisterDevice(String token) => _todo('NotificationRepository.unregisterDevice');
}

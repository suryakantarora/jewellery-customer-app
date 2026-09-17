import '../models/banner.dart';
import '../models/catalogue_item.dart';
import '../models/category.dart';
import '../models/commerce.dart';
import '../models/content.dart';
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
    this.tag,
    this.brand,
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

  /// Scope to one merchandising tag (`solitaire`, `gift`).
  final String? tag;

  /// Scope to one house brand.
  final String? brand;

  /// Number of facets the user has set (for the filter badge).
  int get activeFacetCount =>
      (metals.isEmpty ? 0 : 1) +
      (purities.isEmpty ? 0 : 1) +
      (stones.isEmpty ? 0 : 1) +
      (minPrice != null || maxPrice != null ? 1 : 0) +
      (minRating != null ? 1 : 0) +
      (inStockOnly ? 1 : 0);

  CatalogueQuery copyWith({
    String? categoryId,
    String? audience,
    List<String>? metals,
    List<String>? purities,
    List<String>? stones,
    num? minPrice,
    num? maxPrice,
    double? minRating,
    bool? inStockOnly,
    CatalogueSort? sort,
    String? search,
    String? tag,
    String? brand,
    bool clearPrice = false,
    bool clearRating = false,
  }) => CatalogueQuery(
    categoryId: categoryId ?? this.categoryId,
    audience: audience ?? this.audience,
    metals: metals ?? this.metals,
    purities: purities ?? this.purities,
    stones: stones ?? this.stones,
    minPrice: clearPrice ? null : (minPrice ?? this.minPrice),
    maxPrice: clearPrice ? null : (maxPrice ?? this.maxPrice),
    minRating: clearRating ? null : (minRating ?? this.minRating),
    inStockOnly: inStockOnly ?? this.inStockOnly,
    sort: sort ?? this.sort,
    search: search ?? this.search,
    tag: tag ?? this.tag,
    brand: brand ?? this.brand,
  );

  /// Same listing with every facet cleared (sort and scope kept).
  CatalogueQuery cleared() =>
      CatalogueQuery(
        categoryId: categoryId,
        audience: audience,
        sort: sort,
        search: search,
        tag: tag,
        brand: brand,
      );

  @override
  bool operator ==(Object other) =>
      other is CatalogueQuery && other.toString() == toString();

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() =>
      '$categoryId|$audience|$metals|$purities|$stones|$minPrice|$maxPrice|$minRating|$inStockOnly|$sort|$search|$tag|$brand';
}

enum CatalogueSort { featured, newest, priceAsc, priceDesc, rating }

/// Min/max price of the catalogue scope, for the filter's range slider.
class PriceBounds {
  const PriceBounds(this.min, this.max);
  final num min;
  final num max;
}

abstract interface class CatalogueRepository {
  Future<List<CatalogueItem>> list([CatalogueQuery query = const CatalogueQuery()]);
  Future<CatalogueItem?> byId(String id);
  Future<List<CatalogueItem>> byIds(List<String> ids);
  Future<List<CatalogueItem>> featured();
  Future<List<CatalogueItem>> newArrivals();
  Future<List<CatalogueItem>> trending();
  Future<List<CatalogueItem>> bestSellers();
  Future<List<CatalogueItem>> related(String id, {int limit = 8});
  Future<PriceBounds> priceBounds({String? categoryId, String? audience});
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

/// Customer identity: phone + OTP, guest mode, profile.
abstract interface class AuthRepository {
  /// The persisted session, if any, without a network round trip.
  Future<CustomerSession?> restore();
  Future<OtpChallenge> requestOtp(String phone);

  /// Throws [OtpRejectedException] on a wrong code.
  Future<CustomerSession> verifyOtp(String phone, String code);
  Future<CustomerSession> continueAsGuest();
  Future<CustomerSession> updateProfile(Account account);
  Future<void> signOut();
}

abstract interface class CartRepository {
  Future<List<CartItem>> items();
  Future<void> save(List<CartItem> items);
}

abstract interface class WishlistRepository {
  Future<List<WishlistItem>> items();
  Future<void> save(List<WishlistItem> items);
}

abstract interface class OrderRepository {
  Future<List<Order>> list();
  Future<Order?> byId(String id);
  Future<Order> place(OrderDraft draft);
}

abstract interface class AddressRepository {
  Future<List<Address>> list();

  /// Insert or update; an empty id means new. Returns the stored list.
  Future<List<Address>> save(Address address);
  Future<List<Address>> delete(String id);
  Future<List<Address>> setDefault(String id);
}

abstract interface class PaymentMethodRepository {
  Future<List<PaymentMethod>> list();
  Future<List<PaymentMethod>> setDefault(String id);
  Future<List<PaymentMethod>> remove(String id);
}

abstract interface class GoldRateRepository {
  Future<GoldRateSheet> current();
}

abstract interface class PolicyRepository {
  Future<List<PolicyDoc>> list();
  Future<PolicyDoc?> byKey(String key);
}

abstract interface class StoreRepository {
  Future<List<Store>> list();
  Future<Store?> byId(String id);
}

abstract interface class OfferRepository {
  Future<List<Offer>> list();
  Future<Offer?> byCode(String code);
}

/// Editorial content the home and settings screens show.
abstract interface class ContentRepository {
  Future<List<Brand>> brands();
  Future<List<TrendingCard>> trending();
  Future<List<Story>> stories();
  Future<AboutContent> about();
}

/// A submitted feedback form.
class FeedbackDraft {
  const FeedbackDraft({
    required this.happy,
    required this.topic,
    required this.message,
    this.email,
    this.followUp = false,
  });

  final bool happy;
  final String topic;
  final String message;
  final String? email;
  final bool followUp;
}

abstract interface class FeedbackRepository {
  /// Returns the ticket reference (`FB-2xxxx`).
  Future<String> submit(FeedbackDraft draft);
  Future<void> rate(int stars, {String? comment});
}

/// Notification centre plus the push device registration the staff app
/// already uses (`POST /notifications/devices`).
abstract interface class NotificationRepository {
  Future<List<AppNotification>> list();
  Future<List<AppNotification>> markRead(String id);
  Future<List<AppNotification>> markAllRead();
  Future<void> registerDevice({required String token, required String platform});
  Future<void> unregisterDevice(String token);
}

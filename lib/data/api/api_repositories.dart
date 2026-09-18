import 'dart:async';

import '../../core/network/api_client.dart';
import '../../core/network/app_exception.dart';
import '../../core/storage/local_store.dart';
import '../../core/storage/storage_keys.dart';
import '../catalogue_logic.dart';
import '../models/banner.dart';
import '../models/catalogue_item.dart';
import '../models/category.dart';
import '../models/commerce.dart';
import '../models/content.dart';
import '../models/review.dart';
import '../repositories/repositories.dart';

/// Backend-backed repositories (C10), against the storefront API:
///
/// * `/public/**` — anonymous, scoped by the `X-Tenant-Key` header the Dio
///   client stamps: catalogue, categories, content documents, gold rates,
///   reviews, feedback.
/// * `/customer-auth/otp/*` — phone + one-time code → customer token.
/// * `/storefront/**` — the signed-in customer's own data; the Dio client
///   attaches the token.
///
/// Payloads are the app's own model shapes, so every response goes straight
/// through the models' `fromJson`.

List<Map<String, dynamic>> _maps(Object? data) =>
    (data as List? ?? const []).whereType<Map<String, dynamic>>().toList();

Map<String, dynamic> _map(Object? data) =>
    data is Map<String, dynamic> ? data : const {};

/// Holds a future for a while. One fetch serves every rail on a screen, and a
/// failure is forgotten at once so the next read retries.
class _Cached<T> {
  _Cached(this.ttl, this._load);

  final Duration ttl;
  final Future<T> Function() _load;

  Future<T>? _value;
  DateTime _at = DateTime.fromMillisecondsSinceEpoch(0);

  Future<T> get() {
    final current = _value;
    if (current != null && DateTime.now().difference(_at) < ttl) return current;
    _at = DateTime.now();
    final next = _load();
    _value = next;
    unawaited(next.then<void>((_) {}, onError: (Object _) {
      if (identical(_value, next)) _value = null;
    }));
    return next;
  }

  void clear() => _value = null;
}

/// The shop's whole priced catalogue, fetched once and reused briefly.
///
/// The backend serves the full list (see `StorefrontCatalogueService`);
/// sorting and faceting happen here through [CatalogueLogic], exactly as in
/// demo mode. Shared by the catalogue and category repositories so counts and
/// listings never disagree.
class ApiCatalogueCache {
  ApiCatalogueCache(this.client);

  final ApiClient client;

  late final _items = _Cached<List<CatalogueItem>>(
    const Duration(seconds: 60),
    () => client.get(
      '/public/catalogue/items',
      parse: (data) => _maps(data).map(CatalogueItem.fromJson).toList(),
    ),
  );

  Future<List<CatalogueItem>> items() => _items.get();

  /// After an order: the pieces just bought are no longer for sale.
  void invalidate() => _items.clear();
}

class ApiCatalogueRepository implements CatalogueRepository {
  const ApiCatalogueRepository(this.cache);
  final ApiCatalogueCache cache;

  @override
  Future<List<CatalogueItem>> list([CatalogueQuery query = const CatalogueQuery()]) async =>
      CatalogueLogic.apply(await cache.items(), query);

  @override
  Future<CatalogueItem?> byId(String id) async =>
      (await cache.items()).where((i) => i.id == id).firstOrNull;

  @override
  Future<List<CatalogueItem>> byIds(List<String> ids) async =>
      CatalogueLogic.byIds(await cache.items(), ids);

  @override
  Future<List<CatalogueItem>> featured() async =>
      (await cache.items()).where((i) => i.retail.isFeatured).toList();

  @override
  Future<List<CatalogueItem>> newArrivals() async =>
      (await cache.items()).where((i) => i.retail.isNew).toList();

  @override
  Future<List<CatalogueItem>> trending() async =>
      (await cache.items()).where((i) => i.retail.isTrending).toList();

  @override
  Future<List<CatalogueItem>> bestSellers() async =>
      (await cache.items()).where((i) => i.retail.isBestSeller).toList();

  @override
  Future<List<CatalogueItem>> related(String id, {int limit = 8}) async =>
      CatalogueLogic.related(await cache.items(), id, limit: limit);

  @override
  Future<PriceBounds> priceBounds({String? categoryId, String? audience}) async =>
      CatalogueLogic.priceBounds(
        await cache.items(),
        categoryId: categoryId,
        audience: audience,
      );
}

class ApiCategoryRepository implements CategoryRepository {
  ApiCategoryRepository(this.client);
  final ApiClient client;

  late final _categories = _Cached<List<Category>>(
    const Duration(minutes: 5),
    () => client.get(
      '/public/categories',
      parse: (data) => _maps(data).map(Category.fromJson).toList(),
    ),
  );

  @override
  Future<List<Category>> list() => _categories.get();

  @override
  Future<Category?> byId(String id) async =>
      (await list()).where((c) => c.id == id).firstOrNull;
}

/// The tenant's editorial documents (`/public/content/{kind}`), cached
/// together: the home screen reads five of them at once.
class ApiContentCache {
  ApiContentCache(this.client);
  final ApiClient client;

  final _documents = <String, _Cached<Object?>>{};

  Future<Object?> document(String kind) => _documents
      .putIfAbsent(
        kind,
        () => _Cached<Object?>(
          const Duration(minutes: 5),
          () => client.get('/public/content/$kind', parse: (data) => data),
        ),
      )
      .get();

  Future<List<T>> list<T>(String kind, T Function(Map<String, dynamic>) parse) async =>
      _maps(await document(kind)).map(parse).toList();
}

class ApiBannerRepository implements BannerRepository {
  const ApiBannerRepository(this.content);
  final ApiContentCache content;

  @override
  Future<List<Banner>> list() => content.list('banners', Banner.fromJson);
}

class ApiReviewRepository implements ReviewRepository {
  const ApiReviewRepository(this.client);
  final ApiClient client;

  @override
  Future<List<Review>> forProduct(String productId) => client.get(
    '/public/reviews',
    query: {'productId': productId},
    parse: (data) => _maps(data).map(Review.fromJson).toList(),
  );

  @override
  Future<List<Review>> featured() => client.get(
    '/public/reviews',
    parse: (data) => _maps(data).map(Review.fromJson).toList(),
  );
}

/// Phone + OTP against `/customer-auth`. The session (account + token) is
/// persisted under [StorageKeys.session]; the Dio client reads the token from
/// there on every request.
class ApiAuthRepository implements AuthRepository {
  const ApiAuthRepository(this.client, this._local);
  final ApiClient client;
  final LocalStore _local;

  @override
  Future<CustomerSession?> restore() async {
    final json = _local.getJson(StorageKeys.session);
    return json == null ? null : CustomerSession.fromJson(json);
  }

  @override
  Future<OtpChallenge> requestOtp(String phone) => client.post(
    '/customer-auth/otp/request',
    body: {'phone': phone},
    parse: (data) {
      final json = _map(data);
      return OtpChallenge(
        phone: json['phone'] as String? ?? phone,
        expiresIn: Duration(seconds: (json['expiresInSeconds'] as num?)?.toInt() ?? 300),
        resendAfter: Duration(seconds: (json['resendAfterSeconds'] as num?)?.toInt() ?? 30),
      );
    },
  );

  @override
  Future<CustomerSession> verifyOtp(String phone, String code) async {
    final CustomerSession session;
    try {
      session = await client.post(
        '/customer-auth/otp/verify',
        body: {'phone': phone, 'code': code},
        parse: (data) => CustomerSession.fromJson(_map(data)),
      );
    } on UnauthorizedException {
      throw const OtpRejectedException();
    }
    await _local.setJson(StorageKeys.session, session.toJson());
    return session;
  }

  @override
  Future<CustomerSession> continueAsGuest() async {
    const session = CustomerSession.guest();
    await _local.setJson(StorageKeys.session, session.toJson());
    return session;
  }

  @override
  Future<CustomerSession> updateProfile(Account account) async {
    final token = _local.getJson(StorageKeys.session)?['token'] as String?;
    final updated = await client.put(
      '/storefront/me',
      body: {
        'name': account.name,
        if (account.email != null) 'email': account.email,
        if (!account.avatar.isEmpty) 'avatar': account.avatar.toString(),
      },
      parse: (data) => Account.fromJson(_map(data)),
    );
    final session = CustomerSession.customer(account: updated, token: token);
    await _local.setJson(StorageKeys.session, session.toJson());
    return session;
  }

  @override
  Future<void> signOut() => _local.remove(StorageKeys.session);
}

/// Whether requests will carry a customer token right now.
bool _signedIn(LocalStore local) =>
    (local.getJson(StorageKeys.session)?['token'] as String?)?.isNotEmpty ?? false;

/// A guest's bag lives on the device. On the first read after sign-in it is
/// merged into the account's bag, so nothing chosen before signing in is lost.
class ApiCartRepository implements CartRepository {
  const ApiCartRepository(this.client, this._local);
  final ApiClient client;
  final LocalStore _local;

  List<CartItem> _guest() =>
      _local.getJsonList(StorageKeys.guestCart)?.map(CartItem.fromJson).toList() ??
      const [];

  Future<List<CartItem>> _put(List<CartItem> items) => client.put(
    '/storefront/cart',
    body: items.map((i) => i.toJson()).toList(),
    parse: (data) => _maps(data).map(CartItem.fromJson).toList(),
  );

  @override
  Future<List<CartItem>> items() async {
    if (!_signedIn(_local)) return _guest();
    final server = await client.get(
      '/storefront/cart',
      parse: (data) => _maps(data).map(CartItem.fromJson).toList(),
    );
    final guest = _guest();
    if (guest.isEmpty) return server;
    final merged = await _put([
      ...server,
      ...guest.where((g) => !server.any((s) => s.matches(g.productId, g.size))),
    ]);
    await _local.remove(StorageKeys.guestCart);
    return merged;
  }

  @override
  Future<void> save(List<CartItem> items) async {
    if (_signedIn(_local)) {
      await _put(items);
    } else {
      await _local.setJsonList(
        StorageKeys.guestCart,
        items.map((i) => i.toJson()).toList(),
      );
    }
  }
}

class ApiWishlistRepository implements WishlistRepository {
  const ApiWishlistRepository(this.client, this._local);
  final ApiClient client;
  final LocalStore _local;

  List<WishlistItem> _guest() =>
      _local
          .getJsonList(StorageKeys.guestWishlist)
          ?.map(WishlistItem.fromJson)
          .toList() ??
      const [];

  // The backend wants UTC instants.
  Future<List<WishlistItem>> _put(List<WishlistItem> items) => client.put(
    '/storefront/wishlist',
    body: [
      for (final i in items)
        {'productId': i.productId, 'addedAt': i.addedAt.toUtc().toIso8601String()},
    ],
    parse: (data) => _maps(data).map(WishlistItem.fromJson).toList(),
  );

  @override
  Future<List<WishlistItem>> items() async {
    if (!_signedIn(_local)) return _guest();
    final server = await client.get(
      '/storefront/wishlist',
      parse: (data) => _maps(data).map(WishlistItem.fromJson).toList(),
    );
    final guest = _guest();
    if (guest.isEmpty) return server;
    final merged = await _put([
      ...server,
      ...guest.where((g) => !server.any((s) => s.productId == g.productId)),
    ]);
    await _local.remove(StorageKeys.guestWishlist);
    return merged;
  }

  @override
  Future<void> save(List<WishlistItem> items) async {
    if (_signedIn(_local)) {
      await _put(items);
    } else {
      await _local.setJsonList(
        StorageKeys.guestWishlist,
        items.map((i) => i.toJson()).toList(),
      );
    }
  }
}

class ApiOrderRepository implements OrderRepository {
  const ApiOrderRepository(this.client, this._catalogue, this._local);
  final ApiClient client;
  final ApiCatalogueCache _catalogue;
  final LocalStore _local;

  @override
  Future<List<Order>> list() async => _signedIn(_local)
      ? client.get(
          '/storefront/orders',
          parse: (data) => _maps(data).map(Order.fromJson).toList(),
        )
      : const [];

  @override
  Future<Order?> byId(String id) async {
    if (!_signedIn(_local)) return null;
    try {
      return await client.get(
        '/storefront/orders/${Uri.encodeComponent(id)}',
        parse: (data) => Order.fromJson(_map(data)),
      );
    } on NotFoundException {
      return null;
    }
  }

  /// Sends choices, never amounts: the backend prices the order from the live
  /// catalogue. Throws [RejectedException] (409) when a piece has just sold.
  @override
  Future<Order> place(OrderDraft draft) async {
    try {
      return await client.post(
        '/storefront/orders',
        body: {
          'lines': [
            for (final l in draft.lines)
              {
                'productId': l.product.id,
                'quantity': l.quantity,
                if (l.size != null) 'size': l.size,
              },
          ],
          'addressId': draft.address.id,
          'paymentMethodId': draft.payment.id,
          if (draft.offerCode != null) 'offerCode': draft.offerCode,
        },
        parse: (data) => Order.fromJson(_map(data)),
      );
    } finally {
      // Placed or refused, what is for sale has changed.
      _catalogue.invalidate();
    }
  }
}

class ApiAddressRepository implements AddressRepository {
  const ApiAddressRepository(this.client, this._local);
  final ApiClient client;
  final LocalStore _local;

  static List<Address> _parse(Object? data) =>
      _maps(data).map(Address.fromJson).toList();

  @override
  Future<List<Address>> list() async => _signedIn(_local)
      ? client.get('/storefront/addresses', parse: _parse)
      : const [];

  @override
  Future<List<Address>> save(Address address) {
    final body = address.toJson()..remove('id');
    return address.id.isEmpty
        ? client.post('/storefront/addresses', body: body, parse: _parse)
        : client.put('/storefront/addresses/${address.id}', body: body, parse: _parse);
  }

  @override
  Future<List<Address>> delete(String id) =>
      client.delete('/storefront/addresses/$id', parse: _parse);

  @override
  Future<List<Address>> setDefault(String id) =>
      client.post('/storefront/addresses/$id/default', parse: _parse);
}

class ApiPaymentMethodRepository implements PaymentMethodRepository {
  const ApiPaymentMethodRepository(this.client, this._local);
  final ApiClient client;
  final LocalStore _local;

  static List<PaymentMethod> _parse(Object? data) =>
      _maps(data).map(PaymentMethod.fromJson).toList();

  @override
  Future<List<PaymentMethod>> list() async => _signedIn(_local)
      ? client.get('/storefront/payment-methods', parse: _parse)
      : const [];

  @override
  Future<List<PaymentMethod>> setDefault(String id) =>
      client.post('/storefront/payment-methods/$id/default', parse: _parse);

  @override
  Future<List<PaymentMethod>> remove(String id) =>
      client.delete('/storefront/payment-methods/$id', parse: _parse);
}

class ApiGoldRateRepository implements GoldRateRepository {
  const ApiGoldRateRepository(this.client);
  final ApiClient client;

  @override
  Future<GoldRateSheet> current() => client.get(
    '/public/gold-rates',
    parse: (data) {
      final json = _map(data);
      return GoldRateSheet(
        rates: _maps(json['rates']).map(GoldRate.fromJson).toList(),
        updatedAt:
            DateTime.tryParse(json['updatedAt'] as String? ?? '')?.toLocal() ??
            DateTime.now(),
      );
    },
  );
}

class ApiPolicyRepository implements PolicyRepository {
  const ApiPolicyRepository(this.content);
  final ApiContentCache content;

  @override
  Future<List<PolicyDoc>> list() => content.list('policies', PolicyDoc.fromJson);

  @override
  Future<PolicyDoc?> byKey(String key) async =>
      (await list()).where((p) => p.key == key).firstOrNull;
}

class ApiStoreRepository implements StoreRepository {
  const ApiStoreRepository(this.content);
  final ApiContentCache content;

  @override
  Future<List<Store>> list() => content.list('stores', Store.fromJson);

  @override
  Future<Store?> byId(String id) async =>
      (await list()).where((s) => s.id == id).firstOrNull;
}

class ApiOfferRepository implements OfferRepository {
  const ApiOfferRepository(this.content);
  final ApiContentCache content;

  @override
  Future<List<Offer>> list() => content.list('offers', Offer.fromJson);

  @override
  Future<Offer?> byCode(String code) async => (await list())
      .where((o) => o.code.toLowerCase() == code.trim().toLowerCase())
      .firstOrNull;
}

class ApiContentRepository implements ContentRepository {
  const ApiContentRepository(this.content);
  final ApiContentCache content;

  @override
  Future<List<Brand>> brands() => content.list('brands', Brand.fromJson);

  @override
  Future<List<TrendingCard>> trending() =>
      content.list('trending', TrendingCard.fromJson);

  @override
  Future<List<Story>> stories() => content.list('stories', Story.fromJson);

  @override
  Future<AboutContent> about() async =>
      AboutContent.fromJson(_map(await content.document('about')));
}

/// Guests may send feedback too; a signed-in customer is recorded against it
/// because the Dio client attaches the token to public calls as well.
class ApiFeedbackRepository implements FeedbackRepository {
  const ApiFeedbackRepository(this.client);
  final ApiClient client;

  @override
  Future<String> submit(FeedbackDraft draft) => client.post(
    '/public/feedback',
    body: {
      'happy': draft.happy,
      'topic': draft.topic,
      'message': draft.message,
      if (draft.email != null && draft.email!.isNotEmpty) 'email': draft.email,
      'followUp': draft.followUp,
    },
    parse: (data) => _map(data)['ticket'] as String? ?? '',
  );

  @override
  Future<void> rate(int stars, {String? comment}) => client.post(
    '/public/ratings',
    body: {'stars': stars, if (comment != null && comment.isNotEmpty) 'comment': comment},
    parse: (_) {},
  );
}

/// The customer's inbox and push registration. Guests have neither: the
/// inbox is empty and registration waits for sign-in.
class ApiNotificationRepository implements NotificationRepository {
  const ApiNotificationRepository(this.client, this._local);
  final ApiClient client;
  final LocalStore _local;

  static List<AppNotification> _parse(Object? data) =>
      _maps(data).map(AppNotification.fromJson).toList();

  @override
  Future<List<AppNotification>> list() async => _signedIn(_local)
      ? client.get('/storefront/notifications', parse: _parse)
      : const [];

  @override
  Future<List<AppNotification>> markRead(String id) async => _signedIn(_local)
      ? client.post('/storefront/notifications/$id/read', parse: _parse)
      : const [];

  @override
  Future<List<AppNotification>> markAllRead() async => _signedIn(_local)
      ? client.post('/storefront/notifications/read-all', parse: _parse)
      : const [];

  @override
  Future<void> registerDevice({required String token, required String platform}) async {
    await _local.setString(StorageKeys.pushToken, token);
    if (!_signedIn(_local)) return;
    await client.post(
      '/storefront/devices',
      body: {'token': token, 'platform': platform.toUpperCase()},
      parse: (_) {},
    );
  }

  @override
  Future<void> unregisterDevice(String token) async {
    if (!_signedIn(_local)) return;
    await client.delete('/storefront/devices', query: {'token': token}, parse: (_) {});
  }
}

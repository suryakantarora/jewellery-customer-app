import 'dart:math';

import '../../core/storage/local_store.dart';
import '../../core/storage/storage_keys.dart';
import '../models/banner.dart';
import '../models/catalogue_item.dart';
import '../models/category.dart';
import '../models/commerce.dart';
import '../models/content.dart';
import '../models/localized_text.dart';
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
      if (query.tag != null &&
          !r.tags.map((t) => t.toLowerCase()).contains(query.tag!.toLowerCase())) {
        return false;
      }
      if (query.brand != null &&
          r.brand.toLowerCase() != query.brand!.toLowerCase()) {
        return false;
      }
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
          r.brand,
          ...r.tags,
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
  Future<List<CatalogueItem>> byIds(List<String> ids) => _store.read(
    (d) => [
      for (final id in ids) ...d.items.where((i) => i.id == id),
    ],
  );

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

  @override
  Future<PriceBounds> priceBounds({String? categoryId, String? audience}) =>
      _store.read((d) {
        final scoped = d.items.where((i) {
          if (categoryId != null &&
              categoryId != 'all' &&
              i.categoryId != categoryId) {
            return false;
          }
          if (audience != null &&
              i.retail.audience.name != audience.toLowerCase() &&
              i.retail.audience != Audience.unisex) {
            return false;
          }
          return true;
        }).map((i) => i.price);
        if (scoped.isEmpty) return const PriceBounds(0, 0);
        return PriceBounds(scoped.reduce(min), scoped.reduce(max));
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

// --- Customer data: seeded from commerce.json, then persisted locally -------

/// Demo identity. Any 6-digit code verifies. The seeded account's phone signs
/// in as that customer; any other number creates a fresh account that still
/// needs a name.
class DemoAuthRepository implements AuthRepository {
  const DemoAuthRepository(this._store, this._local);

  final DemoStore _store;
  final LocalStore _local;

  static const otpValidity = Duration(minutes: 5);
  static const resendAfter = Duration(seconds: 30);

  @override
  Future<CustomerSession?> restore() async {
    final json = _local.getJson(StorageKeys.session);
    return json == null ? null : CustomerSession.fromJson(json);
  }

  @override
  Future<OtpChallenge> requestOtp(String phone) => _store.readCommerce(
    (_) => OtpChallenge(
      phone: phone,
      expiresIn: otpValidity,
      resendAfter: resendAfter,
    ),
  );

  @override
  Future<CustomerSession> verifyOtp(String phone, String code) async {
    final seed = await _store.readCommerce((seed) => seed);
    if (!RegExp(r'^\d{6}$').hasMatch(code)) {
      throw const OtpRejectedException();
    }
    final key = _normalise(phone);
    final known = [
      ..._local.getJsonList(StorageKeys.demoAccounts)?.map(Account.fromJson) ??
          const <Account>[],
      ...seed.accounts,
    ].where((a) => _normalise(a.phone) == key).firstOrNull;
    final account =
        known ??
        Account(
          id: 'C-${DateTime.now().millisecondsSinceEpoch % 100000}',
          name: '',
          phone: phone,
          memberSince: DateTime.now(),
          tier: 'Member',
        );
    final session = CustomerSession.customer(account: account);
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
    final stored =
        _local.getJsonList(StorageKeys.demoAccounts)?.map(Account.fromJson).toList() ??
        <Account>[];
    stored.removeWhere((a) => a.id == account.id);
    stored.add(account);
    await _local.setJsonList(
      StorageKeys.demoAccounts,
      stored.map((a) => a.toJson()).toList(),
    );
    final session = CustomerSession.customer(account: account);
    await _local.setJson(StorageKeys.session, session.toJson());
    return session;
  }

  @override
  Future<void> signOut() => _local.remove(StorageKeys.session);

  static String _normalise(String phone) => phone.replaceAll(RegExp(r'\D'), '');
}

class DemoCartRepository implements CartRepository {
  const DemoCartRepository(this._local);
  final LocalStore _local;

  @override
  Future<List<CartItem>> items() async =>
      _local.getJsonList(StorageKeys.demoCart)?.map(CartItem.fromJson).toList() ??
      const [];

  @override
  Future<void> save(List<CartItem> items) => _local.setJsonList(
    StorageKeys.demoCart,
    items.map((i) => i.toJson()).toList(),
  );
}

class DemoWishlistRepository implements WishlistRepository {
  const DemoWishlistRepository(this._local);
  final LocalStore _local;

  @override
  Future<List<WishlistItem>> items() async =>
      _local
          .getJsonList(StorageKeys.demoWishlist)
          ?.map(WishlistItem.fromJson)
          .toList() ??
      const [];

  @override
  Future<void> save(List<WishlistItem> items) => _local.setJsonList(
    StorageKeys.demoWishlist,
    items.map((i) => i.toJson()).toList(),
  );
}

class DemoOrderRepository implements OrderRepository {
  const DemoOrderRepository(this._store, this._local);
  final DemoStore _store;
  final LocalStore _local;

  static const placementLatency = Duration(milliseconds: 1200);

  Future<List<Order>> _all() => _store.readCommerce((seed) {
    final stored = _local.getJsonList(StorageKeys.demoOrders);
    if (stored != null) return stored.map(Order.fromJson).toList();
    return seed.orders;
  });

  Future<void> _persist(List<Order> orders) => _local.setJsonList(
    StorageKeys.demoOrders,
    orders.map((o) => o.toJson()).toList(),
  );

  @override
  Future<List<Order>> list() async =>
      (await _all())..sort((a, b) => b.date.compareTo(a.date));

  @override
  Future<Order?> byId(String id) async =>
      (await _all()).where((o) => o.id == id).firstOrNull;

  @override
  Future<Order> place(OrderDraft draft) async {
    final orders = await _all();
    await Future<void>.delayed(placementLatency);
    final serial = 100500 + orders.length + Random().nextInt(40);
    final order = Order(
      id: 'FINO-$serial',
      date: DateTime.now(),
      status: OrderStatus.placed,
      items: [
        for (final l in draft.lines)
          OrderItem(
            productId: l.product.id,
            name: l.product.productName,
            image: l.product.heroImage,
            price: l.product.price,
            quantity: l.quantity,
            size: l.size,
          ),
      ],
      subtotal: draft.subtotal,
      shipping: draft.shipping,
      tax: draft.tax,
      total: draft.total,
      address: '${draft.address.name} · ${draft.address.oneLine}',
      paymentKind: draft.payment.kind,
      courier: 'Lao Express',
      trackingNumber:
          'LX-${1000 + Random().nextInt(9000)}-${100 + Random().nextInt(900)}-LA',
      eta: const LocalizedText({
        'en': 'Confirmation within 2 hours',
        'lo': 'ຢືນຢັນພາຍໃນ 2 ຊົ່ວໂມງ',
      }),
    );
    await _persist([order, ...orders]);
    return order;
  }
}

class DemoAddressRepository implements AddressRepository {
  const DemoAddressRepository(this._store, this._local);
  final DemoStore _store;
  final LocalStore _local;

  Future<List<Address>> _all() => _store.readCommerce((seed) {
    final stored = _local.getJsonList(StorageKeys.demoAddresses);
    if (stored != null) return stored.map(Address.fromJson).toList();
    return seed.addresses;
  });

  Future<List<Address>> _persist(List<Address> list) async {
    await _local.setJsonList(
      StorageKeys.demoAddresses,
      list.map((a) => a.toJson()).toList(),
    );
    return list;
  }

  @override
  Future<List<Address>> list() => _all();

  @override
  Future<List<Address>> save(Address address) async {
    var list = await _all();
    final isNew = address.id.isEmpty;
    final stored = isNew
        ? address.copyWith(id: 'A${DateTime.now().millisecondsSinceEpoch}')
        : address;
    final makeDefault = stored.isDefault || list.isEmpty;
    list = [
      for (final a in list)
        if (a.id != stored.id) (makeDefault ? a.copyWith(isDefault: false) : a),
      stored.copyWith(isDefault: makeDefault),
    ];
    return _persist(list);
  }

  @override
  Future<List<Address>> delete(String id) async {
    final list = (await _all()).where((a) => a.id != id).toList();
    if (list.isNotEmpty && !list.any((a) => a.isDefault)) {
      list[0] = list[0].copyWith(isDefault: true);
    }
    return _persist(list);
  }

  @override
  Future<List<Address>> setDefault(String id) async => _persist([
    for (final a in await _all()) a.copyWith(isDefault: a.id == id),
  ]);
}

class DemoPaymentMethodRepository implements PaymentMethodRepository {
  const DemoPaymentMethodRepository(this._store, this._local);
  final DemoStore _store;
  final LocalStore _local;

  Future<List<PaymentMethod>> _all() => _store.readCommerce((seed) {
    final stored = _local.getJsonList(StorageKeys.demoPaymentMethods);
    if (stored != null) return stored.map(PaymentMethod.fromJson).toList();
    return seed.paymentMethods;
  });

  Future<List<PaymentMethod>> _persist(List<PaymentMethod> list) async {
    await _local.setJsonList(
      StorageKeys.demoPaymentMethods,
      list.map((p) => p.toJson()).toList(),
    );
    return list;
  }

  @override
  Future<List<PaymentMethod>> list() => _all();

  @override
  Future<List<PaymentMethod>> setDefault(String id) async => _persist([
    for (final p in await _all()) p.copyWith(isDefault: p.id == id),
  ]);

  @override
  Future<List<PaymentMethod>> remove(String id) async {
    final list = (await _all()).where((p) => p.id != id).toList();
    if (list.isNotEmpty && !list.any((p) => p.isDefault)) {
      list[0] = list[0].copyWith(isDefault: true);
    }
    return _persist(list);
  }
}

// --- Content & services (C7, C8) --------------------------------------------

/// Gold rates with the reference's 320 ms latency; the live drift lives in
/// the provider so the repository stays a plain read.
class DemoGoldRateRepository implements GoldRateRepository {
  const DemoGoldRateRepository(this._store);
  final DemoStore _store;

  @override
  Future<GoldRateSheet> current() => _store.readContent(
    (c) => GoldRateSheet(rates: c.goldRates, updatedAt: DateTime.now()),
    latency: const Duration(milliseconds: 320),
  );
}

class DemoPolicyRepository implements PolicyRepository {
  const DemoPolicyRepository(this._store);
  final DemoStore _store;

  @override
  Future<List<PolicyDoc>> list() => _store.readContent((c) => c.policies);

  @override
  Future<PolicyDoc?> byKey(String key) => _store.readContent(
    (c) => c.policies.where((p) => p.key == key).firstOrNull,
  );
}

class DemoStoreRepository implements StoreRepository {
  const DemoStoreRepository(this._store);
  final DemoStore _store;

  @override
  Future<List<Store>> list() => _store.readContent((c) => c.stores);

  @override
  Future<Store?> byId(String id) =>
      _store.readContent((c) => c.stores.where((s) => s.id == id).firstOrNull);
}

class DemoOfferRepository implements OfferRepository {
  const DemoOfferRepository(this._store);
  final DemoStore _store;

  @override
  Future<List<Offer>> list() =>
      _store.readContent((c) => c.offers.where((o) => !o.expired).toList());

  @override
  Future<Offer?> byCode(String code) => _store.readContent(
    (c) => c.offers
        .where((o) => o.code.toLowerCase() == code.trim().toLowerCase() && !o.expired)
        .firstOrNull,
  );
}

class DemoContentRepository implements ContentRepository {
  const DemoContentRepository(this._store);
  final DemoStore _store;

  @override
  Future<List<Brand>> brands() => _store.readContent((c) => c.brands);

  @override
  Future<List<TrendingCard>> trending() => _store.readContent((c) => c.trending);

  @override
  Future<List<Story>> stories() => _store.readContent((c) => c.stories);

  @override
  Future<AboutContent> about() => _store.readContent((c) => c.about);
}

/// Feedback and ratings are kept locally so the confirmation can show a
/// stable ticket number.
class DemoFeedbackRepository implements FeedbackRepository {
  const DemoFeedbackRepository(this._local);
  final LocalStore _local;

  static const latency = Duration(milliseconds: 1100);

  @override
  Future<String> submit(FeedbackDraft draft) async {
    await Future<void>.delayed(latency);
    final sent = _local.getJsonList(StorageKeys.demoFeedback) ?? [];
    final ticket = 'FB-2${(1000 + sent.length * 37 + Random().nextInt(900)).toString().padLeft(4, '0')}';
    await _local.setJsonList(StorageKeys.demoFeedback, [
      ...sent,
      {
        'ticket': ticket,
        'happy': draft.happy,
        'topic': draft.topic,
        'message': draft.message,
        'email': draft.email,
        'followUp': draft.followUp,
        'date': DateTime.now().toIso8601String(),
      },
    ]);
    return ticket;
  }

  @override
  Future<void> rate(int stars, {String? comment}) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    await _local.setJson('${StorageKeys.demoFeedback}.rating', {
      'stars': stars,
      'comment': comment,
      'date': DateTime.now().toIso8601String(),
    });
  }
}

/// Seeded notifications; read state persists locally. Device registration
/// only records the token so the C10 swap has nothing to migrate.
class DemoNotificationRepository implements NotificationRepository {
  const DemoNotificationRepository(this._store, this._local);
  final DemoStore _store;
  final LocalStore _local;

  Future<List<AppNotification>> _all() => _store.readContent((c) {
    final stored = _local.getJsonList(StorageKeys.demoNotifications);
    if (stored != null) return stored.map(AppNotification.fromJson).toList();
    return c.notifications;
  });

  Future<List<AppNotification>> _persist(List<AppNotification> list) async {
    await _local.setJsonList(
      StorageKeys.demoNotifications,
      list.map((n) => n.toJson()).toList(),
    );
    return list;
  }

  @override
  Future<List<AppNotification>> list() async =>
      (await _all())..sort((a, b) => b.date.compareTo(a.date));

  @override
  Future<List<AppNotification>> markRead(String id) async => _persist([
    for (final n in await _all()) n.id == id ? n.copyWith(read: true) : n,
  ]);

  @override
  Future<List<AppNotification>> markAllRead() async =>
      _persist([for (final n in await _all()) n.copyWith(read: true)]);

  @override
  Future<void> registerDevice({required String token, required String platform}) =>
      _local.setString(StorageKeys.pushToken, '$platform:$token');

  @override
  Future<void> unregisterDevice(String token) => _local.remove(StorageKeys.pushToken);
}

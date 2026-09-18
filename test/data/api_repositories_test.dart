import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:jewellery_customer/core/config/app_config.dart';
import 'package:jewellery_customer/core/config/data_mode.dart';
import 'package:jewellery_customer/core/config/environment.dart';
import 'package:jewellery_customer/core/network/api_client.dart';
import 'package:jewellery_customer/core/network/app_exception.dart';
import 'package:jewellery_customer/core/network/dio_client.dart';
import 'package:jewellery_customer/core/storage/local_store.dart';
import 'package:jewellery_customer/core/storage/storage_keys.dart';
import 'package:jewellery_customer/core/tenant/tenant_config.dart';
import 'package:jewellery_customer/data/api/api_repositories.dart';
import 'package:jewellery_customer/data/models/commerce.dart';
import 'package:jewellery_customer/data/repositories/repositories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef _Reply = (int status, Object? body);

/// Answers requests from a table of `METHOD path` → reply, and records what
/// was asked, so the wire contract with the storefront API is what is tested.
class _FakeBackend implements HttpClientAdapter {
  final replies = <String, _Reply Function(RequestOptions)>{};
  final requests = <RequestOptions>[];

  void on(String route, _Reply Function(RequestOptions) reply) => replies[route] = reply;

  int count(String route) =>
      requests.where((r) => '${r.method} ${r.uri.path}' == route).length;

  RequestOptions last(String route) =>
      requests.lastWhere((r) => '${r.method} ${r.uri.path}' == route);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final reply = replies['${options.method} ${options.uri.path}'];
    final (status, body) = reply == null ? (404, {'message': 'no route'}) : reply(options);
    final payload = status < 400
        ? {'success': true, 'data': body}
        : body;
    return ResponseBody.fromString(
      jsonEncode(payload),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Map<String, dynamic> _product(String id, {num price = 1000, bool featured = false}) => {
  'id': id,
  'itemCode': 'IT-$id',
  'productName': 'Ring $id',
  'categoryId': 'rings',
  'categoryName': 'Rings',
  'metalName': 'Gold',
  'purityCode': '22K',
  'price': price,
  'currency': 'LAK',
  'images': <String>[],
  'retail': {'isFeatured': featured},
};

void main() {
  late _FakeBackend backend;
  late LocalStore local;
  late ApiClient client;
  late int expired;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    local = await LocalStore.create();
    backend = _FakeBackend();
    expired = 0;
    final dio = DioClient.create(
      config: const AppConfig(
        environment: Environment.prod,
        apiBaseUrl: 'http://backend.test',
        tenantKey: 'fino',
        dataMode: DataMode.api,
      ),
      tenantKey: 'fino',
      readToken: () => local.getJson(StorageKeys.session)?['token'] as String?,
      onSessionExpired: () => expired++,
    )..httpClientAdapter = backend;
    client = ApiClient(dio);
  });

  Future<void> signIn() => local.setJson(StorageKeys.session, {
    'account': {'id': 'c1', 'name': 'Noy', 'phone': '+85620'},
    'token': 'tok-1',
  });

  test('the catalogue is fetched once, tenant-scoped, and filtered on the device', () async {
    backend.on('GET /api/v1/public/catalogue/items', (_) => (200, [
      _product('a', price: 3000),
      _product('b', price: 1000, featured: true),
    ]));
    final repo = ApiCatalogueRepository(ApiCatalogueCache(client));

    final cheapFirst = await repo.list(const CatalogueQuery(sort: CatalogueSort.priceAsc));
    final featured = await repo.featured();
    final bounds = await repo.priceBounds(categoryId: 'rings');

    expect(cheapFirst.map((i) => i.id), ['b', 'a']);
    expect(featured.single.id, 'b');
    expect((bounds.min, bounds.max), (1000, 3000));
    expect(await repo.byId('missing'), isNull);
    expect(backend.count('GET /api/v1/public/catalogue/items'), 1);
    final sent = backend.last('GET /api/v1/public/catalogue/items');
    expect(sent.headers[DioClient.tenantHeader], 'fino');
    expect(sent.headers.containsKey('Authorization'), isFalse);
  });

  test('a failed catalogue fetch is not cached', () async {
    var calls = 0;
    backend.on('GET /api/v1/public/catalogue/items', (_) {
      calls++;
      return calls == 1 ? (500, {'message': 'boom'}) : (200, [_product('a')]);
    });
    final repo = ApiCatalogueRepository(ApiCatalogueCache(client));

    await expectLater(repo.list(), throwsA(isA<ServerException>()));
    expect((await repo.list()).single.id, 'a');
  });

  test('OTP verify persists the session and the token rides on later calls', () async {
    backend
      ..on('POST /api/v1/customer-auth/otp/request', (_) => (200, {
        'phone': '+8562055550142',
        'expiresInSeconds': 120,
        'resendAfterSeconds': 20,
      }))
      ..on('POST /api/v1/customer-auth/otp/verify', (r) {
        final code = (r.data as Map)['code'];
        return code == '123456'
            ? (200, {
                'account': {'id': 'c1', 'name': '', 'phone': '+8562055550142'},
                'token': 'tok-1',
              })
            : (401, {'message': 'That code is not right'});
      })
      ..on('PUT /api/v1/storefront/me', (r) => (200, {
        'id': 'c1',
        'name': (r.data as Map)['name'],
        'phone': '+8562055550142',
      }));
    final auth = ApiAuthRepository(client, local);

    final challenge = await auth.requestOtp('+856 20 5555 0142');
    expect(challenge.expiresIn, const Duration(seconds: 120));
    expect(challenge.resendAfter, const Duration(seconds: 20));

    await expectLater(
      auth.verifyOtp('+856 20 5555 0142', '000000'),
      throwsA(isA<OtpRejectedException>()),
    );
    expect(expired, 0, reason: 'a wrong code is not an expired session');

    final session = await auth.verifyOtp('+856 20 5555 0142', '123456');
    expect(session.account!.needsProfile, isTrue);
    expect((await auth.restore())!.token, 'tok-1');

    final named = await auth.updateProfile(session.account!.copyWith(name: 'Noy'));
    expect(named.account!.name, 'Noy');
    expect(named.token, 'tok-1', reason: 'the profile response carries no token');
    expect(
      backend.last('PUT /api/v1/storefront/me').headers['Authorization'],
      'Bearer tok-1',
    );
  });

  test('a guest bag stays on the device and moves to the account on sign-in', () async {
    final server = <Map<String, dynamic>>[
      {'productId': 'a', 'quantity': 1},
    ];
    backend
      ..on('GET /api/v1/storefront/cart', (_) => (200, server))
      ..on('PUT /api/v1/storefront/cart', (r) {
        server
          ..clear()
          ..addAll((r.data as List).cast<Map<String, dynamic>>());
        return (200, server);
      });
    final cart = ApiCartRepository(client, local);

    await cart.save(const [
      CartItem(productId: 'a', quantity: 1),
      CartItem(productId: 'b', quantity: 1, size: '12'),
    ]);
    expect(backend.requests, isEmpty);
    expect((await cart.items()).length, 2);

    await signIn();
    final merged = await cart.items();
    expect(merged.map((i) => i.productId), ['a', 'b']);
    expect(local.getJsonList(StorageKeys.guestCart), isNull);

    await cart.items();
    expect(backend.count('PUT /api/v1/storefront/cart'), 1, reason: 'merged once');
  });

  test('guests read empty account data without calling the backend', () async {
    expect(await ApiOrderRepository(client, ApiCatalogueCache(client), local).list(), isEmpty);
    expect(await ApiAddressRepository(client, local).list(), isEmpty);
    expect(await ApiPaymentMethodRepository(client, local).list(), isEmpty);
    expect(await ApiNotificationRepository(client, local).list(), isEmpty);
    expect(backend.requests, isEmpty);
  });

  test('an order carries choices, not amounts, and a sold piece is a rejection', () async {
    await signIn();
    var catalogueReads = 0;
    backend
      ..on('GET /api/v1/public/catalogue/items', (_) {
        catalogueReads++;
        return (200, [_product('a', price: 5000)]);
      })
      ..on('POST /api/v1/storefront/orders', (_) => (201, {
        'id': 'FINO-100001',
        'date': '2026-09-18T10:00:00Z',
        'status': 'placed',
        'items': [
          {'productId': 'a', 'name': 'Ring a', 'image': '', 'price': 5000, 'quantity': 1},
        ],
        'subtotal': 5000,
        'shipping': 0,
        'tax': 350,
        'total': 5350,
        'address': '48 Setthathirath Rd, Vientiane 01000',
        'paymentKind': 'cod',
      }));
    final cache = ApiCatalogueCache(client);
    final product = (await ApiCatalogueRepository(cache).byId('a'))!;
    final orders = ApiOrderRepository(client, cache, local);
    final draft = OrderDraft(
      lines: [CartLine(product: product, quantity: 1, size: '12')],
      address: const Address(
        id: 'addr-1',
        label: AddressLabel.home,
        name: 'Noy',
        line1: '48 Setthathirath Rd',
        city: 'Vientiane',
        postcode: '01000',
        phone: '+85620',
        isDefault: true,
      ),
      payment: const PaymentMethod(
        id: 'pay-1',
        kind: PaymentKind.cod,
        label: 'Cash on delivery',
        detail: '',
        isDefault: true,
      ),
      subtotal: 5000,
      shipping: 0,
      tax: 350,
      total: 5350,
      offerCode: 'SPARKLE20',
    );

    final order = await orders.place(draft);
    expect(order.id, 'FINO-100001');
    expect(order.total, 5350);
    expect(backend.last('POST /api/v1/storefront/orders').data, {
      'lines': [
        {'productId': 'a', 'quantity': 1, 'size': '12'},
      ],
      'addressId': 'addr-1',
      'paymentMethodId': 'pay-1',
      'offerCode': 'SPARKLE20',
    });

    await cache.items();
    expect(catalogueReads, 2, reason: 'what is for sale changed');

    backend.on('POST /api/v1/storefront/orders', (_) => (409, {
      'code': 'CONFLICT',
      'message': 'A piece in your bag is no longer available',
    }));
    await expectLater(
      orders.place(draft),
      throwsA(
        isA<RejectedException>()
            .having((e) => e.isConflict, 'isConflict', isTrue)
            .having((e) => e.message, 'message', contains('no longer available')),
      ),
    );
  });

  test('a refused token reports the session as expired', () async {
    await signIn();
    backend.on('GET /api/v1/storefront/orders', (_) => (401, {'message': 'Sign in again'}));

    await expectLater(
      ApiOrderRepository(client, ApiCatalogueCache(client), local).list(),
      throwsA(isA<UnauthorizedException>()),
    );
    expect(expired, 1);
  });

  test('content documents are fetched once per kind and parsed by the models', () async {
    backend
      ..on('GET /api/v1/public/content/offers', (_) => (200, [
        {'id': 'O1', 'code': 'SPARKLE20', 'title': 'Sparkle', 'subtitle': '', 'kind': 'percent', 'value': 20},
      ]))
      ..on('GET /api/v1/public/content/about', (_) => (200, <String, dynamic>{}))
      ..on('GET /api/v1/public/gold-rates', (_) => (200, {
        'rates': [
          {'purityCode': '22K', 'label': '22K', 'rates': {'LAK': 960000}},
        ],
        'updatedAt': '2026-09-18T03:00:00Z',
      }));
    final content = ApiContentCache(client);
    final offers = ApiOfferRepository(content);

    expect((await offers.byCode(' sparkle20 '))!.discountFor(1000), 200);
    expect(await offers.byCode('nope'), isNull);
    expect(backend.count('GET /api/v1/public/content/offers'), 1);
    expect((await ApiContentRepository(content).about()).intro, '');
    final sheet = await ApiGoldRateRepository(client).current();
    expect(sheet.byPurity('22K')!['LAK'], 960000);
  });

  test('a tenant config without palettes falls back to a built-in one', () {
    final config = TenantConfig.fromJson({
      'key': 'acme',
      'brandName': 'Acme Gold',
      'currency': {'code': 'LAK', 'symbol': '₭'},
      'paletteId': 'emerald',
    });
    expect(config.paletteId, 'emerald');
    expect(config.brandMark, 'Acme Gold');
    expect(config.palette.primary, isNot(config.darkPalette.bg));
  });
}

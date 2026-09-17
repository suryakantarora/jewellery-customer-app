import 'package:flutter_test/flutter_test.dart';
import 'package:jewellery_customer/core/storage/local_store.dart';
import 'package:jewellery_customer/data/demo/demo_repositories.dart';
import 'package:jewellery_customer/data/demo/demo_store.dart';
import 'package:jewellery_customer/data/models/content.dart';
import 'package:jewellery_customer/data/repositories/repositories.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final store = DemoStore(latency: Duration.zero);
  late LocalStore local;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    local = await LocalStore.create();
  });

  test('gold rates: seven rows in LAK / USD / THB, 22K present', () async {
    final sheet = await DemoGoldRateRepository(store).current();
    expect(sheet.rates, hasLength(7));
    expect(sheet.byPurity('22K')?['LAK'], greaterThan(0));
    for (final r in sheet.rates) {
      expect(r.rates.keys, containsAll(['LAK', 'USD', 'THB']));
    }
  });

  test('policies: six documents with sections and faqs', () async {
    final repo = DemoPolicyRepository(store);
    final docs = await repo.list();
    expect(docs.map((d) => d.key), [
      'return',
      'exchange',
      'repair',
      'shipping',
      'emi',
      'help',
    ]);
    final shipping = await repo.byKey('shipping');
    expect(shipping!.sections.any((s) => s.table.isNotEmpty), isTrue);
    expect(shipping.sections.any((s) => s.steps.isNotEmpty), isTrue);
    expect(shipping.faqs, isNotEmpty);
    expect(await repo.byKey('nope'), isNull);
  });

  test('stores: five boutiques, one flagship, coordinates in Laos', () async {
    final stores = await DemoStoreRepository(store).list();
    expect(stores, hasLength(5));
    expect(stores.where((s) => s.flagship), hasLength(1));
    for (final s in stores) {
      expect(s.latitude, inInclusiveRange(13, 23));
      expect(s.longitude, inInclusiveRange(100, 108));
    }
  });

  test(
    'offers: unexpired only, byCode is case-insensitive, discount rules',
    () async {
      final repo = DemoOfferRepository(store);
      final offers = await repo.list();
      expect(offers.every((o) => !o.expired), isTrue);
      final sparkle = await repo.byCode('sparkle20');
      expect(sparkle!.kind, OfferKind.percent);
      expect(sparkle.discountFor(1_000_000), 0, reason: 'below minimum');
      expect(sparkle.discountFor(10_000_000), 2_000_000);
      final bridal = await repo.byCode('BRIDAL500');
      expect(bridal!.discountFor(12_000_000), 500_000);
      expect(await repo.byCode('NOPE'), isNull);
    },
  );

  test('content: brands, trending cards, stories, about', () async {
    final repo = DemoContentRepository(store);
    expect(await repo.brands(), hasLength(4));
    expect(
      (await repo.trending()).every((t) => t.link.startsWith('/')),
      isTrue,
    );
    expect(await repo.stories(), hasLength(6));
    final about = await repo.about();
    expect(about.sections, hasLength(5));
    expect(about.stats, isNotEmpty);
  });

  test('notifications: read state persists; mark all', () async {
    final repo = DemoNotificationRepository(store, local);
    final list = await repo.list();
    expect(list, hasLength(6));
    expect(
      list.first.date.isAfter(list.last.date),
      isTrue,
      reason: 'newest first',
    );
    final unreadBefore = list.where((n) => !n.read).length;
    expect(unreadBefore, 3);

    await repo.markRead('N1');
    final again = await DemoNotificationRepository(store, local).list();
    expect(again.firstWhere((n) => n.id == 'N1').read, isTrue);
    expect(again.where((n) => !n.read).length, unreadBefore - 1);

    await repo.markAllRead();
    expect((await repo.list()).every((n) => n.read), isTrue);

    await repo.registerDevice(token: 'abc', platform: 'ios');
    expect(local.getString('push.token'), 'ios:abc');
  });

  test('feedback: ticket reference and rating are stored', () async {
    final repo = DemoFeedbackRepository(local);
    final ticket = await repo.submit(
      const FeedbackDraft(
        happy: true,
        topic: 'App experience',
        message: 'Lovely app, thank you.',
      ),
    );
    expect(ticket, matches(RegExp(r'^FB-2\d{4}$')));
    expect(local.getJsonList('demo.feedback'), hasLength(1));
    await repo.rate(5);
    expect(local.getJson('demo.feedback.rating')?['stars'], 5);
  });

  test('catalogue: metal, tag and brand scopes; coins category', () async {
    final catalogue = DemoCatalogueRepository(store);
    final diamond = await catalogue.list(
      const CatalogueQuery(metals: ['Diamond']),
    );
    expect(diamond, hasLength(9));
    expect(diamond.every((i) => i.metalName == 'Diamond'), isTrue);

    final solitaire = await catalogue.list(
      const CatalogueQuery(tag: 'solitaire'),
    );
    expect(solitaire, isNotEmpty);
    expect(solitaire.every((i) => i.retail.tags.contains('solitaire')), isTrue);

    final gifts = await catalogue.list(const CatalogueQuery(tag: 'gift'));
    expect(gifts.length, greaterThan(10));

    final lumiere = await catalogue.list(
      const CatalogueQuery(brand: 'Lumière'),
    );
    expect(lumiere.every((i) => i.retail.brand == 'Lumière'), isTrue);

    final coins = await catalogue.list(
      const CatalogueQuery(categoryId: 'coins'),
    );
    expect(coins, hasLength(6));
    expect(coins.every((i) => i.purityCode == '24K'), isTrue);

    final search = await catalogue.list(const CatalogueQuery(search: 'aurum'));
    expect(search, isNotEmpty, reason: 'brand is searchable');
  });
}

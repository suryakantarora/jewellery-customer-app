import 'package:flutter_test/flutter_test.dart';
import 'package:jewellery_customer/data/demo/demo_repositories.dart';
import 'package:jewellery_customer/data/demo/demo_store.dart';
import 'package:jewellery_customer/data/repositories/repositories.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final store = DemoStore(latency: Duration.zero);
  final catalogue = DemoCatalogueRepository(store);
  final categories = DemoCategoryRepository(store);
  final banners = DemoBannerRepository(store);

  test('loads 75 items covering every metal, purity and stone', () async {
    final items = await catalogue.list();
    expect(items, hasLength(75));
    expect(items.map((i) => i.id).toSet(), hasLength(75), reason: 'ids unique');

    expect(
      items.map((i) => i.metalName).toSet(),
      {'Gold', 'White Gold', 'Rose Gold', 'Platinum', 'Silver', 'Diamond'},
    );
    expect(
      items.map((i) => i.purityCode).toSet(),
      {'925', '14K', '18K', '22K', '24K', 'PT950', 'VVS1', 'VVS2', 'VS1', 'VS2', 'SI1'},
    );
    expect(
      items.map((i) => i.retail.stone).toSet(),
      {'Diamond', 'Ruby', 'Emerald', 'Sapphire', 'Pearl', 'Tourmaline', 'None'},
    );
    expect(items.map((i) => i.categoryId).toSet(), hasLength(9));
    for (final item in items) {
      expect(item.heroImage.isEmpty, isFalse, reason: '${item.id} has an image');
      expect(item.price, greaterThan(0));
      expect(item.currency, 'LAK');
    }
  });

  test('9 categories with counts derived from the catalogue', () async {
    final list = await categories.list();
    expect(list, hasLength(9));
    expect(list.fold<int>(0, (n, c) => n + c.productCount), 75);
    expect(list.first.name.en, isNotEmpty);
    expect((await categories.byId('rings'))?.productCount, greaterThan(0));
  });

  test('5 banners, four hero and one promo', () async {
    final list = await banners.list();
    expect(list, hasLength(5));
    expect(list.where((b) => b.placement.name == 'promo'), hasLength(1));
  });

  test('query filters and sorts', () async {
    final rings = await catalogue.list(const CatalogueQuery(categoryId: 'rings'));
    expect(rings.every((i) => i.categoryId == 'rings'), isTrue);

    final platinum = await catalogue.list(
      const CatalogueQuery(metals: ['Platinum'], sort: CatalogueSort.priceAsc),
    );
    expect(platinum.every((i) => i.metalName == 'Platinum'), isTrue);
    for (var i = 1; i < platinum.length; i++) {
      expect(platinum[i].price >= platinum[i - 1].price, isTrue);
    }

    final search = await catalogue.list(const CatalogueQuery(search: 'ruby'));
    expect(search, isNotEmpty);
    expect(await catalogue.byId('FINO-001'), isNotNull);
    expect(await catalogue.related('FINO-001', limit: 4), hasLength(4));
  });

  test('simulated latency is applied per read', () async {
    final slow = DemoCatalogueRepository(
      DemoStore(latency: const Duration(milliseconds: 50)),
    );
    final watch = Stopwatch()..start();
    await slow.featured();
    expect(watch.elapsedMilliseconds, greaterThanOrEqualTo(45));
  });
}

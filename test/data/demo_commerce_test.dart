import 'package:flutter_test/flutter_test.dart';
import 'package:jewellery_customer/core/storage/local_store.dart';
import 'package:jewellery_customer/data/demo/demo_repositories.dart';
import 'package:jewellery_customer/data/demo/demo_store.dart';
import 'package:jewellery_customer/data/models/commerce.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalStore local;
  final store = DemoStore(latency: Duration.zero);

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    local = await LocalStore.create();
  });

  group('auth', () {
    test('any 6 digits verify; seeded phone signs in as the demo customer', () async {
      final auth = DemoAuthRepository(store, local);
      expect(await auth.restore(), isNull);

      final challenge = await auth.requestOtp('+856 20 5555 0142');
      expect(challenge.resendAfter.inSeconds, 30);

      final session = await auth.verifyOtp('+856 20 5555 0142', '123456');
      expect(session.isCustomer, isTrue);
      expect(session.account!.name, 'Suryakant Kumar');
      expect(session.account!.needsProfile, isFalse);
      expect((await auth.restore())?.account?.id, session.account!.id);

      await auth.signOut();
      expect(await auth.restore(), isNull);
    });

    test('unknown phone creates an account that needs a profile', () async {
      final auth = DemoAuthRepository(store, local);
      final session = await auth.verifyOtp('+856 20 9999 0000', '000000');
      expect(session.account!.needsProfile, isTrue);

      final updated = await auth.updateProfile(session.account!.copyWith(name: 'Noy'));
      expect(updated.account!.name, 'Noy');
      // Signing in again with the same number remembers the name.
      await auth.signOut();
      final again = await auth.verifyOtp('+856 20 9999 0000', '111111');
      expect(again.account!.name, 'Noy');
    });

    test('wrong-shaped code is rejected; guest mode persists', () async {
      final auth = DemoAuthRepository(store, local);
      expect(() => auth.verifyOtp('+856 20 1', '12'), throwsA(isA<OtpRejectedException>()));
      final guest = await auth.continueAsGuest();
      expect(guest.isGuest, isTrue);
      expect((await auth.restore())?.isGuest, isTrue);
    });
  });

  test('cart and wishlist round-trip through local storage', () async {
    final cart = DemoCartRepository(local);
    await cart.save(const [CartItem(productId: 'FINO-001', quantity: 2, size: '7')]);
    final items = await DemoCartRepository(local).items();
    expect(items.single.quantity, 2);
    expect(items.single.size, '7');

    final wishlist = DemoWishlistRepository(local);
    await wishlist.save([WishlistItem(productId: 'FINO-002', addedAt: DateTime(2026, 9, 1))]);
    expect((await wishlist.items()).single.productId, 'FINO-002');
  });

  group('orders', () {
    test('seeded orders, newest first; placing prepends and persists', () async {
      final orders = DemoOrderRepository(store, local);
      final list = await orders.list();
      expect(list, hasLength(5));
      expect(list.first.id, 'FINO-100482');
      expect(list.map((o) => o.status).toSet(), contains(OrderStatus.cancelled));
      expect((await orders.byId('FINO-100455'))?.eta?.en, 'Arriving today by 18:00');

      final catalogue = DemoCatalogueRepository(store);
      final product = (await catalogue.byId('FINO-002'))!;
      final placed = await orders.place(
        OrderDraft(
          lines: [CartLine(product: product, quantity: 1)],
          address: const Address(
            id: 'A1', label: AddressLabel.home, name: 'N', line1: 'L', city: 'C',
            postcode: '01000', phone: '+856', isDefault: true,
          ),
          payment: const PaymentMethod(id: 'P4', kind: PaymentKind.cod, label: 'COD', detail: '', isDefault: true),
          subtotal: product.price, shipping: 0, tax: 1, total: product.price + 1,
        ),
      );
      expect(placed.status, OrderStatus.placed);
      expect(placed.trackingNumber, startsWith('LX-'));
      final after = await DemoOrderRepository(store, local).list();
      expect(after, hasLength(6));
      expect(after.first.id, placed.id);
    });

    test('status stage index: cancelled stops after placed', () {
      expect(OrderStatus.placed.stageIndex, 0);
      expect(OrderStatus.shipped.stageIndex, 3);
      expect(OrderStatus.delivered.stageIndex, 4);
      expect(OrderStatus.cancelled.stageIndex, 0);
      expect(OrderStatus.packed.isActive, isTrue);
      expect(OrderStatus.delivered.isActive, isFalse);
    });
  });

  test('addresses: save, default handling, delete', () async {
    final repo = DemoAddressRepository(store, local);
    expect(await repo.list(), hasLength(2));

    final saved = await repo.save(
      const Address(
        id: '', label: AddressLabel.other, name: 'X', line1: 'Y', city: 'Z',
        postcode: '', phone: '', isDefault: true,
      ),
    );
    expect(saved, hasLength(3));
    expect(saved.where((a) => a.isDefault), hasLength(1));
    expect(saved.last.isDefault, isTrue);
    expect(saved.last.id, isNotEmpty);

    final afterDelete = await repo.delete(saved.last.id);
    expect(afterDelete, hasLength(2));
    expect(afterDelete.where((a) => a.isDefault), hasLength(1));

    final defaulted = await repo.setDefault('A2');
    expect(defaulted.firstWhere((a) => a.id == 'A2').isDefault, isTrue);
    expect(defaulted.firstWhere((a) => a.id == 'A1').isDefault, isFalse);
  });

  test('payment methods: four seeded; remove keeps a default', () async {
    final repo = DemoPaymentMethodRepository(store, local);
    final list = await repo.list();
    expect(list, hasLength(4));
    expect(list.map((p) => p.kind).toSet(), {PaymentKind.card, PaymentKind.wallet, PaymentKind.cod});
    final removed = await repo.remove('P1');
    expect(removed, hasLength(3));
    expect(removed.where((p) => p.isDefault), hasLength(1));
  });

  test('catalogue byIds and priceBounds', () async {
    final catalogue = DemoCatalogueRepository(store);
    final two = await catalogue.byIds(['FINO-003', 'FINO-001']);
    expect(two.map((i) => i.id), ['FINO-003', 'FINO-001']);
    final bounds = await catalogue.priceBounds(categoryId: 'rings');
    expect(bounds.max, greaterThan(bounds.min));
    final all = await catalogue.priceBounds();
    expect(all.max, greaterThanOrEqualTo(bounds.max));
  });
}

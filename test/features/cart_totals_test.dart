import 'package:flutter_test/flutter_test.dart';
import 'package:jewellery_customer/core/media/image_ref.dart';
import 'package:jewellery_customer/core/tenant/tenant_config.dart';
import 'package:jewellery_customer/core/theme/palettes.dart';
import 'package:jewellery_customer/data/models/catalogue_item.dart';
import 'package:jewellery_customer/data/models/commerce.dart';
import 'package:jewellery_customer/data/models/retail_attributes.dart';
import 'package:jewellery_customer/features/cart/cart_provider.dart';

CatalogueItem item(String id, num price, {num? original}) => CatalogueItem(
  id: id,
  itemCode: id,
  productName: id,
  categoryId: 'rings',
  categoryName: 'Rings',
  designName: '',
  metalName: 'Gold',
  purityCode: '18K',
  purityName: '18K',
  grossWeight: 1,
  netMetalWeight: 1,
  stoneCount: 0,
  totalCarat: 0,
  hallmarkNumber: null,
  price: price,
  currency: 'LAK',
  primaryImageKey: ImageRef.none,
  fallbackImageKey: ImageRef.none,
  images: const [],
  retail: RetailAttributes(originalPrice: original),
);

TenantConfig tenant() => TenantConfig(
  key: 't',
  brandName: 'T',
  brandMark: 'T',
  tagline: '',
  logoLight: ImageRef.none,
  logoDark: ImageRef.none,
  paletteId: 'ruby',
  palette: FallbackPalettes.ruby.light,
  darkPalette: FallbackPalettes.ruby.dark,
  fontDisplay: 'PlayfairDisplay',
  fontBody: 'Inter',
  currency: const TenantCurrency(
    code: 'LAK',
    symbol: '₭',
    decimals: 0,
    symbolFirst: true,
    locale: 'en_US',
  ),
  supportedLocales: const ['en'],
  defaultLocale: 'en',
  contact: const TenantContact(),
  featureFlags: const {},
  freeDeliveryThreshold: 500000,
  deliveryFee: 25000,
  taxRate: .07,
  allowedPalettes: const [],
  phoneCountryCode: '+856',
);

void main() {
  test('shipping charged below the threshold, free above; tax 7%; savings summed', () {
    final t = tenant();
    final small = CartTotals.compute(
      [CartLine(product: item('a', 100000, original: 120000), quantity: 2)],
      t,
    );
    expect(small.subtotal, 200000);
    expect(small.savings, 40000);
    expect(small.shipping, 25000);
    expect(small.tax, 14000);
    expect(small.total, 239000);
    expect(small.freeDelivery, isFalse);
    expect(small.remainingForFreeDelivery, 300000);
    expect(small.freeDeliveryProgress, closeTo(.4, 1e-9));

    final big = CartTotals.compute([CartLine(product: item('b', 600000), quantity: 1)], t);
    expect(big.shipping, 0);
    expect(big.freeDelivery, isTrue);
    expect(big.total, 642000);

    final empty = CartTotals.compute(const [], t);
    expect(empty.shipping, 0);
    expect(empty.total, 0);
  });

  test('order and session models round-trip through JSON', () {
    final order = Order(
      id: 'X-1',
      date: DateTime(2026, 9, 16),
      status: OrderStatus.shipped,
      items: const [
        OrderItem(productId: 'p', name: 'n', image: ImageRef.none, price: 10, quantity: 2, size: '7'),
      ],
      subtotal: 20,
      shipping: 0,
      tax: 1,
      total: 21,
      address: 'A',
      paymentKind: PaymentKind.wallet,
      courier: 'C',
      trackingNumber: 'T',
    );
    final back = Order.fromJson(order.toJson());
    expect(back.status, OrderStatus.shipped);
    expect(back.items.single.size, '7');
    expect(back.itemCount, 2);
    expect(back.paymentKind, PaymentKind.wallet);

    final session = CustomerSession.customer(
      account: const Account(id: 'c', name: 'N', phone: '+856'),
    );
    expect(CustomerSession.fromJson(session.toJson()).account?.name, 'N');
    expect(CustomerSession.fromJson(const CustomerSession.guest().toJson()).isGuest, isTrue);
  });
}

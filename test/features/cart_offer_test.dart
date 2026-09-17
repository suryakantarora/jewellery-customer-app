import 'package:flutter_test/flutter_test.dart';
import 'package:jewellery_customer/data/models/commerce.dart';
import 'package:jewellery_customer/data/models/content.dart';
import 'package:jewellery_customer/data/models/localized_text.dart';
import 'package:jewellery_customer/features/cart/cart_provider.dart';

import 'cart_totals_test.dart' show item, tenant;

Offer offer(OfferKind kind, num value, {num min = 0}) => Offer(
  id: 'o',
  code: 'CODE',
  title: LocalizedText.empty,
  subtitle: LocalizedText.empty,
  kind: kind,
  value: value,
  minSubtotal: min,
  expires: DateTime(2100),
);

void main() {
  final t = tenant();
  final lines = [CartLine(product: item('a', 1_000_000), quantity: 1)];

  test('percent offer discounts the subtotal and tax follows', () {
    final totals = CartTotals.compute(
      lines,
      t,
      offer: offer(OfferKind.percent, 20),
    );
    expect(totals.discount, 200_000);
    expect(totals.tax, ((1_000_000 - 200_000) * .07).round());
    expect(totals.total, 800_000 + totals.tax);
    expect(totals.offerIneligible, isFalse);
  });

  test('amount offer below its minimum is kept but not applied', () {
    final totals = CartTotals.compute(
      lines,
      t,
      offer: offer(OfferKind.amount, 500_000, min: 5_000_000),
    );
    expect(totals.discount, 0);
    expect(totals.offerIneligible, isTrue);
    expect(
      totals.total,
      1_000_000 + totals.tax,
      reason: 'subtotal is over the free-delivery threshold',
    );
  });

  test('free-delivery offer waives shipping under the threshold', () {
    final small = [CartLine(product: item('b', 100_000), quantity: 1)];
    expect(CartTotals.compute(small, t).shipping, 25_000);
    expect(
      CartTotals.compute(
        small,
        t,
        offer: offer(OfferKind.freeDelivery, 0),
      ).shipping,
      0,
    );
  });

  test('expired offers report as expired', () {
    final old = Offer(
      id: 'x',
      code: 'OLD',
      title: LocalizedText.empty,
      subtitle: LocalizedText.empty,
      kind: OfferKind.percent,
      value: 5,
      minSubtotal: 0,
      expires: DateTime(2000),
    );
    expect(old.expired, isTrue);
  });
}

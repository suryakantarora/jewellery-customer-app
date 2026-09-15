import 'package:flutter_test/flutter_test.dart';
import 'package:jewellery_customer/core/format/money_formatter.dart';
import 'package:jewellery_customer/core/tenant/tenant_config.dart';

void main() {
  const kip = TenantCurrency(
    code: 'LAK',
    symbol: '₭',
    decimals: 0,
    symbolFirst: true,
    locale: 'en_US',
  );

  group('MoneyFormatter', () {
    test('formats Kip with symbol first and no decimals', () {
      final f = MoneyFormatter(kip);
      expect(f.format(1234567), '₭ 1,234,567');
      expect(f.format(0), '₭ 0');
      expect(f.format(4520000.4), '₭ 4,520,000');
    });

    test('honours decimals and symbol-after currencies', () {
      const thb = TenantCurrency(
        code: 'THB',
        symbol: '฿',
        decimals: 2,
        symbolFirst: false,
        locale: 'en_US',
      );
      expect(MoneyFormatter(thb).format(1234.5), '1,234.50 ฿');
    });

    test('per-call decimals override and plain()', () {
      final f = MoneyFormatter(kip);
      expect(f.format(82.4, decimals: 2), '₭ 82.40');
      expect(f.plain(500000), '500,000');
    });
  });
}

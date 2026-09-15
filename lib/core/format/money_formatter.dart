import 'package:intl/intl.dart';

import '../tenant/tenant_config.dart';

/// Formats amounts the way the tenant's currency dictates.
///
/// Kip: `₭ 1,234,567` (0 decimals, symbol first, `en-US` grouping).
class MoneyFormatter {
  MoneyFormatter(this.currency)
    : _number = NumberFormat.decimalPatternDigits(
        locale: currency.locale,
        decimalDigits: currency.decimals,
      );

  final TenantCurrency currency;
  final NumberFormat _number;

  String format(num amount, {int? decimals}) {
    final digits = decimals == null
        ? _number
        : NumberFormat.decimalPatternDigits(
            locale: currency.locale,
            decimalDigits: decimals,
          );
    final body = digits.format(amount);
    return currency.symbolFirst
        ? '${currency.symbol} $body'
        : '$body ${currency.symbol}';
  }

  /// Without the symbol, for tables where the column header carries it.
  String plain(num amount) => _number.format(amount);
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/locale_provider.dart';
import '../tenant/tenant_provider.dart';
import 'date_formatter.dart';
import 'money_formatter.dart';

/// Money formatting follows the tenant's currency, never the device.
final moneyFormatterProvider = Provider<MoneyFormatter>((ref) {
  final tenant = ref.watch(tenantProvider).requireValue;
  return MoneyFormatter(tenant.currency);
});

final dateFormatterProvider = Provider<DateFormatter>((ref) {
  final locale = ref.watch(localeProvider);
  return DateFormatter(locale.toLanguageTag());
});

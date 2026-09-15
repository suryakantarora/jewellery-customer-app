import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import '../storage/storage_keys.dart';
import '../tenant/tenant_provider.dart';

/// Locales the binary has ARB files for.
const appLocales = <Locale>[Locale('en'), Locale('lo')];

/// Native-script names for the language picker.
const localeNativeNames = <String, String>{'en': 'English', 'lo': 'ພາສາລາວ'};
const localeEnglishNames = <String, String>{'en': 'English', 'lo': 'Lao'};

/// Locales offered to the user: the tenant's list, restricted to what ships.
final offeredLocalesProvider = Provider<List<Locale>>((ref) {
  final tenant = ref.watch(tenantProvider).valueOrNull;
  if (tenant == null) return appLocales;
  final offered = appLocales
      .where((l) => tenant.supportedLocales.contains(l.languageCode))
      .toList();
  return offered.isEmpty ? appLocales : offered;
});

/// Active language: persisted choice → tenant default → English.
class LocaleController extends Notifier<Locale> {
  @override
  Locale build() {
    final offered = ref.watch(offeredLocalesProvider);
    final stored = ref.read(localStoreProvider).getString(StorageKeys.locale);
    final match = offered.where((l) => l.languageCode == stored).firstOrNull;
    if (match != null) return match;

    final tenantDefault = ref.watch(tenantProvider).valueOrNull?.defaultLocale;
    return offered.firstWhere(
      (l) => l.languageCode == tenantDefault,
      orElse: () => offered.first,
    );
  }

  Future<void> set(Locale locale) async {
    state = locale;
    await ref
        .read(localStoreProvider)
        .setString(StorageKeys.locale, locale.languageCode);
  }
}

final localeProvider = NotifierProvider<LocaleController, Locale>(
  LocaleController.new,
);

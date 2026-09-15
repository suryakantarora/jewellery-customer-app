import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every English key exists in Lao', () {
    Map<String, dynamic> load(String path) =>
        jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;

    final en = load('lib/l10n/app_en.arb');
    final lo = load('lib/l10n/app_lo.arb');

    final keys = en.keys.where((k) => !k.startsWith('@')).toSet();
    final missing = keys.where((k) => !lo.containsKey(k)).toList();
    expect(missing, isEmpty, reason: 'missing in app_lo.arb: $missing');

    final untranslated = keys
        .where((k) => lo[k] == en[k] && !_allowedSame.contains(k))
        .toList();
    expect(untranslated, isEmpty, reason: 'still English in lo: $untranslated');
  });
}

/// Placeholders-only strings are legitimately identical.
const _allowedSame = {'splashTagline'};

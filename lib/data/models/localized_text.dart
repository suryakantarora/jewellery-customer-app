import 'dart:ui';

/// Data-carried copy (category names, banner headlines) keyed by language.
/// UI chrome lives in ARB; this is for content the backend will serve.
class LocalizedText {
  const LocalizedText(this._values);

  final Map<String, String> _values;

  static const empty = LocalizedText({});

  factory LocalizedText.fromJson(Object? json) {
    if (json is String) return LocalizedText({'en': json});
    if (json is Map) {
      return LocalizedText(
        json.map((k, v) => MapEntry(k.toString(), v.toString())),
      );
    }
    return empty;
  }

  String resolve(Locale locale) =>
      _values[locale.languageCode] ?? _values['en'] ?? _values.values.firstOrNull ?? '';

  String get en => _values['en'] ?? '';

  bool get isEmpty => _values.isEmpty;
}

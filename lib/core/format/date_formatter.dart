import 'package:intl/intl.dart';

/// Locale-aware dates. `2 Aug 2026` in English, Lao digits/month names when
/// the locale is `lo`.
class DateFormatter {
  DateFormatter(this.localeTag);

  final String localeTag;

  String short(DateTime date) => DateFormat.yMMMd(localeTag).format(date);
  String long(DateTime date) => DateFormat.yMMMMEEEEd(localeTag).format(date);
  String time(DateTime date) => DateFormat.Hms(localeTag).format(date);
}

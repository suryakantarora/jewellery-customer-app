import 'dart:ui';

/// Parses the colour notations the tenant config may use:
/// `#rgb`, `#rrggbb`, `#aarrggbb`, `rgb(r,g,b)` and `rgba(r,g,b,a)`.
Color parseColor(String raw) {
  final value = raw.trim();
  if (value.startsWith('#')) {
    var hex = value.substring(1);
    if (hex.length == 3) {
      hex = hex.split('').map((c) => '$c$c').join();
    }
    if (hex.length == 6) hex = 'ff$hex';
    if (hex.length != 8) {
      throw FormatException('Bad colour "$raw"');
    }
    return Color(int.parse(hex, radix: 16));
  }
  final match = RegExp(
    r'^rgba?\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*(?:,\s*([\d.]+)\s*)?\)$',
  ).firstMatch(value);
  if (match == null) throw FormatException('Bad colour "$raw"');
  final alpha = match.group(4) == null ? 1.0 : double.parse(match.group(4)!);
  return Color.fromRGBO(
    int.parse(match.group(1)!),
    int.parse(match.group(2)!),
    int.parse(match.group(3)!),
    alpha,
  );
}

/// `#aarrggbb` — round-trips through [parseColor].
String colorToHex(Color color) =>
    '#${color.toARGB32().toRadixString(16).padLeft(8, '0')}';

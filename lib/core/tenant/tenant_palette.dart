import 'dart:ui';

import '../theme/color_parsing.dart';

/// Every colour role the design system uses, for one brightness.
///
/// Mirrors the Ionic `themes.scss` variables one to one so a tenant can ship
/// a palette without any client code changing.
class TenantPalette {
  const TenantPalette({
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.accent,
    required this.accentSoft,
    required this.bg,
    required this.surface,
    required this.surface2,
    required this.card,
    required this.text,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.borderStrong,
    required this.scrim,
    required this.shadowRgb,
  });

  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final Color accent;
  final Color accentSoft;
  final Color bg;
  final Color surface;
  final Color surface2;
  final Color card;
  final Color text;
  final Color textSecondary;
  final Color textMuted;
  final Color border;
  final Color borderStrong;
  final Color scrim;

  /// The RGB the elevation shadows are tinted with (`--app-shadow-rgb`).
  final Color shadowRgb;

  /// A shadow colour at [opacity], tinted with [shadowRgb].
  Color shadow(double opacity) => shadowRgb.withValues(alpha: opacity);

  factory TenantPalette.fromJson(Map<String, dynamic> json) {
    Color c(String key) {
      final raw = json[key];
      if (raw is! String) throw FormatException('palette.$key missing');
      return parseColor(raw);
    }

    final shadow = json['shadowRgb'];
    final Color shadowRgb;
    if (shadow is List && shadow.length == 3) {
      shadowRgb = Color.fromARGB(
        255,
        (shadow[0] as num).toInt(),
        (shadow[1] as num).toInt(),
        (shadow[2] as num).toInt(),
      );
    } else if (shadow is String) {
      shadowRgb = parseColor(shadow);
    } else {
      throw const FormatException('palette.shadowRgb missing');
    }

    return TenantPalette(
      primary: c('primary'),
      primaryDark: c('primaryDark'),
      primaryLight: c('primaryLight'),
      accent: c('accent'),
      accentSoft: c('accentSoft'),
      bg: c('bg'),
      surface: c('surface'),
      surface2: c('surface2'),
      card: c('card'),
      text: c('text'),
      textSecondary: c('textSecondary'),
      textMuted: c('textMuted'),
      border: c('border'),
      borderStrong: c('borderStrong'),
      scrim: c('scrim'),
      shadowRgb: shadowRgb,
    );
  }

  Map<String, dynamic> toJson() => {
    'primary': colorToHex(primary),
    'primaryDark': colorToHex(primaryDark),
    'primaryLight': colorToHex(primaryLight),
    'accent': colorToHex(accent),
    'accentSoft': colorToHex(accentSoft),
    'bg': colorToHex(bg),
    'surface': colorToHex(surface),
    'surface2': colorToHex(surface2),
    'card': colorToHex(card),
    'text': colorToHex(text),
    'textSecondary': colorToHex(textSecondary),
    'textMuted': colorToHex(textMuted),
    'border': colorToHex(border),
    'borderStrong': colorToHex(borderStrong),
    'scrim': colorToHex(scrim),
    'shadowRgb': [
      (shadowRgb.r * 255).round(),
      (shadowRgb.g * 255).round(),
      (shadowRgb.b * 255).round(),
    ],
  };
}

/// A light + dark pair with an id, so a picker can name it.
class PalettePair {
  const PalettePair({
    required this.id,
    required this.light,
    required this.dark,
  });

  final String id;
  final TenantPalette light;
  final TenantPalette dark;

  factory PalettePair.fromJson(String id, Map<String, dynamic> json) =>
      PalettePair(
        id: id,
        light: TenantPalette.fromJson(json['light'] as Map<String, dynamic>),
        dark: TenantPalette.fromJson(json['dark'] as Map<String, dynamic>),
      );
}

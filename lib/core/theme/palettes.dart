import 'dart:ui';

import '../tenant/tenant_palette.dart';

/// The six palettes from the Ionic `themes.scss`, each with the shared
/// charcoal dark variant and its lifted primary. Offered by the settings
/// picker when the tenant allows, and used as the demo tenant's default.
abstract final class FallbackPalettes {
  static final ruby = PalettePair(
    id: 'ruby',
    light: const TenantPalette(
      primary: Color(0xFFE40046),
      primaryDark: Color(0xFFBE0046),
      primaryLight: Color(0xFFFF4F7D),
      accent: Color(0xFFB8912F),
      accentSoft: Color(0xFFF0E4C4),
      bg: Color(0xFFFFFCFA),
      surface: Color(0xFFFFFFFF),
      surface2: Color(0xFFFAF3F2),
      card: Color(0xFFFFFFFF),
      text: Color(0xFF1C1416),
      textSecondary: Color(0xFF5D5257),
      textMuted: Color(0xFF8D8186),
      border: Color(0xFFEBE2E3),
      borderStrong: Color(0xFFDCCFD2),
      scrim: Color(0x8C1C1416),
      shadowRgb: Color(0xFF5C182A),
    ),
    dark: _Dark.make(
      primary: Color(0xFFFF4F7D),
      primaryDark: Color(0xFFE40046),
      primaryLight: Color(0xFFFF7A9C),
      accent: Color(0xFFD8B45C),
      accentSoft: Color(0xFF3A3020),
    ),
  );

  static final burgundy = PalettePair(
    id: 'burgundy',
    light: const TenantPalette(
      primary: Color(0xFF7B1230),
      primaryDark: Color(0xFF56081F),
      primaryLight: Color(0xFFA52A4A),
      accent: Color(0xFFC2A45F),
      accentSoft: Color(0xFFEFE4CB),
      bg: Color(0xFFFDF9F6),
      surface: Color(0xFFFFFFFF),
      surface2: Color(0xFFF7EFEB),
      card: Color(0xFFFFFFFF),
      text: Color(0xFF211519),
      textSecondary: Color(0xFF5F5054),
      textMuted: Color(0xFF8E7F83),
      border: Color(0xFFEEE2DD),
      borderStrong: Color(0xFFDFCFC9),
      scrim: Color(0x8C211519),
      shadowRgb: Color(0xFF4A1221),
    ),
    dark: _Dark.make(
      primary: Color(0xFFD4728C),
      primaryDark: Color(0xFFA52A4A),
      primaryLight: Color(0xFFE596AA),
      accent: Color(0xFFD8C188),
      accentSoft: Color(0xFF3A3322),
    ),
  );

  static final emerald = PalettePair(
    id: 'emerald',
    light: const TenantPalette(
      primary: Color(0xFF0E5C46),
      primaryDark: Color(0xFF073C2D),
      primaryLight: Color(0xFF1A8163),
      accent: Color(0xFFB8912F),
      accentSoft: Color(0xFFECDFBE),
      bg: Color(0xFFF8FBF9),
      surface: Color(0xFFFFFFFF),
      surface2: Color(0xFFEEF5F1),
      card: Color(0xFFFFFFFF),
      text: Color(0xFF12201B),
      textSecondary: Color(0xFF4F5D58),
      textMuted: Color(0xFF7E8A85),
      border: Color(0xFFE0EAE5),
      borderStrong: Color(0xFFCDDBD4),
      scrim: Color(0x8C12201B),
      shadowRgb: Color(0xFF083629),
    ),
    dark: _Dark.make(
      primary: Color(0xFF46B894),
      primaryDark: Color(0xFF1A8163),
      primaryLight: Color(0xFF6FCCAE),
      accent: Color(0xFFD8B45C),
      accentSoft: Color(0xFF3A3020),
    ),
  );

  static final sapphire = PalettePair(
    id: 'sapphire',
    light: const TenantPalette(
      primary: Color(0xFF17396D),
      primaryDark: Color(0xFF0E2447),
      primaryLight: Color(0xFF2455A0),
      accent: Color(0xFF9AA7BD),
      accentSoft: Color(0xFFDFE5EF),
      bg: Color(0xFFF8FAFD),
      surface: Color(0xFFFFFFFF),
      surface2: Color(0xFFEEF2F9),
      card: Color(0xFFFFFFFF),
      text: Color(0xFF141B28),
      textSecondary: Color(0xFF515A6B),
      textMuted: Color(0xFF7F8797),
      border: Color(0xFFE1E7F0),
      borderStrong: Color(0xFFCED7E4),
      scrim: Color(0x8C141B28),
      shadowRgb: Color(0xFF0E2447),
    ),
    dark: _Dark.make(
      primary: Color(0xFF6A9CE0),
      primaryDark: Color(0xFF2455A0),
      primaryLight: Color(0xFF8FB5EA),
      accent: Color(0xFFC3CCDB),
      accentSoft: Color(0xFF2A3140),
    ),
  );

  static final rose = PalettePair(
    id: 'rose',
    light: const TenantPalette(
      primary: Color(0xFFB03A63),
      primaryDark: Color(0xFF8A2A4B),
      primaryLight: Color(0xFFCD5C82),
      accent: Color(0xFFCF9D6F),
      accentSoft: Color(0xFFF5E2D6),
      bg: Color(0xFFFEFAFB),
      surface: Color(0xFFFFFFFF),
      surface2: Color(0xFFFAF0F3),
      card: Color(0xFFFFFFFF),
      text: Color(0xFF22161B),
      textSecondary: Color(0xFF605156),
      textMuted: Color(0xFF8F8085),
      border: Color(0xFFF0E3E8),
      borderStrong: Color(0xFFE2D0D7),
      scrim: Color(0x8C22161B),
      shadowRgb: Color(0xFF581E33),
    ),
    dark: _Dark.make(
      primary: Color(0xFFE08BAB),
      primaryDark: Color(0xFFCD5C82),
      primaryLight: Color(0xFFEBA8C0),
      accent: Color(0xFFE0B491),
      accentSoft: Color(0xFF3B2E25),
    ),
  );

  static final black = PalettePair(
    id: 'black',
    light: const TenantPalette(
      primary: Color(0xFF232022),
      primaryDark: Color(0xFF0E0C0D),
      primaryLight: Color(0xFF423D40),
      accent: Color(0xFFB8912F),
      accentSoft: Color(0xFFEEE1C1),
      bg: Color(0xFFFAF8F6),
      surface: Color(0xFFFFFFFF),
      surface2: Color(0xFFF2EFEC),
      card: Color(0xFFFFFFFF),
      text: Color(0xFF181617),
      textSecondary: Color(0xFF585455),
      textMuted: Color(0xFF888384),
      border: Color(0xFFE8E4E0),
      borderStrong: Color(0xFFD6D0CB),
      scrim: Color(0x8C181617),
      shadowRgb: Color(0xFF181617),
    ),
    // Black promotes gold to the primary in dark mode.
    dark: _Dark.make(
      primary: Color(0xFFCFA94A),
      primaryDark: Color(0xFFB8912F),
      primaryLight: Color(0xFFDDC078),
      accent: Color(0xFFDDC078),
      accentSoft: Color(0xFF3A3020),
    ),
  );

  static final all = <PalettePair>[
    ruby,
    burgundy,
    emerald,
    sapphire,
    rose,
    black,
  ];

  static PalettePair? byId(String? id) =>
      all.where((p) => p.id == id).firstOrNull;
}

/// The shared charcoal dark ramp (survey §4 "Dark mode").
abstract final class _Dark {
  static TenantPalette make({
    required Color primary,
    required Color primaryDark,
    required Color primaryLight,
    required Color accent,
    required Color accentSoft,
  }) => TenantPalette(
    primary: primary,
    primaryDark: primaryDark,
    primaryLight: primaryLight,
    accent: accent,
    accentSoft: accentSoft,
    bg: const Color(0xFF0E0C0D),
    surface: const Color(0xFF161314),
    surface2: const Color(0xFF1E1A1B),
    card: const Color(0xFF1A1617),
    text: const Color(0xFFF4EDE9),
    textSecondary: const Color(0xFFB3A7A2),
    textMuted: const Color(0xFF837873),
    border: const Color(0x17FFFFFF),
    borderStrong: const Color(0x29FFFFFF),
    scrim: const Color(0xA6000000),
    shadowRgb: const Color(0xFF000000),
  );
}

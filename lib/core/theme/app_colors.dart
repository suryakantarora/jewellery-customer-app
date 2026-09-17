import 'package:flutter/material.dart';

import '../tenant/tenant_palette.dart';

/// Theme extension exposing every tenant colour role plus the derived
/// "ground" treatments. Read it with `context.colors`.
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({required this.palette, required this.isDark});

  final TenantPalette palette;
  final bool isDark;

  Color get primary => palette.primary;
  Color get primaryDark => palette.primaryDark;
  Color get primaryLight => palette.primaryLight;
  Color get accent => palette.accent;
  Color get accentSoft => palette.accentSoft;
  Color get bg => palette.bg;
  Color get surface => palette.surface;
  Color get surface2 => palette.surface2;
  Color get card => palette.card;
  Color get text => palette.text;
  Color get textSecondary => palette.textSecondary;
  Color get textMuted => palette.textMuted;
  Color get border => palette.border;
  Color get borderStrong => palette.borderStrong;
  Color get scrim => palette.scrim;

  static const success = Color(0xFF1F8A5B);
  static const warning = Color(0xFFB8912F);
  static const danger = Color(0xFFC0392B);

  Color shadow(double opacity) => palette.shadow(opacity);

  // --- Banner ground (tinted header, drawer header, profile banner, splash) -
  //
  // Light mode is an ivory-to-champagne "velvet tray" with dark ink and a
  // gold sheen; dark mode is deep charcoal warmed by the primary with the
  // same gold sheen. Both are meant to read as a jeweller's display case
  // rather than a coloured toolbar.

  Color get bannerGround =>
      isDark ? const Color(0xFF120D0F) : const Color(0xFFFBF5EC);

  LinearGradient get bannerGradient => isDark
      ? LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0, .5, 1],
          colors: [
            Color.alphaBlend(primary.withValues(alpha: .20), const Color(0xFF1A1114)),
            const Color(0xFF120D0F),
            Color.alphaBlend(accent.withValues(alpha: .10), const Color(0xFF15100F)),
          ],
        )
      : LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0, .55, 1],
          colors: [
            const Color(0xFFFFFDF8),
            Color.alphaBlend(accent.withValues(alpha: .14), const Color(0xFFFAF2E4)),
            Color.alphaBlend(primary.withValues(alpha: .07), const Color(0xFFF6EBDD)),
          ],
        );

  /// Ink on the banner ground.
  Color get bannerInk => isDark ? const Color(0xFFF7EFE6) : const Color(0xFF2B1B22);
  Color get bannerInkSoft =>
      isDark ? const Color(0xB8F7EFE6) : const Color(0xB82B1B22);
  Color get bannerInkFaint =>
      isDark ? const Color(0x80F7EFE6) : const Color(0x802B1B22);
  Color get bannerHairline => accent.withValues(alpha: isDark ? .30 : .45);

  /// The gold used for the moving sheen and filigree on the ground.
  Color get bannerGold =>
      isDark ? const Color(0xFFD8B45C) : const Color(0xFFC9A24C);

  // --- Hero ground (welcome, tour, auth: photos over a deep plum) ----------

  Color get heroGround =>
      isDark ? const Color(0xFF0B0509) : const Color(0xFF180810);

  /// 165° gradient of the primary at .42 → .20 → .34 (weaker in dark mode).
  LinearGradient get heroGradient {
    final a = isDark ? [.22, .10, .18] : [.42, .20, .34];
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: const [0, .55, 1],
      colors: [
        primary.withValues(alpha: a[0]),
        primary.withValues(alpha: a[1]),
        primary.withValues(alpha: a[2]),
      ],
    );
  }

  /// Ink over photographs and the hero ground: always light.
  static const photoInk = Color(0xFFFDF5F4);
  static const photoInkSoft = Color(0xB8FDF5F4);
  static const photoInkFaint = Color(0x80FDF5F4);
  Color get photoHairline => accent.withValues(alpha: .30);

  @override
  AppColors copyWith({TenantPalette? palette, bool? isDark}) =>
      AppColors(palette: palette ?? this.palette, isDark: isDark ?? this.isDark);

  @override
  AppColors lerp(AppColors? other, double t) => t < .5 ? this : (other ?? this);
}

extension AppColorsContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}

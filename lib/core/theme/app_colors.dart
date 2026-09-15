import 'package:flutter/material.dart';

import '../tenant/tenant_palette.dart';

/// Theme extension exposing every tenant colour role plus the derived
/// "banner ground" treatment. Read it with `context.colors`.
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

  // --- Banner ground (tinted header, drawer header, profile banner) ---------

  Color get bannerGround =>
      isDark ? const Color(0xFF0B0509) : const Color(0xFF180810);

  /// 165° gradient of the primary at .42 → .20 → .34 (weaker in dark mode).
  LinearGradient get bannerGradient {
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

  static const bannerInk = Color(0xFFFDF5F4);
  static const bannerInkSoft = Color(0xB8FDF5F4);
  static const bannerInkFaint = Color(0x80FDF5F4);
  Color get bannerHairline => accent.withValues(alpha: .30);

  @override
  AppColors copyWith({TenantPalette? palette, bool? isDark}) =>
      AppColors(palette: palette ?? this.palette, isDark: isDark ?? this.isDark);

  @override
  AppColors lerp(AppColors? other, double t) => t < .5 ? this : (other ?? this);
}

extension AppColorsContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jewellery_customer/core/theme/app_colors.dart';
import 'package:jewellery_customer/core/theme/app_theme.dart';
import 'package:jewellery_customer/core/theme/palettes.dart';

void main() {
  group('buildTheme', () {
    test('maps the palette onto the colour scheme and extension', () {
      final p = FallbackPalettes.ruby.light;
      final theme = buildTheme(p, Brightness.light);
      expect(theme.brightness, Brightness.light);
      expect(theme.colorScheme.primary, p.primary);
      expect(theme.colorScheme.secondary, p.accent);
      expect(theme.scaffoldBackgroundColor, p.bg);
      expect(theme.cardColor, p.card);
      final colors = theme.extension<AppColors>();
      expect(colors, isNotNull);
      expect(colors!.surface2, p.surface2);
      expect(colors.textMuted, p.textMuted);
      expect(colors.isDark, isFalse);
    });

    test('dark variant uses the charcoal ramp and lifted primary', () {
      final p = FallbackPalettes.black.dark;
      final theme = buildTheme(p, Brightness.dark);
      expect(theme.brightness, Brightness.dark);
      expect(theme.scaffoldBackgroundColor, const Color(0xFF0E0C0D));
      // Black promotes gold to primary in dark mode.
      expect(theme.colorScheme.primary, const Color(0xFFCFA94A));
      expect(theme.extension<AppColors>()!.isDark, isTrue);
    });

    test('display and body faces are applied, unknown faces fall back', () {
      final theme = buildTheme(
        FallbackPalettes.ruby.light,
        Brightness.light,
        fontDisplay: 'Comic Sans',
        fontBody: 'Inter',
      );
      expect(theme.textTheme.displayLarge!.fontFamily, AppFonts.display);
      expect(theme.textTheme.bodyLarge!.fontFamily, AppFonts.body);
      expect(theme.textTheme.bodyLarge!.fontFamilyFallback, contains('NotoSansLao'));
      expect(theme.textTheme.displayLarge!.fontVariations, isNotEmpty);
    });

    test('buttons carry the 11px uppercase tracked label', () {
      final theme = buildTheme(FallbackPalettes.ruby.light, Brightness.light);
      final style = theme.filledButtonTheme.style!.textStyle!.resolve({})!;
      expect(style.fontSize, 11);
      expect(style.letterSpacing, closeTo(11 * .16, 1e-6));
    });

    test('every fallback palette builds both brightnesses', () {
      for (final pair in FallbackPalettes.all) {
        expect(() => buildTheme(pair.light, Brightness.light), returnsNormally);
        expect(() => buildTheme(pair.dark, Brightness.dark), returnsNormally);
      }
      expect(FallbackPalettes.all.map((p) => p.id).toSet(), hasLength(6));
      expect(FallbackPalettes.byId('emerald'), isNotNull);
      expect(FallbackPalettes.byId('nope'), isNull);
    });
  });
}

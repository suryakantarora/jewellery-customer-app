import 'package:flutter/material.dart';

import '../tenant/tenant_palette.dart';
import 'app_colors.dart';
import 'tokens.dart';

/// Font families the binary ships. A tenant may name one of these; anything
/// else falls back so an unknown face never renders as boxes.
abstract final class AppFonts {
  static const display = 'PlayfairDisplay';
  static const body = 'Inter';
  static const lao = 'NotoSansLao';
  static const fallback = <String>[lao];

  static const known = {display, body};

  static String displayOr(String? name) =>
      name != null && known.contains(name) ? name : display;
  static String bodyOr(String? name) =>
      name != null && known.contains(name) ? name : body;
}

/// Weight for a variable display face: sets both the axis and the weight so
/// static and variable fonts render alike.
List<FontVariation> _wght(FontWeight w) => [
  FontVariation('wght', w.value.toDouble()),
];

/// Builds the whole [ThemeData] from one tenant palette.
ThemeData buildTheme(
  TenantPalette p,
  Brightness brightness, {
  String? fontDisplay,
  String? fontBody,
}) {
  final isDark = brightness == Brightness.dark;
  final display = AppFonts.displayOr(fontDisplay);
  final body = AppFonts.bodyOr(fontBody);
  final colors = AppColors(palette: p, isDark: isDark);

  final scheme = ColorScheme(
    brightness: brightness,
    primary: p.primary,
    onPrimary: Colors.white,
    primaryContainer: p.primaryLight,
    onPrimaryContainer: Colors.white,
    secondary: p.accent,
    onSecondary: isDark ? p.bg : Colors.white,
    secondaryContainer: p.accentSoft,
    onSecondaryContainer: p.text,
    tertiary: p.primaryDark,
    onTertiary: Colors.white,
    error: AppColors.danger,
    onError: Colors.white,
    surface: p.surface,
    onSurface: p.text,
    surfaceContainerLowest: p.bg,
    surfaceContainerLow: p.surface,
    surfaceContainer: p.card,
    surfaceContainerHigh: p.surface2,
    surfaceContainerHighest: p.surface2,
    onSurfaceVariant: p.textSecondary,
    outline: p.border,
    outlineVariant: p.borderStrong,
    shadow: p.shadowRgb,
    scrim: p.scrim,
    inverseSurface: p.text,
    onInverseSurface: p.bg,
    inversePrimary: p.primaryLight,
  );

  TextStyle d(double size, FontWeight w, double line, {double track = 0}) =>
      TextStyle(
        fontFamily: display,
        fontFamilyFallback: AppFonts.fallback,
        fontSize: size,
        fontWeight: w,
        fontVariations: _wght(w),
        height: line,
        letterSpacing: AppType.tracking(size, track),
        color: p.text,
      );

  TextStyle b(double size, FontWeight w, double line, {Color? color}) =>
      TextStyle(
        fontFamily: body,
        fontFamilyFallback: AppFonts.fallback,
        fontSize: size,
        fontWeight: w,
        height: line,
        color: color ?? p.text,
      );

  final textTheme = TextTheme(
    displayLarge: d(AppType.xxxxl, FontWeight.w500, AppType.lineTight),
    displayMedium: d(AppType.xxxl, FontWeight.w500, AppType.lineTight),
    displaySmall: d(AppType.xxl, FontWeight.w500, AppType.lineTight),
    headlineLarge: d(AppType.xxl, FontWeight.w500, AppType.lineTight),
    headlineMedium: d(AppType.xl, FontWeight.w500, AppType.lineSnug),
    headlineSmall: d(AppType.lg, FontWeight.w500, AppType.lineSnug),
    titleLarge: b(AppType.lg, FontWeight.w600, AppType.lineSnug),
    titleMedium: b(AppType.md, FontWeight.w600, AppType.lineSnug),
    titleSmall: b(AppType.sm, FontWeight.w600, AppType.lineSnug),
    bodyLarge: b(AppType.md, FontWeight.w400, AppType.lineNormal),
    bodyMedium: b(AppType.sm, FontWeight.w400, AppType.lineNormal),
    bodySmall: b(
      AppType.xs,
      FontWeight.w400,
      AppType.lineSnug,
      color: p.textSecondary,
    ),
    labelLarge: b(AppType.xs, FontWeight.w600, 1.2).copyWith(
      letterSpacing: AppType.tracking(AppType.xs, AppType.trackWider),
    ),
    labelMedium: b(AppType.xxs, FontWeight.w600, 1.2).copyWith(
      letterSpacing: AppType.tracking(AppType.xxs, AppType.trackWidest),
    ),
    labelSmall: b(
      AppType.xxs,
      FontWeight.w500,
      1.2,
      color: p.textMuted,
    ).copyWith(letterSpacing: AppType.tracking(AppType.xxs, AppType.trackWide)),
  );

  // Buttons globally: radius-sm, no shadow, 18px vertical padding, 11px
  // uppercase text at .16em tracking.
  final buttonShape = RoundedRectangleBorder(
    borderRadius: AppRadius.circular(AppRadius.sm),
  );
  const buttonPadding = EdgeInsets.symmetric(horizontal: 22, vertical: 18);
  final buttonText = textTheme.labelLarge!;

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: p.bg,
    canvasColor: p.surface,
    cardColor: p.card,
    dividerColor: p.border,
    shadowColor: p.shadowRgb,
    splashFactory: NoSplash.splashFactory,
    fontFamily: body,
    fontFamilyFallback: AppFonts.fallback,
    textTheme: textTheme,
    primaryTextTheme: textTheme,
    extensions: [colors],
    appBarTheme: AppBarTheme(
      backgroundColor: p.surface,
      foregroundColor: p.text,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      toolbarHeight: AppLayout.headerHeight,
      titleTextStyle: textTheme.headlineSmall,
      iconTheme: IconThemeData(color: p.text, size: 22),
    ),
    iconTheme: IconThemeData(color: p.text, size: 22),
    dividerTheme: DividerThemeData(color: p.border, thickness: 1, space: 1),
    cardTheme: CardThemeData(
      color: p.card,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.circular(AppRadius.md),
        side: BorderSide(color: p.border),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: p.primary,
        foregroundColor: Colors.white,
        disabledBackgroundColor: p.border,
        disabledForegroundColor: p.textMuted,
        elevation: 0,
        shape: buttonShape,
        padding: buttonPadding,
        textStyle: buttonText,
        minimumSize: const Size(64, 48),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: p.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: buttonShape,
        padding: buttonPadding,
        textStyle: buttonText,
        minimumSize: const Size(64, 48),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: p.text,
        side: BorderSide(color: p.borderStrong),
        shape: buttonShape,
        padding: buttonPadding,
        textStyle: buttonText,
        minimumSize: const Size(64, 48),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: p.primary,
        shape: buttonShape,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        textStyle: buttonText,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: p.text),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: p.surface,
      selectedColor: p.primary,
      disabledColor: p.surface2,
      side: BorderSide(color: p.border),
      shape: const StadiumBorder(),
      labelStyle: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
      secondaryLabelStyle: textTheme.bodyMedium!.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      showCheckmark: false,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: p.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: textTheme.bodyLarge!.copyWith(color: p.textMuted),
      labelStyle: textTheme.bodyMedium!.copyWith(color: p.textSecondary),
      border: OutlineInputBorder(
        borderRadius: AppRadius.circular(AppRadius.sm),
        borderSide: BorderSide(color: p.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.circular(AppRadius.sm),
        borderSide: BorderSide(color: p.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.circular(AppRadius.sm),
        borderSide: BorderSide(color: p.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.circular(AppRadius.sm),
        borderSide: const BorderSide(color: AppColors.danger),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: p.surface,
      surfaceTintColor: Colors.transparent,
      modalBackgroundColor: p.surface,
      showDragHandle: true,
      dragHandleColor: p.borderStrong,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: p.surface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: Colors.transparent,
      height: AppLayout.tabBarHeight,
      elevation: 0,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => textTheme.labelSmall!.copyWith(
          color: states.contains(WidgetState.selected)
              ? p.primary
              : p.textMuted,
          fontWeight: FontWeight.w600,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          size: 22,
          color: states.contains(WidgetState.selected)
              ? p.primary
              : p.textMuted,
        ),
      ),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: p.surface,
      surfaceTintColor: Colors.transparent,
      scrimColor: p.scrim,
      shape: const RoundedRectangleBorder(),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: p.textSecondary,
      textColor: p.text,
      titleTextStyle: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
      subtitleTextStyle: textTheme.bodySmall,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: const WidgetStatePropertyAll(Colors.white),
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? p.primary : p.borderStrong,
      ),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: p.text,
      contentTextStyle: textTheme.bodyMedium!.copyWith(color: p.bg),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.circular(AppRadius.sm),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: p.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: const CircleBorder(),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: p.primary,
      linearTrackColor: p.surface2,
    ),
  );
}

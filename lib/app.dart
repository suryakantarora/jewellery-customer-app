import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/l10n/locale_provider.dart';
import 'core/router/app_router.dart';
import 'core/tenant/tenant_config.dart';
import 'core/tenant/tenant_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/palettes.dart';
import 'core/theme/theme_mode_provider.dart';
import 'features/splash/splash_screen.dart';
import 'l10n/app_localizations.dart';

/// The application root: theme, locale and router all derive from the
/// active tenant, so a tenant reload rebuilds everything in one place.
class JewelleryCustomerApp extends ConsumerWidget {
  const JewelleryCustomerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tenantAsync = ref.watch(tenantProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final router = ref.watch(routerProvider);

    // While a reload is in flight keep the last-known tenant so the theme
    // never snaps to defaults; only a genuine first load has none.
    final TenantConfig? tenant = tenantAsync.valueOrNull;
    final light = tenant?.palette ?? FallbackPalettes.ruby.light;
    final dark = tenant?.darkPalette ?? FallbackPalettes.ruby.dark;

    return MaterialApp.router(
      title: tenant?.brandName ?? '',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: buildTheme(
        light,
        Brightness.light,
        fontDisplay: tenant?.fontDisplay,
        fontBody: tenant?.fontBody,
      ),
      darkTheme: buildTheme(
        dark,
        Brightness.dark,
        fontDisplay: tenant?.fontDisplay,
        fontBody: tenant?.fontBody,
      ),
      themeMode: themeMode,
      locale: locale,
      supportedLocales: appLocales,
      localizationsDelegates: const [
        AppL10n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) => MediaQuery.withClampedTextScaling(
        minScaleFactor: .85,
        maxScaleFactor: 1.4,
        child: Stack(
          children: [
            child ?? const SizedBox.shrink(),
            if (tenantAsync.isLoading && !tenantAsync.hasValue)
              SplashScreen(tenant: tenant, standalone: false)
            else if (tenantAsync.isLoading)
              // Reload after a shop-code change: keep the brand on screen.
              SplashScreen(tenant: tenant, standalone: false),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jewellery_customer/app.dart';
import 'package:jewellery_customer/core/providers.dart';
import 'package:jewellery_customer/core/storage/local_store.dart';
import 'package:jewellery_customer/core/tenant/tenant_provider.dart';
import 'package:jewellery_customer/core/theme/theme_mode_provider.dart';
import 'package:jewellery_customer/data/demo/demo_store.dart';
import 'package:jewellery_customer/data/repository_providers.dart';
import 'package:jewellery_customer/features/home/home_screen.dart';
import 'package:jewellery_customer/features/settings/settings_screen.dart';
import 'package:jewellery_customer/features/shell/app_shell.dart';
import 'package:jewellery_customer/features/splash/splash_screen.dart';
import 'package:jewellery_customer/features/support/support_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Shimmer runs forever, so tests pump fixed durations instead of settling:
/// one frame to apply state, then enough time for the longest transition.
Future<void> settle(WidgetTester tester, [int ms = 600]) async {
  await tester.pump();
  await tester.pump(Duration(milliseconds: ms));
}

void main() {
  testWidgets('splash → shell, tabs, FAB and drawer all resolve', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final store = await LocalStore.create();
    final container = ProviderContainer(
      overrides: [
        localStoreProvider.overrideWithValue(store),
        demoStoreProvider.overrideWithValue(DemoStore(latency: Duration.zero)),
      ],
    );
    addTearDown(container.dispose);
    await container.read(tenantProvider.future);

    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const JewelleryCustomerApp(),
      ),
    );
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text('FINO'), findsWidgets);

    // Splash hands over after ~1.1 s.
    await settle(tester, 1200);
    await settle(tester, 500);
    expect(find.byType(AppShell), findsOneWidget);
    expect(find.byType(HomeScreen), findsOneWidget);

    // Demo data has rendered: banner titles and categories.
    await settle(tester, 1000);
    expect(find.text('Timeless elegance'), findsOneWidget);
    expect(find.text('Rings'), findsWidgets);

    // Settings tab.
    await tester.tap(find.text('Settings'));
    await settle(tester);
    expect(find.byType(SettingsScreen), findsOneWidget);

    // Dark mode toggle works and reaches the theme.
    await tester.tap(find.text('Dark'));
    await settle(tester);
    expect(container.read(themeModeProvider), ThemeMode.dark);
    expect(
      Theme.of(tester.element(find.byType(SettingsScreen))).brightness,
      Brightness.dark,
    );

    // Language switch to Lao relabels the tabs; back to English.
    await tester.tap(find.text('ພາສາລາວ'));
    await settle(tester);
    expect(find.text('ຕັ້ງຄ່າ'), findsWidgets);
    await tester.tap(find.text('English').first);
    await settle(tester);
    expect(find.text('Settings'), findsWidgets);

    // Raised FAB → support, then back.
    await tester.tap(find.byType(FloatingActionButton));
    await settle(tester);
    expect(find.byType(SupportScreen), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await settle(tester);
    expect(find.byType(SupportScreen), findsNothing);

    // Drawer opens from the brand header on Home.
    await tester.tap(find.text('Home'));
    await settle(tester);
    await tester.tap(find.byIcon(Icons.menu_rounded));
    await settle(tester, 900);
    expect(find.text('SHOP FOR'), findsOneWidget);
    expect(find.text('Rings'), findsWidgets);
  });
}

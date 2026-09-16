import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jewellery_customer/core/theme/theme_mode_provider.dart';
import 'package:jewellery_customer/features/account/account_screen.dart';
import 'package:jewellery_customer/features/home/home_screen.dart';
import 'package:jewellery_customer/features/settings/settings_screen.dart';
import 'package:jewellery_customer/features/shell/app_shell.dart';
import 'package:jewellery_customer/features/support/support_screen.dart';

import '../support/app_harness.dart';

void main() {
  testWidgets('returning guest: shell, tabs, FAB, drawer, profile prompt', (tester) async {
    final container = await bootApp(tester, prefs: returningGuestPrefs);
    await settle(tester, 1200);
    await settle(tester, 500);
    expect(find.byType(AppShell), findsOneWidget);
    expect(find.byType(HomeScreen), findsOneWidget);

    // Demo data has rendered: hero and categories.
    await settle(tester, 1000);
    expect(find.text('Timeless elegance'), findsWidgets);
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

    // Profile tab shows the guest prompt.
    await tester.tap(find.text('Profile'));
    await settle(tester);
    expect(find.byType(AccountScreen), findsOneWidget);
    expect(find.text('Sign in to continue'), findsOneWidget);

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
    await unmount(tester);
  });
}

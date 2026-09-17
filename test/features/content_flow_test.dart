import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jewellery_customer/core/router/app_router.dart';
import 'package:jewellery_customer/core/router/app_routes.dart';
import 'package:jewellery_customer/core/tenant/tenant_provider.dart';
import 'package:jewellery_customer/features/cart/cart_provider.dart';
import 'package:jewellery_customer/features/content/about_screen.dart';
import 'package:jewellery_customer/features/gold_rates/gold_rates_screen.dart';
import 'package:jewellery_customer/features/notifications/notifications_provider.dart';
import 'package:jewellery_customer/features/notifications/notifications_screen.dart';
import 'package:jewellery_customer/features/offers/offers_screen.dart';
import 'package:jewellery_customer/features/policies/policy_screen.dart';
import 'package:jewellery_customer/features/stores/stores_screen.dart';
import 'package:jewellery_customer/features/support/support_screen.dart';

import '../support/app_harness.dart';

void main() {
  testWidgets(
    'settings & content: theme, policy, gold rates, offers → bag coupon, stores, notifications, support',
    (tester) async {
      final container = await bootApp(tester, prefs: returningGuestPrefs);
      await settle(tester, 1200);
      await settle(tester, 600);
      final router = container.read(routerProvider);

      // Settings: theme swatch applies a palette.
      await tester.tap(find.text('Settings'));
      await settle(tester);
      await tester.tap(find.text('Emerald Luxury'));
      await settle(tester, 900);
      expect(container.read(tenantProvider).valueOrNull?.paletteId, 'emerald');
      expect(find.text('Theme applied'), findsOneWidget);

      // Policy document renders sections and FAQ.
      unawaited(router.push(AppRoutes.policyPath('shipping')));
      await settle(tester, 900);
      expect(find.byType(PolicyScreen), findsOneWidget);
      expect(find.text('Shipping'), findsWidgets);
      expect(find.text('Rates and timelines'), findsOneWidget);
      router.pop();
      await settle(tester, 600);

      // Gold rates table.
      unawaited(router.push(AppRoutes.goldRates));
      await settle(tester, 900);
      expect(find.byType(GoldRatesScreen), findsOneWidget);
      expect(find.text('Platinum 950'), findsOneWidget);
      router.pop();
      await settle(tester, 600);

      // Offers → apply → the bag carries the coupon.
      unawaited(router.push(AppRoutes.offers));
      await settle(tester, 900);
      expect(find.byType(OffersScreen), findsOneWidget);
      expect(find.text('SPARKLE20'), findsOneWidget);
      await tester.tap(find.text('Apply').first);
      await settle(tester, 900);
      expect(
        container.read(appliedOfferProvider).valueOrNull?.code,
        'SPARKLE20',
      );
      expect(find.text('Coupon code'), findsNothing);
      expect(find.text('SPARKLE20'), findsWidgets);
      await container.read(appliedOfferProvider.notifier).clear();
      router.pop();
      router.pop();
      await settle(tester, 600);

      // Stores → detail.
      unawaited(router.push(AppRoutes.stores));
      await settle(tester, 900);
      expect(find.byType(StoresScreen), findsOneWidget);
      await tester.tap(find.text('Setthathirath Flagship'));
      await settle(tester, 900);
      expect(find.byType(StoreDetailScreen), findsOneWidget);
      expect(find.text('Bridal suite'), findsOneWidget);
      router.pop();
      router.pop();
      await settle(tester, 600);

      // Notifications: mark all read clears the count.
      unawaited(router.push(AppRoutes.notifications));
      await settle(tester, 900);
      expect(find.byType(NotificationsScreen), findsOneWidget);
      expect(container.read(unreadNotificationsProvider), 3);
      await tester.tap(find.byIcon(Icons.done_all_rounded));
      await settle(tester, 600);
      expect(container.read(unreadNotificationsProvider), 0);
      router.pop();
      await settle(tester, 600);

      // Support chat: pick an option, get the scripted reply.
      unawaited(router.push(AppRoutes.support));
      await settle(tester, 900);
      expect(find.byType(SupportScreen), findsOneWidget);
      await tester.tap(find.text('Track my order'));
      await settle(tester, 900);
      expect(find.text('That helped'), findsOneWidget);
      router.pop();
      await settle(tester, 600);

      // About.
      unawaited(router.push(AppRoutes.about));
      await settle(tester, 900);
      expect(find.byType(AboutScreen), findsOneWidget);
      expect(find.text('The atelier'), findsOneWidget);
      await unmount(tester);
    },
  );
}

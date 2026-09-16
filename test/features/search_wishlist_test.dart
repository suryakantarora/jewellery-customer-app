import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jewellery_customer/core/router/app_router.dart';
import 'package:jewellery_customer/core/router/app_routes.dart';
import 'package:jewellery_customer/features/cart/cart_provider.dart';
import 'package:jewellery_customer/features/search/search_screen.dart';
import 'package:jewellery_customer/features/wishlist/wishlist_provider.dart';
import 'package:jewellery_customer/features/wishlist/wishlist_screen.dart';

import '../support/app_harness.dart';

void main() {
  testWidgets('search and wishlist screens', (tester) async {
    final container = await bootApp(tester, prefs: returningGuestPrefs);
    await settle(tester, 1200);
    await settle(tester, 600);
    final router = container.read(routerProvider);

    unawaited(router.push(AppRoutes.search));
    await settle(tester, 900);
    expect(find.byType(SearchScreen), findsOneWidget);
    expect(find.text('Solitaire'), findsWidgets);
    await tester.enterText(find.byType(TextField), 'ruby');
    await settle(tester, 400);
    await settle(tester, 600);
    expect(find.textContaining('results'), findsOneWidget);

    await container.read(wishlistProvider.notifier).toggle('FINO-002');
    unawaited(router.push(AppRoutes.wishlist));
    await settle(tester, 900);
    expect(find.byType(WishlistScreen), findsOneWidget);
    expect(find.text('Celeste Diamond Earrings'), findsWidgets);
    await tester.tap(find.text('Move all to bag'));
    await settle(tester, 700);
    expect(container.read(cartCountProvider), 1);
    expect(container.read(wishlistCountProvider), 0);
    await unmount(tester);
  });
}

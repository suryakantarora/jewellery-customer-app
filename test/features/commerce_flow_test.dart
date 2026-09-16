import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jewellery_customer/core/router/app_router.dart';
import 'package:jewellery_customer/core/router/app_routes.dart';
import 'package:jewellery_customer/core/session/session_provider.dart';
import 'package:jewellery_customer/features/auth/otp_screen.dart';
import 'package:jewellery_customer/features/auth/phone_screen.dart';
import 'package:jewellery_customer/features/cart/cart_provider.dart';
import 'package:jewellery_customer/features/cart/cart_screen.dart';
import 'package:jewellery_customer/features/catalogue/category_screen.dart';
import 'package:jewellery_customer/features/checkout/checkout_screen.dart';
import 'package:jewellery_customer/features/orders/order_detail_screen.dart';
import 'package:jewellery_customer/features/orders/orders_provider.dart';
import 'package:jewellery_customer/features/orders/orders_screen.dart';
import 'package:jewellery_customer/features/product/product_screen.dart';
import 'package:jewellery_customer/features/wishlist/wishlist_provider.dart';
import 'package:jewellery_customer/shared/widgets/heart_button.dart';

import '../support/app_harness.dart';

void main() {
  testWidgets('browse → product → bag → sign in → checkout → order', (tester) async {
    final container = await bootApp(tester, prefs: returningGuestPrefs);
    await settle(tester, 1200);
    await settle(tester, 600);
    final router = container.read(routerProvider);

    // Category listing renders a grid; filter badge starts empty.
    unawaited(router.push(AppRoutes.categoryPath('rings')));
    await settle(tester, 900);
    expect(find.byType(CategoryScreen), findsOneWidget);
    expect(find.textContaining('results'), findsOneWidget);

    // Product detail for a sized ring: adding without a size is blocked.
    unawaited(router.push(AppRoutes.productPath('FINO-001')));
    await settle(tester, 900);
    expect(find.byType(ProductScreen), findsOneWidget);
    expect(find.text('Eternal Solitaire Ring'), findsWidgets);
    await tester.tap(find.text('Add to bag'));
    await settle(tester, 700);
    expect(find.text('Please choose a size first.'), findsOneWidget);
    expect(container.read(cartCountProvider), 0);

    // Choose a size, add, and the header count follows.
    await tester.tap(find.widgetWithText(GestureDetector, '7').first);
    await settle(tester);
    await tester.tap(find.text('Add to bag'));
    await settle(tester, 2500);
    expect(container.read(cartCountProvider), 1);

    // Wishlist toggle from the gallery heart (scroll it back into view).
    await tester.dragUntilVisible(
      find.byType(HeartButton),
      find.byType(ListView).first,
      const Offset(0, 300),
    );
    await settle(tester);
    await tester.tap(find.byType(HeartButton).first);
    await settle(tester, 700);
    expect(container.read(wishlistCountProvider), 1);

    // Bag shows the line and totals; checkout requires sign-in.
    unawaited(router.push(AppRoutes.cart));
    await settle(tester, 900);
    expect(find.byType(CartScreen), findsOneWidget);
    expect(find.textContaining('Size 7'), findsWidgets);
    await tester.tap(find.text('Checkout'));
    await settle(tester, 900);
    expect(find.byType(PhoneScreen), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, '20 5555 0142');
    await tester.tap(find.text('Send code'));
    // The first commerce.json read resolves on the real event loop, i.e.
    // only once this test body yields; pump again so the push animates.
    await settle(tester, 900);
    await settle(tester, 900);
    expect(find.byType(OtpScreen), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, '123456');
    await settle(tester, 1500);
    expect(container.read(isSignedInProvider), isTrue);
    expect(find.byType(CheckoutScreen), findsOneWidget);

    // Address step: pick the saved home address and continue.
    await settle(tester, 600);
    await tester.tap(find.text('Home').first);
    await settle(tester);
    await tester.tap(find.text('Continue to payment'));
    await settle(tester, 700);
    expect(find.text('How would you like to pay?'), findsOneWidget);
    await tester.tap(find.text('Cash on delivery'));
    await settle(tester);
    await tester.tap(find.text('Review order'));
    await settle(tester, 700);
    expect(find.text('Almost there'), findsOneWidget);
    await tester.tap(find.textContaining('Place order'));
    await settle(tester, 300);
    expect(find.text('Placing your order'), findsOneWidget);
    await settle(tester, 1600);
    await settle(tester, 1000);
    expect(find.text('Order confirmed'), findsOneWidget);
    expect(container.read(cartCountProvider), 0);
    final orders = container.read(ordersProvider).requireValue;
    expect(orders.first.items.single.size, '7');

    // Track order lands on the detail with a timeline.
    await tester.tap(find.text('Track order'));
    await settle(tester, 900);
    expect(find.byType(OrderDetailScreen), findsOneWidget);
    expect(find.text('We received your order'), findsOneWidget);

    // Orders list segments.
    unawaited(router.push(AppRoutes.orders));
    await settle(tester, 900);
    expect(find.byType(OrdersScreen), findsOneWidget);
    expect(find.textContaining(orders.first.id), findsWidgets);
    await unmount(tester);
  });
}

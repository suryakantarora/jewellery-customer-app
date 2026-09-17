import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jewellery_customer/app.dart';
import 'package:jewellery_customer/core/providers.dart';
import 'package:jewellery_customer/core/session/session_provider.dart';
import 'package:jewellery_customer/core/storage/local_store.dart';
import 'package:jewellery_customer/core/storage/storage_keys.dart';
import 'package:jewellery_customer/core/tenant/tenant_provider.dart';
import 'package:jewellery_customer/data/demo/demo_store.dart';
import 'package:jewellery_customer/data/repository_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Shimmer runs forever, so tests pump fixed durations instead of settling:
/// one frame to apply state, then enough time for the longest transition.
Future<void> settle(WidgetTester tester, [int ms = 600]) async {
  await tester.pump();
  await tester.pump(Duration(milliseconds: ms));
}

/// Autoplay carousels and reveal delays keep timers alive; tear the tree
/// down so the framework's pending-timer check passes.
Future<void> unmount(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(seconds: 7));
}

/// Preferences for a device that has seen the tour and chosen guest mode.
const returningGuestPrefs = <String, Object>{
  StorageKeys.seenTour: true,
  StorageKeys.session: '{}',
};

/// Boots the app on a phone-sized view with zero demo latency. One boot per
/// test file: the mock preferences and asset bundle are process-wide, and a
/// second boot in the same process deadlocks under fake async.
Future<ProviderContainer> bootApp(
  WidgetTester tester, {
  Map<String, Object> prefs = const {},
}) async {
  SharedPreferences.setMockInitialValues(prefs);
  final store = await LocalStore.create();
  final container = ProviderContainer(
    overrides: [
      localStoreProvider.overrideWithValue(store),
      demoStoreProvider.overrideWithValue(DemoStore(latency: Duration.zero)),
    ],
  );
  addTearDown(container.dispose);
  await container.read(tenantProvider.future);
  await container.read(sessionProvider.future);

  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const JewelleryCustomerApp()),
  );
  return container;
}

/// Scrolls the first scrollable, without flinging, until [finder] is on
/// screen and clear of the tab bar / FAB band at the bottom, so a tap lands.
Future<void> revealForTap(WidgetTester tester, Finder finder) async {
  final scrollable = find.byType(Scrollable).first;
  final limit = tester.view.physicalSize.height / tester.view.devicePixelRatio - 140;
  for (var i = 0; i < 30; i++) {
    if (finder.evaluate().isNotEmpty && tester.getCenter(finder).dy <= limit) return;
    await tester.timedDrag(scrollable, const Offset(0, -120), const Duration(milliseconds: 300));
    await settle(tester, 300);
  }
}

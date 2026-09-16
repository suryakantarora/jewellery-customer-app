import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/layout/breakpoints.dart';
import 'core/providers.dart';
import 'core/session/session_provider.dart';
import 'core/storage/local_store.dart';
import 'core/tenant/tenant_provider.dart';

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();

  await _lockPhonesToPortrait(binding);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  // Preferences and the tenant are both resolved before the first frame so
  // the theme never flashes the wrong brand or the wrong mode.
  final localStore = await LocalStore.create();
  final container = ProviderContainer(
    overrides: [localStoreProvider.overrideWithValue(localStore)],
  );
  try {
    await container.read(tenantProvider.future);
    await container.read(sessionProvider.future);
  } on Object catch (error) {
    // The demo repository is the fallback of last resort; if even that fails
    // the app still launches and the error state explains itself.
    debugPrint('Tenant load failed before first frame: $error');
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const JewelleryCustomerApp(),
    ),
  );
}

/// Phones are portrait-only; tablets may rotate. Decided at runtime from the
/// display's shortest side rather than a manifest lock, so one binary serves
/// both (plan §1 item 1).
Future<void> _lockPhonesToPortrait(WidgetsBinding binding) async {
  final view = binding.platformDispatcher.implicitView;
  if (view == null) return;
  final FlutterView v = view;
  final shortest =
      (v.physicalSize.shortestSide / v.devicePixelRatio).clamp(0, 5000).toDouble();
  if (shortest > 0 && shortest < Breakpoints.tablet) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  } else {
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }
}

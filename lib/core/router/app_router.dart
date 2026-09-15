import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/collections/collections_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/settings/shop_code_screen.dart';
import '../../features/shell/app_shell.dart';
import '../../features/shell/placeholder_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/support/support_screen.dart';
import '../../l10n/app_localizations.dart';
import '../motion/page_transition.dart';
import '../providers.dart';
import '../tenant/tenant_provider.dart';
import 'app_routes.dart';

/// Tabs are `StatefulShellBranch`es so each keeps its own stack. Stacked
/// pages use [AppPage] for the slide + parallax transition.
final routerProvider = Provider<GoRouter>((ref) {
  final devTools = ref.watch(appConfigProvider).environment.allowsDeveloperTools;

  Page<void> stacked(GoRouterState state, Widget child) =>
      AppPage(key: state.pageKey, child: child);

  Page<void> placeholder(GoRouterState state, String Function(AppL10n) title) =>
      AppPage(
        key: state.pageKey,
        child: Builder(
          builder: (context) =>
              PlaceholderScreen(title: title(AppL10n.of(context))),
        ),
      );

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: devTools,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, _) => SplashScreen(
          tenant: ref.read(tenantProvider).valueOrNull,
        ),
      ),
      GoRoute(
        path: AppRoutes.support,
        pageBuilder: (_, state) => stacked(state, const SupportScreen()),
      ),
      if (devTools)
        GoRoute(
          path: AppRoutes.shopCode,
          pageBuilder: (_, state) => stacked(state, const ShopCodeScreen()),
        ),
      GoRoute(
        path: '${AppRoutes.category}/:id',
        pageBuilder: (_, state) => placeholder(state, (l) => l.tabCollections),
      ),
      GoRoute(
        path: AppRoutes.orders,
        pageBuilder: (_, state) => placeholder(state, (l) => l.drawerOrders),
      ),
      GoRoute(
        path: AppRoutes.goldRates,
        pageBuilder: (_, state) => placeholder(state, (l) => l.drawerGoldRates),
      ),
      GoRoute(
        path: AppRoutes.contact,
        pageBuilder: (_, state) => placeholder(state, (l) => l.drawerContact),
      ),
      GoRoute(
        path: AppRoutes.search,
        pageBuilder: (_, state) => placeholder(state, (l) => l.actionSearch),
      ),
      GoRoute(
        path: AppRoutes.wishlist,
        pageBuilder: (_, state) => placeholder(state, (l) => l.actionWishlist),
      ),
      GoRoute(
        path: AppRoutes.cart,
        pageBuilder: (_, state) => placeholder(state, (l) => l.actionBag),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, __, shell) => AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (_, __) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.collections,
                builder: (_, __) => const CollectionsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (_, __) => const ProfileScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (_, __) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

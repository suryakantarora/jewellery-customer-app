import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/retail_attributes.dart';
import '../../features/account/account_screen.dart';
import '../../features/account/addresses_screen.dart';
import '../../features/account/payment_methods_screen.dart';
import '../../features/auth/otp_screen.dart';
import '../../features/auth/phone_screen.dart';
import '../../features/auth/profile_setup_screen.dart';
import '../../features/cart/cart_screen.dart';
import '../../features/catalogue/category_screen.dart';
import '../../features/catalogue/lookbook_screen.dart';
import '../../features/catalogue/size_guide_screen.dart';
import '../../features/checkout/checkout_screen.dart';
import '../../features/collections/collections_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/onboarding/tutorial_screen.dart';
import '../../features/onboarding/welcome_screen.dart';
import '../../features/orders/order_detail_screen.dart';
import '../../features/orders/orders_screen.dart';
import '../../features/product/product_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/settings/shop_code_screen.dart';
import '../../features/shell/app_shell.dart';
import '../../features/shell/placeholder_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/support/support_screen.dart';
import '../../features/wishlist/wishlist_screen.dart';
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
      // --- Onboarding & auth (C2) -------------------------------------------
      GoRoute(
        path: AppRoutes.tutorial,
        pageBuilder: (_, state) => stacked(state, const TutorialScreen()),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        pageBuilder: (_, state) => stacked(state, const WelcomeScreen()),
      ),
      GoRoute(
        path: AppRoutes.authPhone,
        pageBuilder: (_, state) => stacked(
          state,
          PhoneScreen(fromWelcome: state.uri.queryParameters['from'] == 'welcome'),
        ),
      ),
      GoRoute(
        path: AppRoutes.authOtp,
        // Reached only from the phone screen with its challenge in `extra`;
        // a cold deep link has none and shows the phone screen instead.
        pageBuilder: (_, state) => stacked(
          state,
          switch (state.extra) {
            final OtpArgs args => OtpScreen(
              challenge: args.challenge,
              fromWelcome: args.fromWelcome,
            ),
            _ => const PhoneScreen(),
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.authProfile,
        pageBuilder: (_, state) => stacked(
          state,
          ProfileSetupScreen(fromWelcome: state.extra == true),
        ),
      ),
      // --- Discovery & catalogue (C3, C4) ----------------------------------
      GoRoute(
        path: AppRoutes.search,
        pageBuilder: (_, state) =>
            stacked(state, SearchScreen(initialQuery: state.uri.queryParameters['q'])),
      ),
      GoRoute(
        path: '${AppRoutes.category}/:id',
        pageBuilder: (_, state) => stacked(
          state,
          CategoryScreen(
            categoryId: state.pathParameters['id']!,
            audience: state.uri.queryParameters['audience'],
          ),
        ),
      ),
      GoRoute(
        path: '${AppRoutes.product}/:id',
        pageBuilder: (_, state) =>
            stacked(state, ProductScreen(productId: state.pathParameters['id']!)),
      ),
      GoRoute(
        path: AppRoutes.sizeGuide,
        pageBuilder: (_, state) => stacked(
          state,
          SizeGuideScreen(kind: SizeKind.fromName(state.uri.queryParameters['kind'])),
        ),
      ),
      GoRoute(
        path: AppRoutes.lookbook,
        pageBuilder: (_, state) => stacked(state, const LookbookScreen()),
      ),
      // --- Wishlist, cart, checkout (C5) -----------------------------------
      GoRoute(
        path: AppRoutes.wishlist,
        pageBuilder: (_, state) => stacked(state, const WishlistScreen()),
      ),
      GoRoute(
        path: AppRoutes.cart,
        pageBuilder: (_, state) => stacked(state, const CartScreen()),
      ),
      GoRoute(
        path: AppRoutes.checkout,
        pageBuilder: (_, state) => stacked(state, const CheckoutScreen()),
      ),
      // --- Orders & account (C6) -------------------------------------------
      GoRoute(
        path: AppRoutes.orders,
        pageBuilder: (_, state) => stacked(state, const OrdersScreen()),
        routes: [
          GoRoute(
            path: ':id',
            pageBuilder: (_, state) =>
                stacked(state, OrderDetailScreen(orderId: state.pathParameters['id']!)),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.addresses,
        pageBuilder: (_, state) => stacked(state, const AddressesScreen()),
      ),
      GoRoute(
        path: AppRoutes.paymentMethods,
        pageBuilder: (_, state) => stacked(state, const PaymentMethodsScreen()),
      ),
      // --- Misc ------------------------------------------------------------
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
        path: AppRoutes.goldRates,
        pageBuilder: (_, state) => placeholder(state, (l) => l.drawerGoldRates),
      ),
      GoRoute(
        path: AppRoutes.contact,
        pageBuilder: (_, state) => placeholder(state, (l) => l.drawerContact),
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
                builder: (_, __) => const AccountScreen(),
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

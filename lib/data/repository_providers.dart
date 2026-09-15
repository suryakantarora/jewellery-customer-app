import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/data_mode.dart';
import '../core/providers.dart';
import 'api/api_repositories.dart';
import 'demo/demo_repositories.dart';
import 'demo/demo_store.dart';
import 'repositories/repositories.dart';

/// The one place that knows whether the app is on demo data or the backend.
final dataModeProvider = Provider<DataMode>(
  (ref) => ref.watch(appConfigProvider).dataMode,
);

final demoStoreProvider = Provider<DemoStore>((ref) => DemoStore());

T _pick<T>(Ref ref, {required T Function() demo, required T Function() api}) =>
    switch (ref.watch(dataModeProvider)) {
      DataMode.demo => demo(),
      DataMode.api => api(),
    };

final catalogueRepositoryProvider = Provider<CatalogueRepository>(
  (ref) => _pick(
    ref,
    demo: () => DemoCatalogueRepository(ref.watch(demoStoreProvider)),
    api: () => ApiCatalogueRepository(ref.watch(apiClientProvider)),
  ),
);

final categoryRepositoryProvider = Provider<CategoryRepository>(
  (ref) => _pick(
    ref,
    demo: () => DemoCategoryRepository(ref.watch(demoStoreProvider)),
    api: () => ApiCategoryRepository(ref.watch(apiClientProvider)),
  ),
);

final bannerRepositoryProvider = Provider<BannerRepository>(
  (ref) => _pick(
    ref,
    demo: () => DemoBannerRepository(ref.watch(demoStoreProvider)),
    api: () => ApiBannerRepository(ref.watch(apiClientProvider)),
  ),
);

final reviewRepositoryProvider = Provider<ReviewRepository>(
  (ref) => _pick(
    ref,
    demo: () => DemoReviewRepository(ref.watch(demoStoreProvider)),
    api: () => ApiReviewRepository(ref.watch(apiClientProvider)),
  ),
);

final cartRepositoryProvider = Provider<CartRepository>(
  (ref) => _pick(
    ref,
    demo: () => const DemoCartRepository(),
    api: () => ApiCartRepository(ref.watch(apiClientProvider)),
  ),
);

final wishlistRepositoryProvider = Provider<WishlistRepository>(
  (ref) => _pick(
    ref,
    demo: () => const DemoWishlistRepository(),
    api: () => ApiWishlistRepository(ref.watch(apiClientProvider)),
  ),
);

final orderRepositoryProvider = Provider<OrderRepository>(
  (ref) => _pick(
    ref,
    demo: () => const DemoOrderRepository(),
    api: () => ApiOrderRepository(ref.watch(apiClientProvider)),
  ),
);

final accountRepositoryProvider = Provider<AccountRepository>(
  (ref) => _pick(
    ref,
    demo: () => const DemoAccountRepository(),
    api: () => ApiAccountRepository(ref.watch(apiClientProvider)),
  ),
);

final addressRepositoryProvider = Provider<AddressRepository>(
  (ref) => _pick(
    ref,
    demo: () => const DemoAddressRepository(),
    api: () => ApiAddressRepository(ref.watch(apiClientProvider)),
  ),
);

final goldRateRepositoryProvider = Provider<GoldRateRepository>(
  (ref) => _pick(
    ref,
    demo: () => const DemoGoldRateRepository(),
    api: () => ApiGoldRateRepository(ref.watch(apiClientProvider)),
  ),
);

final policyRepositoryProvider = Provider<PolicyRepository>(
  (ref) => _pick(
    ref,
    demo: () => const DemoPolicyRepository(),
    api: () => ApiPolicyRepository(ref.watch(apiClientProvider)),
  ),
);

// --- Read-side providers used by the C1 placeholder screens -----------------

final bannersProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(bannerRepositoryProvider).list(),
);

final categoriesProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(categoryRepositoryProvider).list(),
);

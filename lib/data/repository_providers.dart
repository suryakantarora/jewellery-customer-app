import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/data_mode.dart';
import '../core/providers.dart';
import 'api/api_repositories.dart';
import 'demo/demo_repositories.dart';
import 'demo/demo_store.dart';
import 'models/catalogue_item.dart';
import 'models/category.dart';
import 'models/content.dart';
import 'models/review.dart';
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

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => _pick(
    ref,
    demo: () => DemoAuthRepository(
      ref.watch(demoStoreProvider),
      ref.watch(localStoreProvider),
    ),
    api: () => ApiAuthRepository(ref.watch(apiClientProvider)),
  ),
);

final cartRepositoryProvider = Provider<CartRepository>(
  (ref) => _pick(
    ref,
    demo: () => DemoCartRepository(ref.watch(localStoreProvider)),
    api: () => ApiCartRepository(ref.watch(apiClientProvider)),
  ),
);

final wishlistRepositoryProvider = Provider<WishlistRepository>(
  (ref) => _pick(
    ref,
    demo: () => DemoWishlistRepository(ref.watch(localStoreProvider)),
    api: () => ApiWishlistRepository(ref.watch(apiClientProvider)),
  ),
);

final orderRepositoryProvider = Provider<OrderRepository>(
  (ref) => _pick(
    ref,
    demo: () => DemoOrderRepository(
      ref.watch(demoStoreProvider),
      ref.watch(localStoreProvider),
    ),
    api: () => ApiOrderRepository(ref.watch(apiClientProvider)),
  ),
);

final addressRepositoryProvider = Provider<AddressRepository>(
  (ref) => _pick(
    ref,
    demo: () => DemoAddressRepository(
      ref.watch(demoStoreProvider),
      ref.watch(localStoreProvider),
    ),
    api: () => ApiAddressRepository(ref.watch(apiClientProvider)),
  ),
);

final paymentMethodRepositoryProvider = Provider<PaymentMethodRepository>(
  (ref) => _pick(
    ref,
    demo: () => DemoPaymentMethodRepository(
      ref.watch(demoStoreProvider),
      ref.watch(localStoreProvider),
    ),
    api: () => ApiPaymentMethodRepository(ref.watch(apiClientProvider)),
  ),
);

final goldRateRepositoryProvider = Provider<GoldRateRepository>(
  (ref) => _pick(
    ref,
    demo: () => DemoGoldRateRepository(ref.watch(demoStoreProvider)),
    api: () => ApiGoldRateRepository(ref.watch(apiClientProvider)),
  ),
);

final policyRepositoryProvider = Provider<PolicyRepository>(
  (ref) => _pick(
    ref,
    demo: () => DemoPolicyRepository(ref.watch(demoStoreProvider)),
    api: () => ApiPolicyRepository(ref.watch(apiClientProvider)),
  ),
);

final storeRepositoryProvider = Provider<StoreRepository>(
  (ref) => _pick(
    ref,
    demo: () => DemoStoreRepository(ref.watch(demoStoreProvider)),
    api: () => ApiStoreRepository(ref.watch(apiClientProvider)),
  ),
);

final offerRepositoryProvider = Provider<OfferRepository>(
  (ref) => _pick(
    ref,
    demo: () => DemoOfferRepository(ref.watch(demoStoreProvider)),
    api: () => ApiOfferRepository(ref.watch(apiClientProvider)),
  ),
);

final contentRepositoryProvider = Provider<ContentRepository>(
  (ref) => _pick(
    ref,
    demo: () => DemoContentRepository(ref.watch(demoStoreProvider)),
    api: () => ApiContentRepository(ref.watch(apiClientProvider)),
  ),
);

final feedbackRepositoryProvider = Provider<FeedbackRepository>(
  (ref) => _pick(
    ref,
    demo: () => DemoFeedbackRepository(ref.watch(localStoreProvider)),
    api: () => ApiFeedbackRepository(ref.watch(apiClientProvider)),
  ),
);

final notificationRepositoryProvider = Provider<NotificationRepository>(
  (ref) => _pick(
    ref,
    demo: () => DemoNotificationRepository(
      ref.watch(demoStoreProvider),
      ref.watch(localStoreProvider),
    ),
    api: () => ApiNotificationRepository(ref.watch(apiClientProvider)),
  ),
);

// --- Read-side catalogue providers ------------------------------------------

final bannersProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(bannerRepositoryProvider).list(),
);

final categoriesProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(categoryRepositoryProvider).list(),
);

final categoryProvider = FutureProvider.autoDispose.family<Category?, String>(
  (ref, id) => ref.watch(categoryRepositoryProvider).byId(id),
);

final featuredProductsProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(catalogueRepositoryProvider).featured(),
);

final newArrivalsProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(catalogueRepositoryProvider).newArrivals(),
);

final trendingProductsProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(catalogueRepositoryProvider).trending(),
);

final bestSellersProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(catalogueRepositoryProvider).bestSellers(),
);

final featuredReviewsProvider = FutureProvider.autoDispose<List<Review>>(
  (ref) => ref.watch(reviewRepositoryProvider).featured(),
);

final productProvider = FutureProvider.autoDispose.family<CatalogueItem?, String>(
  (ref, id) => ref.watch(catalogueRepositoryProvider).byId(id),
);

final productReviewsProvider = FutureProvider.autoDispose.family<List<Review>, String>(
  (ref, id) => ref.watch(reviewRepositoryProvider).forProduct(id),
);

final relatedProductsProvider =
    FutureProvider.autoDispose.family<List<CatalogueItem>, String>(
      (ref, id) => ref.watch(catalogueRepositoryProvider).related(id),
    );

final catalogueListProvider =
    FutureProvider.autoDispose.family<List<CatalogueItem>, CatalogueQuery>(
      (ref, query) => ref.watch(catalogueRepositoryProvider).list(query),
    );

/// Price bounds for a listing scope, keyed by `categoryId|audience`.
final priceBoundsProvider = FutureProvider.autoDispose.family<PriceBounds, String>(
  (ref, scope) {
    final parts = scope.split('|');
    return ref.watch(catalogueRepositoryProvider).priceBounds(
      categoryId: parts[0].isEmpty ? null : parts[0],
      audience: parts.length > 1 && parts[1].isNotEmpty ? parts[1] : null,
    );
  },
);

// --- Read-side content providers ---------------------------------------------

final policiesProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(policyRepositoryProvider).list(),
);

final policyProvider = FutureProvider.autoDispose.family<PolicyDoc?, String>(
  (ref, key) => ref.watch(policyRepositoryProvider).byKey(key),
);

final storesProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(storeRepositoryProvider).list(),
);

final storeProvider = FutureProvider.autoDispose.family<Store?, String>(
  (ref, id) => ref.watch(storeRepositoryProvider).byId(id),
);

final offersProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(offerRepositoryProvider).list(),
);

final brandsProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(contentRepositoryProvider).brands(),
);

final trendingCardsProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(contentRepositoryProvider).trending(),
);

final storiesProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(contentRepositoryProvider).stories(),
);

final aboutProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(contentRepositoryProvider).about(),
);


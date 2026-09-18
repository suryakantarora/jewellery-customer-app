import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/session/session_provider.dart';
import '../../data/models/catalogue_item.dart';
import '../../data/models/commerce.dart';
import '../../data/repository_providers.dart';

class WishlistController extends AsyncNotifier<List<WishlistItem>> {
  @override
  Future<List<WishlistItem>> build() {
    ref.watch(sessionIdentityProvider);
    return ref.watch(wishlistRepositoryProvider).items();
  }

  List<WishlistItem> get _items => state.valueOrNull ?? const [];

  bool contains(String productId) =>
      _items.any((i) => i.productId == productId);

  Future<void> _commit(List<WishlistItem> items) async {
    state = AsyncData(items);
    await ref.read(wishlistRepositoryProvider).save(items);
  }

  /// Returns true when the product was added, false when removed.
  Future<bool> toggle(String productId) async {
    if (contains(productId)) {
      await _commit(_items.where((i) => i.productId != productId).toList());
      return false;
    }
    await _commit([
      ..._items,
      WishlistItem(productId: productId, addedAt: DateTime.now()),
    ]);
    return true;
  }

  Future<void> remove(String productId) =>
      _commit(_items.where((i) => i.productId != productId).toList());

  Future<void> clear() => _commit(const []);
}

final wishlistProvider =
    AsyncNotifierProvider<WishlistController, List<WishlistItem>>(
      WishlistController.new,
    );

final wishlistCountProvider = Provider<int>(
  (ref) => ref.watch(wishlistProvider).valueOrNull?.length ?? 0,
);

final isWishlistedProvider = Provider.family<bool, String>(
  (ref, id) =>
      (ref.watch(wishlistProvider).valueOrNull ?? const [])
          .any((i) => i.productId == id),
);

/// Wishlist items joined with their products, newest first.
final wishlistProductsProvider = FutureProvider.autoDispose<List<CatalogueItem>>((
  ref,
) async {
  final items = <WishlistItem>[...ref.watch(wishlistProvider).valueOrNull ?? const []]
    ..sort((a, b) => b.addedAt.compareTo(a.addedAt));
  if (items.isEmpty) return const [];
  return ref
      .watch(catalogueRepositoryProvider)
      .byIds(items.map((i) => i.productId).toList());
});

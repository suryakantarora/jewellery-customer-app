import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/tenant/tenant_config.dart';
import '../../core/tenant/tenant_provider.dart';
import '../../data/models/catalogue_item.dart';
import '../../core/providers.dart';
import '../../core/storage/storage_keys.dart';
import '../../data/models/commerce.dart';
import '../../data/models/content.dart';
import '../../data/repository_providers.dart';

/// The bag: persisted line items joined with their products.
///
/// Lines are keyed by product + size, as in the reference. Quantity is
/// clamped to 1–9.
class CartController extends AsyncNotifier<List<CartLine>> {
  static const maxQuantity = 9;

  @override
  Future<List<CartLine>> build() async {
    final items = await ref.watch(cartRepositoryProvider).items();
    return _resolve(items);
  }

  Future<List<CartLine>> _resolve(List<CartItem> items) async {
    if (items.isEmpty) return const [];
    final products = await ref
        .read(catalogueRepositoryProvider)
        .byIds(items.map((i) => i.productId).toSet().toList());
    final byId = {for (final p in products) p.id: p};
    return [
      for (final item in items)
        if (byId[item.productId] case final product?)
          CartLine(product: product, quantity: item.quantity, size: item.size),
    ];
  }

  List<CartLine> get _lines => state.valueOrNull ?? const [];

  Future<void> _commit(List<CartLine> lines) async {
    state = AsyncData(lines);
    await ref
        .read(cartRepositoryProvider)
        .save(lines.map((l) => l.toItem()).toList());
  }

  Future<void> add(CatalogueItem product, {int quantity = 1, String? size}) {
    final lines = [..._lines];
    final i = lines.indexWhere(
      (l) => l.product.id == product.id && l.size == size,
    );
    if (i >= 0) {
      lines[i] = CartLine(
        product: product,
        quantity: (lines[i].quantity + quantity).clamp(1, maxQuantity),
        size: size,
      );
    } else {
      lines.add(
        CartLine(
          product: product,
          quantity: quantity.clamp(1, maxQuantity),
          size: size,
        ),
      );
    }
    return _commit(lines);
  }

  Future<void> setQuantity(CartLine line, int quantity) {
    if (quantity <= 0) return remove(line);
    return _commit([
      for (final l in _lines)
        if (l.product.id == line.product.id && l.size == line.size)
          CartLine(
            product: l.product,
            quantity: quantity.clamp(1, maxQuantity),
            size: l.size,
          )
        else
          l,
    ]);
  }

  Future<void> remove(CartLine line) => _commit([
    for (final l in _lines)
      if (!(l.product.id == line.product.id && l.size == line.size)) l,
  ]);

  Future<void> clear() => _commit(const []);

  /// Reorder: re-add the given products (in-stock only). Returns how many of
  /// the requested lines could be restored.
  Future<int> addAll(List<CartLine> lines) async {
    var restored = 0;
    for (final l in lines) {
      if (!l.product.retail.inStock) continue;
      await add(l.product, quantity: l.quantity, size: l.size);
      restored++;
    }
    return restored;
  }
}

final cartProvider = AsyncNotifierProvider<CartController, List<CartLine>>(
  CartController.new,
);

final cartCountProvider = Provider<int>(
  (ref) => (ref.watch(cartProvider).valueOrNull ?? const [])
      .fold(0, (n, l) => n + l.quantity),
);

/// The coupon applied in the bag (C8 offers), persisted by code.
class AppliedOfferController extends AsyncNotifier<Offer?> {
  @override
  Future<Offer?> build() async {
    final code = ref.read(localStoreProvider).getString(StorageKeys.appliedOffer);
    if (code == null || code.isEmpty) return null;
    return ref.watch(offerRepositoryProvider).byCode(code);
  }

  /// Applies a code; returns false when it is unknown or expired.
  Future<bool> apply(String code) async {
    final offer = await ref.read(offerRepositoryProvider).byCode(code);
    if (offer == null) return false;
    await ref.read(localStoreProvider).setString(StorageKeys.appliedOffer, offer.code);
    state = AsyncData(offer);
    return true;
  }

  Future<void> clear() async {
    await ref.read(localStoreProvider).remove(StorageKeys.appliedOffer);
    state = const AsyncData(null);
  }
}

final appliedOfferProvider = AsyncNotifierProvider<AppliedOfferController, Offer?>(
  AppliedOfferController.new,
);

/// Subtotal, savings, discount, shipping, tax and total per the tenant's
/// rules and the applied offer.
class CartTotals {
  const CartTotals({
    required this.subtotal,
    required this.savings,
    required this.shipping,
    required this.tax,
    required this.freeDeliveryThreshold,
    this.discount = 0,
    this.offer,
  });

  final num subtotal;
  final num savings;
  final num shipping;
  final num tax;
  final num freeDeliveryThreshold;

  /// Taken off by the applied coupon (0 when none or not eligible).
  final num discount;
  final Offer? offer;

  /// The offer is present but the bag does not meet its minimum.
  bool get offerIneligible =>
      offer != null && subtotal > 0 && subtotal < offer!.minSubtotal;

  num get total => subtotal - discount + shipping + tax;
  bool get freeDelivery => shipping == 0;
  num get remainingForFreeDelivery =>
      (freeDeliveryThreshold - subtotal).clamp(0, double.infinity);
  double get freeDeliveryProgress => freeDeliveryThreshold <= 0
      ? 1
      : (subtotal / freeDeliveryThreshold).clamp(0, 1).toDouble();

  static CartTotals compute(List<CartLine> lines, TenantConfig tenant, {Offer? offer}) {
    final subtotal = lines.fold<num>(0, (n, l) => n + l.lineTotal);
    final savings = lines.fold<num>(0, (n, l) => n + l.lineSavings);
    final discount = offer?.discountFor(subtotal) ?? 0;
    final freeByOffer = offer != null &&
        offer.kind == OfferKind.freeDelivery &&
        subtotal >= offer.minSubtotal;
    final shipping = lines.isEmpty || subtotal >= tenant.freeDeliveryThreshold || freeByOffer
        ? 0
        : tenant.deliveryFee;
    final tax = ((subtotal - discount) * tenant.taxRate).round();
    return CartTotals(
      subtotal: subtotal,
      savings: savings,
      discount: discount,
      offer: offer,
      shipping: shipping,
      tax: tax,
      freeDeliveryThreshold: tenant.freeDeliveryThreshold,
    );
  }
}

final cartTotalsProvider = Provider<CartTotals>((ref) {
  final tenant = ref.watch(tenantProvider).requireValue;
  final lines = ref.watch(cartProvider).valueOrNull ?? const [];
  final offer = ref.watch(appliedOfferProvider).valueOrNull;
  return CartTotals.compute(lines, tenant, offer: offer);
});

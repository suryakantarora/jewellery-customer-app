import 'dart:math';

import 'models/catalogue_item.dart';
import 'models/retail_attributes.dart';
import 'repositories/repositories.dart';

/// Sorting, faceting and affinity over an in-memory catalogue.
///
/// Both data modes use it: the demo repository over the bundled JSON, the API
/// repository over the priced catalogue the backend serves whole (the facets
/// are mostly over values that only exist after pricing, so the server would
/// have to price everything to filter anyway).
abstract final class CatalogueLogic {
  static bool _inScope(CatalogueItem i, String? categoryId, String? audience) {
    if (categoryId != null && categoryId != 'all' && i.categoryId != categoryId) {
      return false;
    }
    if (audience != null &&
        i.retail.audience.name != audience.toLowerCase() &&
        i.retail.audience != Audience.unisex) {
      return false;
    }
    return true;
  }

  static List<CatalogueItem> apply(
    Iterable<CatalogueItem> catalogue,
    CatalogueQuery query,
  ) {
    final items = catalogue.where((i) {
      final r = i.retail;
      if (!_inScope(i, query.categoryId, query.audience)) return false;
      if (query.metals.isNotEmpty && !query.metals.contains(i.metalName)) {
        return false;
      }
      if (query.purities.isNotEmpty && !query.purities.contains(i.purityCode)) {
        return false;
      }
      if (query.stones.isNotEmpty && !query.stones.contains(r.stone)) {
        return false;
      }
      if (query.minPrice != null && i.price < query.minPrice!) return false;
      if (query.maxPrice != null && i.price > query.maxPrice!) return false;
      if (query.minRating != null && r.rating < query.minRating!) return false;
      if (query.inStockOnly && !r.inStock) return false;
      if (query.tag != null &&
          !r.tags.map((t) => t.toLowerCase()).contains(query.tag!.toLowerCase())) {
        return false;
      }
      if (query.brand != null &&
          r.brand.toLowerCase() != query.brand!.toLowerCase()) {
        return false;
      }
      final term = query.search?.trim().toLowerCase();
      if (term != null && term.isNotEmpty) {
        final hay = [
          i.productName,
          i.categoryName,
          i.metalName,
          i.purityName,
          r.stone,
          r.collection,
          r.audience.name,
          r.brand,
          ...r.tags,
        ].join(' ').toLowerCase();
        if (!hay.contains(term)) return false;
      }
      return true;
    }).toList();

    int byFeatured(CatalogueItem a, CatalogueItem b) {
      final fa = a.retail.isFeatured ? 0 : 1;
      final fb = b.retail.isFeatured ? 0 : 1;
      return fa != fb ? fa - fb : b.retail.rating.compareTo(a.retail.rating);
    }

    return switch (query.sort) {
      CatalogueSort.featured => (items..sort(byFeatured)),
      CatalogueSort.newest => (items
        ..sort((a, b) => (b.retail.isNew ? 1 : 0) - (a.retail.isNew ? 1 : 0))),
      CatalogueSort.priceAsc => (items..sort((a, b) => a.price.compareTo(b.price))),
      CatalogueSort.priceDesc => (items..sort((a, b) => b.price.compareTo(a.price))),
      CatalogueSort.rating => (items
        ..sort((a, b) => b.retail.rating.compareTo(a.retail.rating))),
    };
  }

  static List<CatalogueItem> byIds(Iterable<CatalogueItem> catalogue, List<String> ids) => [
    for (final id in ids) ...catalogue.where((i) => i.id == id),
  ];

  /// Affinity-scored like the reference: category 4, collection 3, stone 2,
  /// metal 1.
  static List<CatalogueItem> related(
    Iterable<CatalogueItem> catalogue,
    String id, {
    int limit = 8,
  }) {
    final base = catalogue.where((i) => i.id == id).firstOrNull;
    if (base == null) return const [];
    int score(CatalogueItem o) =>
        (o.categoryId == base.categoryId ? 4 : 0) +
        (o.retail.collection == base.retail.collection ? 3 : 0) +
        (o.retail.stone == base.retail.stone ? 2 : 0) +
        (o.metalName == base.metalName ? 1 : 0);
    final others = catalogue.where((i) => i.id != id).toList()
      ..sort((a, b) => score(b).compareTo(score(a)));
    return others.take(limit).toList();
  }

  static PriceBounds priceBounds(
    Iterable<CatalogueItem> catalogue, {
    String? categoryId,
    String? audience,
  }) {
    final scoped = catalogue
        .where((i) => _inScope(i, categoryId, audience))
        .map((i) => i.price);
    if (scoped.isEmpty) return const PriceBounds(0, 0);
    return PriceBounds(scoped.reduce(min), scoped.reduce(max));
  }
}

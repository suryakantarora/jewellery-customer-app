import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/banner.dart';
import '../models/catalogue_item.dart';
import '../models/category.dart';
import '../models/commerce.dart';
import '../models/review.dart';

/// Parses the bundled demo JSON once and shares it between the demo
/// repositories. Every read adds the reference app's 420 ms latency so
/// skeletons and error states are exercised for real.
class DemoStore {
  DemoStore({
    this.assetPath = 'assets/demo/catalogue.json',
    this.commerceAssetPath = 'assets/demo/commerce.json',
    Duration? latency,
  }) : latency = latency ?? defaultLatency;

  static const defaultLatency = Duration(milliseconds: 420);

  final String assetPath;
  final String commerceAssetPath;
  final Duration latency;

  Future<DemoData>? _loading;
  Future<DemoCommerceSeed>? _loadingCommerce;

  Future<Map<String, dynamic>> _json(String path) async {
    // `loadString` hands anything over 50 KB to an isolate; decoding here
    // keeps the read deterministic under widget tests and costs nothing at
    // this size.
    final bytes = await rootBundle.load(path);
    final raw = utf8.decode(bytes.buffer.asUint8List());
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<DemoData> _load() => _loading ??= () async {
    final json = await _json(assetPath);
    return DemoData(
      items: (json['items'] as List)
          .map((e) => CatalogueItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      categories: (json['categories'] as List)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
      banners: (json['banners'] as List)
          .map((e) => Banner.fromJson(e as Map<String, dynamic>))
          .toList(),
      reviews: (json['reviews'] as List? ?? const [])
          .map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }();

  Future<DemoCommerceSeed> _loadCommerce() => _loadingCommerce ??= () async {
    final json = await _json(commerceAssetPath);
    List<T> list<T>(String key, T Function(Map<String, dynamic>) from) =>
        (json[key] as List? ?? const [])
            .map((e) => from(e as Map<String, dynamic>))
            .toList();
    return DemoCommerceSeed(
      accounts: list('accounts', Account.fromJson),
      addresses: list('addresses', Address.fromJson),
      paymentMethods: list('paymentMethods', PaymentMethod.fromJson),
      orders: list('orders', Order.fromJson),
    );
  }();

  Future<T> read<T>(T Function(DemoData data) select) async {
    final data = await _load();
    await Future<void>.delayed(latency);
    return select(data);
  }

  /// Like [read] but with a custom delay (order placement takes longer).
  Future<T> readCommerce<T>(
    T Function(DemoCommerceSeed seed) select, {
    Duration? latency,
  }) async {
    final seed = await _loadCommerce();
    await Future<void>.delayed(latency ?? this.latency);
    return select(seed);
  }
}

class DemoData {
  const DemoData({
    required this.items,
    required this.categories,
    required this.banners,
    required this.reviews,
  });

  final List<CatalogueItem> items;
  final List<Category> categories;
  final List<Banner> banners;
  final List<Review> reviews;
}

/// Seed customer data for the demo account; copied into local storage on
/// first use so edits persist across launches.
class DemoCommerceSeed {
  const DemoCommerceSeed({
    required this.accounts,
    required this.addresses,
    required this.paymentMethods,
    required this.orders,
  });

  final List<Account> accounts;
  final List<Address> addresses;
  final List<PaymentMethod> paymentMethods;
  final List<Order> orders;
}

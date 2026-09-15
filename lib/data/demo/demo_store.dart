import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/banner.dart';
import '../models/catalogue_item.dart';
import '../models/category.dart';
import '../models/review.dart';

/// Parses `assets/demo/catalogue.json` once and shares it between the demo
/// repositories. Every read adds the reference app's 420 ms latency so
/// skeletons and error states are exercised for real.
class DemoStore {
  DemoStore({this.assetPath = 'assets/demo/catalogue.json', Duration? latency})
    : latency = latency ?? defaultLatency;

  static const defaultLatency = Duration(milliseconds: 420);

  final String assetPath;
  final Duration latency;

  Future<DemoData>? _loading;

  Future<DemoData> _load() => _loading ??= () async {
    // `loadString` hands anything over 50 KB to an isolate; decoding here
    // keeps the read deterministic under widget tests and costs nothing at
    // this size.
    final bytes = await rootBundle.load(assetPath);
    final raw = utf8.decode(bytes.buffer.asUint8List());
    final json = jsonDecode(raw) as Map<String, dynamic>;
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

  Future<T> read<T>(T Function(DemoData data) select) async {
    final data = await _load();
    await Future<void>.delayed(latency);
    return select(data);
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

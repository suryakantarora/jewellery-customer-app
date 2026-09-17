/// Presentation extras the ERP catalogue lacks today (plan §5). These become
/// backend fields in C10; until then the demo JSON carries them.
class RetailAttributes {
  const RetailAttributes({
    this.originalPrice,
    this.discountPercent,
    this.rating = 0,
    this.reviewCount = 0,
    this.isNew = false,
    this.isTrending = false,
    this.isBestSeller = false,
    this.isFeatured = false,
    this.inStock = true,
    this.deliveryDays = 3,
    this.certified = true,
    this.sizeKind = SizeKind.none,
    this.sizes = const [],
    this.audience = Audience.unisex,
    this.collection = '',
    this.stone = 'None',
    this.description = '',
    this.tags = const [],
    this.brand = '',
  });

  final num? originalPrice;
  final int? discountPercent;
  final double rating;
  final int reviewCount;
  final bool isNew;
  final bool isTrending;
  final bool isBestSeller;
  final bool isFeatured;
  final bool inStock;
  final int deliveryDays;
  final bool certified;
  final SizeKind sizeKind;
  final List<String> sizes;
  final Audience audience;
  final String collection;
  final String stone;
  final String description;

  /// Merchandising tags (`solitaire`, `gift`, `bridal`…) for curated lists.
  final List<String> tags;

  /// House brand / line the piece belongs to (empty = unbranded).
  final String brand;

  factory RetailAttributes.fromJson(Map<String, dynamic> json) =>
      RetailAttributes(
        originalPrice: json['originalPrice'] as num?,
        discountPercent: (json['discountPercent'] as num?)?.toInt(),
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
        isNew: json['isNew'] as bool? ?? false,
        isTrending: json['isTrending'] as bool? ?? false,
        isBestSeller: json['isBestSeller'] as bool? ?? false,
        isFeatured: json['isFeatured'] as bool? ?? false,
        inStock: json['inStock'] as bool? ?? true,
        deliveryDays: (json['deliveryDays'] as num?)?.toInt() ?? 3,
        certified: json['certified'] as bool? ?? true,
        sizeKind: SizeKind.fromName(json['sizeKind'] as String?),
        sizes: (json['sizes'] as List? ?? const []).map((e) => e.toString()).toList(),
        audience: Audience.fromName(json['audience'] as String?),
        collection: json['collection'] as String? ?? '',
        stone: json['stone'] as String? ?? 'None',
        description: json['description'] as String? ?? '',
        tags: (json['tags'] as List? ?? const []).map((e) => e.toString()).toList(),
        brand: json['brand'] as String? ?? '',
      );
}

enum SizeKind {
  ring,
  bangle,
  length,
  none;

  static SizeKind fromName(String? name) =>
      values.where((v) => v.name == name).firstOrNull ?? SizeKind.none;
}

enum Audience {
  women,
  men,
  kids,
  unisex;

  static Audience fromName(String? name) =>
      values.where((v) => v.name == name?.toLowerCase()).firstOrNull ??
      Audience.unisex;
}

import '../../core/media/image_ref.dart';
import 'retail_attributes.dart';

/// One product, shaped like the ERP catalogue response.
///
/// Retail-only fields the ERP lacks today live in [retail] (plan §2) so that
/// when the backend grows them the model changes in one place.
class CatalogueItem {
  const CatalogueItem({
    required this.id,
    required this.itemCode,
    required this.productName,
    required this.categoryId,
    required this.categoryName,
    required this.designName,
    required this.metalName,
    required this.purityCode,
    required this.purityName,
    required this.grossWeight,
    required this.netMetalWeight,
    required this.stoneCount,
    required this.totalCarat,
    required this.hallmarkNumber,
    required this.price,
    required this.currency,
    required this.primaryImageKey,
    required this.fallbackImageKey,
    required this.images,
    required this.retail,
  });

  final String id;
  final String itemCode;
  final String productName;
  final String categoryId;
  final String categoryName;
  final String designName;
  final String metalName;
  final String purityCode;
  final String purityName;
  final double grossWeight;
  final double netMetalWeight;
  final int stoneCount;
  final double totalCarat;
  final String? hallmarkNumber;
  final num price;
  final String currency;
  final ImageRef primaryImageKey;
  final ImageRef fallbackImageKey;
  final List<ImageRef> images;
  final RetailAttributes retail;

  /// The image to show first: primary, else fallback, else the first extra.
  ImageRef get heroImage => primaryImageKey.isEmpty
      ? (fallbackImageKey.isEmpty ? images.firstOrNull ?? ImageRef.none : fallbackImageKey)
      : primaryImageKey;

  factory CatalogueItem.fromJson(Map<String, dynamic> json) => CatalogueItem(
    id: json['id'].toString(),
    itemCode: json['itemCode'] as String,
    productName: json['productName'] as String,
    categoryId: json['categoryId'].toString(),
    categoryName: json['categoryName'] as String,
    designName: json['designName'] as String? ?? '',
    metalName: json['metalName'] as String,
    purityCode: json['purityCode'] as String,
    purityName: json['purityName'] as String? ?? json['purityCode'] as String,
    grossWeight: (json['grossWeight'] as num?)?.toDouble() ?? 0,
    netMetalWeight: (json['netMetalWeight'] as num?)?.toDouble() ?? 0,
    stoneCount: (json['stoneCount'] as num?)?.toInt() ?? 0,
    totalCarat: (json['totalCarat'] as num?)?.toDouble() ?? 0,
    hallmarkNumber: json['hallmarkNumber'] as String?,
    price: json['price'] as num,
    currency: json['currency'] as String? ?? 'LAK',
    primaryImageKey: ImageRef.fromString(json['primaryImageKey'] as String?),
    fallbackImageKey: ImageRef.fromString(json['fallbackImageKey'] as String?),
    images: (json['images'] as List? ?? const [])
        .map((e) => ImageRef.fromString(e as String?))
        .toList(),
    retail: RetailAttributes.fromJson(
      json['retail'] as Map<String, dynamic>? ?? const {},
    ),
  );
}

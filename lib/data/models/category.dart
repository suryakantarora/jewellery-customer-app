import '../../core/media/image_ref.dart';
import 'localized_text.dart';

class Category {
  const Category({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.icon,
    required this.productCount,
    required this.featured,
  });

  final String id;
  final LocalizedText name;
  final LocalizedText description;
  final ImageRef image;
  final ImageRef icon;
  final int productCount;
  final bool featured;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['id'].toString(),
    name: LocalizedText.fromJson(json['name']),
    description: LocalizedText.fromJson(json['description']),
    image: ImageRef.fromString(json['image'] as String?),
    icon: ImageRef.fromString(json['icon'] as String?),
    productCount: (json['productCount'] as num?)?.toInt() ?? 0,
    featured: json['featured'] as bool? ?? false,
  );
}

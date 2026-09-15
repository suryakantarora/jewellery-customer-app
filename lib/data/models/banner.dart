import '../../core/media/image_ref.dart';
import 'localized_text.dart';

enum BannerPlacement { hero, promo }

class Banner {
  const Banner({
    required this.id,
    required this.image,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.cta,
    required this.link,
    required this.placement,
  });

  final String id;
  final ImageRef image;
  final LocalizedText eyebrow;
  final LocalizedText title;
  final LocalizedText subtitle;
  final LocalizedText cta;

  /// An in-app route (`/category/rings`).
  final String link;
  final BannerPlacement placement;

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
    id: json['id'].toString(),
    image: ImageRef.fromString(json['image'] as String?),
    eyebrow: LocalizedText.fromJson(json['eyebrow']),
    title: LocalizedText.fromJson(json['title']),
    subtitle: LocalizedText.fromJson(json['subtitle']),
    cta: LocalizedText.fromJson(json['cta']),
    link: json['link'] as String? ?? '/home',
    placement: json['placement'] == 'promo'
        ? BannerPlacement.promo
        : BannerPlacement.hero,
  );
}

import '../../core/media/image_ref.dart';
import 'localized_text.dart';

/// Company-wide selling rate per purity (plan Q7), in several currencies.
class GoldRate {
  const GoldRate({
    required this.purityCode,
    required this.label,
    required this.rates,
    this.delta = 0,
  });

  final String purityCode;

  /// Display label ("24K", "PT950").
  final String label;

  /// Per currency code, per gram: `{LAK: 6800000, USD: 82.4, THB: 2870}`.
  final Map<String, num> rates;

  /// Change since the previous tick, as a fraction (+0.004 = +0.4%).
  final double delta;

  num? operator [](String currency) => rates[currency];

  GoldRate copyWith({Map<String, num>? rates, double? delta}) => GoldRate(
    purityCode: purityCode,
    label: label,
    rates: rates ?? this.rates,
    delta: delta ?? this.delta,
  );

  factory GoldRate.fromJson(Map<String, dynamic> json) => GoldRate(
    purityCode: json['purityCode'] as String,
    label: json['label'] as String? ?? json['purityCode'] as String,
    rates: (json['rates'] as Map<String, dynamic>).map(
      (k, v) => MapEntry(k, v as num),
    ),
  );
}

/// A snapshot of all rates with the moment they were taken.
class GoldRateSheet {
  const GoldRateSheet({required this.rates, required this.updatedAt});
  final List<GoldRate> rates;
  final DateTime updatedAt;

  GoldRate? byPurity(String code) =>
      rates.where((r) => r.purityCode == code).firstOrNull;
}

/// One block of a policy document: prose, bullets, numbered steps or a
/// small table.
class PolicySection {
  const PolicySection({
    required this.heading,
    this.body,
    this.bullets = const [],
    this.steps = const [],
    this.table = const [],
  });

  final String heading;
  final String? body;
  final List<String> bullets;
  final List<String> steps;

  /// Rows of cells; the first row is the header.
  final List<List<String>> table;

  factory PolicySection.fromJson(Map<String, dynamic> json) => PolicySection(
    heading: json['heading'] as String,
    body: json['body'] as String?,
    bullets: (json['bullets'] as List? ?? const []).cast<String>(),
    steps: (json['steps'] as List? ?? const []).cast<String>(),
    table: (json['table'] as List? ?? const [])
        .map((r) => (r as List).cast<String>())
        .toList(),
  );
}

class PolicyFaq {
  const PolicyFaq({required this.question, required this.answer});
  final String question;
  final String answer;

  factory PolicyFaq.fromJson(Map<String, dynamic> json) =>
      PolicyFaq(question: json['q'] as String, answer: json['a'] as String);
}

class PolicyHighlight {
  const PolicyHighlight({required this.value, required this.label});
  final String value;
  final String label;

  factory PolicyHighlight.fromJson(Map<String, dynamic> json) =>
      PolicyHighlight(
        value: json['value'] as String,
        label: json['label'] as String,
      );
}

/// One of the six policy documents (Return, Exchange, Repair & Care,
/// Shipping, EMI & Payment, Help Centre).
class PolicyDoc {
  const PolicyDoc({
    required this.key,
    required this.title,
    required this.icon,
    required this.tagline,
    required this.updated,
    this.highlights = const [],
    this.sections = const [],
    this.faqs = const [],
  });

  final String key;
  final String title;

  /// A Material icon name from the small set the policy screen knows.
  final String icon;
  final String tagline;
  final String updated;
  final List<PolicyHighlight> highlights;
  final List<PolicySection> sections;
  final List<PolicyFaq> faqs;

  factory PolicyDoc.fromJson(Map<String, dynamic> json) => PolicyDoc(
    key: json['key'] as String,
    title: json['title'] as String,
    icon: json['icon'] as String? ?? 'article',
    tagline: json['tagline'] as String? ?? '',
    updated: json['updated'] as String? ?? '',
    highlights: (json['highlights'] as List? ?? const [])
        .map((e) => PolicyHighlight.fromJson(e as Map<String, dynamic>))
        .toList(),
    sections: (json['sections'] as List? ?? const [])
        .map((e) => PolicySection.fromJson(e as Map<String, dynamic>))
        .toList(),
    faqs: (json['faqs'] as List? ?? const [])
        .map((e) => PolicyFaq.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

/// A physical boutique.
class Store {
  const Store({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
    required this.phone,
    required this.hours,
    required this.image,
    required this.latitude,
    required this.longitude,
    this.flagship = false,
    this.services = const [],
  });

  final String id;
  final String name;
  final String city;
  final String address;
  final String phone;
  final String hours;
  final ImageRef image;
  final double latitude;
  final double longitude;
  final bool flagship;
  final List<String> services;

  factory Store.fromJson(Map<String, dynamic> json) => Store(
    id: json['id'].toString(),
    name: json['name'] as String,
    city: json['city'] as String,
    address: json['address'] as String,
    phone: json['phone'] as String? ?? '',
    hours: json['hours'] as String? ?? '',
    image: ImageRef.fromString(json['image'] as String?),
    latitude: (json['lat'] as num).toDouble(),
    longitude: (json['lng'] as num).toDouble(),
    flagship: json['flagship'] as bool? ?? false,
    services: (json['services'] as List? ?? const []).cast<String>(),
  );
}

enum OfferKind {
  percent,
  amount,
  freeDelivery;

  static OfferKind fromName(String? name) =>
      values.where((v) => v.name == name).firstOrNull ?? OfferKind.percent;
}

/// A coupon the customer can apply in the bag.
class Offer {
  const Offer({
    required this.id,
    required this.code,
    required this.title,
    required this.subtitle,
    required this.kind,
    required this.value,
    required this.minSubtotal,
    required this.expires,
    this.image = ImageRef.none,
    this.featured = false,
    this.terms = const [],
  });

  final String id;
  final String code;
  final LocalizedText title;
  final LocalizedText subtitle;
  final OfferKind kind;

  /// Percent (0–100) or a flat amount, depending on [kind].
  final num value;
  final num minSubtotal;
  final DateTime expires;
  final ImageRef image;
  final bool featured;
  final List<String> terms;

  bool get expired => DateTime.now().isAfter(expires);

  /// The discount this offer takes off a subtotal (0 when not eligible).
  num discountFor(num subtotal) {
    if (subtotal < minSubtotal) return 0;
    return switch (kind) {
      OfferKind.percent => (subtotal * value / 100).round(),
      OfferKind.amount => value.clamp(0, subtotal),
      OfferKind.freeDelivery => 0,
    };
  }

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
    id: json['id'].toString(),
    code: json['code'] as String,
    title: LocalizedText.fromJson(json['title']),
    subtitle: LocalizedText.fromJson(json['subtitle']),
    kind: OfferKind.fromName(json['kind'] as String?),
    value: json['value'] as num? ?? 0,
    minSubtotal: json['minSubtotal'] as num? ?? 0,
    expires:
        DateTime.tryParse(json['expires'] as String? ?? '') ?? DateTime(2100),
    image: ImageRef.fromString(json['image'] as String?),
    featured: json['featured'] as bool? ?? false,
    terms: (json['terms'] as List? ?? const []).cast<String>(),
  );
}

/// A house brand / line shown in the home "Our brands" mosaic.
class Brand {
  const Brand({
    required this.id,
    required this.name,
    required this.tagline,
    required this.image,
    this.tall = false,
  });

  final String id;
  final String name;
  final LocalizedText tagline;
  final ImageRef image;

  /// Spans two rows in the mosaic.
  final bool tall;

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
    id: json['id'].toString(),
    name: json['name'] as String,
    tagline: LocalizedText.fromJson(json['tagline']),
    image: ImageRef.fromString(json['image'] as String?),
    tall: json['tall'] as bool? ?? false,
  );
}

/// A tall editorial card in the home "What's trending" rail.
class TrendingCard {
  const TrendingCard({
    required this.id,
    required this.image,
    required this.headline,
    required this.subline,
    required this.link,
  });

  final String id;
  final ImageRef image;
  final LocalizedText headline;
  final LocalizedText subline;
  final String link;

  factory TrendingCard.fromJson(Map<String, dynamic> json) => TrendingCard(
    id: json['id'].toString(),
    image: ImageRef.fromString(json['image'] as String?),
    headline: LocalizedText.fromJson(json['headline']),
    subline: LocalizedText.fromJson(json['subline']),
    link: json['link'] as String? ?? '/category/all',
  );
}

enum NotificationKind {
  order,
  offer,
  goldRate,
  general;

  static NotificationKind fromName(String? name) =>
      values.where((v) => v.name == name).firstOrNull ??
      NotificationKind.general;
}

class AppNotification {
  const AppNotification({
    required this.id,
    required this.kind,
    required this.title,
    required this.body,
    required this.date,
    this.link,
    this.read = false,
  });

  final String id;
  final NotificationKind kind;
  final String title;
  final String body;
  final DateTime date;
  final String? link;
  final bool read;

  AppNotification copyWith({bool? read}) => AppNotification(
    id: id,
    kind: kind,
    title: title,
    body: body,
    date: date,
    link: link,
    read: read ?? this.read,
  );

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: json['id'].toString(),
        kind: NotificationKind.fromName(json['kind'] as String?),
        title: json['title'] as String,
        body: json['body'] as String,
        date:
            DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
        link: json['link'] as String?,
        read: json['read'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'body': body,
    'date': date.toIso8601String(),
    'link': link,
    'read': read,
  };
}

/// A customer story: a review with a product shot and a like count.
class Story {
  const Story({
    required this.id,
    required this.productId,
    required this.author,
    required this.avatar,
    required this.date,
    required this.rating,
    required this.body,
    required this.image,
    required this.productName,
    this.verified = true,
    this.likes = 0,
    this.comments = 0,
  });

  final String id;
  final String productId;
  final String author;
  final ImageRef avatar;
  final DateTime date;
  final double rating;
  final String body;
  final ImageRef image;
  final String productName;
  final bool verified;
  final int likes;
  final int comments;

  factory Story.fromJson(Map<String, dynamic> json) => Story(
    id: json['id'].toString(),
    productId: json['productId'].toString(),
    author: json['author'] as String,
    avatar: ImageRef.fromString(json['avatar'] as String?),
    date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
    rating: (json['rating'] as num?)?.toDouble() ?? 5,
    body: json['body'] as String,
    image: ImageRef.fromString(json['image'] as String?),
    productName: json['productName'] as String? ?? '',
    verified: json['verified'] as bool? ?? true,
    likes: (json['likes'] as num?)?.toInt() ?? 0,
    comments: (json['comments'] as num?)?.toInt() ?? 0,
  );
}

class AboutSection {
  const AboutSection({required this.heading, required this.body});
  final String heading;
  final String body;

  factory AboutSection.fromJson(Map<String, dynamic> json) => AboutSection(
    heading: json['heading'] as String,
    body: json['body'] as String,
  );
}

/// The "About us" page and the home teaser drawn from it.
class AboutContent {
  const AboutContent({
    required this.hero,
    required this.intro,
    required this.founded,
    required this.sections,
    this.stats = const [],
  });

  final ImageRef hero;
  final String intro;
  final String founded;
  final List<AboutSection> sections;
  final List<PolicyHighlight> stats;

  factory AboutContent.fromJson(Map<String, dynamic> json) => AboutContent(
    hero: ImageRef.fromString(json['hero'] as String?),
    intro: json['intro'] as String? ?? '',
    founded: json['founded'] as String? ?? '',
    sections: (json['sections'] as List? ?? const [])
        .map((e) => AboutSection.fromJson(e as Map<String, dynamic>))
        .toList(),
    stats: (json['stats'] as List? ?? const [])
        .map((e) => PolicyHighlight.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

import '../../core/media/image_ref.dart';

class Review {
  const Review({
    required this.id,
    required this.productId,
    required this.author,
    required this.avatar,
    required this.rating,
    required this.date,
    required this.body,
    required this.verified,
  });

  final String id;
  final String productId;
  final String author;
  final ImageRef avatar;
  final double rating;
  final DateTime date;
  final String body;
  final bool verified;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json['id'].toString(),
    productId: json['productId'].toString(),
    author: json['author'] as String,
    avatar: ImageRef.fromString(json['avatar'] as String?),
    rating: (json['rating'] as num).toDouble(),
    date: DateTime.parse(json['date'] as String),
    body: json['body'] as String,
    verified: json['verified'] as bool? ?? false,
  );
}

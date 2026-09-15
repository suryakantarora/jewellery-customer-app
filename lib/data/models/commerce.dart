import '../../core/media/image_ref.dart';

/// Skeleton models for later phases (C5–C7). Kept minimal so the repository
/// interfaces can be typed now and grow without breaking C1.
class CartItem {
  const CartItem({required this.productId, required this.quantity, this.size});
  final String productId;
  final int quantity;
  final String? size;
}

class WishlistItem {
  const WishlistItem({required this.productId, required this.addedAt});
  final String productId;
  final DateTime addedAt;
}

enum OrderStatus { placed, confirmed, packed, shipped, delivered, cancelled }

class OrderItem {
  const OrderItem({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    this.size,
  });
  final String productId;
  final String name;
  final ImageRef image;
  final num price;
  final int quantity;
  final String? size;
}

class Order {
  const Order({
    required this.id,
    required this.date,
    required this.status,
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.total,
  });
  final String id;
  final DateTime date;
  final OrderStatus status;
  final List<OrderItem> items;
  final num subtotal;
  final num shipping;
  final num tax;
  final num total;
}

class Address {
  const Address({
    required this.id,
    required this.label,
    required this.name,
    required this.line1,
    required this.city,
    required this.postcode,
    required this.phone,
    required this.isDefault,
  });
  final String id;
  final String label;
  final String name;
  final String line1;
  final String city;
  final String postcode;
  final String phone;
  final bool isDefault;
}

class GoldRate {
  const GoldRate({required this.purityCode, required this.rates});
  final String purityCode;

  /// Per currency code, e.g. `{LAK: 6_800_000, USD: 82.4}`.
  final Map<String, num> rates;
}

class PolicyDoc {
  const PolicyDoc({required this.key, required this.title, required this.body});
  final String key;
  final String title;
  final String body;
}

class Account {
  const Account({
    required this.name,
    required this.phone,
    this.email,
    this.avatar = ImageRef.none,
    this.memberSince,
    this.tier,
  });
  final String name;
  final String phone;
  final String? email;
  final ImageRef avatar;
  final DateTime? memberSince;
  final String? tier;
}

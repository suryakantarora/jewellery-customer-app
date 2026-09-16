import '../../core/media/image_ref.dart';
import 'catalogue_item.dart';
import 'localized_text.dart';

/// Commerce models shared by the cart, checkout, orders and account features.
/// Every model round-trips through JSON so the demo repositories can persist
/// it locally and the API repositories can map it 1:1 in C10.

class CartItem {
  const CartItem({required this.productId, required this.quantity, this.size});
  final String productId;
  final int quantity;
  final String? size;

  CartItem copyWith({int? quantity}) =>
      CartItem(productId: productId, quantity: quantity ?? this.quantity, size: size);

  bool matches(String productId, String? size) =>
      this.productId == productId && this.size == size;

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    productId: json['productId'].toString(),
    quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    size: json['size'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'quantity': quantity,
    if (size != null) 'size': size,
  };
}

/// A cart item joined with its product, for display and totals.
class CartLine {
  const CartLine({required this.product, required this.quantity, this.size});
  final CatalogueItem product;
  final int quantity;
  final String? size;

  num get lineTotal => product.price * quantity;
  num get lineSavings {
    final original = product.retail.originalPrice;
    return original == null ? 0 : (original - product.price) * quantity;
  }

  CartItem toItem() =>
      CartItem(productId: product.id, quantity: quantity, size: size);
}

class WishlistItem {
  const WishlistItem({required this.productId, required this.addedAt});
  final String productId;
  final DateTime addedAt;

  factory WishlistItem.fromJson(Map<String, dynamic> json) => WishlistItem(
    productId: json['productId'].toString(),
    addedAt: DateTime.tryParse(json['addedAt'] as String? ?? '') ?? DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'addedAt': addedAt.toIso8601String(),
  };
}

enum OrderStatus {
  placed,
  confirmed,
  packed,
  shipped,
  delivered,
  cancelled;

  static OrderStatus fromName(String? name) =>
      values.where((v) => v.name == name?.toLowerCase()).firstOrNull ??
      OrderStatus.placed;

  /// The five tracking stages; cancelled orders stop after "placed".
  static const stages = [placed, confirmed, packed, shipped, delivered];

  int get stageIndex => this == cancelled ? 0 : stages.indexOf(this);

  bool get isActive =>
      this != delivered && this != cancelled;
}

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

  num get lineTotal => price * quantity;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    productId: json['productId'].toString(),
    name: json['name'] as String,
    image: ImageRef.fromString(json['image'] as String?),
    price: json['price'] as num,
    quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    size: json['size'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'name': name,
    'image': image.toString(),
    'price': price,
    'quantity': quantity,
    if (size != null) 'size': size,
  };
}

enum PaymentKind {
  card,
  wallet,
  cod;

  static PaymentKind fromName(String? name) =>
      values.where((v) => v.name == name).firstOrNull ?? PaymentKind.cod;
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
    required this.address,
    required this.paymentKind,
    this.courier,
    this.trackingNumber,
    this.eta,
  });

  final String id;
  final DateTime date;
  final OrderStatus status;
  final List<OrderItem> items;
  final num subtotal;
  final num shipping;
  final num tax;
  final num total;

  /// One-line delivery address as it was at the time of ordering.
  final String address;
  final PaymentKind paymentKind;
  final String? courier;
  final String? trackingNumber;
  final LocalizedText? eta;

  int get itemCount => items.fold(0, (n, i) => n + i.quantity);

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json['id'].toString(),
    date: DateTime.parse(json['date'] as String),
    status: OrderStatus.fromName(json['status'] as String?),
    items: (json['items'] as List? ?? const [])
        .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
        .toList(),
    subtotal: json['subtotal'] as num,
    shipping: json['shipping'] as num? ?? 0,
    tax: json['tax'] as num? ?? 0,
    total: json['total'] as num,
    address: json['address'] as String? ?? '',
    paymentKind: PaymentKind.fromName(json['paymentKind'] as String?),
    courier: json['courier'] as String?,
    trackingNumber: json['trackingNumber'] as String?,
    eta: json['eta'] == null ? null : LocalizedText.fromJson(json['eta']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'status': status.name,
    'items': items.map((i) => i.toJson()).toList(),
    'subtotal': subtotal,
    'shipping': shipping,
    'tax': tax,
    'total': total,
    'address': address,
    'paymentKind': paymentKind.name,
    if (courier != null) 'courier': courier,
    if (trackingNumber != null) 'trackingNumber': trackingNumber,
    if (eta != null) 'eta': eta!.toJson(),
  };
}

/// What checkout hands to the order repository.
class OrderDraft {
  const OrderDraft({
    required this.lines,
    required this.address,
    required this.payment,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.total,
  });
  final List<CartLine> lines;
  final Address address;
  final PaymentMethod payment;
  final num subtotal;
  final num shipping;
  final num tax;
  final num total;
}

enum AddressLabel {
  home,
  work,
  other;

  static AddressLabel fromName(String? name) =>
      values.where((v) => v.name == name?.toLowerCase()).firstOrNull ??
      AddressLabel.other;
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
  final AddressLabel label;
  final String name;
  final String line1;
  final String city;
  final String postcode;
  final String phone;
  final bool isDefault;

  String get oneLine => '$line1, $city $postcode';

  Address copyWith({
    String? id,
    AddressLabel? label,
    String? name,
    String? line1,
    String? city,
    String? postcode,
    String? phone,
    bool? isDefault,
  }) => Address(
    id: id ?? this.id,
    label: label ?? this.label,
    name: name ?? this.name,
    line1: line1 ?? this.line1,
    city: city ?? this.city,
    postcode: postcode ?? this.postcode,
    phone: phone ?? this.phone,
    isDefault: isDefault ?? this.isDefault,
  );

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json['id'].toString(),
    label: AddressLabel.fromName(json['label'] as String?),
    name: json['name'] as String? ?? '',
    line1: json['line1'] as String? ?? '',
    city: json['city'] as String? ?? '',
    postcode: json['postcode'] as String? ?? '',
    phone: json['phone'] as String? ?? '',
    isDefault: json['isDefault'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label.name,
    'name': name,
    'line1': line1,
    'city': city,
    'postcode': postcode,
    'phone': phone,
    'isDefault': isDefault,
  };
}

class PaymentMethod {
  const PaymentMethod({
    required this.id,
    required this.kind,
    required this.label,
    required this.detail,
    required this.isDefault,
  });
  final String id;
  final PaymentKind kind;

  /// "Visa", "BCEL One", "Cash on delivery".
  final String label;

  /// Masked number, wallet phone, or empty.
  final String detail;
  final bool isDefault;

  PaymentMethod copyWith({bool? isDefault}) => PaymentMethod(
    id: id,
    kind: kind,
    label: label,
    detail: detail,
    isDefault: isDefault ?? this.isDefault,
  );

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
    id: json['id'].toString(),
    kind: PaymentKind.fromName(json['kind'] as String?),
    label: json['label'] as String? ?? '',
    detail: json['detail'] as String? ?? '',
    isDefault: json['isDefault'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'kind': kind.name,
    'label': label,
    'detail': detail,
    'isDefault': isDefault,
  };
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
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.avatar = ImageRef.none,
    this.memberSince,
    this.tier,
  });
  final String id;
  final String name;
  final String phone;
  final String? email;
  final ImageRef avatar;
  final DateTime? memberSince;
  final String? tier;

  /// A freshly verified number has no name yet; the app asks for one.
  bool get needsProfile => name.trim().isEmpty;

  Account copyWith({String? name, String? email, ImageRef? avatar}) => Account(
    id: id,
    name: name ?? this.name,
    phone: phone,
    email: email ?? this.email,
    avatar: avatar ?? this.avatar,
    memberSince: memberSince,
    tier: tier,
  );

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    id: json['id'].toString(),
    name: json['name'] as String? ?? '',
    phone: json['phone'] as String? ?? '',
    email: json['email'] as String?,
    avatar: ImageRef.fromString(json['avatar'] as String?),
    memberSince: DateTime.tryParse(json['memberSince'] as String? ?? ''),
    tier: json['tier'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    if (email != null) 'email': email,
    'avatar': avatar.toString(),
    if (memberSince != null) 'memberSince': memberSince!.toIso8601String(),
    if (tier != null) 'tier': tier,
  };
}

/// Who is using the app: nobody yet, a guest, or a verified customer.
class CustomerSession {
  const CustomerSession.guest() : account = null, token = null;
  const CustomerSession.customer({required Account this.account, this.token});

  final Account? account;

  /// Customer JWT in api mode; null for demo and guests.
  final String? token;

  bool get isGuest => account == null;
  bool get isCustomer => account != null;

  factory CustomerSession.fromJson(Map<String, dynamic> json) {
    final account = json['account'];
    if (account is Map<String, dynamic>) {
      return CustomerSession.customer(
        account: Account.fromJson(account),
        token: json['token'] as String?,
      );
    }
    return const CustomerSession.guest();
  }

  Map<String, dynamic> toJson() => {
    if (account != null) 'account': account!.toJson(),
    if (token != null) 'token': token,
  };
}

/// Result of requesting an OTP: where it went and how long it is valid.
class OtpChallenge {
  const OtpChallenge({
    required this.phone,
    required this.expiresIn,
    required this.resendAfter,
  });
  final String phone;
  final Duration expiresIn;
  final Duration resendAfter;
}

class OtpRejectedException implements Exception {
  const OtpRejectedException();
}

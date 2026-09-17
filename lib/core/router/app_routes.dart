/// Every route path in one place.
abstract final class AppRoutes {
  static const splash = '/splash';
  static const tutorial = '/tutorial';
  static const welcome = '/welcome';
  static const authPhone = '/auth/phone';
  static const authOtp = '/auth/otp';
  static const authProfile = '/auth/profile';

  static const home = '/home';
  static const collections = '/collections';
  static const profile = '/profile';
  static const settings = '/settings';
  static const support = '/support';
  static const shopCode = '/settings/shop-code';

  static const category = '/category';
  static const product = '/product';
  static const search = '/search';
  static const lookbook = '/lookbook';
  static const sizeGuide = '/size-guide';
  static const wishlist = '/wishlist';
  static const cart = '/cart';
  static const checkout = '/checkout';
  static const orders = '/orders';
  static const addresses = '/addresses';
  static const paymentMethods = '/payment-methods';

  // --- Settings & content (C7) -------------------------------------------
  static const goldRates = '/goldvalue';
  static const contact = '/contact';
  static const about = '/about';
  static const feedback = '/feedback';
  static const rateUs = '/rate-us';
  static const stories = '/stories';
  static const policy = '/policy';

  // --- Support & extras (C8) ---------------------------------------------
  static const notifications = '/notifications';
  static const stores = '/stores';
  static const offers = '/offers';

  static String categoryPath(
    String id, {
    String? audience,
    String? metal,
    String? tag,
    String? brand,
  }) {
    final params = {
      if (audience != null) 'audience': audience,
      if (metal != null) 'metal': metal,
      if (tag != null) 'tag': tag,
      if (brand != null) 'brand': brand,
    };
    if (params.isEmpty) return '$category/$id';
    return Uri(path: '$category/$id', queryParameters: params).toString();
  }

  static String policyPath(String key) => '$policy/$key';
  static String storePath(String id) => '$stores/$id';

  static String productPath(String id) => '$product/$id';
  static String orderPath(String id) => '$orders/$id';
  static String sizeGuidePath(String kind) => '$sizeGuide?kind=$kind';

  /// From the welcome screen the flow lands on Home; from anywhere else it
  /// pops back to the caller with `true`.
  static const authFromWelcome = '$authPhone?from=welcome';
}

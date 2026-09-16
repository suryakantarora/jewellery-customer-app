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

  /// Placeholders for later phases; the drawer links to them already.
  static const goldRates = '/goldvalue';
  static const contact = '/contact';

  static String categoryPath(String id, {String? audience}) =>
      audience == null ? '$category/$id' : '$category/$id?audience=$audience';

  static String productPath(String id) => '$product/$id';
  static String orderPath(String id) => '$orders/$id';
  static String sizeGuidePath(String kind) => '$sizeGuide?kind=$kind';

  /// From the welcome screen the flow lands on Home; from anywhere else it
  /// pops back to the caller with `true`.
  static const authFromWelcome = '$authPhone?from=welcome';
}

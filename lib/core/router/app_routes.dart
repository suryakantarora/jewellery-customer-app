/// Every route path in one place.
abstract final class AppRoutes {
  static const splash = '/splash';
  static const home = '/home';
  static const collections = '/collections';
  static const profile = '/profile';
  static const settings = '/settings';
  static const support = '/support';
  static const shopCode = '/settings/shop-code';

  /// Placeholders for later phases; the drawer links to them already.
  static const category = '/category';
  static const orders = '/orders';
  static const goldRates = '/goldvalue';
  static const contact = '/contact';
  static const search = '/search';
  static const wishlist = '/wishlist';
  static const cart = '/cart';

  static String categoryPath(String id, {String? audience}) =>
      audience == null ? '$category/$id' : '$category/$id?audience=$audience';
}

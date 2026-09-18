/// Every persisted preference key in one place.
abstract final class StorageKeys {
  static const themeMode = 'pref.theme_mode';
  static const paletteId = 'pref.palette_id';
  static const locale = 'pref.locale';

  /// Runtime tenant override from the dev-only shop-code screen.
  static const tenantKeyOverride = 'dev.tenant_key';

  /// First-run tour completed.
  static const seenTour = 'onboarding.seen_tour';

  /// The customer session (guest or verified), JSON.
  static const session = 'auth.session';

  /// Recent search terms, JSON list.
  static const recentSearches = 'search.recent';

  // Demo-mode persistence of customer data (api mode keeps these server-side).
  static const demoCart = 'demo.cart';
  static const demoWishlist = 'demo.wishlist';
  static const demoOrders = 'demo.orders';
  static const demoAddresses = 'demo.addresses';
  static const demoPaymentMethods = 'demo.payment_methods';
  static const demoAccounts = 'demo.accounts';
  static const demoNotifications = 'demo.notifications';
  static const demoStoryLikes = 'demo.story_likes';
  static const demoFeedback = 'demo.feedback';

  // Api mode: a guest's bag and wishlist live on the device and move to the
  // account on sign-in.
  static const guestCart = 'guest.cart';
  static const guestWishlist = 'guest.wishlist';

  /// Coupon code applied in the bag.
  static const appliedOffer = 'cart.offer';

  /// Support chat transcript, so leaving the page keeps the thread.
  static const supportThread = 'support.thread';

  /// Push registration (token echoed back so C10 can unregister).
  static const pushToken = 'push.token';
}

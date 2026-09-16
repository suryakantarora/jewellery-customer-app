// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppL10nEn extends AppL10n {
  AppL10nEn([String locale = 'en']) : super(locale);

  @override
  String get tabHome => 'Home';

  @override
  String get tabCollections => 'Collections';

  @override
  String get tabProfile => 'Profile';

  @override
  String get tabSettings => 'Settings';

  @override
  String get actionSearch => 'Search';

  @override
  String get actionWishlist => 'Wishlist';

  @override
  String get actionBag => 'Bag';

  @override
  String get actionMenu => 'Menu';

  @override
  String get actionBack => 'Back';

  @override
  String get actionSupport => 'Chat with us';

  @override
  String get actionSeeAll => 'See all';

  @override
  String get actionViewAll => 'View all';

  @override
  String get actionContinueShopping => 'Continue shopping';

  @override
  String get retry => 'Try again';

  @override
  String get loading => 'Loading';

  @override
  String splashTagline(String tagline) {
    return '$tagline';
  }

  @override
  String get splashPreparing => 'Preparing your boutique';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get errorGeneric =>
      'We couldn\'t load this right now. Please try again.';

  @override
  String get errorOffline => 'You appear to be offline.';

  @override
  String get emptyTitle => 'Nothing here yet';

  @override
  String get emptyBody => 'Check back soon — new pieces arrive every week.';

  @override
  String get drawerShopFor => 'Shop for';

  @override
  String get drawerJewellery => 'Jewellery';

  @override
  String get drawerOrders => 'My orders';

  @override
  String get drawerGoldRates => 'Gold rates';

  @override
  String get drawerContact => 'Contact us';

  @override
  String get drawerSettings => 'Settings';

  @override
  String get drawerDarkMode => 'Dark mode';

  @override
  String get drawerSignOut => 'Sign out';

  @override
  String get drawerGuest => 'Guest';

  @override
  String get drawerGuestHint => 'Sign in to track orders';

  @override
  String get audienceWomen => 'Women';

  @override
  String get audienceMen => 'Men';

  @override
  String get audienceKids => 'Kids';

  @override
  String get homeStoriesEyebrow => 'This season';

  @override
  String get homeStoriesTitle => 'Featured stories';

  @override
  String get homeCollectionsEyebrow => 'Browse';

  @override
  String get homeCollectionsTitle => 'Shop by collection';

  @override
  String get homeCollectionsSubtitle => 'Every piece hallmarked and certified';

  @override
  String get homeDemoNote =>
      'Demo build — all products, prices and orders are sample data.';

  @override
  String get collectionsEyebrow => 'Collections';

  @override
  String get collectionsTitle => 'Our collections';

  @override
  String get collectionsSubtitle =>
      'From everyday chains to complete bridal suites, each made in our atelier.';

  @override
  String get collectionsAll => 'All jewellery';

  @override
  String piecesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pieces',
      one: '1 piece',
      zero: 'No pieces',
    );
    return '$_temp0';
  }

  @override
  String get profileTitle => 'Profile';

  @override
  String profileWelcome(String brand) {
    return 'Welcome to $brand';
  }

  @override
  String get profileSignInHint =>
      'Sign in with your phone number to see orders, addresses and saved pieces.';

  @override
  String get profileComingSoon => 'Sign-in arrives in the next update.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsDarkMode => 'Dark mode';

  @override
  String get settingsDarkModeSub => 'Easier on the eyes at night';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSub => 'Display language';

  @override
  String get settingsDeveloper => 'Developer';

  @override
  String get settingsShopCode => 'Shop code';

  @override
  String settingsShopCodeSub(String key) {
    return 'Currently: $key';
  }

  @override
  String get settingsAbout => 'About';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String settingsDataMode(String mode) {
    return 'Data: $mode';
  }

  @override
  String get shopCodeTitle => 'Shop code';

  @override
  String get shopCodeIntro =>
      'Enter the code of the shop this app should belong to. The brand, colours and catalogue reload immediately.';

  @override
  String get shopCodeLabel => 'Shop code';

  @override
  String get shopCodeHint => 'e.g. fino';

  @override
  String get shopCodeApply => 'Apply';

  @override
  String get shopCodeReset => 'Reset to default';

  @override
  String get shopCodeApplied => 'Shop code applied';

  @override
  String shopCodeCurrent(String key) {
    return 'Current shop: $key';
  }

  @override
  String get supportTitle => 'Support';

  @override
  String get supportPlaceholderTitle => 'We\'re here to help';

  @override
  String get supportPlaceholderBody =>
      'Live chat arrives in a later update. Until then, reach us on the contact page.';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionCopy => 'Copy';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionRemove => 'Remove';

  @override
  String get actionSave => 'Save';

  @override
  String get badgeNew => 'New';

  @override
  String get purity925 => '925 Silver';

  @override
  String get stoneNone => 'No stone';

  @override
  String get reviewVerified => 'Verified';

  @override
  String get tourSkip => 'Skip';

  @override
  String get tourNext => 'Next';

  @override
  String get tourContinue => 'Get started';

  @override
  String get tourEyebrow1 => 'Welcome';

  @override
  String tourTitle1(String brand) {
    return 'Welcome to $brand';
  }

  @override
  String get tourBody1 =>
      'Browse a curated collection of gold, diamond and gemstone pieces, handcrafted in our atelier.';

  @override
  String get tourEyebrow2 => 'Discover';

  @override
  String get tourTitle2 => 'Shop the way you like';

  @override
  String get tourBody2 =>
      'Filter by metal, occasion or budget, save favourites to your wishlist, and check the live gold rate before you buy.';

  @override
  String get tourEyebrow3 => 'Trust';

  @override
  String get tourTitle3 => 'Certified, always';

  @override
  String get tourBody3 =>
      'Every piece ships with certification, insured delivery and a 15-day return window.';

  @override
  String get tourEyebrow4 => 'Ready';

  @override
  String get tourTitle4 => 'Ready when you are';

  @override
  String get tourBody4 =>
      'Sign in with your phone number to track orders, or browse as a guest.';

  @override
  String get welcomeEyebrow => 'Timeless elegance';

  @override
  String get welcomeTeaser => 'Featured pieces';

  @override
  String get authSignInWithPhone => 'Sign in with phone';

  @override
  String get authContinueAsGuest => 'Continue as guest';

  @override
  String get authPhoneTitle => 'Welcome back';

  @override
  String get authPhoneSubtitle =>
      'Enter your mobile number and we will text you a code.';

  @override
  String get authPhoneLabel => 'Mobile number';

  @override
  String get authPhoneInvalid => 'Please enter a valid mobile number.';

  @override
  String get authSendCode => 'Send code';

  @override
  String get authOr => 'or';

  @override
  String get authTerms =>
      'By continuing you agree to our terms and privacy policy.';

  @override
  String get authDemoHint => 'Demo build — no SMS is sent.';

  @override
  String get authOtpTitle => 'Enter the code';

  @override
  String authOtpSubtitle(String phone) {
    return 'We sent a 6-digit code to $phone.';
  }

  @override
  String get authOtpDemoHint => 'Demo: any 6 digits will verify.';

  @override
  String get authOtpWrong => 'That code is not right. Please try again.';

  @override
  String get authVerify => 'Verify';

  @override
  String get authResend => 'Resend code';

  @override
  String authResendIn(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get authCodeResent => 'A new code is on its way.';

  @override
  String get authChangeNumber => 'Change number';

  @override
  String authWelcomeBack(String name) {
    return 'Welcome back, $name';
  }

  @override
  String authWelcomeNew(String name) {
    return 'Welcome, $name';
  }

  @override
  String get authProfileTitle => 'Tell us about you';

  @override
  String get authProfileSubtitle =>
      'So we can address you properly and send order updates.';

  @override
  String get authNameLabel => 'Your name';

  @override
  String get authNameRequired => 'Please tell us your name.';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authEmailInvalid => 'That email does not look right.';

  @override
  String get authOptional => 'Optional';

  @override
  String get authFinish => 'Finish';

  @override
  String get authPromptTitle => 'Sign in to continue';

  @override
  String get authPromptBody =>
      'Sign in with your phone number to see orders, addresses and saved pieces.';

  @override
  String get homeFeaturedEyebrow => 'Curated';

  @override
  String get homeFeaturedTitle => 'Featured';

  @override
  String get homeNewEyebrow => 'Just in';

  @override
  String get homeNewTitle => 'New arrivals';

  @override
  String get homeNewSubtitle => 'Fresh from the atelier this week';

  @override
  String get homeTrendingEyebrow => 'Popular now';

  @override
  String get homeTrendingTitle => 'Trending';

  @override
  String get homeBestEyebrow => 'Loved';

  @override
  String get homeBestTitle => 'Best sellers';

  @override
  String get homeReviewsEyebrow => 'From our customers';

  @override
  String get homeReviewsTitle => 'Kind words';

  @override
  String get homePromiseEyebrow => 'Our promise';

  @override
  String homePromiseTitle(String brand) {
    return 'The $brand promise';
  }

  @override
  String get promiseCertified => 'Certified';

  @override
  String get promiseCertifiedSub => 'Hallmarked purity';

  @override
  String get promiseSecure => 'Secure payment';

  @override
  String get promiseSecureSub => 'Encrypted checkout';

  @override
  String get promiseReturns => 'Easy returns';

  @override
  String get promiseReturnsSub => '15 days, no questions';

  @override
  String get promisePackaging => 'Gift packaging';

  @override
  String get promisePackagingSub => 'Complimentary';

  @override
  String get searchTitle => 'Search';

  @override
  String get searchHint => 'Search rings, gold, 22K…';

  @override
  String get searchClear => 'Clear';

  @override
  String get searchRecent => 'Recent';

  @override
  String get searchSuggested => 'Suggested';

  @override
  String get searchBrowse => 'Browse';

  @override
  String searchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count results',
      one: '1 result',
      zero: 'No results',
    );
    return '$_temp0';
  }

  @override
  String searchNoResultsTitle(String term) {
    return 'Nothing for “$term”';
  }

  @override
  String get searchNoResultsBody => 'Try another word, a metal or a purity.';

  @override
  String get sortFeatured => 'Featured';

  @override
  String get sortNewest => 'Newest';

  @override
  String get sortPriceAsc => 'Price ↑';

  @override
  String get sortPriceDesc => 'Price ↓';

  @override
  String get sortRating => 'Rating';

  @override
  String get filterButton => 'Filter';

  @override
  String get filterTitle => 'Filter';

  @override
  String get filterClearAll => 'Clear all';

  @override
  String get filterPrice => 'Price';

  @override
  String get filterMetal => 'Metal';

  @override
  String get filterPurity => 'Purity';

  @override
  String get filterStone => 'Stone';

  @override
  String get filterRating => 'Rating';

  @override
  String filterRatingUp(String rating) {
    return '$rating & up';
  }

  @override
  String get filterInStock => 'In stock only';

  @override
  String get filterInStockSub => 'Hide pieces that are sold out';

  @override
  String get filterApply => 'Apply';

  @override
  String filterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Show $count pieces',
      one: 'Show 1 piece',
      zero: 'No matches',
    );
    return '$_temp0';
  }

  @override
  String get categoryEmptyTitle => 'No pieces match';

  @override
  String get categoryEmptyBody => 'Loosen a filter or two and try again.';

  @override
  String get productSoldOut => 'Sold out';

  @override
  String get productInStock => 'In stock';

  @override
  String get productNotFound => 'This piece is no longer available.';

  @override
  String get productQuantity => 'Quantity';

  @override
  String productDeliveryDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Delivery in $days days',
      one: 'Delivery in 1 day',
    );
    return '$_temp0';
  }

  @override
  String get productSpecifications => 'Specifications';

  @override
  String productReviews(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '1 review',
      zero: 'Reviews',
    );
    return '$_temp0';
  }

  @override
  String get productNoReviews => 'No reviews yet — be the first.';

  @override
  String get productRelatedEyebrow => 'You may also like';

  @override
  String get productRelatedTitle => 'Related pieces';

  @override
  String get productTotal => 'Total';

  @override
  String get productBuyNow => 'Buy now';

  @override
  String get productShare => 'Share';

  @override
  String get productLinkCopied => 'Link copied';

  @override
  String get specMetal => 'Metal';

  @override
  String get specPurity => 'Purity';

  @override
  String get specWeight => 'Weight';

  @override
  String specGrams(String grams) {
    return '$grams g';
  }

  @override
  String get specStone => 'Stone';

  @override
  String get specCollection => 'Collection';

  @override
  String get specSku => 'SKU';

  @override
  String get specHallmark => 'Hallmark';

  @override
  String get sizeGuideTitle => 'Size guide';

  @override
  String get sizeGuideHeading => 'Find your size';

  @override
  String get sizeGuideSub =>
      'Measure at home in under a minute, or visit the store for a free fitting.';

  @override
  String get sizeKindRing => 'Ring';

  @override
  String get sizeKindBangle => 'Bangle';

  @override
  String get sizeKindLength => 'Length';

  @override
  String get sizeLabelRing => 'Ring size';

  @override
  String get sizeLabelBangle => 'Bangle size';

  @override
  String get sizeLabelLength => 'Length';

  @override
  String get sizeHowToMeasure => 'How to measure';

  @override
  String get sizeChart => 'Size chart';

  @override
  String get sizeUs => 'US';

  @override
  String get sizeUk => 'UK';

  @override
  String get sizeSize => 'Size';

  @override
  String get sizeDiameterMm => 'Diameter mm';

  @override
  String get sizeDiameterIn => 'Diameter in';

  @override
  String get sizeCircumferenceMm => 'Around mm';

  @override
  String get sizeFits => 'Fits';

  @override
  String get sizeLengthCm => 'cm';

  @override
  String get sizeSits => 'Sits';

  @override
  String get sizeRingStep1 =>
      'Wrap a strip of paper around the base of the finger, snug but not tight.';

  @override
  String get sizeRingStep2 =>
      'Mark where the paper overlaps, then measure that length in millimetres — that is your circumference.';

  @override
  String get sizeRingStep3 =>
      'Find the closest circumference in the chart below to get your size.';

  @override
  String get sizeBangleStep1 =>
      'Press your thumb into your palm and measure around the widest part of your hand.';

  @override
  String get sizeBangleStep2 =>
      'Match that measurement to the circumference column below.';

  @override
  String get sizeTip =>
      'Measure at the end of the day, when fingers are at their largest, and avoid measuring when cold.';

  @override
  String get sizeRequired => 'Please choose a size first.';

  @override
  String get sizeResizeNote =>
      'One complimentary resize is included within 60 days of purchase.';

  @override
  String get sizeFitsXs => 'Extra small';

  @override
  String get sizeFitsS => 'Small';

  @override
  String get sizeFitsM => 'Medium';

  @override
  String get sizeFitsL => 'Large';

  @override
  String get sizeFitsXl => 'Extra large';

  @override
  String get sizeSitsChoker => 'Choker — at the base of the neck';

  @override
  String get sizeSitsPrincess => 'Princess — just below the collarbone';

  @override
  String get sizeSitsMatinee => 'Matinee — on the chest';

  @override
  String get sizeSitsMatineeLow => 'Matinee — lower chest';

  @override
  String get sizeSitsOpera => 'Opera — below the bust';

  @override
  String get lookbookTitle => 'Lookbook';

  @override
  String get lookbookHide => 'Hide';

  @override
  String lookbookHidden(String name) {
    return '$name hidden for now';
  }

  @override
  String get lookbookEmptyTitle => 'Everything is hidden';

  @override
  String get lookbookEmptyBody => 'Bring the pieces back to keep browsing.';

  @override
  String get lookbookRestore => 'Show all';

  @override
  String get wishlistTitle => 'Wishlist';

  @override
  String get wishlistAdded => 'Saved to wishlist';

  @override
  String get wishlistRemoved => 'Removed from wishlist';

  @override
  String wishlistCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saved pieces',
      one: '1 saved piece',
    );
    return '$_temp0';
  }

  @override
  String get wishlistMoveAll => 'Move all to bag';

  @override
  String get wishlistMovedAll => 'Moved to your bag';

  @override
  String wishlistMovedSome(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pieces moved; choose a size for the rest',
      one: '1 piece moved; choose a size for the rest',
      zero: 'Sized pieces need a size — open each one to add it',
    );
    return '$_temp0';
  }

  @override
  String get wishlistEmptyTitle => 'Nothing saved yet';

  @override
  String get wishlistEmptyBody => 'Tap the heart on any piece to keep it here.';

  @override
  String get cartTitle => 'Your bag';

  @override
  String get cartAddToBag => 'Add to bag';

  @override
  String get cartAdded => 'Added';

  @override
  String cartAddedToast(String name) {
    return '$name added to your bag';
  }

  @override
  String get cartEmptyTitle => 'Your bag is empty';

  @override
  String get cartEmptyBody => 'Pieces you add will wait for you here.';

  @override
  String cartFreeDeliveryHint(String amount) {
    return 'Spend $amount more for free delivery';
  }

  @override
  String get cartFreeDeliveryUnlocked => 'You have free delivery';

  @override
  String cartSize(String size) {
    return 'Size $size';
  }

  @override
  String cartQty(int count) {
    return 'Qty $count';
  }

  @override
  String get cartRemove => 'Remove';

  @override
  String get cartMoveToWishlist => 'Move to wishlist';

  @override
  String get cartMovedToWishlist => 'Moved to wishlist';

  @override
  String get cartSubtotal => 'Subtotal';

  @override
  String get cartSavings => 'Savings';

  @override
  String get cartShipping => 'Delivery';

  @override
  String get cartFree => 'Free';

  @override
  String get cartTax => 'Tax';

  @override
  String get cartTotal => 'Total';

  @override
  String get cartCheckout => 'Checkout';

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get checkoutStepAddress => 'Address';

  @override
  String get checkoutStepPayment => 'Payment';

  @override
  String get checkoutStepReview => 'Review';

  @override
  String get checkoutAddressTitle => 'Where should we deliver?';

  @override
  String get checkoutAddressSub => 'Pick a saved address or enter a new one.';

  @override
  String get checkoutAddressIncomplete =>
      'Please fill in name, phone, address and city.';

  @override
  String get checkoutContinuePayment => 'Continue to payment';

  @override
  String get checkoutPaymentTitle => 'How would you like to pay?';

  @override
  String get checkoutPaymentSub => 'No payment is taken in this demo.';

  @override
  String get checkoutContinueReview => 'Review order';

  @override
  String get checkoutSummary => 'Summary';

  @override
  String get checkoutDemoNote =>
      'Demo checkout — no card details are stored and nothing is charged.';

  @override
  String get checkoutReviewTitle => 'Almost there';

  @override
  String get checkoutReviewSub => 'Check everything, then place your order.';

  @override
  String get checkoutDeliverTo => 'Deliver to';

  @override
  String get checkoutPayWith => 'Pay with';

  @override
  String checkoutItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String checkoutPlaceOrder(String total) {
    return 'Place order · $total';
  }

  @override
  String get checkoutPlacing => 'Placing your order';

  @override
  String get checkoutPlacingSub => 'Just a moment…';

  @override
  String get checkoutConfirmedTitle => 'Order confirmed';

  @override
  String get checkoutConfirmedBody =>
      'Thank you. We will confirm it shortly and keep you posted at every step.';

  @override
  String get checkoutTrackOrder => 'Track order';

  @override
  String get paymentCard => 'Card';

  @override
  String get paymentCardSub => 'Visa, Mastercard';

  @override
  String get paymentWallet => 'Wallet';

  @override
  String get paymentWalletSub => 'BCEL One and other wallets';

  @override
  String get paymentCod => 'Cash on delivery';

  @override
  String get paymentCodSub => 'Pay when your piece arrives';

  @override
  String get ordersTitle => 'My orders';

  @override
  String get ordersSignInBody =>
      'Sign in with your phone number to see and track your orders.';

  @override
  String get ordersActive => 'Active';

  @override
  String get ordersAll => 'All';

  @override
  String get ordersEmptyTitle => 'No orders yet';

  @override
  String get ordersEmptyActiveTitle => 'Nothing on its way';

  @override
  String get ordersEmptyBody =>
      'When you place an order it will appear here with live tracking.';

  @override
  String ordersMoreItems(String name, int count) {
    return '$name +$count more';
  }

  @override
  String get ordersViewDetail => 'View detail';

  @override
  String get ordersInvoice => 'Invoice';

  @override
  String get ordersInvoiceDemo => 'Invoices arrive by email in the live app.';

  @override
  String get orderStatusPlaced => 'Placed';

  @override
  String get orderStatusConfirmed => 'Confirmed';

  @override
  String get orderStatusPacked => 'Packed';

  @override
  String get orderStatusShipped => 'Shipped';

  @override
  String get orderStatusDelivered => 'Delivered';

  @override
  String get orderStatusCancelled => 'Cancelled';

  @override
  String get orderStageDescPlaced => 'We received your order';

  @override
  String get orderStageDescConfirmed => 'Payment and stock confirmed';

  @override
  String get orderStageDescPacked => 'Gift-wrapped and ready';

  @override
  String get orderStageDescShipped => 'With the courier';

  @override
  String get orderStageDescDelivered => 'Enjoy your piece';

  @override
  String get orderCancelledNote =>
      'This order was cancelled. Any payment has been refunded.';

  @override
  String get orderCourier => 'Courier';

  @override
  String get orderTracking => 'Tracking';

  @override
  String get orderTrackingCopied => 'Tracking number copied';

  @override
  String get orderDeliverTo => 'Deliver to';

  @override
  String get orderDetailTitle => 'Order';

  @override
  String get orderNotFound => 'We could not find that order.';

  @override
  String get orderProgress => 'Progress';

  @override
  String get orderReorder => 'Reorder';

  @override
  String get orderReorderAll => 'Everything is back in your bag';

  @override
  String orderReorderPartial(int restored, int total) {
    return '$restored of $total pieces added; the rest are sold out';
  }

  @override
  String get orderReorderNone => 'Those pieces are sold out right now';

  @override
  String get orderCallCourier => 'Call courier';

  @override
  String orderCourierNumberCopied(String phone) {
    return '$phone copied';
  }

  @override
  String get addressesTitle => 'Addresses';

  @override
  String get addressesEmptyTitle => 'No addresses yet';

  @override
  String get addressesEmptyBody => 'Add one to speed up checkout.';

  @override
  String get addressAdd => 'Add address';

  @override
  String get addressEdit => 'Edit address';

  @override
  String get addressLabel => 'Label';

  @override
  String get addressLabelHome => 'Home';

  @override
  String get addressLabelWork => 'Work';

  @override
  String get addressLabelOther => 'Other';

  @override
  String get addressName => 'Full name';

  @override
  String get addressPhone => 'Phone';

  @override
  String get addressLine1 => 'Address';

  @override
  String get addressCity => 'City';

  @override
  String get addressPostcode => 'Postcode';

  @override
  String get addressMakeDefault => 'Make default';

  @override
  String get addressDefault => 'Default';

  @override
  String get addressSetDefault => 'Set default';

  @override
  String get addressDefaultSet => 'Default address updated';

  @override
  String get addressDeleteTitle => 'Delete address?';

  @override
  String get addressDeleteBody => 'This cannot be undone.';

  @override
  String get addressDeleted => 'Address deleted';

  @override
  String get paymentMethodsTitle => 'Payment methods';

  @override
  String get paymentEmptyTitle => 'No payment methods';

  @override
  String get paymentAdd => 'Add payment method';

  @override
  String get paymentAddDemo => 'Adding a card is disabled in this demo.';

  @override
  String get paymentDefaultSet => 'Default payment method updated';

  @override
  String get paymentRemoved => 'Payment method removed';

  @override
  String get paymentSecureNote =>
      'This is a demo. No card details are stored and no payment is ever processed.';

  @override
  String get accountStatOrders => 'Orders';

  @override
  String get accountStatWishlist => 'Wishlist';

  @override
  String get accountStatAddresses => 'Addresses';

  @override
  String get accountRecentOrders => 'My orders';

  @override
  String accountAddressCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count addresses',
      one: '1 address',
      zero: 'No addresses',
    );
    return '$_temp0';
  }

  @override
  String accountMemberSince(String date) {
    return 'Member since $date';
  }

  @override
  String get accountEditTitle => 'Edit profile';

  @override
  String get accountPhoneLocked =>
      'Your number is verified and cannot be changed here.';

  @override
  String get accountSaved => 'Profile saved';

  @override
  String get accountSignOutTitle => 'Sign out?';

  @override
  String get accountSignOutBody => 'Your bag will be cleared on this device.';
}

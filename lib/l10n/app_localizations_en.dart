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
}

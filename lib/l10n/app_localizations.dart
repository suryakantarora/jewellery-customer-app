import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_lo.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppL10n
/// returned by `AppL10n.of(context)`.
///
/// Applications need to include `AppL10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppL10n.localizationsDelegates,
///   supportedLocales: AppL10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppL10n.supportedLocales
/// property.
abstract class AppL10n {
  AppL10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppL10n of(BuildContext context) {
    return Localizations.of<AppL10n>(context, AppL10n)!;
  }

  static const LocalizationsDelegate<AppL10n> delegate = _AppL10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('lo'),
  ];

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabCollections.
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get tabCollections;

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// No description provided for @tabSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tabSettings;

  /// No description provided for @actionSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get actionSearch;

  /// No description provided for @actionWishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get actionWishlist;

  /// No description provided for @actionBag.
  ///
  /// In en, this message translates to:
  /// **'Bag'**
  String get actionBag;

  /// No description provided for @actionMenu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get actionMenu;

  /// No description provided for @actionBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get actionBack;

  /// No description provided for @actionSupport.
  ///
  /// In en, this message translates to:
  /// **'Chat with us'**
  String get actionSupport;

  /// No description provided for @actionSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get actionSeeAll;

  /// No description provided for @actionViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get actionViewAll;

  /// No description provided for @actionContinueShopping.
  ///
  /// In en, this message translates to:
  /// **'Continue shopping'**
  String get actionContinueShopping;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'{tagline}'**
  String splashTagline(String tagline);

  /// No description provided for @splashPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing your boutique'**
  String get splashPreparing;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorTitle;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load this right now. Please try again.'**
  String get errorGeneric;

  /// No description provided for @errorOffline.
  ///
  /// In en, this message translates to:
  /// **'You appear to be offline.'**
  String get errorOffline;

  /// No description provided for @emptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get emptyTitle;

  /// No description provided for @emptyBody.
  ///
  /// In en, this message translates to:
  /// **'Check back soon — new pieces arrive every week.'**
  String get emptyBody;

  /// No description provided for @drawerShopFor.
  ///
  /// In en, this message translates to:
  /// **'Shop for'**
  String get drawerShopFor;

  /// No description provided for @drawerJewellery.
  ///
  /// In en, this message translates to:
  /// **'Jewellery'**
  String get drawerJewellery;

  /// No description provided for @drawerOrders.
  ///
  /// In en, this message translates to:
  /// **'My orders'**
  String get drawerOrders;

  /// No description provided for @drawerGoldRates.
  ///
  /// In en, this message translates to:
  /// **'Gold rates'**
  String get drawerGoldRates;

  /// No description provided for @drawerContact.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get drawerContact;

  /// No description provided for @drawerSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get drawerSettings;

  /// No description provided for @drawerDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get drawerDarkMode;

  /// No description provided for @drawerSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get drawerSignOut;

  /// No description provided for @drawerGuest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get drawerGuest;

  /// No description provided for @drawerGuestHint.
  ///
  /// In en, this message translates to:
  /// **'Sign in to track orders'**
  String get drawerGuestHint;

  /// No description provided for @audienceWomen.
  ///
  /// In en, this message translates to:
  /// **'Women'**
  String get audienceWomen;

  /// No description provided for @audienceMen.
  ///
  /// In en, this message translates to:
  /// **'Men'**
  String get audienceMen;

  /// No description provided for @audienceKids.
  ///
  /// In en, this message translates to:
  /// **'Kids'**
  String get audienceKids;

  /// No description provided for @homeStoriesEyebrow.
  ///
  /// In en, this message translates to:
  /// **'This season'**
  String get homeStoriesEyebrow;

  /// No description provided for @homeStoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Featured stories'**
  String get homeStoriesTitle;

  /// No description provided for @homeCollectionsEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get homeCollectionsEyebrow;

  /// No description provided for @homeCollectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop by collection'**
  String get homeCollectionsTitle;

  /// No description provided for @homeCollectionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Every piece hallmarked and certified'**
  String get homeCollectionsSubtitle;

  /// No description provided for @homeDemoNote.
  ///
  /// In en, this message translates to:
  /// **'Demo build — all products, prices and orders are sample data.'**
  String get homeDemoNote;

  /// No description provided for @collectionsEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get collectionsEyebrow;

  /// No description provided for @collectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Our collections'**
  String get collectionsTitle;

  /// No description provided for @collectionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'From everyday chains to complete bridal suites, each made in our atelier.'**
  String get collectionsSubtitle;

  /// No description provided for @collectionsAll.
  ///
  /// In en, this message translates to:
  /// **'All jewellery'**
  String get collectionsAll;

  /// No description provided for @piecesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No pieces} =1{1 piece} other{{count} pieces}}'**
  String piecesCount(int count);

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to {brand}'**
  String profileWelcome(String brand);

  /// No description provided for @profileSignInHint.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your phone number to see orders, addresses and saved pieces.'**
  String get profileSignInHint;

  /// No description provided for @profileComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Sign-in arrives in the next update.'**
  String get profileComingSoon;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get settingsDarkMode;

  /// No description provided for @settingsDarkModeSub.
  ///
  /// In en, this message translates to:
  /// **'Easier on the eyes at night'**
  String get settingsDarkModeSub;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSub.
  ///
  /// In en, this message translates to:
  /// **'Display language'**
  String get settingsLanguageSub;

  /// No description provided for @settingsDeveloper.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get settingsDeveloper;

  /// No description provided for @settingsShopCode.
  ///
  /// In en, this message translates to:
  /// **'Shop code'**
  String get settingsShopCode;

  /// No description provided for @settingsShopCodeSub.
  ///
  /// In en, this message translates to:
  /// **'Currently: {key}'**
  String settingsShopCodeSub(String key);

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String settingsVersion(String version);

  /// No description provided for @settingsDataMode.
  ///
  /// In en, this message translates to:
  /// **'Data: {mode}'**
  String settingsDataMode(String mode);

  /// No description provided for @shopCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop code'**
  String get shopCodeTitle;

  /// No description provided for @shopCodeIntro.
  ///
  /// In en, this message translates to:
  /// **'Enter the code of the shop this app should belong to. The brand, colours and catalogue reload immediately.'**
  String get shopCodeIntro;

  /// No description provided for @shopCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Shop code'**
  String get shopCodeLabel;

  /// No description provided for @shopCodeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. fino'**
  String get shopCodeHint;

  /// No description provided for @shopCodeApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get shopCodeApply;

  /// No description provided for @shopCodeReset.
  ///
  /// In en, this message translates to:
  /// **'Reset to default'**
  String get shopCodeReset;

  /// No description provided for @shopCodeApplied.
  ///
  /// In en, this message translates to:
  /// **'Shop code applied'**
  String get shopCodeApplied;

  /// No description provided for @shopCodeCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current shop: {key}'**
  String shopCodeCurrent(String key);

  /// No description provided for @supportTitle.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get supportTitle;

  /// No description provided for @supportPlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'We\'re here to help'**
  String get supportPlaceholderTitle;

  /// No description provided for @supportPlaceholderBody.
  ///
  /// In en, this message translates to:
  /// **'Live chat arrives in a later update. Until then, reach us on the contact page.'**
  String get supportPlaceholderBody;
}

class _AppL10nDelegate extends LocalizationsDelegate<AppL10n> {
  const _AppL10nDelegate();

  @override
  Future<AppL10n> load(Locale locale) {
    return SynchronousFuture<AppL10n>(lookupAppL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'lo'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppL10nDelegate old) => false;
}

AppL10n lookupAppL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppL10nEn();
    case 'lo':
      return AppL10nLo();
  }

  throw FlutterError(
    'AppL10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

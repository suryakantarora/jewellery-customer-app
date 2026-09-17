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

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get actionCopy;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// No description provided for @actionRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get actionRemove;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @badgeNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get badgeNew;

  /// No description provided for @purity925.
  ///
  /// In en, this message translates to:
  /// **'925 Silver'**
  String get purity925;

  /// No description provided for @stoneNone.
  ///
  /// In en, this message translates to:
  /// **'No stone'**
  String get stoneNone;

  /// No description provided for @reviewVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get reviewVerified;

  /// No description provided for @tourSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get tourSkip;

  /// No description provided for @tourNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get tourNext;

  /// No description provided for @tourContinue.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get tourContinue;

  /// No description provided for @tourEyebrow1.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get tourEyebrow1;

  /// No description provided for @tourTitle1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to {brand}'**
  String tourTitle1(String brand);

  /// No description provided for @tourBody1.
  ///
  /// In en, this message translates to:
  /// **'Browse a curated collection of gold, diamond and gemstone pieces, handcrafted in our atelier.'**
  String get tourBody1;

  /// No description provided for @tourEyebrow2.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get tourEyebrow2;

  /// No description provided for @tourTitle2.
  ///
  /// In en, this message translates to:
  /// **'Shop the way you like'**
  String get tourTitle2;

  /// No description provided for @tourBody2.
  ///
  /// In en, this message translates to:
  /// **'Filter by metal, occasion or budget, save favourites to your wishlist, and check the live gold rate before you buy.'**
  String get tourBody2;

  /// No description provided for @tourEyebrow3.
  ///
  /// In en, this message translates to:
  /// **'Trust'**
  String get tourEyebrow3;

  /// No description provided for @tourTitle3.
  ///
  /// In en, this message translates to:
  /// **'Certified, always'**
  String get tourTitle3;

  /// No description provided for @tourBody3.
  ///
  /// In en, this message translates to:
  /// **'Every piece ships with certification, insured delivery and a 15-day return window.'**
  String get tourBody3;

  /// No description provided for @tourEyebrow4.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get tourEyebrow4;

  /// No description provided for @tourTitle4.
  ///
  /// In en, this message translates to:
  /// **'Ready when you are'**
  String get tourTitle4;

  /// No description provided for @tourBody4.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your phone number to track orders, or browse as a guest.'**
  String get tourBody4;

  /// No description provided for @welcomeEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Timeless elegance'**
  String get welcomeEyebrow;

  /// No description provided for @welcomeTeaser.
  ///
  /// In en, this message translates to:
  /// **'Featured pieces'**
  String get welcomeTeaser;

  /// No description provided for @authSignInWithPhone.
  ///
  /// In en, this message translates to:
  /// **'Sign in with phone'**
  String get authSignInWithPhone;

  /// No description provided for @authContinueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as guest'**
  String get authContinueAsGuest;

  /// No description provided for @authPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get authPhoneTitle;

  /// No description provided for @authPhoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number and we will text you a code.'**
  String get authPhoneSubtitle;

  /// No description provided for @authPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get authPhoneLabel;

  /// No description provided for @authPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid mobile number.'**
  String get authPhoneInvalid;

  /// No description provided for @authSendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get authSendCode;

  /// No description provided for @authOr.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get authOr;

  /// No description provided for @authTerms.
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to our terms and privacy policy.'**
  String get authTerms;

  /// No description provided for @authDemoHint.
  ///
  /// In en, this message translates to:
  /// **'Demo build — no SMS is sent.'**
  String get authDemoHint;

  /// No description provided for @authOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the code'**
  String get authOtpTitle;

  /// No description provided for @authOtpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to {phone}.'**
  String authOtpSubtitle(String phone);

  /// No description provided for @authOtpDemoHint.
  ///
  /// In en, this message translates to:
  /// **'Demo: any 6 digits will verify.'**
  String get authOtpDemoHint;

  /// No description provided for @authOtpWrong.
  ///
  /// In en, this message translates to:
  /// **'That code is not right. Please try again.'**
  String get authOtpWrong;

  /// No description provided for @authVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get authVerify;

  /// No description provided for @authResend.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get authResend;

  /// No description provided for @authResendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String authResendIn(int seconds);

  /// No description provided for @authCodeResent.
  ///
  /// In en, this message translates to:
  /// **'A new code is on its way.'**
  String get authCodeResent;

  /// No description provided for @authChangeNumber.
  ///
  /// In en, this message translates to:
  /// **'Change number'**
  String get authChangeNumber;

  /// No description provided for @authWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}'**
  String authWelcomeBack(String name);

  /// No description provided for @authWelcomeNew.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}'**
  String authWelcomeNew(String name);

  /// No description provided for @authProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us about you'**
  String get authProfileTitle;

  /// No description provided for @authProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'So we can address you properly and send order updates.'**
  String get authProfileSubtitle;

  /// No description provided for @authNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get authNameLabel;

  /// No description provided for @authNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please tell us your name.'**
  String get authNameRequired;

  /// No description provided for @authEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// No description provided for @authEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'That email does not look right.'**
  String get authEmailInvalid;

  /// No description provided for @authOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get authOptional;

  /// No description provided for @authFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get authFinish;

  /// No description provided for @authPromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get authPromptTitle;

  /// No description provided for @authPromptBody.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your phone number to see orders, addresses and saved pieces.'**
  String get authPromptBody;

  /// No description provided for @homeFeaturedEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Curated'**
  String get homeFeaturedEyebrow;

  /// No description provided for @homeFeaturedTitle.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get homeFeaturedTitle;

  /// No description provided for @homeNewEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Just in'**
  String get homeNewEyebrow;

  /// No description provided for @homeNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New arrivals'**
  String get homeNewTitle;

  /// No description provided for @homeNewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fresh from the atelier this week'**
  String get homeNewSubtitle;

  /// No description provided for @homeTrendingEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Popular now'**
  String get homeTrendingEyebrow;

  /// No description provided for @homeTrendingTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s trending'**
  String get homeTrendingTitle;

  /// No description provided for @homeBestEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Loved'**
  String get homeBestEyebrow;

  /// No description provided for @homeBestTitle.
  ///
  /// In en, this message translates to:
  /// **'Best sellers'**
  String get homeBestTitle;

  /// No description provided for @homeReviewsEyebrow.
  ///
  /// In en, this message translates to:
  /// **'From our customers'**
  String get homeReviewsEyebrow;

  /// No description provided for @homeReviewsTitle.
  ///
  /// In en, this message translates to:
  /// **'Kind words'**
  String get homeReviewsTitle;

  /// No description provided for @homePromiseEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Our promise'**
  String get homePromiseEyebrow;

  /// No description provided for @homePromiseTitle.
  ///
  /// In en, this message translates to:
  /// **'The {brand} promise'**
  String homePromiseTitle(String brand);

  /// No description provided for @promiseCertified.
  ///
  /// In en, this message translates to:
  /// **'Certified'**
  String get promiseCertified;

  /// No description provided for @promiseCertifiedSub.
  ///
  /// In en, this message translates to:
  /// **'Hallmarked purity'**
  String get promiseCertifiedSub;

  /// No description provided for @promiseSecure.
  ///
  /// In en, this message translates to:
  /// **'Secure payment'**
  String get promiseSecure;

  /// No description provided for @promiseSecureSub.
  ///
  /// In en, this message translates to:
  /// **'Encrypted checkout'**
  String get promiseSecureSub;

  /// No description provided for @promiseReturns.
  ///
  /// In en, this message translates to:
  /// **'Easy returns'**
  String get promiseReturns;

  /// No description provided for @promiseReturnsSub.
  ///
  /// In en, this message translates to:
  /// **'15 days, no questions'**
  String get promiseReturnsSub;

  /// No description provided for @promisePackaging.
  ///
  /// In en, this message translates to:
  /// **'Gift packaging'**
  String get promisePackaging;

  /// No description provided for @promisePackagingSub.
  ///
  /// In en, this message translates to:
  /// **'Complimentary'**
  String get promisePackagingSub;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search rings, gold, 22K…'**
  String get searchHint;

  /// No description provided for @searchClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get searchClear;

  /// No description provided for @searchRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get searchRecent;

  /// No description provided for @searchSuggested.
  ///
  /// In en, this message translates to:
  /// **'Suggested'**
  String get searchSuggested;

  /// No description provided for @searchBrowse.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get searchBrowse;

  /// No description provided for @searchResultCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No results} =1{1 result} other{{count} results}}'**
  String searchResultCount(int count);

  /// No description provided for @searchNoResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing for “{term}”'**
  String searchNoResultsTitle(String term);

  /// No description provided for @searchNoResultsBody.
  ///
  /// In en, this message translates to:
  /// **'Try another word, a metal or a purity.'**
  String get searchNoResultsBody;

  /// No description provided for @sortFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get sortFeatured;

  /// No description provided for @sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get sortNewest;

  /// No description provided for @sortPriceAsc.
  ///
  /// In en, this message translates to:
  /// **'Price ↑'**
  String get sortPriceAsc;

  /// No description provided for @sortPriceDesc.
  ///
  /// In en, this message translates to:
  /// **'Price ↓'**
  String get sortPriceDesc;

  /// No description provided for @sortRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get sortRating;

  /// No description provided for @filterButton.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filterButton;

  /// No description provided for @filterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filterTitle;

  /// No description provided for @filterClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get filterClearAll;

  /// No description provided for @filterPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get filterPrice;

  /// No description provided for @filterMetal.
  ///
  /// In en, this message translates to:
  /// **'Metal'**
  String get filterMetal;

  /// No description provided for @filterPurity.
  ///
  /// In en, this message translates to:
  /// **'Purity'**
  String get filterPurity;

  /// No description provided for @filterStone.
  ///
  /// In en, this message translates to:
  /// **'Stone'**
  String get filterStone;

  /// No description provided for @filterRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get filterRating;

  /// No description provided for @filterRatingUp.
  ///
  /// In en, this message translates to:
  /// **'{rating} & up'**
  String filterRatingUp(String rating);

  /// No description provided for @filterInStock.
  ///
  /// In en, this message translates to:
  /// **'In stock only'**
  String get filterInStock;

  /// No description provided for @filterInStockSub.
  ///
  /// In en, this message translates to:
  /// **'Hide pieces that are sold out'**
  String get filterInStockSub;

  /// No description provided for @filterApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get filterApply;

  /// No description provided for @filterShowResults.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No matches} =1{Show 1 piece} other{Show {count} pieces}}'**
  String filterShowResults(int count);

  /// No description provided for @categoryEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No pieces match'**
  String get categoryEmptyTitle;

  /// No description provided for @categoryEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Loosen a filter or two and try again.'**
  String get categoryEmptyBody;

  /// No description provided for @productSoldOut.
  ///
  /// In en, this message translates to:
  /// **'Sold out'**
  String get productSoldOut;

  /// No description provided for @productInStock.
  ///
  /// In en, this message translates to:
  /// **'In stock'**
  String get productInStock;

  /// No description provided for @productNotFound.
  ///
  /// In en, this message translates to:
  /// **'This piece is no longer available.'**
  String get productNotFound;

  /// No description provided for @productQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get productQuantity;

  /// No description provided for @productDeliveryDays.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{Delivery in 1 day} other{Delivery in {days} days}}'**
  String productDeliveryDays(int days);

  /// No description provided for @productSpecifications.
  ///
  /// In en, this message translates to:
  /// **'Specifications'**
  String get productSpecifications;

  /// No description provided for @productReviews.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Reviews} =1{1 review} other{{count} reviews}}'**
  String productReviews(int count);

  /// No description provided for @productNoReviews.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet — be the first.'**
  String get productNoReviews;

  /// No description provided for @productRelatedEyebrow.
  ///
  /// In en, this message translates to:
  /// **'You may also like'**
  String get productRelatedEyebrow;

  /// No description provided for @productRelatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Related pieces'**
  String get productRelatedTitle;

  /// No description provided for @productTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get productTotal;

  /// No description provided for @productBuyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy now'**
  String get productBuyNow;

  /// No description provided for @productShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get productShare;

  /// No description provided for @productLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get productLinkCopied;

  /// No description provided for @specMetal.
  ///
  /// In en, this message translates to:
  /// **'Metal'**
  String get specMetal;

  /// No description provided for @specPurity.
  ///
  /// In en, this message translates to:
  /// **'Purity'**
  String get specPurity;

  /// No description provided for @specWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get specWeight;

  /// No description provided for @specGrams.
  ///
  /// In en, this message translates to:
  /// **'{grams} g'**
  String specGrams(String grams);

  /// No description provided for @specStone.
  ///
  /// In en, this message translates to:
  /// **'Stone'**
  String get specStone;

  /// No description provided for @specCollection.
  ///
  /// In en, this message translates to:
  /// **'Collection'**
  String get specCollection;

  /// No description provided for @specSku.
  ///
  /// In en, this message translates to:
  /// **'SKU'**
  String get specSku;

  /// No description provided for @specHallmark.
  ///
  /// In en, this message translates to:
  /// **'Hallmark'**
  String get specHallmark;

  /// No description provided for @sizeGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'Size guide'**
  String get sizeGuideTitle;

  /// No description provided for @sizeGuideHeading.
  ///
  /// In en, this message translates to:
  /// **'Find your size'**
  String get sizeGuideHeading;

  /// No description provided for @sizeGuideSub.
  ///
  /// In en, this message translates to:
  /// **'Measure at home in under a minute, or visit the store for a free fitting.'**
  String get sizeGuideSub;

  /// No description provided for @sizeKindRing.
  ///
  /// In en, this message translates to:
  /// **'Ring'**
  String get sizeKindRing;

  /// No description provided for @sizeKindBangle.
  ///
  /// In en, this message translates to:
  /// **'Bangle'**
  String get sizeKindBangle;

  /// No description provided for @sizeKindLength.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get sizeKindLength;

  /// No description provided for @sizeLabelRing.
  ///
  /// In en, this message translates to:
  /// **'Ring size'**
  String get sizeLabelRing;

  /// No description provided for @sizeLabelBangle.
  ///
  /// In en, this message translates to:
  /// **'Bangle size'**
  String get sizeLabelBangle;

  /// No description provided for @sizeLabelLength.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get sizeLabelLength;

  /// No description provided for @sizeHowToMeasure.
  ///
  /// In en, this message translates to:
  /// **'How to measure'**
  String get sizeHowToMeasure;

  /// No description provided for @sizeChart.
  ///
  /// In en, this message translates to:
  /// **'Size chart'**
  String get sizeChart;

  /// No description provided for @sizeUs.
  ///
  /// In en, this message translates to:
  /// **'US'**
  String get sizeUs;

  /// No description provided for @sizeUk.
  ///
  /// In en, this message translates to:
  /// **'UK'**
  String get sizeUk;

  /// No description provided for @sizeSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get sizeSize;

  /// No description provided for @sizeDiameterMm.
  ///
  /// In en, this message translates to:
  /// **'Diameter mm'**
  String get sizeDiameterMm;

  /// No description provided for @sizeDiameterIn.
  ///
  /// In en, this message translates to:
  /// **'Diameter in'**
  String get sizeDiameterIn;

  /// No description provided for @sizeCircumferenceMm.
  ///
  /// In en, this message translates to:
  /// **'Around mm'**
  String get sizeCircumferenceMm;

  /// No description provided for @sizeFits.
  ///
  /// In en, this message translates to:
  /// **'Fits'**
  String get sizeFits;

  /// No description provided for @sizeLengthCm.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get sizeLengthCm;

  /// No description provided for @sizeSits.
  ///
  /// In en, this message translates to:
  /// **'Sits'**
  String get sizeSits;

  /// No description provided for @sizeRingStep1.
  ///
  /// In en, this message translates to:
  /// **'Wrap a strip of paper around the base of the finger, snug but not tight.'**
  String get sizeRingStep1;

  /// No description provided for @sizeRingStep2.
  ///
  /// In en, this message translates to:
  /// **'Mark where the paper overlaps, then measure that length in millimetres — that is your circumference.'**
  String get sizeRingStep2;

  /// No description provided for @sizeRingStep3.
  ///
  /// In en, this message translates to:
  /// **'Find the closest circumference in the chart below to get your size.'**
  String get sizeRingStep3;

  /// No description provided for @sizeBangleStep1.
  ///
  /// In en, this message translates to:
  /// **'Press your thumb into your palm and measure around the widest part of your hand.'**
  String get sizeBangleStep1;

  /// No description provided for @sizeBangleStep2.
  ///
  /// In en, this message translates to:
  /// **'Match that measurement to the circumference column below.'**
  String get sizeBangleStep2;

  /// No description provided for @sizeTip.
  ///
  /// In en, this message translates to:
  /// **'Measure at the end of the day, when fingers are at their largest, and avoid measuring when cold.'**
  String get sizeTip;

  /// No description provided for @sizeRequired.
  ///
  /// In en, this message translates to:
  /// **'Please choose a size first.'**
  String get sizeRequired;

  /// No description provided for @sizeResizeNote.
  ///
  /// In en, this message translates to:
  /// **'One complimentary resize is included within 60 days of purchase.'**
  String get sizeResizeNote;

  /// No description provided for @sizeFitsXs.
  ///
  /// In en, this message translates to:
  /// **'Extra small'**
  String get sizeFitsXs;

  /// No description provided for @sizeFitsS.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get sizeFitsS;

  /// No description provided for @sizeFitsM.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get sizeFitsM;

  /// No description provided for @sizeFitsL.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get sizeFitsL;

  /// No description provided for @sizeFitsXl.
  ///
  /// In en, this message translates to:
  /// **'Extra large'**
  String get sizeFitsXl;

  /// No description provided for @sizeSitsChoker.
  ///
  /// In en, this message translates to:
  /// **'Choker — at the base of the neck'**
  String get sizeSitsChoker;

  /// No description provided for @sizeSitsPrincess.
  ///
  /// In en, this message translates to:
  /// **'Princess — just below the collarbone'**
  String get sizeSitsPrincess;

  /// No description provided for @sizeSitsMatinee.
  ///
  /// In en, this message translates to:
  /// **'Matinee — on the chest'**
  String get sizeSitsMatinee;

  /// No description provided for @sizeSitsMatineeLow.
  ///
  /// In en, this message translates to:
  /// **'Matinee — lower chest'**
  String get sizeSitsMatineeLow;

  /// No description provided for @sizeSitsOpera.
  ///
  /// In en, this message translates to:
  /// **'Opera — below the bust'**
  String get sizeSitsOpera;

  /// No description provided for @lookbookTitle.
  ///
  /// In en, this message translates to:
  /// **'Lookbook'**
  String get lookbookTitle;

  /// No description provided for @lookbookHide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get lookbookHide;

  /// No description provided for @lookbookHidden.
  ///
  /// In en, this message translates to:
  /// **'{name} hidden for now'**
  String lookbookHidden(String name);

  /// No description provided for @lookbookEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Everything is hidden'**
  String get lookbookEmptyTitle;

  /// No description provided for @lookbookEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Bring the pieces back to keep browsing.'**
  String get lookbookEmptyBody;

  /// No description provided for @lookbookRestore.
  ///
  /// In en, this message translates to:
  /// **'Show all'**
  String get lookbookRestore;

  /// No description provided for @wishlistTitle.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlistTitle;

  /// No description provided for @wishlistAdded.
  ///
  /// In en, this message translates to:
  /// **'Saved to wishlist'**
  String get wishlistAdded;

  /// No description provided for @wishlistRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed from wishlist'**
  String get wishlistRemoved;

  /// No description provided for @wishlistCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 saved piece} other{{count} saved pieces}}'**
  String wishlistCount(int count);

  /// No description provided for @wishlistMoveAll.
  ///
  /// In en, this message translates to:
  /// **'Move all to bag'**
  String get wishlistMoveAll;

  /// No description provided for @wishlistMovedAll.
  ///
  /// In en, this message translates to:
  /// **'Moved to your bag'**
  String get wishlistMovedAll;

  /// No description provided for @wishlistMovedSome.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Sized pieces need a size — open each one to add it} =1{1 piece moved; choose a size for the rest} other{{count} pieces moved; choose a size for the rest}}'**
  String wishlistMovedSome(int count);

  /// No description provided for @wishlistEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing saved yet'**
  String get wishlistEmptyTitle;

  /// No description provided for @wishlistEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart on any piece to keep it here.'**
  String get wishlistEmptyBody;

  /// No description provided for @cartTitle.
  ///
  /// In en, this message translates to:
  /// **'Your bag'**
  String get cartTitle;

  /// No description provided for @cartAddToBag.
  ///
  /// In en, this message translates to:
  /// **'Add to bag'**
  String get cartAddToBag;

  /// No description provided for @cartAdded.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get cartAdded;

  /// No description provided for @cartAddedToast.
  ///
  /// In en, this message translates to:
  /// **'{name} added to your bag'**
  String cartAddedToast(String name);

  /// No description provided for @cartEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your bag is empty'**
  String get cartEmptyTitle;

  /// No description provided for @cartEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Pieces you add will wait for you here.'**
  String get cartEmptyBody;

  /// No description provided for @cartFreeDeliveryHint.
  ///
  /// In en, this message translates to:
  /// **'Spend {amount} more for free delivery'**
  String cartFreeDeliveryHint(String amount);

  /// No description provided for @cartFreeDeliveryUnlocked.
  ///
  /// In en, this message translates to:
  /// **'You have free delivery'**
  String get cartFreeDeliveryUnlocked;

  /// No description provided for @cartSize.
  ///
  /// In en, this message translates to:
  /// **'Size {size}'**
  String cartSize(String size);

  /// No description provided for @cartQty.
  ///
  /// In en, this message translates to:
  /// **'Qty {count}'**
  String cartQty(int count);

  /// No description provided for @cartRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get cartRemove;

  /// No description provided for @cartMoveToWishlist.
  ///
  /// In en, this message translates to:
  /// **'Move to wishlist'**
  String get cartMoveToWishlist;

  /// No description provided for @cartMovedToWishlist.
  ///
  /// In en, this message translates to:
  /// **'Moved to wishlist'**
  String get cartMovedToWishlist;

  /// No description provided for @cartSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get cartSubtotal;

  /// No description provided for @cartSavings.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get cartSavings;

  /// No description provided for @cartShipping.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get cartShipping;

  /// No description provided for @cartFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get cartFree;

  /// No description provided for @cartTax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get cartTax;

  /// No description provided for @cartTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get cartTotal;

  /// No description provided for @cartCheckout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get cartCheckout;

  /// No description provided for @checkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkoutTitle;

  /// No description provided for @checkoutStepAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get checkoutStepAddress;

  /// No description provided for @checkoutStepPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get checkoutStepPayment;

  /// No description provided for @checkoutStepReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get checkoutStepReview;

  /// No description provided for @checkoutAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Where should we deliver?'**
  String get checkoutAddressTitle;

  /// No description provided for @checkoutAddressSub.
  ///
  /// In en, this message translates to:
  /// **'Pick a saved address or enter a new one.'**
  String get checkoutAddressSub;

  /// No description provided for @checkoutAddressIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Please fill in name, phone, address and city.'**
  String get checkoutAddressIncomplete;

  /// No description provided for @checkoutContinuePayment.
  ///
  /// In en, this message translates to:
  /// **'Continue to payment'**
  String get checkoutContinuePayment;

  /// No description provided for @checkoutPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'How would you like to pay?'**
  String get checkoutPaymentTitle;

  /// No description provided for @checkoutPaymentSub.
  ///
  /// In en, this message translates to:
  /// **'No payment is taken in this demo.'**
  String get checkoutPaymentSub;

  /// No description provided for @checkoutContinueReview.
  ///
  /// In en, this message translates to:
  /// **'Review order'**
  String get checkoutContinueReview;

  /// No description provided for @checkoutSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get checkoutSummary;

  /// No description provided for @checkoutDemoNote.
  ///
  /// In en, this message translates to:
  /// **'Demo checkout — no card details are stored and nothing is charged.'**
  String get checkoutDemoNote;

  /// No description provided for @checkoutReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Almost there'**
  String get checkoutReviewTitle;

  /// No description provided for @checkoutReviewSub.
  ///
  /// In en, this message translates to:
  /// **'Check everything, then place your order.'**
  String get checkoutReviewSub;

  /// No description provided for @checkoutDeliverTo.
  ///
  /// In en, this message translates to:
  /// **'Deliver to'**
  String get checkoutDeliverTo;

  /// No description provided for @checkoutPayWith.
  ///
  /// In en, this message translates to:
  /// **'Pay with'**
  String get checkoutPayWith;

  /// No description provided for @checkoutItems.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String checkoutItems(int count);

  /// No description provided for @checkoutPlaceOrder.
  ///
  /// In en, this message translates to:
  /// **'Place order · {total}'**
  String checkoutPlaceOrder(String total);

  /// No description provided for @checkoutPlacing.
  ///
  /// In en, this message translates to:
  /// **'Placing your order'**
  String get checkoutPlacing;

  /// No description provided for @checkoutPlacingSub.
  ///
  /// In en, this message translates to:
  /// **'Just a moment…'**
  String get checkoutPlacingSub;

  /// No description provided for @checkoutConfirmedTitle.
  ///
  /// In en, this message translates to:
  /// **'Order confirmed'**
  String get checkoutConfirmedTitle;

  /// No description provided for @checkoutConfirmedBody.
  ///
  /// In en, this message translates to:
  /// **'Thank you. We will confirm it shortly and keep you posted at every step.'**
  String get checkoutConfirmedBody;

  /// No description provided for @checkoutTrackOrder.
  ///
  /// In en, this message translates to:
  /// **'Track order'**
  String get checkoutTrackOrder;

  /// No description provided for @paymentCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get paymentCard;

  /// No description provided for @paymentCardSub.
  ///
  /// In en, this message translates to:
  /// **'Visa, Mastercard'**
  String get paymentCardSub;

  /// No description provided for @paymentWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get paymentWallet;

  /// No description provided for @paymentWalletSub.
  ///
  /// In en, this message translates to:
  /// **'BCEL One and other wallets'**
  String get paymentWalletSub;

  /// No description provided for @paymentCod.
  ///
  /// In en, this message translates to:
  /// **'Cash on delivery'**
  String get paymentCod;

  /// No description provided for @paymentCodSub.
  ///
  /// In en, this message translates to:
  /// **'Pay when your piece arrives'**
  String get paymentCodSub;

  /// No description provided for @ordersTitle.
  ///
  /// In en, this message translates to:
  /// **'My orders'**
  String get ordersTitle;

  /// No description provided for @ordersSignInBody.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your phone number to see and track your orders.'**
  String get ordersSignInBody;

  /// No description provided for @ordersActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get ordersActive;

  /// No description provided for @ordersAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get ordersAll;

  /// No description provided for @ordersEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get ordersEmptyTitle;

  /// No description provided for @ordersEmptyActiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing on its way'**
  String get ordersEmptyActiveTitle;

  /// No description provided for @ordersEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'When you place an order it will appear here with live tracking.'**
  String get ordersEmptyBody;

  /// No description provided for @ordersMoreItems.
  ///
  /// In en, this message translates to:
  /// **'{name} +{count} more'**
  String ordersMoreItems(String name, int count);

  /// No description provided for @ordersViewDetail.
  ///
  /// In en, this message translates to:
  /// **'View detail'**
  String get ordersViewDetail;

  /// No description provided for @ordersInvoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get ordersInvoice;

  /// No description provided for @ordersInvoiceDemo.
  ///
  /// In en, this message translates to:
  /// **'Invoices arrive by email in the live app.'**
  String get ordersInvoiceDemo;

  /// No description provided for @orderStatusPlaced.
  ///
  /// In en, this message translates to:
  /// **'Placed'**
  String get orderStatusPlaced;

  /// No description provided for @orderStatusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get orderStatusConfirmed;

  /// No description provided for @orderStatusPacked.
  ///
  /// In en, this message translates to:
  /// **'Packed'**
  String get orderStatusPacked;

  /// No description provided for @orderStatusShipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get orderStatusShipped;

  /// No description provided for @orderStatusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get orderStatusDelivered;

  /// No description provided for @orderStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get orderStatusCancelled;

  /// No description provided for @orderStageDescPlaced.
  ///
  /// In en, this message translates to:
  /// **'We received your order'**
  String get orderStageDescPlaced;

  /// No description provided for @orderStageDescConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Payment and stock confirmed'**
  String get orderStageDescConfirmed;

  /// No description provided for @orderStageDescPacked.
  ///
  /// In en, this message translates to:
  /// **'Gift-wrapped and ready'**
  String get orderStageDescPacked;

  /// No description provided for @orderStageDescShipped.
  ///
  /// In en, this message translates to:
  /// **'With the courier'**
  String get orderStageDescShipped;

  /// No description provided for @orderStageDescDelivered.
  ///
  /// In en, this message translates to:
  /// **'Enjoy your piece'**
  String get orderStageDescDelivered;

  /// No description provided for @orderCancelledNote.
  ///
  /// In en, this message translates to:
  /// **'This order was cancelled. Any payment has been refunded.'**
  String get orderCancelledNote;

  /// No description provided for @orderCourier.
  ///
  /// In en, this message translates to:
  /// **'Courier'**
  String get orderCourier;

  /// No description provided for @orderTracking.
  ///
  /// In en, this message translates to:
  /// **'Tracking'**
  String get orderTracking;

  /// No description provided for @orderTrackingCopied.
  ///
  /// In en, this message translates to:
  /// **'Tracking number copied'**
  String get orderTrackingCopied;

  /// No description provided for @orderDeliverTo.
  ///
  /// In en, this message translates to:
  /// **'Deliver to'**
  String get orderDeliverTo;

  /// No description provided for @orderDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get orderDetailTitle;

  /// No description provided for @orderNotFound.
  ///
  /// In en, this message translates to:
  /// **'We could not find that order.'**
  String get orderNotFound;

  /// No description provided for @orderProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get orderProgress;

  /// No description provided for @orderReorder.
  ///
  /// In en, this message translates to:
  /// **'Reorder'**
  String get orderReorder;

  /// No description provided for @orderReorderAll.
  ///
  /// In en, this message translates to:
  /// **'Everything is back in your bag'**
  String get orderReorderAll;

  /// No description provided for @orderReorderPartial.
  ///
  /// In en, this message translates to:
  /// **'{restored} of {total} pieces added; the rest are sold out'**
  String orderReorderPartial(int restored, int total);

  /// No description provided for @orderReorderNone.
  ///
  /// In en, this message translates to:
  /// **'Those pieces are sold out right now'**
  String get orderReorderNone;

  /// No description provided for @orderCallCourier.
  ///
  /// In en, this message translates to:
  /// **'Call courier'**
  String get orderCallCourier;

  /// No description provided for @orderCourierNumberCopied.
  ///
  /// In en, this message translates to:
  /// **'{phone} copied'**
  String orderCourierNumberCopied(String phone);

  /// No description provided for @addressesTitle.
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get addressesTitle;

  /// No description provided for @addressesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No addresses yet'**
  String get addressesEmptyTitle;

  /// No description provided for @addressesEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add one to speed up checkout.'**
  String get addressesEmptyBody;

  /// No description provided for @addressAdd.
  ///
  /// In en, this message translates to:
  /// **'Add address'**
  String get addressAdd;

  /// No description provided for @addressEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit address'**
  String get addressEdit;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get addressLabel;

  /// No description provided for @addressLabelHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get addressLabelHome;

  /// No description provided for @addressLabelWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get addressLabelWork;

  /// No description provided for @addressLabelOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get addressLabelOther;

  /// No description provided for @addressName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get addressName;

  /// No description provided for @addressPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get addressPhone;

  /// No description provided for @addressLine1.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressLine1;

  /// No description provided for @addressCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get addressCity;

  /// No description provided for @addressPostcode.
  ///
  /// In en, this message translates to:
  /// **'Postcode'**
  String get addressPostcode;

  /// No description provided for @addressMakeDefault.
  ///
  /// In en, this message translates to:
  /// **'Make default'**
  String get addressMakeDefault;

  /// No description provided for @addressDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get addressDefault;

  /// No description provided for @addressSetDefault.
  ///
  /// In en, this message translates to:
  /// **'Set default'**
  String get addressSetDefault;

  /// No description provided for @addressDefaultSet.
  ///
  /// In en, this message translates to:
  /// **'Default address updated'**
  String get addressDefaultSet;

  /// No description provided for @addressDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete address?'**
  String get addressDeleteTitle;

  /// No description provided for @addressDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get addressDeleteBody;

  /// No description provided for @addressDeleted.
  ///
  /// In en, this message translates to:
  /// **'Address deleted'**
  String get addressDeleted;

  /// No description provided for @paymentMethodsTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment methods'**
  String get paymentMethodsTitle;

  /// No description provided for @paymentEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No payment methods'**
  String get paymentEmptyTitle;

  /// No description provided for @paymentAdd.
  ///
  /// In en, this message translates to:
  /// **'Add payment method'**
  String get paymentAdd;

  /// No description provided for @paymentAddDemo.
  ///
  /// In en, this message translates to:
  /// **'Adding a card is disabled in this demo.'**
  String get paymentAddDemo;

  /// No description provided for @paymentDefaultSet.
  ///
  /// In en, this message translates to:
  /// **'Default payment method updated'**
  String get paymentDefaultSet;

  /// No description provided for @paymentRemoved.
  ///
  /// In en, this message translates to:
  /// **'Payment method removed'**
  String get paymentRemoved;

  /// No description provided for @paymentSecureNote.
  ///
  /// In en, this message translates to:
  /// **'This is a demo. No card details are stored and no payment is ever processed.'**
  String get paymentSecureNote;

  /// No description provided for @accountStatOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get accountStatOrders;

  /// No description provided for @accountStatWishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get accountStatWishlist;

  /// No description provided for @accountStatAddresses.
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get accountStatAddresses;

  /// No description provided for @accountRecentOrders.
  ///
  /// In en, this message translates to:
  /// **'My orders'**
  String get accountRecentOrders;

  /// No description provided for @accountAddressCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No addresses} =1{1 address} other{{count} addresses}}'**
  String accountAddressCount(int count);

  /// No description provided for @accountMemberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since {date}'**
  String accountMemberSince(String date);

  /// No description provided for @accountEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get accountEditTitle;

  /// No description provided for @accountPhoneLocked.
  ///
  /// In en, this message translates to:
  /// **'Your number is verified and cannot be changed here.'**
  String get accountPhoneLocked;

  /// No description provided for @accountSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved'**
  String get accountSaved;

  /// No description provided for @accountSignOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get accountSignOutTitle;

  /// No description provided for @accountSignOutBody.
  ///
  /// In en, this message translates to:
  /// **'Your bag will be cleared on this device.'**
  String get accountSignOutBody;

  /// No description provided for @metalListing.
  ///
  /// In en, this message translates to:
  /// **'{metal} jewellery'**
  String metalListing(String metal);

  /// No description provided for @menuAllJewellery.
  ///
  /// In en, this message translates to:
  /// **'All Jewellery'**
  String get menuAllJewellery;

  /// No description provided for @menuGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get menuGold;

  /// No description provided for @menuDiamond.
  ///
  /// In en, this message translates to:
  /// **'Diamond'**
  String get menuDiamond;

  /// No description provided for @menuSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get menuSilver;

  /// No description provided for @menuPlatinum.
  ///
  /// In en, this message translates to:
  /// **'Platinum'**
  String get menuPlatinum;

  /// No description provided for @menuCoinsBars.
  ///
  /// In en, this message translates to:
  /// **'Coins & Bars'**
  String get menuCoinsBars;

  /// No description provided for @menuSolitaire.
  ///
  /// In en, this message translates to:
  /// **'Solitaire'**
  String get menuSolitaire;

  /// No description provided for @menuCollections.
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get menuCollections;

  /// No description provided for @menuGiftStore.
  ///
  /// In en, this message translates to:
  /// **'Gift Store'**
  String get menuGiftStore;

  /// No description provided for @menuOffers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get menuOffers;

  /// No description provided for @drawerBrowse.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get drawerBrowse;

  /// No description provided for @drawerNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get drawerNotifications;

  /// No description provided for @drawerStores.
  ///
  /// In en, this message translates to:
  /// **'Our stores'**
  String get drawerStores;

  /// No description provided for @homeRateTicker.
  ///
  /// In en, this message translates to:
  /// **'GOLD {purity} / 1 g'**
  String homeRateTicker(String purity);

  /// No description provided for @homeSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for necklaces, rings, 22K…'**
  String get homeSearchHint;

  /// No description provided for @homeBrandsTitle.
  ///
  /// In en, this message translates to:
  /// **'Our Brands'**
  String get homeBrandsTitle;

  /// No description provided for @homeCuratedEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Latest collection'**
  String get homeCuratedEyebrow;

  /// No description provided for @homeCuratedTitle.
  ///
  /// In en, this message translates to:
  /// **'Curated for you'**
  String get homeCuratedTitle;

  /// No description provided for @homeCuratedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Picked from the collections you love'**
  String get homeCuratedSubtitle;

  /// No description provided for @homeStoresTitle.
  ///
  /// In en, this message translates to:
  /// **'Come visit us'**
  String get homeStoresTitle;

  /// No description provided for @homeStoresSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try pieces on at any of our boutiques'**
  String get homeStoresSubtitle;

  /// No description provided for @homeAboutEyebrow.
  ///
  /// In en, this message translates to:
  /// **'About us'**
  String get homeAboutEyebrow;

  /// No description provided for @homeAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'The {brand} story'**
  String homeAboutTitle(String brand);

  /// No description provided for @homeAboutCta.
  ///
  /// In en, this message translates to:
  /// **'Our story'**
  String get homeAboutCta;

  /// No description provided for @actionViewCollection.
  ///
  /// In en, this message translates to:
  /// **'View collection'**
  String get actionViewCollection;

  /// No description provided for @actionDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get actionDone;

  /// No description provided for @storeFlagship.
  ///
  /// In en, this message translates to:
  /// **'Flagship'**
  String get storeFlagship;

  /// No description provided for @storeDirections.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get storeDirections;

  /// No description provided for @storeServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get storeServices;

  /// No description provided for @storesTitle.
  ///
  /// In en, this message translates to:
  /// **'Our stores'**
  String get storesTitle;

  /// No description provided for @storesEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Store locator'**
  String get storesEyebrow;

  /// No description provided for @storesHeadline.
  ///
  /// In en, this message translates to:
  /// **'Visit a boutique'**
  String get storesHeadline;

  /// No description provided for @storesAllCities.
  ///
  /// In en, this message translates to:
  /// **'All cities'**
  String get storesAllCities;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSub.
  ///
  /// In en, this message translates to:
  /// **'Choose your boutique\'s colour'**
  String get settingsThemeSub;

  /// No description provided for @settingsThemeApplied.
  ///
  /// In en, this message translates to:
  /// **'Theme applied'**
  String get settingsThemeApplied;

  /// No description provided for @settingsShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get settingsShopping;

  /// No description provided for @settingsTrackOrder.
  ///
  /// In en, this message translates to:
  /// **'Track order'**
  String get settingsTrackOrder;

  /// No description provided for @settingsSizeGuide.
  ///
  /// In en, this message translates to:
  /// **'Size guide'**
  String get settingsSizeGuide;

  /// No description provided for @settingsPolicies.
  ///
  /// In en, this message translates to:
  /// **'Policies'**
  String get settingsPolicies;

  /// No description provided for @settingsSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get settingsSupport;

  /// No description provided for @settingsFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get settingsFeedback;

  /// No description provided for @settingsRateUs.
  ///
  /// In en, this message translates to:
  /// **'Rate us'**
  String get settingsRateUs;

  /// No description provided for @settingsShare.
  ///
  /// In en, this message translates to:
  /// **'Share app'**
  String get settingsShare;

  /// No description provided for @settingsShareText.
  ///
  /// In en, this message translates to:
  /// **'Shop {brand} on your phone: {url}'**
  String settingsShareText(String brand, String url);

  /// No description provided for @settingsShareFailed.
  ///
  /// In en, this message translates to:
  /// **'Sharing isn\'t available on this device'**
  String get settingsShareFailed;

  /// No description provided for @settingsTour.
  ///
  /// In en, this message translates to:
  /// **'Take the tour'**
  String get settingsTour;

  /// No description provided for @themeRuby.
  ///
  /// In en, this message translates to:
  /// **'Ruby Red'**
  String get themeRuby;

  /// No description provided for @themeRubySub.
  ///
  /// In en, this message translates to:
  /// **'The signature red'**
  String get themeRubySub;

  /// No description provided for @themeBurgundy.
  ///
  /// In en, this message translates to:
  /// **'Royal Burgundy'**
  String get themeBurgundy;

  /// No description provided for @themeBurgundySub.
  ///
  /// In en, this message translates to:
  /// **'Deep and warm'**
  String get themeBurgundySub;

  /// No description provided for @themeEmerald.
  ///
  /// In en, this message translates to:
  /// **'Emerald Luxury'**
  String get themeEmerald;

  /// No description provided for @themeEmeraldSub.
  ///
  /// In en, this message translates to:
  /// **'Green with gold'**
  String get themeEmeraldSub;

  /// No description provided for @themeSapphire.
  ///
  /// In en, this message translates to:
  /// **'Sapphire'**
  String get themeSapphire;

  /// No description provided for @themeSapphireSub.
  ///
  /// In en, this message translates to:
  /// **'Cool blue, silver accent'**
  String get themeSapphireSub;

  /// No description provided for @themeRose.
  ///
  /// In en, this message translates to:
  /// **'Rose'**
  String get themeRose;

  /// No description provided for @themeRoseSub.
  ///
  /// In en, this message translates to:
  /// **'Soft pink, copper accent'**
  String get themeRoseSub;

  /// No description provided for @themeBlack.
  ///
  /// In en, this message translates to:
  /// **'Classic Black'**
  String get themeBlack;

  /// No description provided for @themeBlackSub.
  ///
  /// In en, this message translates to:
  /// **'Ink with gold'**
  String get themeBlackSub;

  /// No description provided for @policyUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated {date}'**
  String policyUpdated(String date);

  /// No description provided for @policyFaq.
  ///
  /// In en, this message translates to:
  /// **'Frequently asked'**
  String get policyFaq;

  /// No description provided for @goldEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Live rates'**
  String get goldEyebrow;

  /// No description provided for @goldTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s gold rate'**
  String get goldTitle;

  /// No description provided for @goldUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated {time}'**
  String goldUpdated(String time);

  /// No description provided for @goldColPurity.
  ///
  /// In en, this message translates to:
  /// **'Purity'**
  String get goldColPurity;

  /// No description provided for @goldPerGram.
  ///
  /// In en, this message translates to:
  /// **'Per gram, selling rate. USD and THB are indicative.'**
  String get goldPerGram;

  /// No description provided for @goldDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Rates move with the market and are confirmed at the counter. Coins and bars are priced on the rate at the time of order.'**
  String get goldDisclaimer;

  /// No description provided for @aboutEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Since {year}'**
  String aboutEyebrow(String year);

  /// No description provided for @aboutVisit.
  ///
  /// In en, this message translates to:
  /// **'Visit a boutique'**
  String get aboutVisit;

  /// No description provided for @contactHeadline.
  ///
  /// In en, this message translates to:
  /// **'We\'re here to help'**
  String get contactHeadline;

  /// No description provided for @contactChannels.
  ///
  /// In en, this message translates to:
  /// **'Reach us'**
  String get contactChannels;

  /// No description provided for @contactCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get contactCall;

  /// No description provided for @contactWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get contactWhatsapp;

  /// No description provided for @contactEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get contactEmail;

  /// No description provided for @contactStore.
  ///
  /// In en, this message translates to:
  /// **'Flagship store'**
  String get contactStore;

  /// No description provided for @contactMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'Send a message'**
  String get contactMessageTitle;

  /// No description provided for @contactMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get contactMessage;

  /// No description provided for @contactMessageShort.
  ///
  /// In en, this message translates to:
  /// **'Tell us a little more (at least 10 characters).'**
  String get contactMessageShort;

  /// No description provided for @contactSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get contactSend;

  /// No description provided for @contactSent.
  ///
  /// In en, this message translates to:
  /// **'Message sent. We\'ll reply within a working day.'**
  String get contactSent;

  /// No description provided for @contactCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied {value}'**
  String contactCopied(String value);

  /// No description provided for @feedbackEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedbackEyebrow;

  /// No description provided for @feedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'How was your experience?'**
  String get feedbackTitle;

  /// No description provided for @feedbackIntro.
  ///
  /// In en, this message translates to:
  /// **'Every note reaches the atelier. Tell us what to keep and what to fix.'**
  String get feedbackIntro;

  /// No description provided for @feedbackHappy.
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get feedbackHappy;

  /// No description provided for @feedbackSad.
  ///
  /// In en, this message translates to:
  /// **'Not happy'**
  String get feedbackSad;

  /// No description provided for @feedbackTopic.
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get feedbackTopic;

  /// No description provided for @feedbackTopicApp.
  ///
  /// In en, this message translates to:
  /// **'App experience'**
  String get feedbackTopicApp;

  /// No description provided for @feedbackTopicRange.
  ///
  /// In en, this message translates to:
  /// **'Product range'**
  String get feedbackTopicRange;

  /// No description provided for @feedbackTopicPricing.
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get feedbackTopicPricing;

  /// No description provided for @feedbackTopicDelivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get feedbackTopicDelivery;

  /// No description provided for @feedbackTopicStore.
  ///
  /// In en, this message translates to:
  /// **'Store visit'**
  String get feedbackTopicStore;

  /// No description provided for @feedbackTopicOther.
  ///
  /// In en, this message translates to:
  /// **'Something else'**
  String get feedbackTopicOther;

  /// No description provided for @feedbackMessage.
  ///
  /// In en, this message translates to:
  /// **'Your feedback'**
  String get feedbackMessage;

  /// No description provided for @feedbackTooShort.
  ///
  /// In en, this message translates to:
  /// **'Please write at least {min} characters.'**
  String feedbackTooShort(int min);

  /// No description provided for @feedbackFollowUp.
  ///
  /// In en, this message translates to:
  /// **'You may follow up with me'**
  String get feedbackFollowUp;

  /// No description provided for @feedbackThanksTitle.
  ///
  /// In en, this message translates to:
  /// **'Thank you'**
  String get feedbackThanksTitle;

  /// No description provided for @feedbackThanksBody.
  ///
  /// In en, this message translates to:
  /// **'We read every message. If you asked for a follow-up, expect one within two working days.'**
  String get feedbackThanksBody;

  /// No description provided for @feedbackTicket.
  ///
  /// In en, this message translates to:
  /// **'Ticket {ticket}'**
  String feedbackTicket(String ticket);

  /// No description provided for @feedbackBack.
  ///
  /// In en, this message translates to:
  /// **'Back to settings'**
  String get feedbackBack;

  /// No description provided for @feedbackAnother.
  ///
  /// In en, this message translates to:
  /// **'Send another'**
  String get feedbackAnother;

  /// No description provided for @feedbackRate.
  ///
  /// In en, this message translates to:
  /// **'Rate the app'**
  String get feedbackRate;

  /// No description provided for @rateTitle.
  ///
  /// In en, this message translates to:
  /// **'Enjoying {brand}?'**
  String rateTitle(String brand);

  /// No description provided for @rateIntro.
  ///
  /// In en, this message translates to:
  /// **'Tap a star. Your rating helps other customers find us.'**
  String get rateIntro;

  /// No description provided for @rateCaption0.
  ///
  /// In en, this message translates to:
  /// **'Tap a star to rate'**
  String get rateCaption0;

  /// No description provided for @rateCaption1.
  ///
  /// In en, this message translates to:
  /// **'We\'re sorry. Tell us what went wrong.'**
  String get rateCaption1;

  /// No description provided for @rateCaption2.
  ///
  /// In en, this message translates to:
  /// **'Not great. We\'d like to do better.'**
  String get rateCaption2;

  /// No description provided for @rateCaption3.
  ///
  /// In en, this message translates to:
  /// **'Okay. What would make it better?'**
  String get rateCaption3;

  /// No description provided for @rateCaption4.
  ///
  /// In en, this message translates to:
  /// **'Glad you like it!'**
  String get rateCaption4;

  /// No description provided for @rateCaption5.
  ///
  /// In en, this message translates to:
  /// **'Wonderful, thank you!'**
  String get rateCaption5;

  /// No description provided for @rateOnStore.
  ///
  /// In en, this message translates to:
  /// **'Rate on the store'**
  String get rateOnStore;

  /// No description provided for @rateNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get rateNotNow;

  /// No description provided for @rateStoreDemo.
  ///
  /// In en, this message translates to:
  /// **'The store listing opens here once the app is published.'**
  String get rateStoreDemo;

  /// No description provided for @rateWhatWentWrong.
  ///
  /// In en, this message translates to:
  /// **'What went wrong?'**
  String get rateWhatWentWrong;

  /// No description provided for @rateDetailedFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send detailed feedback'**
  String get rateDetailedFeedback;

  /// No description provided for @rateThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks for your rating'**
  String get rateThanks;

  /// No description provided for @rateSummary.
  ///
  /// In en, this message translates to:
  /// **'Ratings'**
  String get rateSummary;

  /// No description provided for @rateCount.
  ///
  /// In en, this message translates to:
  /// **'{count} ratings'**
  String rateCount(String count);

  /// No description provided for @rateWhatsNew.
  ///
  /// In en, this message translates to:
  /// **'What\'s new in {version}'**
  String rateWhatsNew(String version);

  /// No description provided for @rateNew1.
  ///
  /// In en, this message translates to:
  /// **'Live gold rates and a store locator'**
  String get rateNew1;

  /// No description provided for @rateNew2.
  ///
  /// In en, this message translates to:
  /// **'Offers and coupon codes in the bag'**
  String get rateNew2;

  /// No description provided for @rateNew3.
  ///
  /// In en, this message translates to:
  /// **'Support chat with a live agent'**
  String get rateNew3;

  /// No description provided for @rateNew4.
  ///
  /// In en, this message translates to:
  /// **'Bespoke commission requests'**
  String get rateNew4;

  /// No description provided for @storiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer stories'**
  String get storiesTitle;

  /// No description provided for @storiesShopNow.
  ///
  /// In en, this message translates to:
  /// **'Shop now'**
  String get storiesShopNow;

  /// No description provided for @storiesLike.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get storiesLike;

  /// No description provided for @supportRoot.
  ///
  /// In en, this message translates to:
  /// **'Hello! I\'m the boutique assistant. What can I help you with today?'**
  String get supportRoot;

  /// No description provided for @supportOptTrack.
  ///
  /// In en, this message translates to:
  /// **'Track my order'**
  String get supportOptTrack;

  /// No description provided for @supportOptReturns.
  ///
  /// In en, this message translates to:
  /// **'Returns & exchange'**
  String get supportOptReturns;

  /// No description provided for @supportOptCare.
  ///
  /// In en, this message translates to:
  /// **'Jewellery care & sizing'**
  String get supportOptCare;

  /// No description provided for @supportOptPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments & offers'**
  String get supportOptPayments;

  /// No description provided for @supportOptHelped.
  ///
  /// In en, this message translates to:
  /// **'That helped'**
  String get supportOptHelped;

  /// No description provided for @supportOptAgent.
  ///
  /// In en, this message translates to:
  /// **'Talk to a live agent'**
  String get supportOptAgent;

  /// No description provided for @supportOptMore.
  ///
  /// In en, this message translates to:
  /// **'Something else'**
  String get supportOptMore;

  /// No description provided for @supportTrack.
  ///
  /// In en, this message translates to:
  /// **'Open Orders, pick the order and you\'ll see its five-stage timeline with the courier\'s tracking number. Out-for-delivery parcels also send a notification.'**
  String get supportTrack;

  /// No description provided for @supportReturns.
  ///
  /// In en, this message translates to:
  /// **'Unworn pieces can be returned within 14 days and exchanged within 30. Coins, bars and engraved pieces are excluded. I can open the policy for you.'**
  String get supportReturns;

  /// No description provided for @supportCare.
  ///
  /// In en, this message translates to:
  /// **'Remove jewellery before swimming or chemicals, store pieces separately, and bring them in any time for a free clean. Ring sizes are in the size guide.'**
  String get supportCare;

  /// No description provided for @supportPayments.
  ///
  /// In en, this message translates to:
  /// **'We accept cards, BCEL One and cash on delivery, with 0% instalments over three months. Current coupon codes are on the Offers page.'**
  String get supportPayments;

  /// No description provided for @supportHelped.
  ///
  /// In en, this message translates to:
  /// **'Wonderful. Is there anything else?'**
  String get supportHelped;

  /// No description provided for @supportConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting you to an agent…'**
  String get supportConnecting;

  /// No description provided for @supportAgentJoined.
  ///
  /// In en, this message translates to:
  /// **'{name} joined the chat'**
  String supportAgentJoined(String name);

  /// No description provided for @supportAgentGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi, I\'m {name} from the boutique. How can I help?'**
  String supportAgentGreeting(String name);

  /// No description provided for @supportAgentAck.
  ///
  /// In en, this message translates to:
  /// **'Thanks, noted. Let me check that for you and come back in a moment.'**
  String get supportAgentAck;

  /// No description provided for @supportComposerHint.
  ///
  /// In en, this message translates to:
  /// **'Write a message'**
  String get supportComposerHint;

  /// No description provided for @supportWaiting.
  ///
  /// In en, this message translates to:
  /// **'One moment…'**
  String get supportWaiting;

  /// No description provided for @supportOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get supportOpenLink;

  /// No description provided for @supportRestart.
  ///
  /// In en, this message translates to:
  /// **'Start over'**
  String get supportRestart;

  /// No description provided for @notificationsMarkAll.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get notificationsMarkAll;

  /// No description provided for @notificationsUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get notificationsUnread;

  /// No description provided for @notificationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get notificationsEmptyTitle;

  /// No description provided for @notificationsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Order updates, offers and gold-rate alerts will appear here.'**
  String get notificationsEmptyBody;

  /// No description provided for @offersEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No offers right now'**
  String get offersEmptyTitle;

  /// No description provided for @offersEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Check back soon. Follow us for seasonal edits.'**
  String get offersEmptyBody;

  /// No description provided for @offerPercentOff.
  ///
  /// In en, this message translates to:
  /// **'{value}% off'**
  String offerPercentOff(String value);

  /// No description provided for @offerAmountOff.
  ///
  /// In en, this message translates to:
  /// **'{amount} off'**
  String offerAmountOff(String amount);

  /// No description provided for @offerFreeDelivery.
  ///
  /// In en, this message translates to:
  /// **'Free delivery'**
  String get offerFreeDelivery;

  /// No description provided for @offerMinimum.
  ///
  /// In en, this message translates to:
  /// **'Min. order {amount}'**
  String offerMinimum(String amount);

  /// No description provided for @offerExpires.
  ///
  /// In en, this message translates to:
  /// **'Valid until {date}'**
  String offerExpires(String date);

  /// No description provided for @offerCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied {code}'**
  String offerCopied(String code);

  /// No description provided for @cartCoupon.
  ///
  /// In en, this message translates to:
  /// **'Coupon code'**
  String get cartCoupon;

  /// No description provided for @cartCouponApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get cartCouponApply;

  /// No description provided for @cartCouponApplied.
  ///
  /// In en, this message translates to:
  /// **'Coupon applied'**
  String get cartCouponApplied;

  /// No description provided for @cartCouponInvalid.
  ///
  /// In en, this message translates to:
  /// **'That code isn\'t valid or has expired.'**
  String get cartCouponInvalid;

  /// No description provided for @cartCouponActive.
  ///
  /// In en, this message translates to:
  /// **'Applied to this bag'**
  String get cartCouponActive;

  /// No description provided for @cartCouponMinimum.
  ///
  /// In en, this message translates to:
  /// **'Add more to reach {amount}'**
  String cartCouponMinimum(String amount);

  /// No description provided for @cartDiscount.
  ///
  /// In en, this message translates to:
  /// **'Coupon {code}'**
  String cartDiscount(String code);

  /// No description provided for @commissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Bespoke commission'**
  String get commissionTitle;

  /// No description provided for @commissionIntro.
  ///
  /// In en, this message translates to:
  /// **'Share a reference and a budget; the atelier replies with a sketch and a quote within three working days.'**
  String get commissionIntro;

  /// No description provided for @commissionPhotoHint.
  ///
  /// In en, this message translates to:
  /// **'Add a reference photo'**
  String get commissionPhotoHint;

  /// No description provided for @commissionCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get commissionCamera;

  /// No description provided for @commissionGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get commissionGallery;

  /// No description provided for @commissionBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get commissionBudget;

  /// No description provided for @commissionBrief.
  ///
  /// In en, this message translates to:
  /// **'Tell us about the piece'**
  String get commissionBrief;

  /// No description provided for @commissionNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please add your name.'**
  String get commissionNameRequired;

  /// No description provided for @commissionSend.
  ///
  /// In en, this message translates to:
  /// **'Send request'**
  String get commissionSend;

  /// No description provided for @commissionDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Request received'**
  String get commissionDoneTitle;

  /// No description provided for @commissionDoneBody.
  ///
  /// In en, this message translates to:
  /// **'A designer will be in touch with a first sketch.'**
  String get commissionDoneBody;
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

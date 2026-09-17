// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Lao (`lo`).
class AppL10nLo extends AppL10n {
  AppL10nLo([String locale = 'lo']) : super(locale);

  @override
  String get tabHome => 'ໜ້າຫຼັກ';

  @override
  String get tabCollections => 'ຄໍເລັກຊັນ';

  @override
  String get tabProfile => 'ໂປຣໄຟລ໌';

  @override
  String get tabSettings => 'ຕັ້ງຄ່າ';

  @override
  String get actionSearch => 'ຄົ້ນຫາ';

  @override
  String get actionWishlist => 'ລາຍການທີ່ມັກ';

  @override
  String get actionBag => 'ກະຕ່າ';

  @override
  String get actionMenu => 'ເມນູ';

  @override
  String get actionBack => 'ກັບຄືນ';

  @override
  String get actionSupport => 'ສົນທະນາກັບພວກເຮົາ';

  @override
  String get actionSeeAll => 'ເບິ່ງທັງໝົດ';

  @override
  String get actionViewAll => 'ເບິ່ງທັງໝົດ';

  @override
  String get actionContinueShopping => 'ເລືອກຊື້ຕໍ່';

  @override
  String get retry => 'ລອງໃໝ່';

  @override
  String get loading => 'ກຳລັງໂຫຼດ';

  @override
  String splashTagline(String tagline) {
    return '$tagline';
  }

  @override
  String get splashPreparing => 'ກຳລັງກຽມຮ້ານຂອງທ່ານ';

  @override
  String get errorTitle => 'ມີບາງຢ່າງຜິດພາດ';

  @override
  String get errorGeneric =>
      'ພວກເຮົາໂຫຼດຂໍ້ມູນນີ້ບໍ່ໄດ້ໃນຕອນນີ້. ກະລຸນາລອງໃໝ່.';

  @override
  String get errorOffline => 'ເບິ່ງຄືວ່າທ່ານບໍ່ໄດ້ເຊື່ອມຕໍ່ອິນເຕີເນັດ.';

  @override
  String get emptyTitle => 'ຍັງບໍ່ມີຫຍັງຢູ່ນີ້';

  @override
  String get emptyBody => 'ກັບມາເບິ່ງອີກໃນໄວໆນີ້ — ມີສິນຄ້າໃໝ່ມາທຸກອາທິດ.';

  @override
  String get drawerShopFor => 'ເລືອກຊື້ສຳລັບ';

  @override
  String get drawerJewellery => 'ເຄື່ອງປະດັບ';

  @override
  String get drawerOrders => 'ຄຳສັ່ງຊື້ຂອງຂ້ອຍ';

  @override
  String get drawerGoldRates => 'ລາຄາຄຳ';

  @override
  String get drawerContact => 'ຕິດຕໍ່ພວກເຮົາ';

  @override
  String get drawerSettings => 'ຕັ້ງຄ່າ';

  @override
  String get drawerDarkMode => 'ໂໝດມືດ';

  @override
  String get drawerSignOut => 'ອອກຈາກລະບົບ';

  @override
  String get drawerGuest => 'ຜູ້ໃຊ້ທົ່ວໄປ';

  @override
  String get drawerGuestHint => 'ເຂົ້າສູ່ລະບົບເພື່ອຕິດຕາມຄຳສັ່ງຊື້';

  @override
  String get audienceWomen => 'ຜູ້ຍິງ';

  @override
  String get audienceMen => 'ຜູ້ຊາຍ';

  @override
  String get audienceKids => 'ເດັກນ້ອຍ';

  @override
  String get homeStoriesEyebrow => 'ລະດູການນີ້';

  @override
  String get homeStoriesTitle => 'ເລື່ອງລາວແນະນຳ';

  @override
  String get homeCollectionsEyebrow => 'ເລືອກເບິ່ງ';

  @override
  String get homeCollectionsTitle => 'ເລືອກຊື້ຕາມຄໍເລັກຊັນ';

  @override
  String get homeCollectionsSubtitle => 'ທຸກຊິ້ນຕີຕາ ແລະ ມີໃບຮັບຮອງ';

  @override
  String get homeDemoNote =>
      'ລຸ້ນທົດລອງ — ສິນຄ້າ, ລາຄາ ແລະ ຄຳສັ່ງຊື້ທັງໝົດແມ່ນຂໍ້ມູນຕົວຢ່າງ.';

  @override
  String get collectionsEyebrow => 'ຄໍເລັກຊັນ';

  @override
  String get collectionsTitle => 'ຄໍເລັກຊັນຂອງພວກເຮົາ';

  @override
  String get collectionsSubtitle =>
      'ຕັ້ງແຕ່ສາຍສ້ອຍໃສ່ປະຈຳວັນຈົນເຖິງຊຸດແຕ່ງງານຄົບຊຸດ, ແຕ່ລະຊິ້ນເຮັດຢູ່ໂຮງງານຂອງພວກເຮົາ.';

  @override
  String get collectionsAll => 'ເຄື່ອງປະດັບທັງໝົດ';

  @override
  String piecesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ຊິ້ນ',
      one: '1 ຊິ້ນ',
      zero: 'ບໍ່ມີສິນຄ້າ',
    );
    return '$_temp0';
  }

  @override
  String get profileTitle => 'ໂປຣໄຟລ໌';

  @override
  String profileWelcome(String brand) {
    return 'ຍິນດີຕ້ອນຮັບສູ່ $brand';
  }

  @override
  String get profileSignInHint =>
      'ເຂົ້າສູ່ລະບົບດ້ວຍເບີໂທຂອງທ່ານເພື່ອເບິ່ງຄຳສັ່ງຊື້, ທີ່ຢູ່ ແລະ ສິນຄ້າທີ່ບັນທຶກໄວ້.';

  @override
  String get profileComingSoon => 'ການເຂົ້າສູ່ລະບົບຈະມາໃນການອັບເດດຄັ້ງຕໍ່ໄປ.';

  @override
  String get settingsTitle => 'ຕັ້ງຄ່າ';

  @override
  String get settingsAppearance => 'ຮູບລັກສະນະ';

  @override
  String get settingsDarkMode => 'ໂໝດມືດ';

  @override
  String get settingsDarkModeSub => 'ສະບາຍຕາໃນເວລາກາງຄືນ';

  @override
  String get settingsThemeLight => 'ສະຫວ່າງ';

  @override
  String get settingsThemeDark => 'ມືດ';

  @override
  String get settingsThemeSystem => 'ຕາມລະບົບ';

  @override
  String get settingsLanguage => 'ພາສາ';

  @override
  String get settingsLanguageSub => 'ພາສາທີ່ສະແດງ';

  @override
  String get settingsDeveloper => 'ນັກພັດທະນາ';

  @override
  String get settingsShopCode => 'ລະຫັດຮ້ານ';

  @override
  String settingsShopCodeSub(String key) {
    return 'ປັດຈຸບັນ: $key';
  }

  @override
  String get settingsAbout => 'ກ່ຽວກັບ';

  @override
  String settingsVersion(String version) {
    return 'ລຸ້ນ $version';
  }

  @override
  String settingsDataMode(String mode) {
    return 'ຂໍ້ມູນ: $mode';
  }

  @override
  String get shopCodeTitle => 'ລະຫັດຮ້ານ';

  @override
  String get shopCodeIntro =>
      'ປ້ອນລະຫັດຂອງຮ້ານທີ່ແອັບນີ້ຄວນເປັນຂອງ. ຍີ່ຫໍ້, ສີ ແລະ ລາຍການສິນຄ້າຈະໂຫຼດໃໝ່ທັນທີ.';

  @override
  String get shopCodeLabel => 'ລະຫັດຮ້ານ';

  @override
  String get shopCodeHint => 'ຕົວຢ່າງ: fino';

  @override
  String get shopCodeApply => 'ນຳໃຊ້';

  @override
  String get shopCodeReset => 'ຕັ້ງຄ່າກັບເປັນຄ່າເລີ່ມຕົ້ນ';

  @override
  String get shopCodeApplied => 'ນຳໃຊ້ລະຫັດຮ້ານແລ້ວ';

  @override
  String shopCodeCurrent(String key) {
    return 'ຮ້ານປັດຈຸບັນ: $key';
  }

  @override
  String get supportTitle => 'ການຊ່ວຍເຫຼືອ';

  @override
  String get supportPlaceholderTitle => 'ພວກເຮົາພ້ອມຊ່ວຍທ່ານ';

  @override
  String get supportPlaceholderBody =>
      'ການສົນທະນາສົດຈະມາໃນການອັບເດດຕໍ່ໄປ. ໃນຕອນນີ້ ຕິດຕໍ່ພວກເຮົາໄດ້ຜ່ານໜ້າຕິດຕໍ່.';

  @override
  String get actionCancel => 'ຍົກເລີກ';

  @override
  String get actionCopy => 'ສຳເນົາ';

  @override
  String get actionDelete => 'ລຶບ';

  @override
  String get actionEdit => 'ແກ້ໄຂ';

  @override
  String get actionRemove => 'ເອົາອອກ';

  @override
  String get actionSave => 'ບັນທຶກ';

  @override
  String get badgeNew => 'ໃໝ່';

  @override
  String get purity925 => 'ເງິນ 925';

  @override
  String get stoneNone => 'ບໍ່ມີພອຍ';

  @override
  String get reviewVerified => 'ຢືນຢັນແລ້ວ';

  @override
  String get tourSkip => 'ຂ້າມ';

  @override
  String get tourNext => 'ຕໍ່ໄປ';

  @override
  String get tourContinue => 'ເລີ່ມຕົ້ນ';

  @override
  String get tourEyebrow1 => 'ຍິນດີຕ້ອນຮັບ';

  @override
  String tourTitle1(String brand) {
    return 'ຍິນດີຕ້ອນຮັບສູ່ $brand';
  }

  @override
  String get tourBody1 =>
      'ເລືອກຊົມຄໍເລັກຊັນເຄື່ອງປະດັບຄຳ, ເພັດ ແລະ ພອຍ ທີ່ຄັດສັນ ແລະ ຜະລິດດ້ວຍມືໃນໂຮງງານຂອງພວກເຮົາ.';

  @override
  String get tourEyebrow2 => 'ຄົ້ນພົບ';

  @override
  String get tourTitle2 => 'ຊື້ເຄື່ອງຕາມແບບທີ່ທ່ານມັກ';

  @override
  String get tourBody2 =>
      'ກັ່ນຕອງຕາມໂລຫະ, ໂອກາດ ຫຼື ງົບປະມານ, ບັນທຶກລາຍການທີ່ມັກ ແລະ ກວດເບິ່ງລາຄາຄຳສົດກ່ອນຊື້.';

  @override
  String get tourEyebrow3 => 'ຄວາມໄວ້ວາງໃຈ';

  @override
  String get tourTitle3 => 'ຮັບຮອງຄຸນນະພາບສະເໝີ';

  @override
  String get tourBody3 =>
      'ທຸກຊິ້ນມາພ້ອມໃບຮັບຮອງ, ການຈັດສົ່ງທີ່ມີປະກັນ ແລະ ສາມາດສົ່ງຄືນໄດ້ພາຍໃນ 15 ວັນ.';

  @override
  String get tourEyebrow4 => 'ພ້ອມແລ້ວ';

  @override
  String get tourTitle4 => 'ພ້ອມເມື່ອທ່ານພ້ອມ';

  @override
  String get tourBody4 =>
      'ເຂົ້າສູ່ລະບົບດ້ວຍເບີໂທເພື່ອຕິດຕາມຄຳສັ່ງຊື້ ຫຼື ເລືອກຊົມໃນຖານະແຂກ.';

  @override
  String get welcomeEyebrow => 'ຄວາມງາມທີ່ບໍ່ມີວັນລ້າສະໄໝ';

  @override
  String get welcomeTeaser => 'ຊິ້ນເດັ່ນ';

  @override
  String get authSignInWithPhone => 'ເຂົ້າສູ່ລະບົບດ້ວຍເບີໂທ';

  @override
  String get authContinueAsGuest => 'ສືບຕໍ່ໃນຖານະແຂກ';

  @override
  String get authPhoneTitle => 'ຍິນດີຕ້ອນຮັບກັບມາ';

  @override
  String get authPhoneSubtitle =>
      'ໃສ່ເບີມືຖືຂອງທ່ານ ແລ້ວພວກເຮົາຈະສົ່ງລະຫັດໄປໃຫ້.';

  @override
  String get authPhoneLabel => 'ເບີມືຖື';

  @override
  String get authPhoneInvalid => 'ກະລຸນາໃສ່ເບີມືຖືທີ່ຖືກຕ້ອງ.';

  @override
  String get authSendCode => 'ສົ່ງລະຫັດ';

  @override
  String get authOr => 'ຫຼື';

  @override
  String get authTerms =>
      'ການສືບຕໍ່ໝາຍຄວາມວ່າທ່ານຍອມຮັບເງື່ອນໄຂ ແລະ ນະໂຍບາຍຄວາມເປັນສ່ວນຕົວຂອງພວກເຮົາ.';

  @override
  String get authDemoHint => 'ສະບັບທົດລອງ — ບໍ່ມີການສົ່ງ SMS ແທ້.';

  @override
  String get authOtpTitle => 'ໃສ່ລະຫັດ';

  @override
  String authOtpSubtitle(String phone) {
    return 'ພວກເຮົາໄດ້ສົ່ງລະຫັດ 6 ຕົວເລກໄປທີ່ $phone.';
  }

  @override
  String get authOtpDemoHint => 'ທົດລອງ: ຕົວເລກ 6 ຕົວໃດກໍໃຊ້ໄດ້.';

  @override
  String get authOtpWrong => 'ລະຫັດບໍ່ຖືກຕ້ອງ. ກະລຸນາລອງໃໝ່.';

  @override
  String get authVerify => 'ຢືນຢັນ';

  @override
  String get authResend => 'ສົ່ງລະຫັດອີກຄັ້ງ';

  @override
  String authResendIn(int seconds) {
    return 'ສົ່ງອີກຄັ້ງໃນ $seconds ວິ';
  }

  @override
  String get authCodeResent => 'ລະຫັດໃໝ່ກຳລັງສົ່ງໄປ.';

  @override
  String get authChangeNumber => 'ປ່ຽນເບີ';

  @override
  String authWelcomeBack(String name) {
    return 'ຍິນດີຕ້ອນຮັບກັບມາ, $name';
  }

  @override
  String authWelcomeNew(String name) {
    return 'ຍິນດີຕ້ອນຮັບ, $name';
  }

  @override
  String get authProfileTitle => 'ບອກພວກເຮົາກ່ຽວກັບທ່ານ';

  @override
  String get authProfileSubtitle =>
      'ເພື່ອໃຫ້ພວກເຮົາເອີ້ນຊື່ທ່ານໄດ້ຖືກຕ້ອງ ແລະ ສົ່ງຂ່າວຄຳສັ່ງຊື້.';

  @override
  String get authNameLabel => 'ຊື່ຂອງທ່ານ';

  @override
  String get authNameRequired => 'ກະລຸນາບອກຊື່ຂອງທ່ານ.';

  @override
  String get authEmailLabel => 'ອີເມວ';

  @override
  String get authEmailInvalid => 'ອີເມວນີ້ບໍ່ຖືກຕ້ອງ.';

  @override
  String get authOptional => 'ບໍ່ບັງຄັບ';

  @override
  String get authFinish => 'ສຳເລັດ';

  @override
  String get authPromptTitle => 'ເຂົ້າສູ່ລະບົບເພື່ອສືບຕໍ່';

  @override
  String get authPromptBody =>
      'ເຂົ້າສູ່ລະບົບດ້ວຍເບີໂທເພື່ອເບິ່ງຄຳສັ່ງຊື້, ທີ່ຢູ່ ແລະ ຊິ້ນທີ່ບັນທຶກໄວ້.';

  @override
  String get homeFeaturedEyebrow => 'ຄັດສັນ';

  @override
  String get homeFeaturedTitle => 'ຊິ້ນເດັ່ນ';

  @override
  String get homeNewEyebrow => 'ມາໃໝ່';

  @override
  String get homeNewTitle => 'ສິນຄ້າມາໃໝ່';

  @override
  String get homeNewSubtitle => 'ສົດໃໝ່ຈາກໂຮງງານອາທິດນີ້';

  @override
  String get homeTrendingEyebrow => 'ນິຍົມຕອນນີ້';

  @override
  String get homeTrendingTitle => 'ກຳລັງມາແຮງ';

  @override
  String get homeBestEyebrow => 'ເປັນທີ່ຮັກ';

  @override
  String get homeBestTitle => 'ຂາຍດີທີ່ສຸດ';

  @override
  String get homeReviewsEyebrow => 'ຈາກລູກຄ້າຂອງພວກເຮົາ';

  @override
  String get homeReviewsTitle => 'ຄຳຊົມເຊີຍ';

  @override
  String get homePromiseEyebrow => 'ຄຳໝັ້ນສັນຍາຂອງພວກເຮົາ';

  @override
  String homePromiseTitle(String brand) {
    return 'ຄຳໝັ້ນສັນຍາຂອງ $brand';
  }

  @override
  String get promiseCertified => 'ຮັບຮອງແລ້ວ';

  @override
  String get promiseCertifiedSub => 'ຄວາມບໍລິສຸດມີຕາປະທັບ';

  @override
  String get promiseSecure => 'ຊຳລະເງິນປອດໄພ';

  @override
  String get promiseSecureSub => 'ການຊຳລະທີ່ເຂົ້າລະຫັດ';

  @override
  String get promiseReturns => 'ສົ່ງຄືນງ່າຍ';

  @override
  String get promiseReturnsSub => '15 ວັນ ບໍ່ມີເງື່ອນໄຂ';

  @override
  String get promisePackaging => 'ຫຸ້ມຫໍ່ຂອງຂວັນ';

  @override
  String get promisePackagingSub => 'ຟຣີ';

  @override
  String get searchTitle => 'ຄົ້ນຫາ';

  @override
  String get searchHint => 'ຄົ້ນຫາ ແຫວນ, ຄຳ, 22K…';

  @override
  String get searchClear => 'ລ້າງ';

  @override
  String get searchRecent => 'ຫຼ້າສຸດ';

  @override
  String get searchSuggested => 'ແນະນຳ';

  @override
  String get searchBrowse => 'ເລືອກຊົມ';

  @override
  String searchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ຜົນການຄົ້ນຫາ',
      zero: 'ບໍ່ພົບຜົນ',
    );
    return '$_temp0';
  }

  @override
  String searchNoResultsTitle(String term) {
    return 'ບໍ່ພົບ “$term”';
  }

  @override
  String get searchNoResultsBody => 'ລອງຄຳອື່ນ, ໂລຫະ ຫຼື ຄວາມບໍລິສຸດ.';

  @override
  String get sortFeatured => 'ແນະນຳ';

  @override
  String get sortNewest => 'ໃໝ່ສຸດ';

  @override
  String get sortPriceAsc => 'ລາຄາ ↑';

  @override
  String get sortPriceDesc => 'ລາຄາ ↓';

  @override
  String get sortRating => 'ຄະແນນ';

  @override
  String get filterButton => 'ກັ່ນຕອງ';

  @override
  String get filterTitle => 'ກັ່ນຕອງ';

  @override
  String get filterClearAll => 'ລ້າງທັງໝົດ';

  @override
  String get filterPrice => 'ລາຄາ';

  @override
  String get filterMetal => 'ໂລຫະ';

  @override
  String get filterPurity => 'ຄວາມບໍລິສຸດ';

  @override
  String get filterStone => 'ພອຍ';

  @override
  String get filterRating => 'ຄະແນນ';

  @override
  String filterRatingUp(String rating) {
    return '$rating ຂຶ້ນໄປ';
  }

  @override
  String get filterInStock => 'ສະເພາະທີ່ມີໃນສາງ';

  @override
  String get filterInStockSub => 'ເຊື່ອງຊິ້ນທີ່ຂາຍໝົດແລ້ວ';

  @override
  String get filterApply => 'ນຳໃຊ້';

  @override
  String filterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ສະແດງ $count ຊິ້ນ',
      zero: 'ບໍ່ມີທີ່ກົງກັນ',
    );
    return '$_temp0';
  }

  @override
  String get categoryEmptyTitle => 'ບໍ່ມີຊິ້ນທີ່ກົງກັນ';

  @override
  String get categoryEmptyBody => 'ລອງຜ່ອນຕົວກັ່ນຕອງລົງ ແລ້ວລອງໃໝ່.';

  @override
  String get productSoldOut => 'ຂາຍໝົດແລ້ວ';

  @override
  String get productInStock => 'ມີໃນສາງ';

  @override
  String get productNotFound => 'ຊິ້ນນີ້ບໍ່ມີໃຫ້ບໍລິການແລ້ວ.';

  @override
  String get productQuantity => 'ຈຳນວນ';

  @override
  String productDeliveryDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'ຈັດສົ່ງພາຍໃນ $days ວັນ',
    );
    return '$_temp0';
  }

  @override
  String get productSpecifications => 'ລາຍລະອຽດ';

  @override
  String productReviews(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ຣີວິວ',
      zero: 'ຣີວິວ',
    );
    return '$_temp0';
  }

  @override
  String get productNoReviews => 'ຍັງບໍ່ມີຣີວິວ — ເປັນຄົນທຳອິດ.';

  @override
  String get productRelatedEyebrow => 'ທ່ານອາດຈະມັກ';

  @override
  String get productRelatedTitle => 'ຊິ້ນທີ່ກ່ຽວຂ້ອງ';

  @override
  String get productTotal => 'ລວມ';

  @override
  String get productBuyNow => 'ຊື້ຕອນນີ້';

  @override
  String get productShare => 'ແບ່ງປັນ';

  @override
  String get productLinkCopied => 'ສຳເນົາລິ້ງແລ້ວ';

  @override
  String get specMetal => 'ໂລຫະ';

  @override
  String get specPurity => 'ຄວາມບໍລິສຸດ';

  @override
  String get specWeight => 'ນ້ຳໜັກ';

  @override
  String specGrams(String grams) {
    return '$grams ກຣາມ';
  }

  @override
  String get specStone => 'ພອຍ';

  @override
  String get specCollection => 'ຄໍເລັກຊັນ';

  @override
  String get specSku => 'ລະຫັດສິນຄ້າ';

  @override
  String get specHallmark => 'ຕາປະທັບ';

  @override
  String get sizeGuideTitle => 'ຄູ່ມືຂະໜາດ';

  @override
  String get sizeGuideHeading => 'ຊອກຫາຂະໜາດຂອງທ່ານ';

  @override
  String get sizeGuideSub =>
      'ວັດແທກຢູ່ເຮືອນບໍ່ຮອດນາທີ ຫຼື ມາທີ່ຮ້ານເພື່ອລອງຟຣີ.';

  @override
  String get sizeKindRing => 'ແຫວນ';

  @override
  String get sizeKindBangle => 'ກຳໄລ';

  @override
  String get sizeKindLength => 'ຄວາມຍາວ';

  @override
  String get sizeLabelRing => 'ຂະໜາດແຫວນ';

  @override
  String get sizeLabelBangle => 'ຂະໜາດກຳໄລ';

  @override
  String get sizeLabelLength => 'ຄວາມຍາວ';

  @override
  String get sizeHowToMeasure => 'ວິທີວັດແທກ';

  @override
  String get sizeChart => 'ຕາຕະລາງຂະໜາດ';

  @override
  String get sizeUs => 'US';

  @override
  String get sizeUk => 'UK';

  @override
  String get sizeSize => 'ຂະໜາດ';

  @override
  String get sizeDiameterMm => 'ເສັ້ນຜ່າກາງ ມມ';

  @override
  String get sizeDiameterIn => 'ເສັ້ນຜ່າກາງ ນິ້ວ';

  @override
  String get sizeCircumferenceMm => 'ຮອບ ມມ';

  @override
  String get sizeFits => 'ພໍດີກັບ';

  @override
  String get sizeLengthCm => 'ຊມ';

  @override
  String get sizeSits => 'ຢູ່ຕຳແໜ່ງ';

  @override
  String get sizeRingStep1 => 'ພັນແຜ່ນເຈ້ຍອ້ອມໂຄນນິ້ວມື ໃຫ້ພໍດີແຕ່ບໍ່ແໜ້ນ.';

  @override
  String get sizeRingStep2 =>
      'ໝາຍຈຸດທີ່ເຈ້ຍທັບກັນ ແລ້ວວັດຄວາມຍາວເປັນມິນລີແມັດ — ນັ້ນຄືເສັ້ນຮອບຂອງທ່ານ.';

  @override
  String get sizeRingStep3 =>
      'ຊອກຫາເສັ້ນຮອບທີ່ໃກ້ຄຽງທີ່ສຸດໃນຕາຕະລາງລຸ່ມນີ້ເພື່ອຮູ້ຂະໜາດ.';

  @override
  String get sizeBangleStep1 =>
      'ກົດໂປ້ມືເຂົ້າຝ່າມື ແລ້ວວັດອ້ອມສ່ວນທີ່ກວ້າງທີ່ສຸດຂອງມື.';

  @override
  String get sizeBangleStep2 => 'ທຽບຄ່າທີ່ວັດໄດ້ກັບຖັນເສັ້ນຮອບລຸ່ມນີ້.';

  @override
  String get sizeTip =>
      'ວັດແທກຕອນທ້າຍວັນ ເມື່ອນິ້ວມືໃຫຍ່ທີ່ສຸດ ແລະ ຫຼີກລ່ຽງການວັດຕອນອາກາດເຢັນ.';

  @override
  String get sizeRequired => 'ກະລຸນາເລືອກຂະໜາດກ່ອນ.';

  @override
  String get sizeResizeNote => 'ປັບຂະໜາດຟຣີ 1 ຄັ້ງ ພາຍໃນ 60 ວັນຫຼັງຊື້.';

  @override
  String get sizeFitsXs => 'ນ້ອຍພິເສດ';

  @override
  String get sizeFitsS => 'ນ້ອຍ';

  @override
  String get sizeFitsM => 'ກາງ';

  @override
  String get sizeFitsL => 'ໃຫຍ່';

  @override
  String get sizeFitsXl => 'ໃຫຍ່ພິເສດ';

  @override
  String get sizeSitsChoker => 'ໂຊກເກີ — ຢູ່ໂຄນຄໍ';

  @override
  String get sizeSitsPrincess => 'ພຣິນເຊສ — ຢູ່ລຸ່ມກະດູກໄຫຼ່';

  @override
  String get sizeSitsMatinee => 'ມາຕິເນ — ຢູ່ໜ້າເອິກ';

  @override
  String get sizeSitsMatineeLow => 'ມາຕິເນ — ໜ້າເອິກຕອນລຸ່ມ';

  @override
  String get sizeSitsOpera => 'ໂອເປຣາ — ຢູ່ລຸ່ມໜ້າເອິກ';

  @override
  String get lookbookTitle => 'ລຸກບຸກ';

  @override
  String get lookbookHide => 'ເຊື່ອງ';

  @override
  String lookbookHidden(String name) {
    return 'ເຊື່ອງ $name ໄວ້ກ່ອນ';
  }

  @override
  String get lookbookEmptyTitle => 'ເຊື່ອງທັງໝົດແລ້ວ';

  @override
  String get lookbookEmptyBody => 'ນຳຊິ້ນຕ່າງໆກັບມາເພື່ອເລືອກຊົມຕໍ່.';

  @override
  String get lookbookRestore => 'ສະແດງທັງໝົດ';

  @override
  String get wishlistTitle => 'ລາຍການທີ່ມັກ';

  @override
  String get wishlistAdded => 'ບັນທຶກໃສ່ລາຍການທີ່ມັກແລ້ວ';

  @override
  String get wishlistRemoved => 'ເອົາອອກຈາກລາຍການທີ່ມັກແລ້ວ';

  @override
  String wishlistCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ຊິ້ນທີ່ບັນທຶກ',
    );
    return '$_temp0';
  }

  @override
  String get wishlistMoveAll => 'ຍ້າຍທັງໝົດໃສ່ກະເປົາ';

  @override
  String get wishlistMovedAll => 'ຍ້າຍໃສ່ກະເປົາແລ້ວ';

  @override
  String wishlistMovedSome(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ຍ້າຍ $count ຊິ້ນແລ້ວ; ເລືອກຂະໜາດສຳລັບທີ່ເຫຼືອ',
      zero: 'ຊິ້ນທີ່ມີຂະໜາດຕ້ອງເລືອກຂະໜາດກ່ອນ',
    );
    return '$_temp0';
  }

  @override
  String get wishlistEmptyTitle => 'ຍັງບໍ່ມີທີ່ບັນທຶກ';

  @override
  String get wishlistEmptyBody =>
      'ແຕະຮູບຫົວໃຈໃສ່ຊິ້ນໃດກໍໄດ້ເພື່ອເກັບໄວ້ທີ່ນີ້.';

  @override
  String get cartTitle => 'ກະເປົາຂອງທ່ານ';

  @override
  String get cartAddToBag => 'ໃສ່ກະເປົາ';

  @override
  String get cartAdded => 'ເພີ່ມແລ້ວ';

  @override
  String cartAddedToast(String name) {
    return 'ເພີ່ມ $name ໃສ່ກະເປົາແລ້ວ';
  }

  @override
  String get cartEmptyTitle => 'ກະເປົາຂອງທ່ານຫວ່າງເປົ່າ';

  @override
  String get cartEmptyBody => 'ຊິ້ນທີ່ທ່ານເພີ່ມຈະລໍຖ້າທ່ານຢູ່ທີ່ນີ້.';

  @override
  String cartFreeDeliveryHint(String amount) {
    return 'ຊື້ເພີ່ມອີກ $amount ເພື່ອຈັດສົ່ງຟຣີ';
  }

  @override
  String get cartFreeDeliveryUnlocked => 'ທ່ານໄດ້ຮັບການຈັດສົ່ງຟຣີ';

  @override
  String cartSize(String size) {
    return 'ຂະໜາດ $size';
  }

  @override
  String cartQty(int count) {
    return 'ຈຳນວນ $count';
  }

  @override
  String get cartRemove => 'ເອົາອອກ';

  @override
  String get cartMoveToWishlist => 'ຍ້າຍໄປລາຍການທີ່ມັກ';

  @override
  String get cartMovedToWishlist => 'ຍ້າຍໄປລາຍການທີ່ມັກແລ້ວ';

  @override
  String get cartSubtotal => 'ລວມຍ່ອຍ';

  @override
  String get cartSavings => 'ປະຢັດ';

  @override
  String get cartShipping => 'ຄ່າຈັດສົ່ງ';

  @override
  String get cartFree => 'ຟຣີ';

  @override
  String get cartTax => 'ພາສີ';

  @override
  String get cartTotal => 'ລວມທັງໝົດ';

  @override
  String get cartCheckout => 'ຊຳລະເງິນ';

  @override
  String get checkoutTitle => 'ຊຳລະເງິນ';

  @override
  String get checkoutStepAddress => 'ທີ່ຢູ່';

  @override
  String get checkoutStepPayment => 'ການຊຳລະ';

  @override
  String get checkoutStepReview => 'ກວດສອບ';

  @override
  String get checkoutAddressTitle => 'ຈັດສົ່ງໄປໃສ?';

  @override
  String get checkoutAddressSub => 'ເລືອກທີ່ຢູ່ທີ່ບັນທຶກໄວ້ ຫຼື ໃສ່ໃໝ່.';

  @override
  String get checkoutAddressIncomplete =>
      'ກະລຸນາໃສ່ຊື່, ເບີໂທ, ທີ່ຢູ່ ແລະ ເມືອງ.';

  @override
  String get checkoutContinuePayment => 'ໄປຕໍ່ການຊຳລະ';

  @override
  String get checkoutPaymentTitle => 'ທ່ານຕ້ອງການຊຳລະແບບໃດ?';

  @override
  String get checkoutPaymentSub => 'ບໍ່ມີການເກັບເງິນຈິງໃນສະບັບທົດລອງນີ້.';

  @override
  String get checkoutContinueReview => 'ກວດສອບຄຳສັ່ງຊື້';

  @override
  String get checkoutSummary => 'ສະຫຼຸບ';

  @override
  String get checkoutDemoNote =>
      'ຊຳລະທົດລອງ — ບໍ່ມີການເກັບຂໍ້ມູນບັດ ແລະ ບໍ່ມີການຫັກເງິນ.';

  @override
  String get checkoutReviewTitle => 'ໃກ້ສຳເລັດແລ້ວ';

  @override
  String get checkoutReviewSub => 'ກວດເບິ່ງທຸກຢ່າງ ແລ້ວສັ່ງຊື້.';

  @override
  String get checkoutDeliverTo => 'ຈັດສົ່ງໄປທີ່';

  @override
  String get checkoutPayWith => 'ຊຳລະດ້ວຍ';

  @override
  String checkoutItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ລາຍການ',
    );
    return '$_temp0';
  }

  @override
  String checkoutPlaceOrder(String total) {
    return 'ສັ່ງຊື້ · $total';
  }

  @override
  String get checkoutPlacing => 'ກຳລັງສັ່ງຊື້';

  @override
  String get checkoutPlacingSub => 'ລໍຖ້າບຶດໜຶ່ງ…';

  @override
  String get checkoutConfirmedTitle => 'ຢືນຢັນຄຳສັ່ງຊື້ແລ້ວ';

  @override
  String get checkoutConfirmedBody =>
      'ຂອບໃຈ. ພວກເຮົາຈະຢືນຢັນໃນໄວໆນີ້ ແລະ ແຈ້ງໃຫ້ທ່ານຮູ້ທຸກຂັ້ນຕອນ.';

  @override
  String get checkoutTrackOrder => 'ຕິດຕາມຄຳສັ່ງຊື້';

  @override
  String get paymentCard => 'ບັດ';

  @override
  String get paymentCardSub => 'Visa, Mastercard';

  @override
  String get paymentWallet => 'ກະເປົາເງິນ';

  @override
  String get paymentWalletSub => 'BCEL One ແລະ ກະເປົາເງິນອື່ນໆ';

  @override
  String get paymentCod => 'ຈ່າຍເງິນປາຍທາງ';

  @override
  String get paymentCodSub => 'ຈ່າຍເມື່ອສິນຄ້າມາຮອດ';

  @override
  String get ordersTitle => 'ຄຳສັ່ງຊື້ຂອງຂ້ອຍ';

  @override
  String get ordersSignInBody =>
      'ເຂົ້າສູ່ລະບົບດ້ວຍເບີໂທເພື່ອເບິ່ງ ແລະ ຕິດຕາມຄຳສັ່ງຊື້.';

  @override
  String get ordersActive => 'ກຳລັງດຳເນີນ';

  @override
  String get ordersAll => 'ທັງໝົດ';

  @override
  String get ordersEmptyTitle => 'ຍັງບໍ່ມີຄຳສັ່ງຊື້';

  @override
  String get ordersEmptyActiveTitle => 'ບໍ່ມີທີ່ກຳລັງຈັດສົ່ງ';

  @override
  String get ordersEmptyBody =>
      'ເມື່ອທ່ານສັ່ງຊື້ ມັນຈະປາກົດຢູ່ນີ້ພ້ອມການຕິດຕາມສົດ.';

  @override
  String ordersMoreItems(String name, int count) {
    return '$name +$count ອື່ນໆ';
  }

  @override
  String get ordersViewDetail => 'ເບິ່ງລາຍລະອຽດ';

  @override
  String get ordersInvoice => 'ໃບແຈ້ງໜີ້';

  @override
  String get ordersInvoiceDemo => 'ໃບແຈ້ງໜີ້ຈະສົ່ງທາງອີເມວໃນແອັບຈິງ.';

  @override
  String get orderStatusPlaced => 'ສັ່ງແລ້ວ';

  @override
  String get orderStatusConfirmed => 'ຢືນຢັນແລ້ວ';

  @override
  String get orderStatusPacked => 'ຫຸ້ມຫໍ່ແລ້ວ';

  @override
  String get orderStatusShipped => 'ຈັດສົ່ງແລ້ວ';

  @override
  String get orderStatusDelivered => 'ສົ່ງເຖິງແລ້ວ';

  @override
  String get orderStatusCancelled => 'ຍົກເລີກແລ້ວ';

  @override
  String get orderStageDescPlaced => 'ພວກເຮົາໄດ້ຮັບຄຳສັ່ງຊື້ຂອງທ່ານ';

  @override
  String get orderStageDescConfirmed => 'ຢືນຢັນການຊຳລະ ແລະ ສິນຄ້າແລ້ວ';

  @override
  String get orderStageDescPacked => 'ຫຸ້ມຫໍ່ ແລະ ພ້ອມສົ່ງ';

  @override
  String get orderStageDescShipped => 'ຢູ່ກັບບໍລິສັດຂົນສົ່ງ';

  @override
  String get orderStageDescDelivered => 'ຂໍໃຫ້ມີຄວາມສຸກກັບຊິ້ນຂອງທ່ານ';

  @override
  String get orderCancelledNote =>
      'ຄຳສັ່ງຊື້ນີ້ຖືກຍົກເລີກ. ເງິນທີ່ຊຳລະໄດ້ຄືນແລ້ວ.';

  @override
  String get orderCourier => 'ຂົນສົ່ງ';

  @override
  String get orderTracking => 'ເລກຕິດຕາມ';

  @override
  String get orderTrackingCopied => 'ສຳເນົາເລກຕິດຕາມແລ້ວ';

  @override
  String get orderDeliverTo => 'ຈັດສົ່ງໄປທີ່';

  @override
  String get orderDetailTitle => 'ຄຳສັ່ງຊື້';

  @override
  String get orderNotFound => 'ບໍ່ພົບຄຳສັ່ງຊື້ນັ້ນ.';

  @override
  String get orderProgress => 'ຄວາມຄືບໜ້າ';

  @override
  String get orderReorder => 'ສັ່ງຊື້ອີກຄັ້ງ';

  @override
  String get orderReorderAll => 'ທຸກຢ່າງກັບມາຢູ່ໃນກະເປົາແລ້ວ';

  @override
  String orderReorderPartial(int restored, int total) {
    return 'ເພີ່ມ $restored ຈາກ $total ຊິ້ນ; ທີ່ເຫຼືອຂາຍໝົດແລ້ວ';
  }

  @override
  String get orderReorderNone => 'ຊິ້ນເຫຼົ່ານັ້ນຂາຍໝົດແລ້ວຕອນນີ້';

  @override
  String get orderCallCourier => 'ໂທຫາຂົນສົ່ງ';

  @override
  String orderCourierNumberCopied(String phone) {
    return 'ສຳເນົາ $phone ແລ້ວ';
  }

  @override
  String get addressesTitle => 'ທີ່ຢູ່';

  @override
  String get addressesEmptyTitle => 'ຍັງບໍ່ມີທີ່ຢູ່';

  @override
  String get addressesEmptyBody => 'ເພີ່ມທີ່ຢູ່ເພື່ອໃຫ້ຊຳລະໄວຂຶ້ນ.';

  @override
  String get addressAdd => 'ເພີ່ມທີ່ຢູ່';

  @override
  String get addressEdit => 'ແກ້ໄຂທີ່ຢູ່';

  @override
  String get addressLabel => 'ປ້າຍ';

  @override
  String get addressLabelHome => 'ບ້ານ';

  @override
  String get addressLabelWork => 'ບ່ອນເຮັດວຽກ';

  @override
  String get addressLabelOther => 'ອື່ນໆ';

  @override
  String get addressName => 'ຊື່ເຕັມ';

  @override
  String get addressPhone => 'ເບີໂທ';

  @override
  String get addressLine1 => 'ທີ່ຢູ່';

  @override
  String get addressCity => 'ເມືອງ';

  @override
  String get addressPostcode => 'ລະຫັດໄປສະນີ';

  @override
  String get addressMakeDefault => 'ຕັ້ງເປັນຄ່າເລີ່ມຕົ້ນ';

  @override
  String get addressDefault => 'ຄ່າເລີ່ມຕົ້ນ';

  @override
  String get addressSetDefault => 'ຕັ້ງເປັນຄ່າເລີ່ມຕົ້ນ';

  @override
  String get addressDefaultSet => 'ອັບເດດທີ່ຢູ່ຫຼັກແລ້ວ';

  @override
  String get addressDeleteTitle => 'ລຶບທີ່ຢູ່?';

  @override
  String get addressDeleteBody => 'ບໍ່ສາມາດກູ້ຄືນໄດ້.';

  @override
  String get addressDeleted => 'ລຶບທີ່ຢູ່ແລ້ວ';

  @override
  String get paymentMethodsTitle => 'ວິທີຊຳລະເງິນ';

  @override
  String get paymentEmptyTitle => 'ບໍ່ມີວິທີຊຳລະເງິນ';

  @override
  String get paymentAdd => 'ເພີ່ມວິທີຊຳລະເງິນ';

  @override
  String get paymentAddDemo => 'ການເພີ່ມບັດຖືກປິດໃນສະບັບທົດລອງນີ້.';

  @override
  String get paymentDefaultSet => 'ອັບເດດວິທີຊຳລະຫຼັກແລ້ວ';

  @override
  String get paymentRemoved => 'ເອົາວິທີຊຳລະອອກແລ້ວ';

  @override
  String get paymentSecureNote =>
      'ນີ້ແມ່ນສະບັບທົດລອງ. ບໍ່ມີການເກັບຂໍ້ມູນບັດ ແລະ ບໍ່ມີການຊຳລະຈິງ.';

  @override
  String get accountStatOrders => 'ຄຳສັ່ງຊື້';

  @override
  String get accountStatWishlist => 'ທີ່ມັກ';

  @override
  String get accountStatAddresses => 'ທີ່ຢູ່';

  @override
  String get accountRecentOrders => 'ຄຳສັ່ງຊື້ຂອງຂ້ອຍ';

  @override
  String accountAddressCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ທີ່ຢູ່',
      zero: 'ບໍ່ມີທີ່ຢູ່',
    );
    return '$_temp0';
  }

  @override
  String accountMemberSince(String date) {
    return 'ເປັນສະມາຊິກຕັ້ງແຕ່ $date';
  }

  @override
  String get accountEditTitle => 'ແກ້ໄຂໂປຣໄຟລ໌';

  @override
  String get accountPhoneLocked =>
      'ເບີຂອງທ່ານຢືນຢັນແລ້ວ ແລະ ບໍ່ສາມາດປ່ຽນໄດ້ຢູ່ນີ້.';

  @override
  String get accountSaved => 'ບັນທຶກໂປຣໄຟລ໌ແລ້ວ';

  @override
  String get accountSignOutTitle => 'ອອກຈາກລະບົບ?';

  @override
  String get accountSignOutBody => 'ກະເປົາຂອງທ່ານໃນອຸປະກອນນີ້ຈະຖືກລ້າງ.';

  @override
  String metalListing(String metal) {
    return 'ເຄື່ອງປະດັບ$metal';
  }

  @override
  String get menuAllJewellery => 'ເຄື່ອງປະດັບທັງໝົດ';

  @override
  String get menuGold => 'ຄຳ';

  @override
  String get menuDiamond => 'ເພັດ';

  @override
  String get menuSilver => 'ເງິນ';

  @override
  String get menuPlatinum => 'ແພລັດຕິນຳ';

  @override
  String get menuCoinsBars => 'ຫຼຽນ ແລະ ຄຳແທ່ງ';

  @override
  String get menuSolitaire => 'ໂຊລິແທ';

  @override
  String get menuCollections => 'ຄໍເລັກຊັນ';

  @override
  String get menuGiftStore => 'ຮ້ານຂອງຂວັນ';

  @override
  String get menuOffers => 'ໂປຣໂມຊັນ';

  @override
  String get drawerBrowse => 'ເລືອກຊົມ';

  @override
  String get drawerNotifications => 'ການແຈ້ງເຕືອນ';

  @override
  String get drawerStores => 'ຮ້ານຂອງພວກເຮົາ';

  @override
  String homeRateTicker(String purity) {
    return 'ຄຳ $purity / 1 g';
  }

  @override
  String get homeSearchHint => 'ຄົ້ນຫາສາຍຄໍ, ແຫວນ, 22K…';

  @override
  String get homeBrandsTitle => 'ແບຣນຂອງພວກເຮົາ';

  @override
  String get homeCuratedEyebrow => 'ຄໍເລັກຊັນຫຼ້າສຸດ';

  @override
  String get homeCuratedTitle => 'ຄັດເລືອກສຳລັບທ່ານ';

  @override
  String get homeCuratedSubtitle => 'ເລືອກຈາກຄໍເລັກຊັນທີ່ທ່ານມັກ';

  @override
  String get homeStoresTitle => 'ມາຢ້ຽມຢາມພວກເຮົາ';

  @override
  String get homeStoresSubtitle => 'ລອງໃສ່ໄດ້ທີ່ຮ້ານໃດກໍໄດ້ຂອງພວກເຮົາ';

  @override
  String get homeAboutEyebrow => 'ກ່ຽວກັບພວກເຮົາ';

  @override
  String homeAboutTitle(String brand) {
    return 'ເລື່ອງລາວຂອງ $brand';
  }

  @override
  String get homeAboutCta => 'ເລື່ອງລາວຂອງພວກເຮົາ';

  @override
  String get actionViewCollection => 'ເບິ່ງຄໍເລັກຊັນ';

  @override
  String get actionDone => 'ສຳເລັດ';

  @override
  String get storeFlagship => 'ຮ້ານຫຼັກ';

  @override
  String get storeDirections => 'ເສັ້ນທາງ';

  @override
  String get storeServices => 'ບໍລິການ';

  @override
  String get storesTitle => 'ຮ້ານຂອງພວກເຮົາ';

  @override
  String get storesEyebrow => 'ຄົ້ນຫາຮ້ານ';

  @override
  String get storesHeadline => 'ຢ້ຽມຊົມຮ້ານ';

  @override
  String get storesAllCities => 'ທຸກເມືອງ';

  @override
  String get settingsTheme => 'ທີມສີ';

  @override
  String get settingsThemeSub => 'ເລືອກສີຂອງຮ້ານທ່ານ';

  @override
  String get settingsThemeApplied => 'ນຳໃຊ້ທີມສີແລ້ວ';

  @override
  String get settingsShopping => 'ການຊື້ເຄື່ອງ';

  @override
  String get settingsTrackOrder => 'ຕິດຕາມຄຳສັ່ງຊື້';

  @override
  String get settingsSizeGuide => 'ຄູ່ມືຂະໜາດ';

  @override
  String get settingsPolicies => 'ນະໂຍບາຍ';

  @override
  String get settingsSupport => 'ການຊ່ວຍເຫຼືອ';

  @override
  String get settingsFeedback => 'ສົ່ງຄຳຕິຊົມ';

  @override
  String get settingsRateUs => 'ໃຫ້ຄະແນນພວກເຮົາ';

  @override
  String get settingsShare => 'ແບ່ງປັນແອັບ';

  @override
  String settingsShareText(String brand, String url) {
    return 'ຊື້ເຄື່ອງ $brand ໃນໂທລະສັບຂອງທ່ານ: $url';
  }

  @override
  String get settingsShareFailed => 'ອຸປະກອນນີ້ບໍ່ສາມາດແບ່ງປັນໄດ້';

  @override
  String get settingsTour => 'ເບິ່ງການແນະນຳ';

  @override
  String get themeRuby => 'ແດງທັບທິມ';

  @override
  String get themeRubySub => 'ສີແດງເອກະລັກ';

  @override
  String get themeBurgundy => 'ແດງເບີກັນດີ';

  @override
  String get themeBurgundySub => 'ເຂັ້ມ ແລະ ອົບອຸ່ນ';

  @override
  String get themeEmerald => 'ມໍລະກົດ';

  @override
  String get themeEmeraldSub => 'ຂຽວກັບຄຳ';

  @override
  String get themeSapphire => 'ໄພລິນ';

  @override
  String get themeSapphireSub => 'ຟ້າເຢັນ, ແຕ້ມເງິນ';

  @override
  String get themeRose => 'ກຸຫຼາບ';

  @override
  String get themeRoseSub => 'ບົວອ່ອນ, ແຕ້ມທອງແດງ';

  @override
  String get themeBlack => 'ດຳຄລາສສິກ';

  @override
  String get themeBlackSub => 'ດຳກັບຄຳ';

  @override
  String policyUpdated(String date) {
    return 'ອັບເດດ $date';
  }

  @override
  String get policyFaq => 'ຄຳຖາມທີ່ພົບເລື້ອຍ';

  @override
  String get goldEyebrow => 'ລາຄາສົດ';

  @override
  String get goldTitle => 'ລາຄາຄຳມື້ນີ້';

  @override
  String goldUpdated(String time) {
    return 'ອັບເດດ $time';
  }

  @override
  String get goldColPurity => 'ຄວາມບໍລິສຸດ';

  @override
  String get goldPerGram => 'ຕໍ່ກຣາມ, ລາຄາຂາຍ. USD ແລະ THB ເປັນລາຄາອ້າງອີງ.';

  @override
  String get goldDisclaimer =>
      'ລາຄາປ່ຽນແປງຕາມຕະຫຼາດ ແລະ ຢືນຢັນທີ່ເຄົາເຕີ. ຫຼຽນ ແລະ ຄຳແທ່ງຄິດລາຄາຕາມອັດຕາ ณ ເວລາສັ່ງຊື້.';

  @override
  String aboutEyebrow(String year) {
    return 'ຕັ້ງແຕ່ $year';
  }

  @override
  String get aboutVisit => 'ຢ້ຽມຊົມຮ້ານ';

  @override
  String get contactHeadline => 'ພວກເຮົາພ້ອມຊ່ວຍທ່ານ';

  @override
  String get contactChannels => 'ຕິດຕໍ່ພວກເຮົາ';

  @override
  String get contactCall => 'ໂທ';

  @override
  String get contactWhatsapp => 'WhatsApp';

  @override
  String get contactEmail => 'ອີເມວ';

  @override
  String get contactStore => 'ຮ້ານຫຼັກ';

  @override
  String get contactMessageTitle => 'ສົ່ງຂໍ້ຄວາມ';

  @override
  String get contactMessage => 'ຂໍ້ຄວາມ';

  @override
  String get contactMessageShort =>
      'ກະລຸນາບອກລາຍລະອຽດເພີ່ມ (ຢ່າງໜ້ອຍ 10 ຕົວອັກສອນ).';

  @override
  String get contactSend => 'ສົ່ງ';

  @override
  String get contactSent => 'ສົ່ງຂໍ້ຄວາມແລ້ວ. ພວກເຮົາຈະຕອບພາຍໃນໜຶ່ງວັນເຮັດວຽກ.';

  @override
  String contactCopied(String value) {
    return 'ຄັດລອກ $value ແລ້ວ';
  }

  @override
  String get feedbackEyebrow => 'ຄຳຕິຊົມ';

  @override
  String get feedbackTitle => 'ປະສົບການຂອງທ່ານເປັນແນວໃດ?';

  @override
  String get feedbackIntro =>
      'ທຸກຂໍ້ຄວາມສົ່ງເຖິງໂຮງງານ. ບອກພວກເຮົາວ່າຄວນຮັກສາຫຍັງ ແລະ ແກ້ໄຂຫຍັງ.';

  @override
  String get feedbackHappy => 'ພໍໃຈ';

  @override
  String get feedbackSad => 'ບໍ່ພໍໃຈ';

  @override
  String get feedbackTopic => 'ຫົວຂໍ້';

  @override
  String get feedbackTopicApp => 'ປະສົບການແອັບ';

  @override
  String get feedbackTopicRange => 'ຄວາມຫຼາກຫຼາຍສິນຄ້າ';

  @override
  String get feedbackTopicPricing => 'ລາຄາ';

  @override
  String get feedbackTopicDelivery => 'ການຈັດສົ່ງ';

  @override
  String get feedbackTopicStore => 'ການຢ້ຽມຮ້ານ';

  @override
  String get feedbackTopicOther => 'ອື່ນໆ';

  @override
  String get feedbackMessage => 'ຄຳຕິຊົມຂອງທ່ານ';

  @override
  String feedbackTooShort(int min) {
    return 'ກະລຸນາຂຽນຢ່າງໜ້ອຍ $min ຕົວອັກສອນ.';
  }

  @override
  String get feedbackFollowUp => 'ທ່ານສາມາດຕິດຕໍ່ຂ້ອຍກັບໄດ້';

  @override
  String get feedbackThanksTitle => 'ຂອບໃຈ';

  @override
  String get feedbackThanksBody =>
      'ພວກເຮົາອ່ານທຸກຂໍ້ຄວາມ. ຖ້າທ່ານຂໍໃຫ້ຕິດຕໍ່ກັບ, ຈະໄດ້ຮັບພາຍໃນສອງວັນເຮັດວຽກ.';

  @override
  String feedbackTicket(String ticket) {
    return 'ໝາຍເລກ $ticket';
  }

  @override
  String get feedbackBack => 'ກັບໄປຕັ້ງຄ່າ';

  @override
  String get feedbackAnother => 'ສົ່ງອີກ';

  @override
  String get feedbackRate => 'ໃຫ້ຄະແນນແອັບ';

  @override
  String rateTitle(String brand) {
    return 'ມັກ $brand ບໍ?';
  }

  @override
  String get rateIntro => 'ແຕະດາວ. ຄະແນນຂອງທ່ານຊ່ວຍໃຫ້ລູກຄ້າຄົນອື່ນພົບພວກເຮົາ.';

  @override
  String get rateCaption0 => 'ແຕະດາວເພື່ອໃຫ້ຄະແນນ';

  @override
  String get rateCaption1 => 'ຂໍອະໄພ. ບອກພວກເຮົາວ່າມີຫຍັງຜິດພາດ.';

  @override
  String get rateCaption2 => 'ບໍ່ດີປານໃດ. ພວກເຮົາຢາກເຮັດໃຫ້ດີຂຶ້ນ.';

  @override
  String get rateCaption3 => 'ພໍໃຊ້ໄດ້. ຈະດີຂຶ້ນໄດ້ແນວໃດ?';

  @override
  String get rateCaption4 => 'ດີໃຈທີ່ທ່ານມັກ!';

  @override
  String get rateCaption5 => 'ຍອດຢ້ຽມ, ຂອບໃຈ!';

  @override
  String get rateOnStore => 'ໃຫ້ຄະແນນໃນສະໂຕ';

  @override
  String get rateNotNow => 'ບໍ່ແມ່ນຕອນນີ້';

  @override
  String get rateStoreDemo => 'ໜ້າສະໂຕຈະເປີດຢູ່ນີ້ເມື່ອແອັບຖືກເຜີຍແຜ່ແລ້ວ.';

  @override
  String get rateWhatWentWrong => 'ມີຫຍັງຜິດພາດ?';

  @override
  String get rateDetailedFeedback => 'ສົ່ງຄຳຕິຊົມລະອຽດ';

  @override
  String get rateThanks => 'ຂອບໃຈສຳລັບຄະແນນ';

  @override
  String get rateSummary => 'ຄະແນນ';

  @override
  String rateCount(String count) {
    return '$count ຄະແນນ';
  }

  @override
  String rateWhatsNew(String version) {
    return 'ມີຫຍັງໃໝ່ໃນ $version';
  }

  @override
  String get rateNew1 => 'ລາຄາຄຳສົດ ແລະ ຄົ້ນຫາຮ້ານ';

  @override
  String get rateNew2 => 'ໂປຣໂມຊັນ ແລະ ລະຫັດຄູປອງໃນກະເປົາ';

  @override
  String get rateNew3 => 'ສົນທະນາຊ່ວຍເຫຼືອກັບພະນັກງານ';

  @override
  String get rateNew4 => 'ສັ່ງເຮັດພິເສດ';

  @override
  String get storiesTitle => 'ເລື່ອງລາວລູກຄ້າ';

  @override
  String get storiesShopNow => 'ຊື້ເລີຍ';

  @override
  String get storiesLike => 'ມັກ';

  @override
  String get supportRoot =>
      'ສະບາຍດີ! ຂ້ອຍແມ່ນຜູ້ຊ່ວຍຂອງຮ້ານ. ມື້ນີ້ຊ່ວຍຫຍັງໄດ້ແດ່?';

  @override
  String get supportOptTrack => 'ຕິດຕາມຄຳສັ່ງຊື້';

  @override
  String get supportOptReturns => 'ສົ່ງຄືນ ແລະ ແລກປ່ຽນ';

  @override
  String get supportOptCare => 'ການດູແລ ແລະ ຂະໜາດ';

  @override
  String get supportOptPayments => 'ການຊຳລະ ແລະ ໂປຣໂມຊັນ';

  @override
  String get supportOptHelped => 'ຊ່ວຍໄດ້ແລ້ວ';

  @override
  String get supportOptAgent => 'ຄຸຍກັບພະນັກງານ';

  @override
  String get supportOptMore => 'ເລື່ອງອື່ນ';

  @override
  String get supportTrack =>
      'ເປີດຄຳສັ່ງຊື້, ເລືອກຄຳສັ່ງ ແລະ ທ່ານຈະເຫັນເສັ້ນເວລາຫ້າຂັ້ນຕອນພ້ອມເລກຕິດຕາມຂອງຜູ້ສົ່ງ. ພັດສະດຸທີ່ກຳລັງສົ່ງກໍຈະແຈ້ງເຕືອນເຊັ່ນກັນ.';

  @override
  String get supportReturns =>
      'ຊິ້ນທີ່ຍັງບໍ່ໄດ້ໃສ່ສາມາດສົ່ງຄືນພາຍໃນ 14 ວັນ ແລະ ແລກປ່ຽນພາຍໃນ 30 ວັນ. ຫຼຽນ, ຄຳແທ່ງ ແລະ ຊິ້ນທີ່ແກະສະຫຼັກບໍ່ລວມ. ຂ້ອຍສາມາດເປີດນະໂຍບາຍໃຫ້ທ່ານໄດ້.';

  @override
  String get supportCare =>
      'ຖອດເຄື່ອງປະດັບກ່ອນລອຍນ້ຳ ຫຼື ສຳຜັດສານເຄມີ, ເກັບແຍກກັນ, ແລະ ນຳມາທຳຄວາມສະອາດຟຣີໄດ້ທຸກເວລາ. ຂະໜາດແຫວນຢູ່ໃນຄູ່ມືຂະໜາດ.';

  @override
  String get supportPayments =>
      'ພວກເຮົາຮັບບັດ, BCEL One ແລະ ເກັບເງິນປາຍທາງ, ພ້ອມຜ່ອນ 0% ສາມເດືອນ. ລະຫັດຄູປອງປັດຈຸບັນຢູ່ໜ້າໂປຣໂມຊັນ.';

  @override
  String get supportHelped => 'ຍອດຢ້ຽມ. ມີຫຍັງອີກບໍ?';

  @override
  String get supportConnecting => 'ກຳລັງເຊື່ອມຕໍ່ກັບພະນັກງານ…';

  @override
  String supportAgentJoined(String name) {
    return '$name ເຂົ້າຮ່ວມການສົນທະນາ';
  }

  @override
  String supportAgentGreeting(String name) {
    return 'ສະບາຍດີ, ຂ້ອຍແມ່ນ $name ຈາກຮ້ານ. ຊ່ວຍຫຍັງໄດ້ແດ່?';
  }

  @override
  String get supportAgentAck =>
      'ຂອບໃຈ, ຮັບຊາບແລ້ວ. ຂໍກວດເບິ່ງແລ້ວຈະກັບມາຕອບໃນອີກບໍ່ດົນ.';

  @override
  String get supportComposerHint => 'ຂຽນຂໍ້ຄວາມ';

  @override
  String get supportWaiting => 'ລໍຖ້າບຶດໜຶ່ງ…';

  @override
  String get supportOpenLink => 'ເປີດ';

  @override
  String get supportRestart => 'ເລີ່ມໃໝ່';

  @override
  String get notificationsMarkAll => 'ໝາຍວ່າອ່ານທັງໝົດ';

  @override
  String get notificationsUnread => 'ຍັງບໍ່ໄດ້ອ່ານ';

  @override
  String get notificationsEmptyTitle => 'ບໍ່ມີການແຈ້ງເຕືອນ';

  @override
  String get notificationsEmptyBody =>
      'ອັບເດດຄຳສັ່ງຊື້, ໂປຣໂມຊັນ ແລະ ແຈ້ງເຕືອນລາຄາຄຳຈະສະແດງຢູ່ນີ້.';

  @override
  String get offersEmptyTitle => 'ຕອນນີ້ບໍ່ມີໂປຣໂມຊັນ';

  @override
  String get offersEmptyBody => 'ກັບມາເບິ່ງອີກໄວໆນີ້.';

  @override
  String offerPercentOff(String value) {
    return 'ຫຼຸດ $value%';
  }

  @override
  String offerAmountOff(String amount) {
    return 'ຫຼຸດ $amount';
  }

  @override
  String get offerFreeDelivery => 'ສົ່ງຟຣີ';

  @override
  String offerMinimum(String amount) {
    return 'ສັ່ງຂັ້ນຕ່ຳ $amount';
  }

  @override
  String offerExpires(String date) {
    return 'ໃຊ້ໄດ້ຮອດ $date';
  }

  @override
  String offerCopied(String code) {
    return 'ຄັດລອກ $code ແລ້ວ';
  }

  @override
  String get cartCoupon => 'ລະຫັດຄູປອງ';

  @override
  String get cartCouponApply => 'ນຳໃຊ້';

  @override
  String get cartCouponApplied => 'ນຳໃຊ້ຄູປອງແລ້ວ';

  @override
  String get cartCouponInvalid => 'ລະຫັດນີ້ບໍ່ຖືກຕ້ອງ ຫຼື ໝົດອາຍຸແລ້ວ.';

  @override
  String get cartCouponActive => 'ນຳໃຊ້ກັບກະເປົານີ້';

  @override
  String cartCouponMinimum(String amount) {
    return 'ເພີ່ມອີກເພື່ອໃຫ້ຮອດ $amount';
  }

  @override
  String cartDiscount(String code) {
    return 'ຄູປອງ $code';
  }

  @override
  String get commissionTitle => 'ສັ່ງເຮັດພິເສດ';

  @override
  String get commissionIntro =>
      'ແບ່ງປັນຮູບອ້າງອີງ ແລະ ງົບປະມານ; ໂຮງງານຈະຕອບພ້ອມແບບຮ່າງ ແລະ ລາຄາພາຍໃນສາມວັນເຮັດວຽກ.';

  @override
  String get commissionPhotoHint => 'ເພີ່ມຮູບອ້າງອີງ';

  @override
  String get commissionCamera => 'ກ້ອງ';

  @override
  String get commissionGallery => 'ຄັງຮູບ';

  @override
  String get commissionBudget => 'ງົບປະມານ';

  @override
  String get commissionBrief => 'ບອກພວກເຮົາກ່ຽວກັບຊິ້ນງານ';

  @override
  String get commissionNameRequired => 'ກະລຸນາໃສ່ຊື່ຂອງທ່ານ.';

  @override
  String get commissionSend => 'ສົ່ງຄຳຮ້ອງ';

  @override
  String get commissionDoneTitle => 'ໄດ້ຮັບຄຳຮ້ອງແລ້ວ';

  @override
  String get commissionDoneBody => 'ນັກອອກແບບຈະຕິດຕໍ່ພ້ອມແບບຮ່າງທຳອິດ.';
}

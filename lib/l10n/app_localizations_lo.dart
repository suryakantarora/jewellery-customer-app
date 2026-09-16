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
}

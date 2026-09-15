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
}

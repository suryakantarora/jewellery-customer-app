import '../media/image_ref.dart';
import '../theme/palettes.dart';
import 'tenant_palette.dart';

/// Currency presentation, driven entirely by the tenant.
class TenantCurrency {
  const TenantCurrency({
    required this.code,
    required this.symbol,
    required this.decimals,
    required this.symbolFirst,
    required this.locale,
  });

  final String code;
  final String symbol;
  final int decimals;
  final bool symbolFirst;

  /// The locale used for digit grouping (`en-US` gives `1,234,567`).
  final String locale;

  factory TenantCurrency.fromJson(Map<String, dynamic> json) => TenantCurrency(
    code: json['code'] as String,
    symbol: json['symbol'] as String,
    decimals: (json['decimals'] as num?)?.toInt() ?? 0,
    symbolFirst: json['symbolFirst'] as bool? ?? true,
    locale: json['locale'] as String? ?? 'en_US',
  );
}

class TenantContact {
  const TenantContact({
    this.phone,
    this.whatsapp,
    this.email,
    this.storeAddress,
    this.hours,
  });

  final String? phone;
  final String? whatsapp;
  final String? email;
  final String? storeAddress;
  final String? hours;

  factory TenantContact.fromJson(Map<String, dynamic>? json) => TenantContact(
    phone: json?['phone'] as String?,
    whatsapp: json?['whatsapp'] as String?,
    email: json?['email'] as String?,
    storeAddress: json?['storeAddress'] as String?,
    hours: json?['hours'] as String?,
  );
}

/// Everything that makes one company's app look and behave like theirs.
///
/// Nothing brand-specific exists anywhere else in the code base — screens
/// read this through `tenantProvider`.
class TenantConfig {
  const TenantConfig({
    required this.key,
    required this.brandName,
    required this.brandMark,
    required this.tagline,
    required this.logoLight,
    required this.logoDark,
    required this.paletteId,
    required this.palette,
    required this.darkPalette,
    required this.fontDisplay,
    required this.fontBody,
    required this.currency,
    required this.supportedLocales,
    required this.defaultLocale,
    required this.contact,
    required this.featureFlags,
    required this.freeDeliveryThreshold,
    required this.deliveryFee,
    required this.taxRate,
    required this.allowedPalettes,
    required this.phoneCountryCode,
    this.storefrontUrl,
  });

  final String key;
  final String brandName;

  /// Short mark used in the header wordmark ("FINO").
  final String brandMark;
  final String tagline;
  final ImageRef logoLight;
  final ImageRef logoDark;

  /// Id of the palette in use — one of the bundled fallbacks or `custom`.
  final String paletteId;
  final TenantPalette palette;
  final TenantPalette darkPalette;
  final String fontDisplay;
  final String fontBody;
  final TenantCurrency currency;
  final List<String> supportedLocales;
  final String defaultLocale;
  final TenantContact contact;
  final Map<String, bool> featureFlags;
  final num freeDeliveryThreshold;

  /// Flat delivery charge below the free-delivery threshold.
  final num deliveryFee;

  /// Fraction, e.g. 0.07 for 7% VAT.
  final double taxRate;

  /// Dialling prefix pre-filled on the phone sign-in screen (`+856`).
  final String phoneCountryCode;

  /// Public web storefront, used to build share links. Optional.
  final String? storefrontUrl;

  /// Palette ids the settings picker may offer. Empty = picker hidden.
  final List<String> allowedPalettes;

  bool flag(String name, {bool orElse = false}) => featureFlags[name] ?? orElse;

  factory TenantConfig.fromJson(Map<String, dynamic> json) {
    final flags = <String, bool>{};
    (json['featureFlags'] as Map<String, dynamic>? ?? const {}).forEach((k, v) {
      flags[k] = v == true;
    });
    final logo = json['logo'] as Map<String, dynamic>? ?? const {};
    // A tenant that has only named a built-in palette (or nothing at all)
    // still gets a complete theme: the backend fills brand and currency from
    // the company record and leaves colours to the app.
    final builtIn =
        FallbackPalettes.byId(json['paletteId'] as String?) ?? FallbackPalettes.ruby;
    final light = json['palette'] as Map<String, dynamic>?;
    final dark = json['darkPalette'] as Map<String, dynamic>?;
    return TenantConfig(
      key: json['key'] as String,
      brandName: json['brandName'] as String,
      brandMark: json['brandMark'] as String? ?? json['brandName'] as String,
      tagline: json['tagline'] as String? ?? '',
      logoLight: ImageRef.fromString(logo['light'] as String? ?? ''),
      logoDark: ImageRef.fromString(
        logo['dark'] as String? ?? logo['light'] as String? ?? '',
      ),
      paletteId: json['paletteId'] as String? ?? (light == null ? builtIn.id : 'custom'),
      palette: light == null ? builtIn.light : TenantPalette.fromJson(light),
      darkPalette: dark == null ? builtIn.dark : TenantPalette.fromJson(dark),
      fontDisplay: json['fontDisplay'] as String? ?? 'PlayfairDisplay',
      fontBody: json['fontBody'] as String? ?? 'Inter',
      currency: TenantCurrency.fromJson(
        json['currency'] as Map<String, dynamic>,
      ),
      supportedLocales:
          (json['supportedLocales'] as List?)?.cast<String>() ?? const ['en'],
      defaultLocale: json['defaultLocale'] as String? ?? 'en',
      contact: TenantContact.fromJson(json['contact'] as Map<String, dynamic>?),
      featureFlags: flags,
      freeDeliveryThreshold: json['freeDeliveryThreshold'] as num? ?? 0,
      deliveryFee: json['deliveryFee'] as num? ?? 0,
      taxRate: (json['taxRate'] as num?)?.toDouble() ?? 0,
      allowedPalettes:
          (json['allowedPalettes'] as List?)?.cast<String>() ?? const [],
      phoneCountryCode: json['phoneCountryCode'] as String? ?? '+856',
      storefrontUrl: json['storefrontUrl'] as String?,
    );
  }

  TenantConfig copyWith({
    String? paletteId,
    TenantPalette? palette,
    TenantPalette? darkPalette,
  }) => TenantConfig(
    key: key,
    brandName: brandName,
    brandMark: brandMark,
    tagline: tagline,
    logoLight: logoLight,
    logoDark: logoDark,
    paletteId: paletteId ?? this.paletteId,
    palette: palette ?? this.palette,
    darkPalette: darkPalette ?? this.darkPalette,
    fontDisplay: fontDisplay,
    fontBody: fontBody,
    currency: currency,
    supportedLocales: supportedLocales,
    defaultLocale: defaultLocale,
    contact: contact,
    featureFlags: featureFlags,
    freeDeliveryThreshold: freeDeliveryThreshold,
    deliveryFee: deliveryFee,
    taxRate: taxRate,
    allowedPalettes: allowedPalettes,
    phoneCountryCode: phoneCountryCode,
    storefrontUrl: storefrontUrl,
  );
}

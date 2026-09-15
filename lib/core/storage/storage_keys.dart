/// Every persisted preference key in one place.
abstract final class StorageKeys {
  static const themeMode = 'pref.theme_mode';
  static const paletteId = 'pref.palette_id';
  static const locale = 'pref.locale';

  /// Runtime tenant override from the dev-only shop-code screen.
  static const tenantKeyOverride = 'dev.tenant_key';
}

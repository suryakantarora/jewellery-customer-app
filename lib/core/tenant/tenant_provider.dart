import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/data_mode.dart';
import '../providers.dart';
import '../storage/storage_keys.dart';
import '../theme/palettes.dart';
import 'api_tenant_repository.dart';
import 'demo_tenant_repository.dart';
import 'tenant_config.dart';
import 'tenant_repository.dart';

final tenantRepositoryProvider = Provider<TenantRepository>((ref) {
  const demo = DemoTenantRepository();
  final config = ref.watch(appConfigProvider);
  return switch (config.dataMode) {
    DataMode.demo => demo,
    DataMode.api => ApiTenantRepository(
      client: ref.watch(apiClientProvider),
      fallback: demo,
    ),
  };
});

/// The effective tenant key: a dev-time override from the shop-code screen,
/// else the build-time `TENANT_KEY`.
class TenantKeyController extends Notifier<String> {
  @override
  String build() {
    final config = ref.watch(appConfigProvider);
    if (config.environment.allowsDeveloperTools) {
      final stored = ref
          .read(localStoreProvider)
          .getString(StorageKeys.tenantKeyOverride);
      if (stored != null && stored.isNotEmpty) return stored;
    }
    return config.tenantKey;
  }

  Future<void> set(String key) async {
    final cleaned = key.trim().toLowerCase();
    final store = ref.read(localStoreProvider);
    if (cleaned.isEmpty || cleaned == ref.read(appConfigProvider).tenantKey) {
      await store.remove(StorageKeys.tenantKeyOverride);
      state = ref.read(appConfigProvider).tenantKey;
      return;
    }
    await store.setString(StorageKeys.tenantKeyOverride, cleaned);
    state = cleaned;
  }
}

final tenantKeyProvider = NotifierProvider<TenantKeyController, String>(
  TenantKeyController.new,
);

/// The active tenant. Awaited in `main()` before the first frame; any later
/// reload (shop code changed) shows the branded splash until it resolves.
class TenantController extends AsyncNotifier<TenantConfig> {
  @override
  Future<TenantConfig> build() async {
    final key = ref.watch(tenantKeyProvider);
    final config = await ref.watch(tenantRepositoryProvider).load(key);
    return _applyPaletteChoice(config);
  }

  /// A palette chosen in settings (C7) overrides the tenant's, but only from
  /// the list the tenant allows.
  TenantConfig _applyPaletteChoice(TenantConfig config) {
    final chosen = ref.read(localStoreProvider).getString(StorageKeys.paletteId);
    if (chosen == null || !config.allowedPalettes.contains(chosen)) {
      return config;
    }
    final pair = FallbackPalettes.byId(chosen);
    if (pair == null) return config;
    return config.copyWith(
      paletteId: pair.id,
      palette: pair.light,
      darkPalette: pair.dark,
    );
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final key = ref.read(tenantKeyProvider);
      final config = await ref.read(tenantRepositoryProvider).load(key);
      return _applyPaletteChoice(config);
    });
  }

  Future<void> choosePalette(String? id) async {
    await ref.read(localStoreProvider).setString(StorageKeys.paletteId, id);
    await reload();
  }
}

final tenantProvider = AsyncNotifierProvider<TenantController, TenantConfig>(
  TenantController.new,
);

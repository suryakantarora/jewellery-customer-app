import 'tenant_config.dart';

/// Resolves the [TenantConfig] for a tenant key.
abstract interface class TenantRepository {
  Future<TenantConfig> load(String tenantKey);
}

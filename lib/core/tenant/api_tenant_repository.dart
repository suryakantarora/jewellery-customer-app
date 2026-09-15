import 'package:flutter/foundation.dart';

import '../network/api_client.dart';
import 'tenant_config.dart';
import 'tenant_repository.dart';

/// `GET /api/v1/public/tenant/{key}` — not on the backend yet (plan §5).
///
/// Fails gracefully: any error, including a 404 or an unparseable body,
/// falls back to [fallback] so the app always launches with a brand.
class ApiTenantRepository implements TenantRepository {
  const ApiTenantRepository({required this.client, required this.fallback});

  final ApiClient client;
  final TenantRepository fallback;

  @override
  Future<TenantConfig> load(String tenantKey) async {
    try {
      return await client.get(
        '/public/tenant/$tenantKey',
        parse: (data) =>
            TenantConfig.fromJson(data! as Map<String, dynamic>),
      );
    } on Object catch (error) {
      debugPrint('Tenant "$tenantKey" not served by API; using bundled ($error)');
      return fallback.load(tenantKey);
    }
  }
}

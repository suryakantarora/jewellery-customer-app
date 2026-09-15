import 'dart:convert';

import 'package:flutter/services.dart';

import 'tenant_config.dart';
import 'tenant_repository.dart';

/// Reads the bundled `assets/demo/tenant.json`.
///
/// The bundled config is also the fallback for the API repository, so a
/// fresh install always has a brand to show before the network answers.
class DemoTenantRepository implements TenantRepository {
  const DemoTenantRepository({this.assetPath = 'assets/demo/tenant.json'});

  final String assetPath;

  @override
  Future<TenantConfig> load(String tenantKey) async {
    final raw = await rootBundle.loadString(assetPath);
    return TenantConfig.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}

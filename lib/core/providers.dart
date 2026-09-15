import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/app_config.dart';
import 'network/api_client.dart';
import 'network/dio_client.dart';
import 'storage/local_store.dart';
import 'tenant/tenant_provider.dart';

/// Overridden in `main()` once preferences have loaded, so no widget has to
/// await storage during build.
final localStoreProvider = Provider<LocalStore>(
  (ref) => throw UnimplementedError('localStoreProvider must be overridden'),
);

final appConfigProvider = Provider<AppConfig>(
  (ref) => AppConfig.fromEnvironment(),
);

final dioProvider = Provider<Dio>((ref) {
  return DioClient.create(
    config: ref.watch(appConfigProvider),
    tenantKey: ref.watch(tenantKeyProvider),
  );
});

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(ref.watch(dioProvider)),
);

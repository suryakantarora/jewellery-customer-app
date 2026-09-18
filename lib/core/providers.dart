import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/app_config.dart';
import 'network/api_client.dart';
import 'network/dio_client.dart';
import 'storage/local_store.dart';
import 'storage/storage_keys.dart';
import 'tenant/tenant_provider.dart';

/// Overridden in `main()` once preferences have loaded, so no widget has to
/// await storage during build.
final localStoreProvider = Provider<LocalStore>(
  (ref) => throw UnimplementedError('localStoreProvider must be overridden'),
);

final appConfigProvider = Provider<AppConfig>(
  (ref) => AppConfig.fromEnvironment(),
);

/// Bumped when the backend refuses the stored customer token (expired,
/// revoked, or the account was closed). The session controller listens and
/// drops to guest, so the next gated action asks the customer to sign in.
final sessionExpiredProvider = StateProvider<int>((ref) => 0);

final dioProvider = Provider<Dio>((ref) {
  final store = ref.watch(localStoreProvider);
  return DioClient.create(
    config: ref.watch(appConfigProvider),
    tenantKey: ref.watch(tenantKeyProvider),
    readToken: () => store.getJson(StorageKeys.session)?['token'] as String?,
    // Deferred: this fires inside a request, often during a provider build.
    onSessionExpired: () => Future.microtask(
      () => ref.read(sessionExpiredProvider.notifier).state++,
    ),
  );
});

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(ref.watch(dioProvider)),
);

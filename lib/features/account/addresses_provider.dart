import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/session/session_provider.dart';
import '../../data/models/commerce.dart';
import '../../data/repository_providers.dart';

class AddressesController extends AsyncNotifier<List<Address>> {
  @override
  Future<List<Address>> build() {
    ref.watch(sessionIdentityProvider);
    return ref.watch(addressRepositoryProvider).list();
  }

  Future<void> save(Address address) async {
    state = AsyncData(await ref.read(addressRepositoryProvider).save(address));
  }

  Future<void> delete(String id) async {
    state = AsyncData(await ref.read(addressRepositoryProvider).delete(id));
  }

  Future<void> setDefault(String id) async {
    state = AsyncData(await ref.read(addressRepositoryProvider).setDefault(id));
  }
}

final addressesProvider =
    AsyncNotifierProvider<AddressesController, List<Address>>(
      AddressesController.new,
    );

final defaultAddressProvider = Provider<Address?>((ref) {
  final list = ref.watch(addressesProvider).valueOrNull ?? const [];
  return list.where((a) => a.isDefault).firstOrNull ?? list.firstOrNull;
});

class PaymentMethodsController extends AsyncNotifier<List<PaymentMethod>> {
  @override
  Future<List<PaymentMethod>> build() {
    ref.watch(sessionIdentityProvider);
    return ref.watch(paymentMethodRepositoryProvider).list();
  }

  Future<void> setDefault(String id) async {
    state = AsyncData(
      await ref.read(paymentMethodRepositoryProvider).setDefault(id),
    );
  }

  Future<void> remove(String id) async {
    state = AsyncData(await ref.read(paymentMethodRepositoryProvider).remove(id));
  }
}

final paymentMethodsProvider =
    AsyncNotifierProvider<PaymentMethodsController, List<PaymentMethod>>(
      PaymentMethodsController.new,
    );

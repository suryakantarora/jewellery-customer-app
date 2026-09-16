import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/commerce.dart';
import '../../data/repository_providers.dart';

class OrdersController extends AsyncNotifier<List<Order>> {
  @override
  Future<List<Order>> build() => ref.watch(orderRepositoryProvider).list();

  Future<Order> place(OrderDraft draft) async {
    final order = await ref.read(orderRepositoryProvider).place(draft);
    state = AsyncData(<Order>[order, ...state.valueOrNull ?? const []]);
    return order;
  }
}

final ordersProvider = AsyncNotifierProvider<OrdersController, List<Order>>(
  OrdersController.new,
);

final orderProvider = Provider.autoDispose.family<AsyncValue<Order?>, String>(
  (ref, id) => ref
      .watch(ordersProvider)
      .whenData((list) => list.where((o) => o.id == id).firstOrNull),
);

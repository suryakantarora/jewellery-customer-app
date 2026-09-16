import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format/formatters_provider.dart';
import '../../core/l10n/locale_provider.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/router/app_routes.dart';
import '../../core/tenant/tenant_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../data/models/commerce.dart';
import '../../data/repository_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_panel.dart';
import '../../shared/widgets/app_toast.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/eyebrow.dart';
import '../../shared/widgets/skeleton.dart';
import '../../shared/widgets/status_pill.dart';
import '../cart/cart_provider.dart';
import '../cart/cart_screen.dart';
import '../shell/fino_header.dart';
import 'order_timeline.dart';
import 'orders_provider.dart';
import 'orders_screen.dart';

/// Order detail (survey: OrderDetailPage): status, items, timeline,
/// courier block, totals, reorder / invoice / call courier.
class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final money = ref.watch(moneyFormatterProvider);
    final dates = ref.watch(dateFormatterProvider);
    final locale = ref.watch(localeProvider);
    final gutter = Breakpoints.gutter(context);
    final order = ref.watch(orderProvider(orderId));
    final tenant = ref.watch(tenantProvider).valueOrNull;

    Future<void> reorder(Order o) async {
      final products = await ref.read(catalogueRepositoryProvider).byIds(o.items.map((i) => i.productId).toList());
      final byId = {for (final p in products) p.id: p};
      final lines = [
        for (final i in o.items)
          if (byId[i.productId] case final p?) CartLine(product: p, quantity: i.quantity, size: i.size),
      ];
      final restored = await ref.read(cartProvider.notifier).addAll(lines);
      if (!context.mounted) return;
      if (restored == 0) {
        showToast(context, l10n.orderReorderNone);
        return;
      }
      showToast(
        context,
        restored == o.items.length ? l10n.orderReorderAll : l10n.orderReorderPartial(restored, o.items.length),
        icon: Icons.shopping_bag_outlined,
      );
      await context.push(AppRoutes.cart);
    }

    return Scaffold(
      appBar: FinoHeader.page(title: l10n.orderDetailTitle),
      body: ContentWidth(
        child: order.when(
          loading: () => ListView(
            padding: EdgeInsets.all(gutter),
            children: const [Skeleton(height: 80), SizedBox(height: AppSpacing.md), Skeleton(height: 200)],
          ),
          error: (_, __) => ErrorState(onRetry: () => ref.invalidate(ordersProvider)),
          data: (o) => o == null
              ? ErrorState(body: l10n.orderNotFound)
              : ListView(
                  padding: EdgeInsets.fromLTRB(gutter, AppSpacing.lg, gutter, AppSpacing.xl),
                  children: [
                    StatusPill(orderStatusLabel(l10n, o.status), tone: orderStatusTone(o.status)),
                    const SizedBox(height: AppSpacing.xs),
                    Text(o.id, style: text.displaySmall!.copyWith(fontFeatures: const [FontFeature.tabularFigures()])),
                    Text(dates.long(o.date), style: text.bodySmall),
                    if (o.eta != null)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.xxs),
                        child: Text(o.eta!.resolve(locale), style: text.bodyMedium!.copyWith(color: c.primary)),
                      ),
                    const SizedBox(height: AppSpacing.lg),
                    Eyebrow(l10n.checkoutItems(o.itemCount)),
                    const SizedBox(height: AppSpacing.xs),
                    AppPanel(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                      child: Column(
                        children: [
                          for (final i in o.items)
                            LineThumbRow(
                              image: i.image,
                              name: i.name,
                              meta: [if (i.size != null) l10n.cartSize(i.size!), l10n.cartQty(i.quantity)].join(' · '),
                              trailing: money.format(i.lineTotal),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Eyebrow(l10n.orderProgress),
                    const SizedBox(height: AppSpacing.sm),
                    AppPanel(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          OrderStageRail(status: o.status),
                          const SizedBox(height: AppSpacing.lg),
                          OrderTimeline(order: o),
                          const SizedBox(height: AppSpacing.xs),
                          CourierBlock(order: o),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Eyebrow(l10n.checkoutSummary),
                    const SizedBox(height: AppSpacing.xs),
                    AppPanel(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: OrderSummaryLines(
                        totals: CartTotals(
                          subtotal: o.subtotal,
                          savings: 0,
                          shipping: o.shipping,
                          tax: o.tax,
                          freeDeliveryThreshold: tenant?.freeDeliveryThreshold ?? 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    FilledButton.icon(
                      onPressed: () => reorder(o),
                      icon: const Icon(Icons.replay_rounded, size: 18),
                      label: Text(l10n.orderReorder),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => showToast(context, l10n.ordersInvoiceDemo, icon: Icons.receipt_long_outlined),
                            icon: const Icon(Icons.receipt_long_outlined, size: 16),
                            label: Text(l10n.ordersInvoice),
                          ),
                        ),
                        if (o.courier != null && tenant?.contact.phone != null) ...[
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                await Clipboard.setData(ClipboardData(text: tenant!.contact.phone!));
                                if (context.mounted) {
                                  showToast(context, l10n.orderCourierNumberCopied(tenant.contact.phone!), icon: Icons.call_outlined);
                                }
                              },
                              icon: const Icon(Icons.call_outlined, size: 16),
                              label: Text(l10n.orderCallCourier),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

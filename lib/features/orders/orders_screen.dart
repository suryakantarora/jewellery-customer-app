import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format/formatters_provider.dart';
import '../../core/l10n/locale_provider.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/media/app_image.dart';
import '../../core/media/image_ref.dart';
import '../../core/motion/motion.dart';
import '../../core/router/app_routes.dart';
import '../../core/session/session_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../data/models/commerce.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_panel.dart';
import '../../shared/widgets/app_toast.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/segmented_control.dart';
import '../../shared/widgets/skeleton.dart';
import '../../shared/widgets/staggered_reveal.dart';
import '../../shared/widgets/status_pill.dart';
import '../auth/auth_gate.dart';
import '../shell/fino_header.dart';
import 'order_timeline.dart';
import 'orders_provider.dart';

/// Orders (survey: TrackOrderPage): Active / All segments, expandable cards
/// (first in-flight one open), stage rail + timeline, courier block.
class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  int _segment = 0;
  String? _expanded;
  bool _autoExpanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final gutter = Breakpoints.gutter(context);
    final signedIn = ref.watch(isSignedInProvider);
    final orders = ref.watch(ordersProvider);

    return Scaffold(
      appBar: FinoHeader.page(title: l10n.ordersTitle),
      body: !signedIn
          ? SignInPrompt(body: l10n.ordersSignInBody)
          : ContentWidth(
              child: orders.when(
                loading: () => ListView(
                  padding: EdgeInsets.all(gutter),
                  children: const [
                    Skeleton(height: 40, radius: AppRadius.pill),
                    SizedBox(height: AppSpacing.md),
                    Skeleton(height: 96, radius: AppRadius.md),
                    SizedBox(height: AppSpacing.sm),
                    Skeleton(height: 96, radius: AppRadius.md),
                  ],
                ),
                error: (_, __) => ErrorState(onRetry: () => ref.invalidate(ordersProvider)),
                data: (all) {
                  final list = _segment == 0 ? all.where((o) => o.status.isActive).toList() : all;
                  if (!_autoExpanded) {
                    _autoExpanded = true;
                    _expanded = all.where((o) => o.status.isActive).firstOrNull?.id;
                  }
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(gutter, AppSpacing.md, gutter, AppSpacing.xs),
                        child: SegmentedControl(
                          labels: [l10n.ordersActive, l10n.ordersAll],
                          index: _segment,
                          onChanged: (i) => setState(() => _segment = i),
                        ),
                      ),
                      Expanded(
                        child: list.isEmpty
                            ? EmptyState(
                                image: const ImageRef.asset('images/ui/nodata.png'),
                                title: _segment == 0 ? l10n.ordersEmptyActiveTitle : l10n.ordersEmptyTitle,
                                body: l10n.ordersEmptyBody,
                                primaryLabel: l10n.actionContinueShopping,
                                onPrimary: () => context.go(AppRoutes.home),
                              )
                            : ListView.separated(
                                padding: EdgeInsets.fromLTRB(gutter, AppSpacing.xs, gutter, AppSpacing.xl),
                                itemCount: list.length,
                                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                                itemBuilder: (context, i) => StaggeredReveal(
                                  key: ValueKey(list[i].id),
                                  index: i,
                                  child: _OrderCard(
                                    order: list[i],
                                    expanded: _expanded == list[i].id,
                                    onToggle: () => setState(
                                      () => _expanded = _expanded == list[i].id ? null : list[i].id,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }
}

class _OrderCard extends ConsumerWidget {
  const _OrderCard({required this.order, required this.expanded, required this.onToggle});

  final Order order;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final money = ref.watch(moneyFormatterProvider);
    final dates = ref.watch(dateFormatterProvider);
    final locale = ref.watch(localeProvider);
    final first = order.items.first;
    final more = order.items.length - 1;

    return AppPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  AppImage(first.image, width: 56, height: 56, borderRadius: AppRadius.circular(AppRadius.sm)),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${order.id} · ${dates.short(order.date)}', style: text.labelSmall),
                        const SizedBox(height: 2),
                        Text(
                          more > 0 ? l10n.ordersMoreItems(first.name, more) : first.name,
                          style: text.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (order.eta != null)
                          Text(order.eta!.resolve(locale), style: text.bodySmall!.copyWith(color: c.primary)),
                        const SizedBox(height: AppSpacing.xxs),
                        Row(
                          children: [
                            StatusPill(orderStatusLabel(l10n, order.status), tone: orderStatusTone(order.status)),
                            const Spacer(),
                            Text(money.format(order.total), style: text.titleSmall),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  AnimatedRotation(
                    turns: expanded ? .5 : 0,
                    duration: AppMotion.of(context, AppMotion.normal),
                    child: Icon(Icons.expand_more_rounded, color: c.textMuted),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: AppMotion.of(context, AppMotion.normal),
            curve: AppMotion.easeOut,
            alignment: Alignment.topCenter,
            child: !expanded
                ? const SizedBox(width: double.infinity)
                : Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(border: Border(top: BorderSide(color: c.border))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OrderStageRail(status: order.status),
                        const SizedBox(height: AppSpacing.lg),
                        OrderTimeline(order: order),
                        if (order.courier != null) ...[
                          const SizedBox(height: AppSpacing.sm),
                          CourierBlock(order: order),
                        ],
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => context.push(AppRoutes.orderPath(order.id)),
                                child: Text(l10n.ordersViewDetail),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => showToast(context, l10n.ordersInvoiceDemo, icon: Icons.receipt_long_outlined),
                                icon: const Icon(Icons.receipt_long_outlined, size: 16),
                                label: Text(l10n.ordersInvoice),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Courier, tracking number (mono + copy), deliver-to.
class CourierBlock extends StatelessWidget {
  const CourierBlock({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    Widget row(IconData icon, String label, Widget value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: c.textMuted),
          const SizedBox(width: AppSpacing.xs),
          SizedBox(width: 84, child: Text(label, style: text.bodySmall)),
          Expanded(child: value),
        ],
      ),
    );
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(color: c.surface2, borderRadius: AppRadius.circular(AppRadius.sm)),
      child: Column(
        children: [
          if (order.courier != null)
            row(Icons.local_shipping_outlined, l10n.orderCourier, Text(order.courier!, style: text.titleSmall)),
          if (order.trackingNumber != null)
            row(
              Icons.qr_code_2_rounded,
              l10n.orderTracking,
              Row(
                children: [
                  Expanded(
                    child: Text(
                      order.trackingNumber!,
                      style: text.titleSmall!.copyWith(fontFamily: 'Menlo', fontFamilyFallback: const ['monospace']),
                    ),
                  ),
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 16,
                      tooltip: l10n.actionCopy,
                      icon: const Icon(Icons.copy_rounded),
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: order.trackingNumber!));
                        if (context.mounted) showToast(context, l10n.orderTrackingCopied, icon: Icons.copy_rounded);
                      },
                    ),
                  ),
                ],
              ),
            ),
          row(Icons.place_outlined, l10n.orderDeliverTo, Text(order.address, style: text.bodySmall!.copyWith(color: c.text))),
        ],
      ),
    );
  }
}

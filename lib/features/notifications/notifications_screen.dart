import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format/formatters_provider.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../data/models/content.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/skeleton.dart';
import '../../shared/widgets/staggered_reveal.dart';
import '../shell/fino_header.dart';
import 'notifications_provider.dart';

/// Notification centre: unread dot, kind icon, relative date, tap opens the
/// linked screen and marks it read; "Mark all read" in the header.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final list = ref.watch(notificationsProvider);
    final unread = ref.watch(unreadNotificationsProvider);
    final gutter = Breakpoints.gutter(context);
    return Scaffold(
      appBar: FinoHeader.page(
        title: l10n.drawerNotifications,
        actions: [
          if (unread > 0)
            IconButton(
              tooltip: l10n.notificationsMarkAll,
              icon: const Icon(Icons.done_all_rounded),
              onPressed: () =>
                  ref.read(notificationsProvider.notifier).markAllRead(),
            ),
        ],
      ),
      body: ContentWidth(
        child: list.when(
          loading: () => ListView(
            padding: EdgeInsets.all(gutter),
            children: [
              for (var i = 0; i < 5; i++)
                const Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Skeleton(height: 72, radius: AppRadius.md),
                ),
            ],
          ),
          error: (_, __) =>
              ErrorState(onRetry: () => ref.invalidate(notificationsProvider)),
          data: (items) => items.isEmpty
              ? EmptyState(
                  icon: Icons.notifications_none_rounded,
                  title: l10n.notificationsEmptyTitle,
                  body: l10n.notificationsEmptyBody,
                )
              : ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: gutter,
                    vertical: AppSpacing.md,
                  ),
                  itemCount: items.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.xs),
                  itemBuilder: (context, i) => StaggeredReveal(
                    index: i,
                    child: _Row(item: items[i]),
                  ),
                ),
        ),
      ),
    );
  }
}

class _Row extends ConsumerWidget {
  const _Row({required this.item});

  final AppNotification item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final dates = ref.watch(dateFormatterProvider);
    final icon = switch (item.kind) {
      NotificationKind.order => Icons.local_shipping_outlined,
      NotificationKind.offer => Icons.local_offer_outlined,
      NotificationKind.goldRate => Icons.trending_up_rounded,
      NotificationKind.general => Icons.auto_awesome_rounded,
    };
    return Material(
      color: item.read
          ? c.card
          : c.accentSoft.withValues(alpha: c.isDark ? .5 : .55),
      borderRadius: AppRadius.circular(AppRadius.md),
      child: InkWell(
        borderRadius: AppRadius.circular(AppRadius.md),
        onTap: () {
          ref.read(notificationsProvider.notifier).markRead(item.id);
          if (item.link != null) context.push(item.link!);
        },
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            borderRadius: AppRadius.circular(AppRadius.md),
            border: Border.all(color: c.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: c.surface2,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: c.accent),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: text.titleSmall!.copyWith(
                              fontWeight: item.read
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                            ),
                          ),
                        ),
                        if (!item.read)
                          Semantics(
                            label: l10n.notificationsUnread,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: c.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(item.body, style: text.bodySmall),
                    const SizedBox(height: 4),
                    Text(dates.short(item.date), style: text.labelSmall),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

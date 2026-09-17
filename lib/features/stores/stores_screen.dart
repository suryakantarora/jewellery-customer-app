import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/layout/breakpoints.dart';
import '../../core/media/app_image.dart';
import '../../core/platform/launch.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../data/models/content.dart';
import '../../data/repository_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_chip.dart';
import '../../shared/widgets/app_panel.dart';
import '../../shared/widgets/app_toast.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/eyebrow.dart';
import '../../shared/widgets/press_scale.dart';
import '../../shared/widgets/scrim.dart';
import '../../shared/widgets/skeleton.dart';
import '../../shared/widgets/staggered_reveal.dart';
import '../shell/fino_header.dart';

/// Store locator: city filter chips, then boutique cards with a map link.
class StoresScreen extends ConsumerStatefulWidget {
  const StoresScreen({super.key});

  @override
  ConsumerState<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends ConsumerState<StoresScreen> {
  String? _city;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final stores = ref.watch(storesProvider);
    final gutter = Breakpoints.gutter(context);
    return Scaffold(
      appBar: FinoHeader.page(title: l10n.storesTitle),
      body: ContentWidth(
        child: stores.when(
          loading: () => ListView(
            padding: EdgeInsets.all(gutter),
            children: [
              for (var i = 0; i < 3; i++)
                const Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Skeleton(height: 200, radius: AppRadius.md),
                ),
            ],
          ),
          error: (_, __) =>
              ErrorState(onRetry: () => ref.invalidate(storesProvider)),
          data: (list) {
            final cities = list.map((s) => s.city).toSet().toList();
            final visible = _city == null
                ? list
                : list.where((s) => s.city == _city).toList();
            return ListView(
              padding: EdgeInsets.symmetric(
                horizontal: gutter,
                vertical: AppSpacing.md,
              ),
              children: [
                Eyebrow(l10n.storesEyebrow),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  l10n.storesHeadline,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: AppSpacing.md),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      AppChip(
                        label: l10n.storesAllCities,
                        active: _city == null,
                        onTap: () => setState(() => _city = null),
                      ),
                      for (final city in cities) ...[
                        const SizedBox(width: AppSpacing.xs),
                        AppChip(
                          label: city,
                          active: _city == city,
                          onTap: () => setState(() => _city = city),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                if (visible.isEmpty)
                  EmptyState(title: l10n.emptyTitle, body: l10n.emptyBody)
                else
                  for (final (i, s) in visible.indexed)
                    StaggeredReveal(
                      index: i,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: _StoreRow(store: s),
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

class _StoreRow extends StatelessWidget {
  const _StoreRow({required this.store});

  final Store store;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return PressScale(
      onTap: () => context.push(AppRoutes.storePath(store.id)),
      child: Container(
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: AppRadius.circular(AppRadius.md),
          border: Border.all(color: c.border),
          boxShadow: AppShadows.sm(c.shadow),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 130,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AppImage(store.image),
                  const Scrim(stops: [.3, 1], strength: 1.2),
                  Positioned(
                    left: AppSpacing.md,
                    bottom: AppSpacing.sm,
                    right: AppSpacing.md,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            store.name,
                            style: text.headlineSmall!.copyWith(
                              color: AppColors.photoInk,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (store.flagship)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: c.accent,
                              borderRadius: AppRadius.circular(AppRadius.pill),
                            ),
                            child: Text(
                              l10n.storeFlagship.toUpperCase(),
                              style: text.labelSmall!.copyWith(
                                color: const Color(0xFF1C1416),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Line(Icons.location_on_outlined, store.address),
                  _Line(Icons.schedule_rounded, store.hours),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                        onPressed: () => Launch.maps(
                          store.latitude,
                          store.longitude,
                          label: store.name,
                        ),
                        icon: const Icon(Icons.directions_outlined, size: 16),
                        label: Text(l10n.storeDirections),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                        onPressed: () => Launch.phone(store.phone),
                        icon: const Icon(Icons.call_outlined, size: 16),
                        label: Text(l10n.contactCall),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: c.textMuted),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}

/// One boutique: photo, address, hours, services, directions / call / copy.
class StoreDetailScreen extends ConsumerWidget {
  const StoreDetailScreen({super.key, required this.storeId});

  final String storeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final store = ref.watch(storeProvider(storeId));
    final gutter = Breakpoints.gutter(context);
    return Scaffold(
      appBar: FinoHeader.page(
        title: store.valueOrNull?.name ?? l10n.storesTitle,
      ),
      body: ContentWidth(
        child: store.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(AppLayout.gutter),
            child: Skeleton(height: 260, radius: AppRadius.lg),
          ),
          error: (_, __) =>
              ErrorState(onRetry: () => ref.invalidate(storeProvider(storeId))),
          data: (s) => s == null
              ? EmptyState(title: l10n.emptyTitle, body: l10n.emptyBody)
              : ListView(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                  children: [
                    SizedBox(height: 220, child: AppImage(s.image)),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        gutter,
                        AppSpacing.lg,
                        gutter,
                        0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Eyebrow(s.city),
                          Text(s.name, style: text.displaySmall),
                          const SizedBox(height: AppSpacing.md),
                          AppPanel(
                            children: [
                              ListTile(
                                leading: Icon(
                                  Icons.location_on_outlined,
                                  color: c.accent,
                                ),
                                title: Text(s.address),
                                trailing: IconButton(
                                  tooltip: l10n.actionCopy,
                                  icon: const Icon(
                                    Icons.copy_rounded,
                                    size: 18,
                                  ),
                                  onPressed: () async {
                                    await Clipboard.setData(
                                      ClipboardData(text: s.address),
                                    );
                                    if (context.mounted) {
                                      showToast(
                                        context,
                                        l10n.contactCopied(s.address),
                                      );
                                    }
                                  },
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.schedule_rounded,
                                  color: c.accent,
                                ),
                                title: Text(s.hours),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.call_outlined,
                                  color: c.accent,
                                ),
                                title: Text(s.phone),
                                onTap: () => Launch.phone(s.phone),
                              ),
                            ],
                          ),
                          if (s.services.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.lg),
                            Eyebrow(l10n.storeServices),
                            const SizedBox(height: AppSpacing.xs),
                            Wrap(
                              spacing: AppSpacing.xs,
                              runSpacing: AppSpacing.xs,
                              children: [
                                for (final v in s.services) AppChip(label: v),
                              ],
                            ),
                          ],
                          const SizedBox(height: AppSpacing.lg),
                          FilledButton.icon(
                            onPressed: () => Launch.maps(
                              s.latitude,
                              s.longitude,
                              label: s.name,
                            ),
                            icon: const Icon(
                              Icons.directions_outlined,
                              size: 18,
                            ),
                            label: Text(l10n.storeDirections),
                          ),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/locale_provider.dart';
import '../../core/media/app_image.dart';
import '../../core/media/image_ref.dart';
import '../../core/motion/motion.dart';
import '../../core/router/app_routes.dart';
import '../../core/tenant/tenant_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_mode_provider.dart';
import '../../core/theme/tokens.dart';
import '../../data/repository_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_art.dart';
import '../../shared/widgets/eyebrow.dart';
import '../../shared/widgets/press_scale.dart';
import '../../shared/widgets/skeleton.dart';
import '../../shared/widgets/staggered_reveal.dart';

/// The side menu (survey §1): tinted banner, avatar with gold ring, "Shop
/// for" audience tiles, category list, utility rows, dark-mode pill, sign out.
/// Rows slide in from the leading edge, staggered.
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final locale = ref.watch(localeProvider);
    final categories = ref.watch(categoriesProvider);
    var row = 0;

    void go(String path) {
      Navigator.of(context).pop();
      context.push(path);
    }

    Widget reveal(Widget child) =>
        StaggeredReveal(index: row++, axis: Axis.horizontal, rise: 14, child: child);

    return Drawer(
      width: 300,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const _DrawerBanner(),
          const SizedBox(height: AppSpacing.md),
          reveal(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppLayout.gutter),
              child: Eyebrow(l10n.drawerShopFor),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          reveal(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppLayout.gutter),
              child: Builder(
                builder: (context) {
                  final tiles = [
                    (l10n.audienceWomen, 'women', 'asset://images/ui/women.png'),
                    (l10n.audienceMen, 'men', 'asset://images/ui/men.png'),
                    (l10n.audienceKids, 'kids', 'asset://images/ui/kid.jpg'),
                  ];
                  return Row(
                    children: [
                      for (var i = 0; i < tiles.length; i++) ...[
                        if (i > 0) const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: _AudienceTile(
                            label: tiles[i].$1,
                            image: ImageRef.fromString(tiles[i].$3),
                            onTap: () => go(
                              AppRoutes.categoryPath(
                                'all',
                                audience: tiles[i].$2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          reveal(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppLayout.gutter),
              child: Eyebrow(l10n.drawerJewellery),
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          ...categories.when(
            loading: () => [
              for (var i = 0; i < 8; i++)
                const ListTile(
                  leading: Skeleton.circle(size: 28),
                  title: Skeleton(height: 12, width: 120),
                ),
            ],
            error: (_, __) => const [],
            data: (list) => [
              for (final cat in list)
                reveal(
                  ListTile(
                    dense: true,
                    leading: ClipOval(
                      child: AppImage(cat.icon, width: 28, height: 28),
                    ),
                    title: Text(cat.name.resolve(locale)),
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: c.textMuted,
                      size: 20,
                    ),
                    onTap: () => go(AppRoutes.categoryPath(cat.id)),
                  ),
                ),
            ],
          ),
          const Divider(height: AppSpacing.lg),
          for (final item in [
            (Icons.inventory_2_outlined, l10n.drawerOrders, AppRoutes.orders),
            (Icons.trending_up_rounded, l10n.drawerGoldRates, AppRoutes.goldRates),
            (Icons.chat_bubble_outline_rounded, l10n.drawerContact, AppRoutes.contact),
            (Icons.settings_outlined, l10n.drawerSettings, AppRoutes.settings),
          ])
            reveal(
              ListTile(
                dense: true,
                leading: Icon(item.$1, size: 22),
                title: Text(item.$2),
                onTap: () {
                  Navigator.of(context).pop();
                  if (item.$3 == AppRoutes.settings) {
                    context.go(item.$3);
                  } else {
                    context.push(item.$3);
                  }
                },
              ),
            ),
          reveal(const _DarkModeRow()),
          reveal(
            ListTile(
              dense: true,
              leading: const Icon(Icons.logout_rounded, size: 22, color: AppColors.danger),
              title: Text(
                l10n.drawerSignOut,
                style: const TextStyle(color: AppColors.danger),
              ),
              // Auth lands in C2; the row is present so the layout is final.
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppLayout.gutter),
            child: Text(
              l10n.homeDemoNote,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerBanner extends ConsumerWidget {
  const _DrawerBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final tenant = ref.watch(tenantProvider).valueOrNull;
    return Container(
      decoration: BoxDecoration(color: c.bannerGround, gradient: c.bannerGradient),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            top: -30,
            child: Opacity(
              opacity: .55,
              child: AppArt.filigreeCorner(color: c.accent, size: 190),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppLayout.gutter,
                AppSpacing.lg,
                AppLayout.gutter,
                AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: c.accent.withValues(alpha: .75),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: AppImage(
                        ImageRef.fromString('asset://images/ui/avtr2.png'),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.drawerGuest,
                    style: text.headlineSmall!.copyWith(
                      color: AppColors.bannerInk,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.drawerGuestHint,
                    style: text.bodySmall!.copyWith(
                      color: AppColors.bannerInkSoft,
                    ),
                  ),
                  if (tenant != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Container(height: 1, color: c.bannerHairline),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      tenant.brandName,
                      style: text.labelMedium!.copyWith(
                        color: AppColors.bannerInkFaint,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AudienceTile extends StatelessWidget {
  const _AudienceTile({
    required this.label,
    required this.image,
    required this.onTap,
  });

  final String label;
  final ImageRef image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return PressScale(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: AppRadius.circular(AppRadius.sm),
          child: Stack(
            fit: StackFit.expand,
            children: [
              AppImage(image),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, c.scrim],
                  ),
                ),
              ),
              Positioned(
                left: 8,
                bottom: 6,
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: AppColors.bannerInk,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The 38×22 pill switch with an 18px knob and spring easing.
class _DarkModeRow extends ConsumerWidget {
  const _DarkModeRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    ref.watch(themeModeProvider);
    final isDark = ref.read(themeModeProvider.notifier).isDark(context);
    return ListTile(
      dense: true,
      leading: Icon(isDark ? Icons.dark_mode_rounded : Icons.dark_mode_outlined, size: 22),
      title: Text(l10n.drawerDarkMode),
      onTap: () => ref
          .read(themeModeProvider.notifier)
          .set(isDark ? ThemeMode.light : ThemeMode.dark),
      trailing: AnimatedContainer(
        duration: AppMotion.of(context, AppMotion.normal),
        curve: AppMotion.spring,
        width: 38,
        height: 22,
        padding: const EdgeInsets.all(2),
        alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
        decoration: BoxDecoration(
          color: isDark ? c.primary : c.borderStrong,
          borderRadius: AppRadius.circular(AppRadius.pill),
        ),
        child: Container(
          width: 18,
          height: 18,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

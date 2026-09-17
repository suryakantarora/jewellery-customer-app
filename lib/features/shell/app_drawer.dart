import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../core/media/app_image.dart';
import '../../core/media/image_ref.dart';
import '../../core/motion/motion.dart';
import '../../core/router/app_routes.dart';
import '../../core/session/session_provider.dart';
import '../../core/tenant/tenant_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_mode_provider.dart';
import '../../core/theme/tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/banner_ground.dart';
import '../../shared/widgets/eyebrow.dart';
import '../../shared/widgets/press_scale.dart';
import '../../shared/widgets/staggered_reveal.dart';
import '../cart/cart_provider.dart';
import '../notifications/notifications_provider.dart';

/// One entry of the "Browse" list: a bundled monoline icon, a label and
/// where it goes.
class DrawerMenuEntry {
  const DrawerMenuEntry({
    required this.icon,
    required this.label,
    required this.path,
    this.isTab = false,
  });

  /// File name under `assets/art/menu/`.
  final String icon;
  final String Function(AppL10n) label;
  final String path;

  /// Tabs are switched with `go`; everything else is pushed.
  final bool isTab;

  static final entries = <DrawerMenuEntry>[
    DrawerMenuEntry(
      icon: 'all-jewellery',
      label: (l) => l.menuAllJewellery,
      path: AppRoutes.categoryPath('all'),
    ),
    DrawerMenuEntry(
      icon: 'gold',
      label: (l) => l.menuGold,
      path: AppRoutes.categoryPath('all', metal: 'Gold'),
    ),
    DrawerMenuEntry(
      icon: 'diamond',
      label: (l) => l.menuDiamond,
      path: AppRoutes.categoryPath('all', metal: 'Diamond'),
    ),
    DrawerMenuEntry(
      icon: 'silver',
      label: (l) => l.menuSilver,
      path: AppRoutes.categoryPath('all', metal: 'Silver'),
    ),
    DrawerMenuEntry(
      icon: 'platinum',
      label: (l) => l.menuPlatinum,
      path: AppRoutes.categoryPath('all', metal: 'Platinum'),
    ),
    DrawerMenuEntry(
      icon: 'coins-bars',
      label: (l) => l.menuCoinsBars,
      path: AppRoutes.categoryPath('coins'),
    ),
    DrawerMenuEntry(
      icon: 'solitaire',
      label: (l) => l.menuSolitaire,
      path: AppRoutes.categoryPath('all', tag: 'solitaire'),
    ),
    DrawerMenuEntry(
      icon: 'collections',
      label: (l) => l.menuCollections,
      path: AppRoutes.collections,
      isTab: true,
    ),
    DrawerMenuEntry(
      icon: 'gift-store',
      label: (l) => l.menuGiftStore,
      path: AppRoutes.categoryPath('all', tag: 'gift'),
    ),
    DrawerMenuEntry(
      icon: 'offers',
      label: (l) => l.menuOffers,
      path: AppRoutes.offers,
    ),
  ];
}

/// The side menu: the jeweller's ground banner, "Shop for" portrait tiles,
/// the ten-entry browse list with monoline gold icons, utility rows,
/// dark-mode pill, sign out. Rows slide in from the leading edge, staggered.
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final unread = ref.watch(unreadNotificationsProvider);
    var row = 0;

    void go(String path, {bool isTab = false}) {
      Navigator.of(context).pop();
      if (isTab) {
        context.go(path);
      } else {
        context.push(path);
      }
    }

    Widget reveal(Widget child) => StaggeredReveal(
      index: row++,
      axis: Axis.horizontal,
      rise: 14,
      child: child,
    );

    Widget eyebrow(String text) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppLayout.gutter),
      child: Eyebrow(text),
    );

    return Drawer(
      width: 304,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const _DrawerBanner(),
          const SizedBox(height: AppSpacing.md),
          reveal(eyebrow(l10n.drawerShopFor)),
          const SizedBox(height: AppSpacing.sm),
          reveal(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppLayout.gutter),
              child: Row(
                children: [
                  for (final (i, tile) in [
                    (
                      l10n.audienceWomen,
                      'women',
                      'asset://art/audience/women.svg',
                    ),
                    (l10n.audienceMen, 'men', 'asset://art/audience/men.svg'),
                    (l10n.audienceKids, 'kids', 'asset://art/audience/kids.svg'),
                  ].indexed) ...[
                    if (i > 0) const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _AudienceTile(
                        label: tile.$1,
                        image: ImageRef.fromString(tile.$3),
                        onTap: () => go(
                          AppRoutes.categoryPath('all', audience: tile.$2),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          reveal(eyebrow(l10n.drawerBrowse)),
          const SizedBox(height: AppSpacing.xxs),
          for (final entry in DrawerMenuEntry.entries)
            reveal(
              _MenuRow(
                icon: entry.icon,
                label: entry.label(l10n),
                onTap: () => go(entry.path, isTab: entry.isTab),
              ),
            ),
          const Divider(height: AppSpacing.lg),
          for (final item in [
            (
              Icons.inventory_2_outlined,
              l10n.drawerOrders,
              AppRoutes.orders,
              0,
            ),
            (
              Icons.notifications_none_rounded,
              l10n.drawerNotifications,
              AppRoutes.notifications,
              unread,
            ),
            (
              Icons.trending_up_rounded,
              l10n.drawerGoldRates,
              AppRoutes.goldRates,
              0,
            ),
            (Icons.storefront_outlined, l10n.drawerStores, AppRoutes.stores, 0),
            (
              Icons.chat_bubble_outline_rounded,
              l10n.drawerContact,
              AppRoutes.contact,
              0,
            ),
            (
              Icons.settings_outlined,
              l10n.drawerSettings,
              AppRoutes.settings,
              0,
            ),
          ])
            reveal(
              ListTile(
                dense: true,
                leading: Icon(item.$1, size: 22),
                title: Text(item.$2),
                trailing: item.$4 > 0
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: c.primary,
                          borderRadius: AppRadius.circular(AppRadius.pill),
                        ),
                        child: Text(
                          '${item.$4}',
                          style: Theme.of(context).textTheme.labelSmall!
                              .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      )
                    : null,
                onTap: () => go(item.$3, isTab: item.$3 == AppRoutes.settings),
              ),
            ),
          reveal(const _DarkModeRow()),
          reveal(
            ListTile(
              dense: true,
              leading: Icon(
                ref.watch(isSignedInProvider)
                    ? Icons.logout_rounded
                    : Icons.login_rounded,
                size: 22,
                color: ref.watch(isSignedInProvider)
                    ? AppColors.danger
                    : c.primary,
              ),
              title: Text(
                ref.watch(isSignedInProvider)
                    ? l10n.drawerSignOut
                    : l10n.authSignInWithPhone,
                style: TextStyle(
                  color: ref.watch(isSignedInProvider)
                      ? AppColors.danger
                      : c.primary,
                ),
              ),
              onTap: () async {
                Navigator.of(context).pop();
                if (ref.read(isSignedInProvider)) {
                  await ref.read(cartProvider.notifier).clear();
                  await ref.read(sessionProvider.notifier).signOut();
                }
                if (context.mounted) context.go(AppRoutes.welcome);
              },
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

/// A browse row: monoline icon in a soft accent disc, label, chevron.
class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ListTile(
      dense: true,
      leading: MenuIcon(name: icon),
      title: Text(label),
      trailing: Icon(Icons.chevron_right_rounded, color: c.textMuted, size: 20),
      onTap: onTap,
    );
  }
}

/// One of the bundled `assets/art/menu/*.svg` icons on a soft accent disc.
class MenuIcon extends StatelessWidget {
  const MenuIcon({super.key, required this.name, this.size = 32});

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * .2),
      decoration: BoxDecoration(
        color: c.accentSoft.withValues(alpha: c.isDark ? .8 : 1),
        shape: BoxShape.circle,
        border: Border.all(color: c.accent.withValues(alpha: .35), width: .8),
      ),
      child: SvgPicture.asset(
        'assets/art/menu/$name.svg',
        colorFilter: ColorFilter.mode(
          c.isDark ? c.accent : c.primaryDark,
          BlendMode.srcIn,
        ),
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
    final account = ref.watch(accountProvider);
    return BannerGround(
      hairline: true,
      filigreeSize: 200,
      child: SafeArea(
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
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      c.bannerGold,
                      c.bannerGold.withValues(alpha: .35),
                      c.bannerGold,
                      c.bannerGold.withValues(alpha: .35),
                      c.bannerGold,
                    ],
                  ),
                  boxShadow: AppShadows.sm(c.shadow),
                ),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: c.bannerGround,
                  ),
                  child: ClipOval(
                    child: AppImage(
                      account == null || account.avatar.isEmpty
                          ? ImageRef.fromString('asset://images/ui/avtr2.png')
                          : account.avatar,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                account?.name ?? l10n.drawerGuest,
                style: text.headlineSmall!.copyWith(color: c.bannerInk),
              ),
              const SizedBox(height: 2),
              Text(
                account?.phone ?? l10n.drawerGuestHint,
                style: text.bodySmall!.copyWith(color: c.bannerInkSoft),
              ),
              if (tenant != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        c.bannerHairline,
                        c.bannerHairline.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  tenant.brandName.toUpperCase(),
                  style: text.labelSmall!.copyWith(
                    color: c.bannerInkFaint,
                    letterSpacing: AppType.tracking(
                      AppType.xxs,
                      AppType.trackWidest,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A portrait tile: the photo in a tall rounded frame with a gold hairline,
/// a soft scrim and the audience name set as an eyebrow with a short rule.
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
        aspectRatio: .78,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: AppRadius.circular(AppRadius.md),
            border: Border.all(color: c.accent.withValues(alpha: .45)),
            boxShadow: AppShadows.sm(c.shadow),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AppImage(image, alignment: Alignment.topCenter),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [.35, 1],
                    colors: [Colors.transparent, c.scrim],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: AppColors.photoInk,
                        fontWeight: FontWeight.w600,
                        letterSpacing: AppType.tracking(
                          AppType.xxs,
                          AppType.trackWider,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Container(width: 18, height: 1, color: c.bannerGold),
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
      leading: Icon(
        isDark ? Icons.dark_mode_rounded : Icons.dark_mode_outlined,
        size: 22,
      ),
      title: Text(l10n.drawerDarkMode),
      onTap: () => ref
          .read(themeModeProvider.notifier)
          .set(isDark ? ThemeMode.light : ThemeMode.dark),
      trailing: Semantics(
        toggled: isDark,
        label: l10n.drawerDarkMode,
        child: AnimatedContainer(
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/l10n/locale_provider.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/motion/motion.dart';
import '../../core/providers.dart';
import '../../core/router/app_routes.dart';
import '../../core/tenant/tenant_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/palettes.dart';
import '../../core/theme/theme_mode_provider.dart';
import '../../core/theme/tokens.dart';
import '../../data/repository_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_chip.dart';
import '../../shared/widgets/app_panel.dart';
import '../../shared/widgets/app_toast.dart';
import '../../shared/widgets/eyebrow.dart';
import '../../shared/widgets/press_scale.dart';
import '../../shared/widgets/skeleton.dart';
import '../policies/policy_screen.dart';
import '../shell/fino_header.dart';

/// Settings (survey: SettingsPage): theme swatches, dark mode, language,
/// Shopping rows, Policies grid, Support rows, dev tools, brand footer.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final offered = ref.watch(offeredLocalesProvider);
    final config = ref.watch(appConfigProvider);
    final tenantKey = ref.watch(tenantKeyProvider);
    final tenant = ref.watch(tenantProvider).valueOrNull;
    final policies = ref.watch(policiesProvider);
    final gutter = Breakpoints.gutter(context);
    final showPicker =
        (tenant?.flag('themePicker', orElse: true) ?? true) &&
        (tenant?.allowedPalettes.isNotEmpty ?? false);

    Widget row(
      IconData icon,
      String title,
      VoidCallback onTap, {
      String? subtitle,
    }) => ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle),
      trailing: Icon(Icons.chevron_right_rounded, color: c.textMuted),
      onTap: onTap,
    );

    return Scaffold(
      appBar: FinoHeader.page(title: l10n.settingsTitle),
      body: ContentWidth(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: gutter,
            vertical: AppSpacing.lg,
          ),
          children: [
            Eyebrow(l10n.settingsAppearance),
            const SizedBox(height: AppSpacing.sm),
            AppPanel(
              children: [
                if (showPicker) ...[
                  ListTile(
                    leading: const Icon(Icons.palette_outlined),
                    title: Text(l10n.settingsTheme),
                    subtitle: Text(l10n.settingsThemeSub),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      0,
                      AppSpacing.md,
                      AppSpacing.md,
                    ),
                    child: _ThemePicker(
                      allowed: tenant!.allowedPalettes,
                      activeId: tenant.paletteId,
                    ),
                  ),
                  const Divider(),
                ],
                ListTile(
                  leading: const Icon(Icons.dark_mode_outlined),
                  title: Text(l10n.settingsDarkMode),
                  subtitle: Text(l10n.settingsDarkModeSub),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    0,
                    AppSpacing.md,
                    AppSpacing.md,
                  ),
                  child: Wrap(
                    spacing: AppSpacing.xs,
                    children: [
                      for (final entry in [
                        (
                          ThemeMode.light,
                          l10n.settingsThemeLight,
                          Icons.light_mode_outlined,
                        ),
                        (
                          ThemeMode.dark,
                          l10n.settingsThemeDark,
                          Icons.dark_mode_outlined,
                        ),
                        (
                          ThemeMode.system,
                          l10n.settingsThemeSystem,
                          Icons.phone_iphone_rounded,
                        ),
                      ])
                        AppChip(
                          label: entry.$2,
                          leading: Icon(entry.$3),
                          active: themeMode == entry.$1,
                          onTap: () => ref
                              .read(themeModeProvider.notifier)
                              .set(entry.$1),
                        ),
                    ],
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.language_rounded),
                  title: Text(l10n.settingsLanguage),
                  subtitle: Text(l10n.settingsLanguageSub),
                ),
                for (final l in offered)
                  ListTile(
                    dense: true,
                    leading: const SizedBox(width: 24),
                    title: Text(
                      localeNativeNames[l.languageCode] ?? l.languageCode,
                    ),
                    subtitle: Text(localeEnglishNames[l.languageCode] ?? ''),
                    trailing: l == locale
                        ? Icon(Icons.check_rounded, color: c.primary)
                        : null,
                    onTap: () => ref.read(localeProvider.notifier).set(l),
                  ),
                const SizedBox(height: AppSpacing.xs),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Eyebrow(l10n.settingsShopping),
            const SizedBox(height: AppSpacing.sm),
            AppPanel(
              children: [
                row(
                  Icons.local_shipping_outlined,
                  l10n.settingsTrackOrder,
                  () => context.push(AppRoutes.orders),
                ),
                row(
                  Icons.trending_up_rounded,
                  l10n.drawerGoldRates,
                  () => context.push(AppRoutes.goldRates),
                ),
                row(
                  Icons.straighten_rounded,
                  l10n.settingsSizeGuide,
                  () => context.push(AppRoutes.sizeGuidePath('ring')),
                ),
                row(
                  Icons.location_on_outlined,
                  l10n.addressesTitle,
                  () => context.push(AppRoutes.addresses),
                ),
                row(
                  Icons.local_offer_outlined,
                  l10n.menuOffers,
                  () => context.push(AppRoutes.offers),
                ),
                row(
                  Icons.notifications_none_rounded,
                  l10n.drawerNotifications,
                  () => context.push(AppRoutes.notifications),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Eyebrow(l10n.settingsPolicies),
            const SizedBox(height: AppSpacing.sm),
            policies.when(
              loading: () => const Skeleton(height: 150, radius: AppRadius.md),
              error: (_, __) => const SizedBox.shrink(),
              data: (docs) => GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: Breakpoints.isPhone(context) ? 3 : 6,
                  mainAxisSpacing: AppSpacing.xs,
                  crossAxisSpacing: AppSpacing.xs,
                  mainAxisExtent: 84,
                ),
                itemCount: docs.length,
                itemBuilder: (context, i) => PressScale(
                  onTap: () => context.push(AppRoutes.policyPath(docs[i].key)),
                  child: Container(
                    decoration: BoxDecoration(
                      color: c.card,
                      borderRadius: AppRadius.circular(AppRadius.md),
                      border: Border.all(color: c.border),
                    ),
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          policyIcon(docs[i].icon),
                          color: c.accent,
                          size: 22,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          docs[i].title,
                          style: text.labelMedium,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Eyebrow(l10n.settingsSupport),
            const SizedBox(height: AppSpacing.sm),
            AppPanel(
              children: [
                row(
                  Icons.rate_review_outlined,
                  l10n.settingsFeedback,
                  () => context.push(AppRoutes.feedback),
                ),
                row(
                  Icons.star_outline_rounded,
                  l10n.settingsRateUs,
                  () => context.push(AppRoutes.rateUs),
                ),
                row(
                  Icons.chat_bubble_outline_rounded,
                  l10n.drawerContact,
                  () => context.push(AppRoutes.contact),
                ),
                row(
                  Icons.storefront_outlined,
                  l10n.drawerStores,
                  () => context.push(AppRoutes.stores),
                ),
                row(
                  Icons.ios_share_rounded,
                  l10n.settingsShare,
                  () => _share(context, ref),
                ),
                row(
                  Icons.slideshow_rounded,
                  l10n.settingsTour,
                  () => context.push(AppRoutes.tutorial),
                ),
                row(
                  Icons.info_outline_rounded,
                  l10n.settingsAbout,
                  () => context.push(AppRoutes.about),
                ),
              ],
            ),
            if (config.environment.allowsDeveloperTools) ...[
              const SizedBox(height: AppSpacing.lg),
              Eyebrow(l10n.settingsDeveloper),
              const SizedBox(height: AppSpacing.sm),
              AppPanel(
                children: [
                  ListTile(
                    leading: const Icon(Icons.storefront_outlined),
                    title: Text(l10n.settingsShopCode),
                    subtitle: Text(l10n.settingsShopCodeSub(tenantKey)),
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: c.textMuted,
                    ),
                    onTap: () => context.push(AppRoutes.shopCode),
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.dns_outlined),
                    title: Text(l10n.settingsDataMode(config.dataMode.name)),
                    subtitle: Text(
                      '${config.environment.shortCode} · ${config.apiBaseUrl}',
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.xxl),
            Center(
              child: Column(
                children: [
                  Text(
                    tenant?.brandMark ?? '',
                    style: text.headlineMedium!.copyWith(
                      letterSpacing: AppType.tracking(
                        AppType.xl,
                        AppType.trackWide,
                      ),
                    ),
                  ),
                  Text(tenant?.brandName ?? '', style: text.bodySmall),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(l10n.settingsVersion('0.1.0'), style: text.labelSmall),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    l10n.homeDemoNote,
                    style: text.labelSmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppLayout.tabBarHeight),
          ],
        ),
      ),
    );
  }

  Future<void> _share(BuildContext context, WidgetRef ref) async {
    final l10n = AppL10n.of(context);
    final tenant = ref.read(tenantProvider).valueOrNull;
    final url = tenant?.storefrontUrl;
    try {
      await SharePlus.instance.share(
        ShareParams(
          text: l10n.settingsShareText(tenant?.brandName ?? '', url ?? ''),
          subject: tenant?.brandName,
        ),
      );
    } on Object {
      if (context.mounted) showToast(context, l10n.settingsShareFailed);
    }
  }
}

/// Six swatch cards (three colour chips, name, description, check when
/// active) → toast "Theme applied".
class _ThemePicker extends ConsumerWidget {
  const _ThemePicker({required this.allowed, required this.activeId});

  final List<String> allowed;
  final String activeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final pairs = [
      for (final id in allowed)
        if (FallbackPalettes.byId(id) case final p?) p,
    ];
    final columns = Breakpoints.isPhone(context) ? 2 : 3;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: AppSpacing.xs,
        crossAxisSpacing: AppSpacing.xs,
        mainAxisExtent: 92,
      ),
      itemCount: pairs.length,
      itemBuilder: (context, i) {
        final p = pairs[i];
        final active = p.id == activeId;
        final light = p.light;
        return PressScale(
          onTap: () async {
            await ref.read(tenantProvider.notifier).choosePalette(p.id);
            if (context.mounted) showToast(context, l10n.settingsThemeApplied);
          },
          child: AnimatedContainer(
            duration: AppMotion.of(context, AppMotion.normal),
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: c.card,
              borderRadius: AppRadius.circular(AppRadius.md),
              border: Border.all(
                color: active ? c.primary : c.border,
                width: active ? 1.5 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    for (final swatch in [
                      light.primary,
                      light.accent,
                      light.primaryLight,
                    ])
                      Container(
                        width: 18,
                        height: 18,
                        margin: const EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                          color: swatch,
                          shape: BoxShape.circle,
                          border: Border.all(color: c.border),
                        ),
                      ),
                    const Spacer(),
                    if (active)
                      Icon(
                        Icons.check_circle_rounded,
                        size: 18,
                        color: c.primary,
                      ),
                  ],
                ),
                const Spacer(),
                Text(
                  _name(l10n, p.id),
                  style: text.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _description(l10n, p.id),
                  style: text.labelSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static String _name(AppL10n l10n, String id) => switch (id) {
    'ruby' => l10n.themeRuby,
    'burgundy' => l10n.themeBurgundy,
    'emerald' => l10n.themeEmerald,
    'sapphire' => l10n.themeSapphire,
    'rose' => l10n.themeRose,
    'black' => l10n.themeBlack,
    _ => id,
  };

  static String _description(AppL10n l10n, String id) => switch (id) {
    'ruby' => l10n.themeRubySub,
    'burgundy' => l10n.themeBurgundySub,
    'emerald' => l10n.themeEmeraldSub,
    'sapphire' => l10n.themeSapphireSub,
    'rose' => l10n.themeRoseSub,
    'black' => l10n.themeBlackSub,
    _ => '',
  };
}

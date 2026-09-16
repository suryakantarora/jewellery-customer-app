import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/locale_provider.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/providers.dart';
import '../../core/router/app_routes.dart';
import '../../core/tenant/tenant_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_mode_provider.dart';
import '../../core/theme/tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_chip.dart';
import '../../shared/widgets/app_panel.dart';
import '../../shared/widgets/eyebrow.dart';
import '../shell/fino_header.dart';

/// C1 subset of Settings: dark mode, language, the dev shop-code entry, and
/// the tenant brand in the footer. Theme picker and content rows are C7.
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
    final gutter = Breakpoints.gutter(context);

    return Scaffold(
      appBar: FinoHeader.page(title: l10n.settingsTitle),
      body: ContentWidth(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: gutter, vertical: AppSpacing.lg),
          children: [
            Eyebrow(l10n.settingsAppearance),
            const SizedBox(height: AppSpacing.sm),
            AppPanel(
              children: [
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
                        (ThemeMode.light, l10n.settingsThemeLight, Icons.light_mode_outlined),
                        (ThemeMode.dark, l10n.settingsThemeDark, Icons.dark_mode_outlined),
                        (ThemeMode.system, l10n.settingsThemeSystem, Icons.phone_iphone_rounded),
                      ])
                        AppChip(
                          label: entry.$2,
                          leading: Icon(entry.$3),
                          active: themeMode == entry.$1,
                          onTap: () =>
                              ref.read(themeModeProvider.notifier).set(entry.$1),
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
                    title: Text(localeNativeNames[l.languageCode] ?? l.languageCode),
                    subtitle: Text(localeEnglishNames[l.languageCode] ?? ''),
                    trailing: l == locale
                        ? Icon(Icons.check_rounded, color: c.primary)
                        : null,
                    onTap: () => ref.read(localeProvider.notifier).set(l),
                  ),
                const SizedBox(height: AppSpacing.xs),
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
                    trailing: Icon(Icons.chevron_right_rounded, color: c.textMuted),
                    onTap: () => context.push(AppRoutes.shopCode),
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.dns_outlined),
                    title: Text(l10n.settingsDataMode(config.dataMode.name)),
                    subtitle: Text('${config.environment.shortCode} · ${config.apiBaseUrl}'),
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
                      letterSpacing: AppType.tracking(AppType.xl, AppType.trackWide),
                    ),
                  ),
                  Text(tenant?.brandName ?? '', style: text.bodySmall),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(l10n.settingsVersion('0.1.0'), style: text.labelSmall),
                ],
              ),
            ),
            const SizedBox(height: AppLayout.tabBarHeight),
          ],
        ),
      ),
    );
  }
}

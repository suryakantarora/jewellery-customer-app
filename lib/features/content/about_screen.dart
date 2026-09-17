import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/layout/breakpoints.dart';
import '../../core/media/app_image.dart';
import '../../core/router/app_routes.dart';
import '../../core/tenant/tenant_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../data/repository_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/eyebrow.dart';
import '../../shared/widgets/gold_rule.dart';
import '../../shared/widgets/scrim.dart';
import '../../shared/widgets/skeleton.dart';
import '../../shared/widgets/staggered_reveal.dart';
import '../shell/fino_header.dart';

/// About us (survey: ContentPage): hero photo, stat row, prose sections,
/// and a "Visit us" link to the stores.
class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final tenant = ref.watch(tenantProvider).valueOrNull;
    final about = ref.watch(aboutProvider);
    final gutter = Breakpoints.gutter(context);

    return Scaffold(
      appBar: FinoHeader.page(title: l10n.settingsAbout),
      body: ContentWidth(
        child: about.when(
          loading: () => ListView(
            padding: EdgeInsets.all(gutter),
            children: const [
              Skeleton(height: 220, radius: AppRadius.lg),
              SizedBox(height: AppSpacing.md),
              SkeletonLines(lines: 8),
            ],
          ),
          error: (_, __) =>
              ErrorState(onRetry: () => ref.invalidate(aboutProvider)),
          data: (a) => ListView(
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            children: [
              SizedBox(
                height: 240,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AppImage(a.hero),
                    const Scrim(stops: [.2, 1], strength: 1.4),
                    Positioned(
                      left: gutter,
                      right: gutter,
                      bottom: AppSpacing.lg,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Eyebrow(
                            l10n.aboutEyebrow(a.founded),
                            color: c.accent,
                          ),
                          Text(
                            tenant?.brandName ?? '',
                            style: text.displayMedium!.copyWith(
                              color: AppColors.photoInk,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          GoldRule(color: c.accent),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(gutter, AppSpacing.lg, gutter, 0),
                child: Text(
                  a.intro,
                  style: text.bodyLarge!.copyWith(
                    fontFamily: text.headlineSmall!.fontFamily,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(gutter, AppSpacing.lg, gutter, 0),
                child: Wrap(
                  spacing: AppSpacing.lg,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final s in a.stats)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.value,
                            style: text.headlineMedium!.copyWith(
                              color: c.primaryDark,
                            ),
                          ),
                          Text(s.label.toUpperCase(), style: text.labelSmall),
                        ],
                      ),
                  ],
                ),
              ),
              for (final (i, s) in a.sections.indexed)
                StaggeredReveal(
                  index: i,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      gutter,
                      AppSpacing.xl,
                      gutter,
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (i + 1).toString().padLeft(2, '0'),
                          style: text.labelSmall!.copyWith(color: c.accent),
                        ),
                        Text(s.heading, style: text.headlineSmall),
                        const SizedBox(height: AppSpacing.xs),
                        Text(s.body, style: text.bodyMedium),
                      ],
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.fromLTRB(gutter, AppSpacing.xl, gutter, 0),
                child: FilledButton.icon(
                  onPressed: () => context.push(AppRoutes.stores),
                  icon: const Icon(Icons.storefront_outlined, size: 18),
                  label: Text(l10n.aboutVisit),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

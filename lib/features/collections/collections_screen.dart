import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/locale_provider.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/media/app_image.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../data/repository_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_chip.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/eyebrow.dart';
import '../../shared/widgets/gold_rule.dart';
import '../../shared/widgets/press_scale.dart';
import '../../shared/widgets/skeleton.dart';
import '../../shared/widgets/staggered_reveal.dart';
import '../shell/fino_header.dart';

/// Editorial list of the categories (survey: CollectionsPage).
class CollectionsScreen extends ConsumerWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final locale = ref.watch(localeProvider);
    final categories = ref.watch(categoriesProvider);
    final gutter = Breakpoints.gutter(context);

    return Scaffold(
      appBar: const FinoHeader.brand(),
      body: ContentWidth(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: gutter, vertical: AppSpacing.lg),
          children: [
            Eyebrow(l10n.collectionsEyebrow),
            const SizedBox(height: AppSpacing.xxs),
            Text(l10n.collectionsTitle, style: text.displayMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.collectionsSubtitle,
              style: text.bodyMedium!.copyWith(color: c.textSecondary),
            ),
            const SizedBox(height: AppSpacing.sm),
            const GoldRule(),
            const SizedBox(height: AppSpacing.lg),
            ...categories.when(
              loading: () => [
                for (var i = 0; i < 8; i++)
                  const Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Skeleton(height: 96, radius: AppRadius.md),
                  ),
              ],
              error: (_, __) => [
                ErrorState(onRetry: () => ref.invalidate(categoriesProvider)),
              ],
              data: (list) => [
                for (var i = 0; i < list.length; i++)
                  StaggeredReveal(
                    index: i,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: PressScale(
                        onTap: () =>
                            context.push(AppRoutes.categoryPath(list[i].id)),
                        child: Container(
                          height: 96,
                          decoration: BoxDecoration(
                            borderRadius: AppRadius.circular(AppRadius.md),
                            boxShadow: AppShadows.sm(c.shadow),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              AppImage(list[i].image),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [c.scrim, c.scrim.withValues(alpha: .15)],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      (i + 1).toString().padLeft(2, '0'),
                                      style: text.labelMedium!.copyWith(
                                        color: c.accent,
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.md),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            list[i].name.resolve(locale),
                                            style: text.headlineMedium!
                                                .copyWith(
                                                  color: AppColors.bannerInk,
                                                ),
                                          ),
                                          Text(
                                            list[i].description.resolve(locale),
                                            style: text.bodySmall!.copyWith(
                                              color: AppColors.bannerInkSoft,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    Text(
                                      l10n.piecesCount(list[i].productCount),
                                      style: text.labelSmall!.copyWith(
                                        color: AppColors.bannerInkFaint,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.xs,
                  children: [
                    AppChip(
                      label: l10n.collectionsAll,
                      leading: const Icon(Icons.diamond_outlined),
                      onTap: () =>
                          context.push(AppRoutes.categoryPath('all')),
                    ),
                    AppChip(
                      label: l10n.lookbookTitle,
                      leading: const Icon(Icons.auto_stories_outlined),
                      onTap: () => context.push(AppRoutes.lookbook),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppLayout.tabBarHeight),
          ],
        ),
      ),
    );
  }
}

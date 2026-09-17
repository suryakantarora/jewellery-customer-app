import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format/formatters_provider.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/media/app_image.dart';
import '../../core/motion/motion.dart';
import '../../core/providers.dart';
import '../../core/router/app_routes.dart';
import '../../core/storage/storage_keys.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../data/models/content.dart';
import '../../data/repository_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/rating_stars.dart';
import '../../shared/widgets/skeleton.dart';
import '../../shared/widgets/staggered_reveal.dart';
import '../shell/fino_header.dart';

/// Which stories the customer has liked, persisted.
class StoryLikesController extends Notifier<Set<String>> {
  @override
  Set<String> build() =>
      (ref.read(localStoreProvider).getStringList(StorageKeys.demoStoryLikes) ??
              const [])
          .toSet();

  Future<void> toggle(String id) async {
    state = state.contains(id) ? ({...state}..remove(id)) : {...state, id};
    await ref
        .read(localStoreProvider)
        .setStringList(StorageKeys.demoStoryLikes, state.toList());
  }
}

final storyLikesProvider = NotifierProvider<StoryLikesController, Set<String>>(
  StoryLikesController.new,
);

/// Customer stories (survey: CardsPage): avatar, name + verified, date,
/// stars, product shot with a name tag, body, like button that pops,
/// comment count, "Shop now".
class StoriesScreen extends ConsumerWidget {
  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final stories = ref.watch(storiesProvider);
    final gutter = Breakpoints.gutter(context);
    return Scaffold(
      appBar: FinoHeader.page(title: l10n.storiesTitle),
      body: ContentWidth(
        child: stories.when(
          loading: () => ListView(
            padding: EdgeInsets.all(gutter),
            children: [
              for (var i = 0; i < 3; i++)
                const Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.md),
                  child: Skeleton(height: 320, radius: AppRadius.md),
                ),
            ],
          ),
          error: (_, __) =>
              ErrorState(onRetry: () => ref.invalidate(storiesProvider)),
          data: (list) => ListView.separated(
            padding: EdgeInsets.symmetric(
              horizontal: gutter,
              vertical: AppSpacing.md,
            ),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, i) => StaggeredReveal(
              index: i,
              child: _StoryCard(story: list[i]),
            ),
          ),
        ),
      ),
    );
  }
}

class _StoryCard extends ConsumerWidget {
  const _StoryCard({required this.story});

  final Story story;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final dates = ref.watch(dateFormatterProvider);
    final liked = ref.watch(storyLikesProvider).contains(story.id);
    final likes = story.likes + (liked ? 1 : 0);
    return Container(
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
          ListTile(
            leading: ClipOval(
              child: AppImage(story.avatar, width: 40, height: 40),
            ),
            title: Row(
              children: [
                Flexible(
                  child: Text(
                    story.author,
                    style: text.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (story.verified) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.verified_rounded,
                    size: 14,
                    color: AppColors.success,
                  ),
                ],
              ],
            ),
            subtitle: Text(dates.short(story.date)),
            trailing: RatingStars(rating: story.rating),
          ),
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                AppImage(story.image),
                Positioned(
                  left: AppSpacing.sm,
                  bottom: AppSpacing.sm,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: c.scrim,
                      borderRadius: AppRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      story.productName,
                      style: text.labelMedium!.copyWith(
                        color: AppColors.photoInk,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(story.body, style: text.bodyMedium),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xs,
              0,
              AppSpacing.sm,
              AppSpacing.xs,
            ),
            child: Row(
              children: [
                _LikeButton(
                  liked: liked,
                  onTap: () =>
                      ref.read(storyLikesProvider.notifier).toggle(story.id),
                ),
                Text('$likes', style: text.labelMedium),
                const SizedBox(width: AppSpacing.md),
                Icon(Icons.mode_comment_outlined, size: 18, color: c.textMuted),
                const SizedBox(width: 4),
                Text('${story.comments}', style: text.labelMedium),
                const Spacer(),
                TextButton(
                  onPressed: () =>
                      context.push(AppRoutes.productPath(story.productId)),
                  child: Text(l10n.storiesShopNow),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LikeButton extends StatelessWidget {
  const _LikeButton({required this.liked, required this.onTap});

  final bool liked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return IconButton(
      tooltip: AppL10n.of(context).storiesLike,
      onPressed: onTap,
      icon: TweenAnimationBuilder<double>(
        key: ValueKey(liked),
        tween: Tween(begin: liked ? .6 : 1, end: 1),
        duration: AppMotion.of(context, AppMotion.normal),
        curve: AppMotion.spring,
        builder: (context, v, child) => Transform.scale(scale: v, child: child),
        child: Icon(
          liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: liked ? c.primary : c.textMuted,
          size: 20,
        ),
      ),
    );
  }
}

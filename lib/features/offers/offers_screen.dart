import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format/formatters_provider.dart';
import '../../core/l10n/locale_provider.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/media/app_image.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../data/models/content.dart';
import '../../data/repository_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_toast.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/eyebrow.dart';
import '../../shared/widgets/press_scale.dart';
import '../../shared/widgets/scrim.dart';
import '../../shared/widgets/skeleton.dart';
import '../../shared/widgets/staggered_reveal.dart';
import '../cart/cart_provider.dart';
import '../shell/fino_header.dart';

/// Offers & coupons: a featured hero offer, then coupon cards with a
/// dashed code you can copy or apply straight to the bag.
class OffersScreen extends ConsumerWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final offers = ref.watch(offersProvider);
    final gutter = Breakpoints.gutter(context);
    return Scaffold(
      appBar: FinoHeader.page(title: l10n.menuOffers),
      body: ContentWidth(
        child: offers.when(
          loading: () => ListView(
            padding: EdgeInsets.all(gutter),
            children: [
              for (var i = 0; i < 4; i++)
                const Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Skeleton(height: 120, radius: AppRadius.md),
                ),
            ],
          ),
          error: (_, __) =>
              ErrorState(onRetry: () => ref.invalidate(offersProvider)),
          data: (list) => list.isEmpty
              ? EmptyState(
                  icon: Icons.local_offer_outlined,
                  title: l10n.offersEmptyTitle,
                  body: l10n.offersEmptyBody,
                )
              : ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: gutter,
                    vertical: AppSpacing.md,
                  ),
                  itemCount: list.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, i) => StaggeredReveal(
                    index: i,
                    child: _OfferCard(
                      offer: list[i],
                      hero: i == 0 && list[i].featured,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class _OfferCard extends ConsumerWidget {
  const _OfferCard({required this.offer, required this.hero});

  final Offer offer;
  final bool hero;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final locale = ref.watch(localeProvider);
    final dates = ref.watch(dateFormatterProvider);
    final money = ref.watch(moneyFormatterProvider);
    final applied =
        ref.watch(appliedOfferProvider).valueOrNull?.code == offer.code;

    final value = switch (offer.kind) {
      OfferKind.percent => l10n.offerPercentOff(offer.value.toString()),
      OfferKind.amount => l10n.offerAmountOff(money.format(offer.value)),
      OfferKind.freeDelivery => l10n.offerFreeDelivery,
    };

    Future<void> copy() async {
      await Clipboard.setData(ClipboardData(text: offer.code));
      if (context.mounted) {
        showToast(
          context,
          l10n.offerCopied(offer.code),
          icon: Icons.copy_rounded,
        );
      }
    }

    Future<void> apply() async {
      await ref.read(appliedOfferProvider.notifier).apply(offer.code);
      if (context.mounted) {
        showToast(
          context,
          l10n.cartCouponApplied,
          icon: Icons.local_offer_outlined,
        );
        unawaited(context.push(AppRoutes.cart));
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: AppRadius.circular(AppRadius.md),
        border: Border.all(color: applied ? c.accent : c.border),
        boxShadow: AppShadows.sm(c.shadow),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: hero ? 170 : 110,
            child: Stack(
              fit: StackFit.expand,
              children: [
                AppImage(offer.image),
                const Scrim(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  stops: [0, 1],
                  strength: 1.4,
                ),
                Positioned(
                  left: AppSpacing.md,
                  right: AppSpacing.md,
                  bottom: AppSpacing.sm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Eyebrow(offer.title.resolve(locale), color: c.accent),
                      Text(
                        value,
                        style: (hero ? text.displaySmall : text.headlineMedium)!
                            .copyWith(color: AppColors.photoInk),
                      ),
                      Text(
                        offer.subtitle.resolve(locale),
                        style: text.bodySmall!.copyWith(
                          color: AppColors.photoInkSoft,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Row(
              children: [
                PressScale(
                  onTap: copy,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: c.accentSoft,
                      borderRadius: AppRadius.circular(AppRadius.xs),
                      border: Border.all(color: c.accent.withValues(alpha: .5)),
                    ),
                    child: Row(
                      children: [
                        Text(
                          offer.code,
                          style: text.labelLarge!.copyWith(
                            color: c.accent,
                            letterSpacing: AppType.tracking(
                              AppType.xs,
                              AppType.trackWide,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(Icons.copy_rounded, size: 14, color: c.accent),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (offer.minSubtotal > 0)
                        Text(
                          l10n.offerMinimum(money.format(offer.minSubtotal)),
                          style: text.labelSmall,
                        ),
                      Text(
                        l10n.offerExpires(dates.short(offer.expires)),
                        style: text.labelSmall,
                      ),
                    ],
                  ),
                ),
                applied
                    ? Icon(Icons.check_circle_rounded, color: c.accent)
                    : FilledButton(
                        style: FilledButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                        ),
                        onPressed: apply,
                        child: Text(l10n.cartCouponApply),
                      ),
              ],
            ),
          ),
          if (offer.terms.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sm,
                0,
                AppSpacing.sm,
                AppSpacing.sm,
              ),
              child: Text(offer.terms.join(' · '), style: text.labelSmall),
            ),
        ],
      ),
    );
  }
}

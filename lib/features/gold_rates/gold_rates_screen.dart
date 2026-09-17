import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format/formatters_provider.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/motion/motion.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../data/models/content.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/eyebrow.dart';
import '../../shared/widgets/gold_rule.dart';
import '../../shared/widgets/skeleton.dart';
import '../../shared/widgets/staggered_reveal.dart';
import '../shell/fino_header.dart';
import 'gold_rates_provider.dart';

/// Gold rates (survey: GoldValuePage): live "updated HH:mm:ss" stamp with a
/// pulsing dot, a Purity | LAK | USD | THB table with delta chips that
/// animate in on every 5 s tick, and a disclaimer.
class GoldRatesScreen extends ConsumerWidget {
  const GoldRatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final dates = ref.watch(dateFormatterProvider);
    final sheet = ref.watch(goldRatesProvider);
    final gutter = Breakpoints.gutter(context);

    return Scaffold(
      appBar: FinoHeader.page(title: l10n.drawerGoldRates),
      body: GoldRateDriftDriver(
        child: ContentWidth(
          child: sheet.when(
            loading: () => ListView(
              padding: EdgeInsets.all(gutter),
              children: [
                for (var i = 0; i < 7; i++)
                  const Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.xs),
                    child: Skeleton(height: 44, radius: AppRadius.sm),
                  ),
              ],
            ),
            error: (_, __) => ErrorState(
              onRetry: () => ref.read(goldRatesProvider.notifier).refresh(),
            ),
            data: (s) => ListView(
              padding: EdgeInsets.symmetric(
                horizontal: gutter,
                vertical: AppSpacing.lg,
              ),
              children: [
                Eyebrow(l10n.goldEyebrow),
                const SizedBox(height: AppSpacing.xxs),
                Text(l10n.goldTitle, style: text.displaySmall),
                const SizedBox(height: AppSpacing.xs),
                const GoldRule(),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    const _LiveDot(),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      l10n.goldUpdated(dates.time(s.updatedAt)),
                      style: text.labelMedium!.copyWith(color: c.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  decoration: BoxDecoration(
                    color: c.card,
                    borderRadius: AppRadius.circular(AppRadius.md),
                    border: Border.all(color: c.border),
                    boxShadow: AppShadows.sm(c.shadow),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      Container(
                        color: c.surface2,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                l10n.goldColPurity,
                                style: text.labelSmall,
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                'LAK',
                                style: text.labelSmall,
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'USD',
                                style: text.labelSmall,
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'THB',
                                style: text.labelSmall,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                      for (final (i, r) in s.rates.indexed)
                        StaggeredReveal(
                          index: i,
                          child: _RateRow(
                            rate: r,
                            last: i == s.rates.length - 1,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(l10n.goldPerGram, style: text.labelSmall),
                const SizedBox(height: AppSpacing.xxs),
                Text(l10n.goldDisclaimer, style: text.bodySmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RateRow extends ConsumerWidget {
  const _RateRow({required this.rate, required this.last});

  final GoldRate rate;
  final bool last;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final money = ref.watch(moneyFormatterProvider);
    final tabular = text.bodyMedium!.copyWith(
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    final up = rate.delta >= 0;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        border: last ? null : Border(bottom: BorderSide(color: c.border)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    rate.label,
                    style: text.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (rate.delta != 0) ...[
                  const SizedBox(width: 4),
                  _DeltaChip(
                    key: ValueKey(rate.delta),
                    up: up,
                    delta: rate.delta,
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              money.plain(rate['LAK'] ?? 0),
              style: tabular.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              '\$${(rate['USD'] ?? 0).toStringAsFixed(2)}',
              style: tabular,
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              '฿${money.plain(rate['THB'] ?? 0)}',
              style: tabular,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

/// `delta-in`: the arrow chip scales in from .6 whenever the delta changes.
class _DeltaChip extends StatelessWidget {
  const _DeltaChip({super.key, required this.up, required this.delta});

  final bool up;
  final double delta;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: .6, end: 1),
    duration: AppMotion.of(context, AppMotion.normal),
    curve: AppMotion.spring,
    builder: (context, v, child) => Transform.scale(scale: v, child: child),
    child: Tooltip(
      message: '${(delta * 100).toStringAsFixed(2)}%',
      child: Icon(
        up ? Icons.trending_up_rounded : Icons.trending_down_rounded,
        size: 16,
        color: up ? AppColors.success : AppColors.danger,
      ),
    ),
  );
}

/// `live`: an 8px dot whose halo pulses.
class _LiveDot extends StatefulWidget {
  const _LiveDot();

  @override
  State<_LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<_LiveDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!AppMotion.reduced(context) && !_c.isAnimating) _c.repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    builder: (context, _) => SizedBox(
      width: 16,
      height: 16,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 8 + 8 * _c.value,
            height: 8 + 8 * _c.value,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: .35 * (1 - _c.value)),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    ),
  );
}

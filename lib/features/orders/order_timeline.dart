import 'package:flutter/material.dart';

import '../../core/motion/motion.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../data/models/commerce.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/status_pill.dart';

String orderStatusLabel(AppL10n l10n, OrderStatus s) => switch (s) {
  OrderStatus.placed => l10n.orderStatusPlaced,
  OrderStatus.confirmed => l10n.orderStatusConfirmed,
  OrderStatus.packed => l10n.orderStatusPacked,
  OrderStatus.shipped => l10n.orderStatusShipped,
  OrderStatus.delivered => l10n.orderStatusDelivered,
  OrderStatus.cancelled => l10n.orderStatusCancelled,
};

PillTone orderStatusTone(OrderStatus s) => switch (s) {
  OrderStatus.delivered => PillTone.ok,
  OrderStatus.cancelled => PillTone.bad,
  _ => PillTone.live,
};

/// The horizontal stage rail: animated fill and five nodes.
class OrderStageRail extends StatelessWidget {
  const OrderStageRail({super.key, required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final stages = OrderStatus.stages;
    final reached = status.stageIndex;
    final cancelled = status == OrderStatus.cancelled;
    final tint = cancelled ? AppColors.danger : c.primary;
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ClipRRect(
            borderRadius: AppRadius.circular(AppRadius.pill),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: reached / (stages.length - 1)),
              duration: AppMotion.of(context, AppMotion.slower),
              curve: AppMotion.easeOut,
              builder: (context, v, _) => LinearProgressIndicator(value: v, minHeight: 2, color: tint),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var i = 0; i < stages.length; i++)
              _Node(done: i <= reached, current: i == reached && !cancelled && status != OrderStatus.delivered, tint: tint),
          ],
        ),
      ],
    );
  }
}

class _Node extends StatefulWidget {
  const _Node({required this.done, required this.current, required this.tint});

  final bool done;
  final bool current;
  final Color tint;

  @override
  State<_Node> createState() => _NodeState();
}

class _NodeState extends State<_Node> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.current && !AppMotion.reduced(context)) {
      _pulse.repeat();
    } else {
      _pulse.stop();
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SizedBox(
      width: 20,
      height: 20,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.current)
            AnimatedBuilder(
              animation: _pulse,
              builder: (context, _) => Container(
                width: 20 * (1 + _pulse.value * .6),
                height: 20 * (1 + _pulse.value * .6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.tint.withValues(alpha: .35 * (1 - _pulse.value)),
                ),
              ),
            ),
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.done ? widget.tint : c.surface,
              border: Border.all(color: widget.done ? widget.tint : c.borderStrong, width: 2),
            ),
          ),
        ],
      ),
    );
  }
}

/// The vertical five-stage timeline with the current stage pulsing.
class OrderTimeline extends StatelessWidget {
  const OrderTimeline({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final stages = OrderStatus.stages;
    final reached = order.status.stageIndex;
    final cancelled = order.status == OrderStatus.cancelled;
    final tint = cancelled ? AppColors.danger : c.primary;
    final descriptions = [
      l10n.orderStageDescPlaced,
      l10n.orderStageDescConfirmed,
      l10n.orderStageDescPacked,
      l10n.orderStageDescShipped,
      l10n.orderStageDescDelivered,
    ];
    return Column(
      children: [
        for (var i = 0; i < stages.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 28,
                  child: Column(
                    children: [
                      _Node(done: i <= reached, current: i == reached && !cancelled && order.status != OrderStatus.delivered, tint: tint),
                      if (i < stages.length - 1)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: i < reached ? tint : c.border,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          orderStatusLabel(l10n, stages[i]),
                          style: text.titleSmall!.copyWith(color: i <= reached ? c.text : c.textMuted),
                        ),
                        Text(descriptions[i], style: text.bodySmall),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (cancelled)
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.danger.withValues(alpha: .08),
              borderRadius: AppRadius.circular(AppRadius.sm),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.danger),
                const SizedBox(width: AppSpacing.xs),
                Expanded(child: Text(l10n.orderCancelledNote, style: text.bodySmall)),
              ],
            ),
          ),
      ],
    );
  }
}

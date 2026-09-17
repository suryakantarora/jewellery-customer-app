import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/layout/breakpoints.dart';
import '../../core/motion/motion.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../data/models/content.dart';
import '../../data/repository_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/banner_ground.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/eyebrow.dart';
import '../../shared/widgets/skeleton.dart';
import '../../shared/widgets/staggered_reveal.dart';
import '../shell/fino_header.dart';

/// Maps the policy's icon name to a Material icon.
IconData policyIcon(String name) => switch (name) {
  'refresh' => Icons.refresh_rounded,
  'swap' => Icons.swap_horiz_rounded,
  'build' => Icons.build_outlined,
  'local_shipping' => Icons.local_shipping_outlined,
  'credit_card' => Icons.credit_card_rounded,
  'help' => Icons.help_outline_rounded,
  _ => Icons.article_outlined,
};

/// Policy document (survey: PolicyPage): hero with icon, title, tagline,
/// updated date, highlight chips, then prose / bullets / step timelines /
/// small tables and an FAQ accordion.
class PolicyScreen extends ConsumerWidget {
  const PolicyScreen({super.key, required this.policyKey});

  final String policyKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final doc = ref.watch(policyProvider(policyKey));
    final gutter = Breakpoints.gutter(context);
    return Scaffold(
      appBar: FinoHeader.page(
        title: doc.valueOrNull?.title ?? l10n.settingsPolicies,
      ),
      body: ContentWidth(
        child: doc.when(
          loading: () => ListView(
            padding: EdgeInsets.all(gutter),
            children: const [
              Skeleton(height: 180, radius: AppRadius.lg),
              SizedBox(height: AppSpacing.md),
              SkeletonLines(lines: 6),
            ],
          ),
          error: (_, __) => ErrorState(
            onRetry: () => ref.invalidate(policyProvider(policyKey)),
          ),
          data: (d) => d == null
              ? EmptyState(title: l10n.emptyTitle, body: l10n.emptyBody)
              : _PolicyBody(doc: d, gutter: gutter),
        ),
      ),
    );
  }
}

class _PolicyBody extends StatelessWidget {
  const _PolicyBody({required this.doc, required this.gutter});

  final PolicyDoc doc;
  final double gutter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    var i = 0;
    return ListView(
      padding: EdgeInsets.only(bottom: AppSpacing.xxl),
      children: [
        BannerGround(
          filigreeSize: 170,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              gutter,
              AppSpacing.lg,
              gutter,
              AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: .6, end: 1),
                  duration: AppMotion.of(context, AppMotion.slow),
                  curve: AppMotion.spring,
                  builder: (context, v, child) =>
                      Transform.scale(scale: v, child: child),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: c.bannerGold.withValues(alpha: .18),
                      shape: BoxShape.circle,
                      border: Border.all(color: c.bannerHairline),
                    ),
                    child: Icon(
                      policyIcon(doc.icon),
                      color: c.bannerGold,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  doc.title,
                  style: text.displaySmall!.copyWith(color: c.bannerInk),
                ),
                Text(
                  doc.tagline,
                  style: text.bodyMedium!.copyWith(color: c.bannerInkSoft),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  l10n.policyUpdated(doc.updated),
                  style: text.labelSmall!.copyWith(color: c.bannerInkFaint),
                ),
                if (doc.highlights.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      for (final h in doc.highlights)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: c.bannerGround.withValues(alpha: .7),
                            borderRadius: AppRadius.circular(AppRadius.sm),
                            border: Border.all(color: c.bannerHairline),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                h.value,
                                style: text.titleMedium!.copyWith(
                                  color: c.bannerInk,
                                ),
                              ),
                              Text(
                                h.label.toUpperCase(),
                                style: text.labelSmall!.copyWith(
                                  color: c.bannerInkSoft,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
        for (final s in doc.sections)
          StaggeredReveal(
            index: i++,
            child: Padding(
              padding: EdgeInsets.fromLTRB(gutter, AppSpacing.lg, gutter, 0),
              child: _Section(section: s),
            ),
          ),
        if (doc.faqs.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.fromLTRB(
              gutter,
              AppSpacing.xl,
              gutter,
              AppSpacing.sm,
            ),
            child: Eyebrow(l10n.policyFaq),
          ),
          for (final f in doc.faqs)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: gutter),
              child: _Faq(faq: f),
            ),
        ],
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.section});

  final PolicySection section;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(section.heading, style: text.headlineSmall),
        const SizedBox(height: AppSpacing.xs),
        if (section.body != null) Text(section.body!, style: text.bodyMedium),
        for (final b in section.bullets)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 5,
                  height: 5,
                  margin: const EdgeInsets.only(top: 8, right: 10),
                  decoration: BoxDecoration(
                    color: c.accent,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(child: Text(b, style: text.bodyMedium)),
              ],
            ),
          ),
        if (section.steps.isNotEmpty)
          for (final (n, step) in section.steps.indexed)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 28,
                    child: Column(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: c.accentSoft,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: c.accent.withValues(alpha: .5),
                            ),
                          ),
                          child: Text(
                            '${n + 1}',
                            style: text.labelSmall!.copyWith(
                              color: c.accent,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (n < section.steps.length - 1)
                          Expanded(child: Container(width: 1, color: c.border)),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 2,
                        bottom: AppSpacing.sm,
                      ),
                      child: Text(step, style: text.bodyMedium),
                    ),
                  ),
                ],
              ),
            ),
        if (section.table.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: AppSpacing.xs),
            decoration: BoxDecoration(
              border: Border.all(color: c.border),
              borderRadius: AppRadius.circular(AppRadius.sm),
            ),
            clipBehavior: Clip.antiAlias,
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                for (final (r, row) in section.table.indexed)
                  TableRow(
                    decoration: BoxDecoration(
                      color: r == 0 ? c.surface2 : c.card,
                    ),
                    children: [
                      for (final cell in row)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          child: Text(
                            cell,
                            style: r == 0
                                ? text.labelSmall!.copyWith(
                                    fontWeight: FontWeight.w700,
                                  )
                                : text.bodySmall,
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Faq extends StatefulWidget {
  const _Faq({required this.faq});

  final PolicyFaq faq;

  @override
  State<_Faq> createState() => _FaqState();
}

class _FaqState extends State<_Faq> {
  var _open = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Material(
        color: c.card,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: c.border),
          borderRadius: AppRadius.circular(AppRadius.sm),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            ListTile(
              dense: true,
              title: Text(widget.faq.question, style: text.titleSmall),
              trailing: AnimatedRotation(
                turns: _open ? .5 : 0,
                duration: AppMotion.of(context, AppMotion.normal),
                child: Icon(Icons.expand_more_rounded, color: c.textMuted),
              ),
              onTap: () => setState(() => _open = !_open),
            ),
            AnimatedSize(
              duration: AppMotion.of(context, AppMotion.normal),
              curve: AppMotion.easeOut,
              alignment: Alignment.topCenter,
              child: _open
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.md,
                        0,
                        AppSpacing.md,
                        AppSpacing.sm,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(widget.faq.answer, style: text.bodyMedium),
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }
}

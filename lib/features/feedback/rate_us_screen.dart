import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/layout/breakpoints.dart';
import '../../core/media/app_image.dart';
import '../../core/media/image_ref.dart';
import '../../core/motion/motion.dart';
import '../../core/router/app_routes.dart';
import '../../core/tenant/tenant_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../data/repository_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/animated_tick.dart';
import '../../shared/widgets/app_panel.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/app_toast.dart';
import '../../shared/widgets/eyebrow.dart';
import '../../shared/widgets/press_scale.dart';
import '../shell/fino_header.dart';

/// Rate us (survey: RateUsPage): app icon hero, five tappable stars with a
/// staggered pop, a caption per rating; ≥4 → store link (toast), ≤3 →
/// private note; ratings summary with animated bars; what's new.
class RateUsScreen extends ConsumerStatefulWidget {
  const RateUsScreen({super.key});

  @override
  ConsumerState<RateUsScreen> createState() => _RateUsScreenState();
}

class _RateUsScreenState extends ConsumerState<RateUsScreen> {
  var _stars = 0;
  var _submitted = false;
  final _note = TextEditingController();

  static const distribution = [78, 14, 5, 2, 1];

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _submit({bool store = false}) async {
    final l10n = AppL10n.of(context);
    await ref
        .read(feedbackRepositoryProvider)
        .rate(
          _stars,
          comment: _note.text.trim().isEmpty ? null : _note.text.trim(),
        );
    if (!mounted) return;
    if (store) showToast(context, l10n.rateStoreDemo);
    setState(() => _submitted = true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final tenant = ref.watch(tenantProvider).valueOrNull;
    final gutter = Breakpoints.gutter(context);
    final captions = [
      l10n.rateCaption0,
      l10n.rateCaption1,
      l10n.rateCaption2,
      l10n.rateCaption3,
      l10n.rateCaption4,
      l10n.rateCaption5,
    ];

    return Scaffold(
      appBar: FinoHeader.page(title: l10n.settingsRateUs),
      body: ContentWidth(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: gutter,
            vertical: AppSpacing.lg,
          ),
          children: [
            Center(
              child: Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  borderRadius: AppRadius.circular(AppRadius.lg),
                  boxShadow: AppShadows.md(c.shadow),
                ),
                clipBehavior: Clip.antiAlias,
                child: AppImage(
                  tenant?.logoLight ??
                      const ImageRef.asset('images/ui/app-icon.png'),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.rateTitle(tenant?.brandName ?? ''),
              style: text.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.rateIntro,
              style: text.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            AnimatedSwitcher(
              duration: AppMotion.of(context, AppMotion.normal),
              child: _submitted
                  ? Column(
                      key: const ValueKey('done'),
                      children: [
                        const AnimatedTick(size: 72),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          l10n.rateThanks,
                          style: text.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : Column(
                      key: const ValueKey('stars'),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var i = 1; i <= 5; i++)
                              _Star(
                                index: i,
                                lit: i <= _stars,
                                onTap: () => setState(() => _stars = i),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          captions[_stars],
                          style: text.bodyMedium!.copyWith(
                            color: c.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        if (_stars >= 4) ...[
                          FilledButton.icon(
                            onPressed: () => _submit(store: true),
                            icon: const Icon(
                              Icons.storefront_outlined,
                              size: 18,
                            ),
                            label: Text(l10n.rateOnStore),
                          ),
                          TextButton(
                            onPressed: () => context.pop(),
                            child: Text(l10n.rateNotNow),
                          ),
                        ] else if (_stars > 0) ...[
                          AppPanel(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            children: [
                              AppTextField(
                                label: l10n.rateWhatWentWrong,
                                controller: _note,
                                maxLines: 3,
                                textCapitalization:
                                    TextCapitalization.sentences,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              FilledButton(
                                onPressed: _submit,
                                child: Text(l10n.contactSend),
                              ),
                              TextButton(
                                onPressed: () =>
                                    context.pushReplacement(AppRoutes.feedback),
                                child: Text(l10n.rateDetailedFeedback),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Eyebrow(l10n.rateSummary),
            const SizedBox(height: AppSpacing.sm),
            AppPanel(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '4.7',
                      style: text.displayMedium!.copyWith(color: c.primaryDark),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        l10n.rateCount('2,418'),
                        style: text.bodySmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                for (final (i, pct) in distribution.indexed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 14,
                          child: Text('${5 - i}', style: text.labelSmall),
                        ),
                        Icon(Icons.star_rounded, size: 12, color: c.accent),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: AppRadius.circular(AppRadius.pill),
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: pct / 100),
                              duration: AppMotion.of(context, AppMotion.slower),
                              curve: AppMotion.easeOut,
                              builder: (context, v, _) =>
                                  LinearProgressIndicator(
                                    value: v,
                                    minHeight: 6,
                                    backgroundColor: c.surface2,
                                    color: c.accent,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        SizedBox(
                          width: 32,
                          child: Text(
                            '$pct%',
                            style: text.labelSmall,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Eyebrow(l10n.rateWhatsNew('0.1.0')),
            const SizedBox(height: AppSpacing.sm),
            AppPanel(
              children: [
                for (final item in [
                  l10n.rateNew1,
                  l10n.rateNew2,
                  l10n.rateNew3,
                  l10n.rateNew4,
                ])
                  ListTile(
                    dense: true,
                    leading: Icon(
                      Icons.check_circle_outline_rounded,
                      color: AppColors.success,
                      size: 20,
                    ),
                    title: Text(item),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.homeDemoNote,
              style: text.labelSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

/// `star-pop`: each star scales 1 → 1.3 → 1 when lit, staggered by index.
class _Star extends StatelessWidget {
  const _Star({required this.index, required this.lit, required this.onTap});

  final int index;
  final bool lit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return PressScale(
      onTap: onTap,
      scale: .9,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: TweenAnimationBuilder<double>(
          key: ValueKey(lit),
          tween: Tween(begin: lit ? .7 : 1, end: 1),
          duration:
              AppMotion.of(context, AppMotion.normal) +
              Duration(milliseconds: lit ? index * 40 : 0),
          curve: AppMotion.spring,
          builder: (context, v, child) =>
              Transform.scale(scale: v, child: child),
          child: Semantics(
            button: true,
            label: '$index',
            child: Icon(
              lit ? Icons.star_rounded : Icons.star_outline_rounded,
              size: 40,
              color: lit ? c.accent : c.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}

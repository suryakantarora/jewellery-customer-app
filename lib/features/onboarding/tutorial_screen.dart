import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/media/app_image.dart';
import '../../core/media/image_ref.dart';
import '../../core/motion/motion.dart';
import '../../core/router/app_routes.dart';
import '../../core/session/session_provider.dart';
import '../../core/tenant/tenant_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/eyebrow.dart';
import '../../shared/widgets/scrim.dart';

/// First-run tour: four full-bleed slides, floating blurred Skip pill (hidden
/// on the last), dot pager, CTA on the last slide → welcome.
class TutorialScreen extends ConsumerStatefulWidget {
  const TutorialScreen({super.key});

  @override
  ConsumerState<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends ConsumerState<TutorialScreen> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref.read(seenTourProvider.notifier).markSeen();
    if (mounted) context.go(AppRoutes.welcome);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final brand = ref.watch(tenantProvider).valueOrNull?.brandName ?? '';
    final slides = [
      (l10n.tourEyebrow1, l10n.tourTitle1(brand), l10n.tourBody1),
      (l10n.tourEyebrow2, l10n.tourTitle2, l10n.tourBody2),
      (l10n.tourEyebrow3, l10n.tourTitle3, l10n.tourBody3),
      (l10n.tourEyebrow4, l10n.tourTitle4, l10n.tourBody4),
    ];
    final last = _index == slides.length - 1;

    return Scaffold(
      backgroundColor: c.heroGround,
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: slides.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (context, i) => _Slide(
              image: ImageRef.asset('images/ui/tour-${i + 1}.jpg'),
              eyebrow: slides[i].$1,
              title: slides[i].$2,
              body: slides[i].$3,
              active: i == _index,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppLayout.gutter),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: AnimatedOpacity(
                      opacity: last ? 0 : 1,
                      duration: AppMotion.of(context, AppMotion.normal),
                      child: IgnorePointer(
                        ignoring: last,
                        child: _SkipPill(label: l10n.tourSkip, onTap: _finish),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < slides.length; i++)
                        AnimatedContainer(
                          duration: AppMotion.of(context, AppMotion.normal),
                          curve: AppMotion.easeOut,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: i == _index ? 22 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: i == _index
                                ? c.accent
                                : AppColors.photoInkFaint,
                            borderRadius: AppRadius.circular(AppRadius.pill),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    height: 52,
                    child: AnimatedSwitcher(
                      duration: AppMotion.of(context, AppMotion.normal),
                      child: last
                          ? SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                key: const ValueKey('cta'),
                                onPressed: _finish,
                                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                                label: Text(l10n.tourContinue),
                              ),
                            )
                          : SizedBox(
                              key: const ValueKey('next'),
                              width: double.infinity,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.photoInk,
                                  side: BorderSide(color: c.photoHairline),
                                ),
                                onPressed: () => _controller.nextPage(
                                  duration: AppMotion.of(context, AppMotion.slow),
                                  curve: AppMotion.easeOut,
                                ),
                                child: Text(l10n.tourNext),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({
    required this.image,
    required this.eyebrow,
    required this.title,
    required this.body,
    required this.active,
  });

  final ImageRef image;
  final String eyebrow;
  final String title;
  final String body;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Stack(
      fit: StackFit.expand,
      children: [
        AppImage(image),
        const Scrim(stops: [.35, 1], strength: 1.4),
        Positioned(
          left: AppLayout.gutter,
          right: AppLayout.gutter,
          bottom: 150,
          child: AnimatedOpacity(
            opacity: active ? 1 : 0,
            duration: AppMotion.of(context, AppMotion.slow),
            child: AnimatedSlide(
              offset: active ? Offset.zero : const Offset(0, .08),
              duration: AppMotion.of(context, AppMotion.slow),
              curve: AppMotion.easeOut,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Eyebrow(eyebrow),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    title,
                    style: text.displayMedium!.copyWith(color: AppColors.photoInk),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    body,
                    style: text.bodyLarge!.copyWith(color: AppColors.photoInkSoft),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SkipPill extends StatelessWidget {
  const _SkipPill({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: AppRadius.circular(AppRadius.pill),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: Material(
        color: Colors.white.withValues(alpha: .16),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: AppColors.photoInk,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

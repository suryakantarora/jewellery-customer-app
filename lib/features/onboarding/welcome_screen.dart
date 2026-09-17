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
import '../../data/repository_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/eyebrow.dart';
import '../../shared/widgets/gold_rule.dart';
import '../../shared/widgets/press_scale.dart';
import '../../shared/widgets/scrim.dart';
import '../../shared/widgets/skeleton.dart';
import '../../shared/widgets/staggered_reveal.dart';

/// Landing screen: jewel-box ground, 40 s panning hero masked at its base,
/// brand block rising in, sign-in / guest actions and a teaser rail.
class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pan = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 40),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!AppMotion.reduced(context) && !_pan.isAnimating) {
      _pan.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pan.dispose();
    super.dispose();
  }

  Future<void> _guest() async {
    await ref.read(sessionProvider.notifier).continueAsGuest();
    if (mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final tenant = ref.watch(tenantProvider).valueOrNull;
    final featured = ref.watch(featuredProductsProvider);
    final height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: c.heroGround,
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: c.heroGradient),
        child: Stack(
          children: [
            // Hero photo, panning slowly, fading out towards its base.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: height * .58,
              child: ShaderMask(
                shaderCallback: (rect) => const LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0, .46],
                  colors: [Colors.transparent, Colors.black],
                ).createShader(rect),
                blendMode: BlendMode.dstIn,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AnimatedBuilder(
                      animation: _pan,
                      builder: (context, child) => AppImage(
                        const ImageRef.asset('images/banners/welcome-banner-1.jpg'),
                        alignment: Alignment(-1 + 2 * _pan.value, 0),
                      ),
                    ),
                    const Scrim(stops: [0, 1], strength: 1.2),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  const Spacer(),
                  StaggeredReveal(
                    index: 1,
                    child: Column(
                      children: [
                        if (tenant != null && !tenant.logoDark.isEmpty)
                          ClipRRect(
                            borderRadius: AppRadius.circular(AppRadius.lg),
                            child: AppImage(tenant.logoDark, width: 72, height: 72),
                          ),
                        const SizedBox(height: AppSpacing.md),
                        Eyebrow(l10n.welcomeEyebrow),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          tenant?.brandName ?? '',
                          textAlign: TextAlign.center,
                          style: text.displayLarge!.copyWith(color: AppColors.photoInk),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        GoldRule(width: 48, color: c.accent),
                        const SizedBox(height: AppSpacing.sm),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                          child: Text(
                            tenant?.tagline ?? '',
                            textAlign: TextAlign.center,
                            style: text.bodyLarge!.copyWith(color: AppColors.photoInkSoft),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  StaggeredReveal(
                    index: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppLayout.gutter),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          FilledButton.icon(
                            onPressed: () => context.push(AppRoutes.authFromWelcome),
                            icon: const Icon(Icons.phone_iphone_rounded, size: 18),
                            label: Text(l10n.authSignInWithPhone),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.photoInk,
                              side: BorderSide(color: c.photoHairline),
                            ),
                            onPressed: _guest,
                            child: Text(l10n.authContinueAsGuest),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  StaggeredReveal(
                    index: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(left: AppLayout.gutter),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Eyebrow(l10n.welcomeTeaser, color: AppColors.photoInkFaint),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  SizedBox(
                    height: 120,
                    child: featured.when(
                      loading: () => ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: AppLayout.gutter),
                        itemCount: 4,
                        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
                        itemBuilder: (_, __) =>
                            const Skeleton(width: 100, height: 120, radius: AppRadius.sm),
                      ),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (items) => ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: AppLayout.gutter),
                        itemCount: items.length.clamp(0, 5),
                        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
                        itemBuilder: (context, i) => StaggeredReveal(
                          index: 6 + i,
                          child: PressScale(
                            onTap: _guest,
                            child: SizedBox(
                              width: 100,
                              child: ClipRRect(
                                borderRadius: AppRadius.circular(AppRadius.sm),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    AppImage(items[i].heroImage),
                                    const Scrim(),
                                    Positioned(
                                      left: 8,
                                      right: 8,
                                      bottom: 8,
                                      child: Text(
                                        items[i].productName,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: text.labelLarge!.copyWith(
                                          color: AppColors.photoInk,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

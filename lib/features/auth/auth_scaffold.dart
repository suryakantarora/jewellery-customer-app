import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/layout/breakpoints.dart';
import '../../core/media/app_image.dart';
import '../../core/media/image_ref.dart';
import '../../core/motion/motion.dart';
import '../../core/tenant/tenant_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/gold_rule.dart';
import '../../shared/widgets/scrim.dart';
import '../../shared/widgets/staggered_reveal.dart';

/// The auth pages' shared frame: drifting photo hero with scrim, circular
/// back button, brand block, and a form sheet that rides up over the photo.
class AuthScaffold extends ConsumerStatefulWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    this.footer,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final Widget? footer;

  @override
  ConsumerState<AuthScaffold> createState() => _AuthScaffoldState();
}

class _AuthScaffoldState extends ConsumerState<AuthScaffold>
    with SingleTickerProviderStateMixin {
  late final AnimationController _drift = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 18),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!AppMotion.reduced(context) && !_drift.isAnimating) {
      _drift.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _drift.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final tenant = ref.watch(tenantProvider).valueOrNull;
    final wide = !Breakpoints.isPhone(context);
    final heroHeight = MediaQuery.sizeOf(context).height * .42;

    return Scaffold(
      backgroundColor: c.bannerGround,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: heroHeight + AppRadius.xl,
            child: Stack(
              fit: StackFit.expand,
              children: [
                AnimatedBuilder(
                  animation: _drift,
                  builder: (context, _) => Transform.scale(
                    scale: 1.04 + .04 * _drift.value,
                    child: AppImage(
                      const ImageRef.asset('images/ui/auth-hero.jpg'),
                      alignment: Alignment(-.3 + .6 * _drift.value, 0),
                    ),
                  ),
                ),
                const Scrim(stops: [.1, 1], strength: 1.3),
              ],
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _CircleBack(onTap: () => context.pop()),
                  ),
                ),
                SizedBox(
                  height: heroHeight - 56 - AppSpacing.xs * 2,
                  child: Center(
                    child: StaggeredReveal(
                      index: 1,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (tenant != null && !tenant.logoDark.isEmpty)
                            ClipRRect(
                              borderRadius: AppRadius.circular(AppRadius.md),
                              child: AppImage(tenant.logoDark, width: 56, height: 56),
                            ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            tenant?.brandMark ?? '',
                            style: text.displaySmall!.copyWith(
                              color: AppColors.bannerInk,
                              letterSpacing: AppType.tracking(AppType.xxl, AppType.trackWider),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          GoldRule(color: c.accent),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            tenant?.tagline ?? '',
                            style: text.labelMedium!.copyWith(
                              color: AppColors.bannerInkSoft,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: StaggeredReveal(
                    index: 3,
                    rise: 40,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: wide ? 520 : double.infinity),
                        child: Container(
                          decoration: BoxDecoration(
                            color: c.surface,
                            borderRadius: BorderRadius.vertical(
                              top: const Radius.circular(AppRadius.xl),
                              bottom: wide ? const Radius.circular(AppRadius.xl) : Radius.zero,
                            ),
                            boxShadow: AppShadows.lg(c.shadow),
                          ),
                          child: ListView(
                            padding: EdgeInsets.fromLTRB(
                              AppSpacing.lg,
                              AppSpacing.lg,
                              AppSpacing.lg,
                              AppSpacing.lg + MediaQuery.paddingOf(context).bottom,
                            ),
                            children: [
                              Text(widget.title, style: text.headlineLarge),
                              const SizedBox(height: AppSpacing.xxs),
                              Text(
                                widget.subtitle,
                                style: text.bodyMedium!.copyWith(color: c.textSecondary),
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              for (var i = 0; i < widget.children.length; i++)
                                StaggeredReveal(index: 4 + i, child: widget.children[i]),
                              if (widget.footer != null) ...[
                                const SizedBox(height: AppSpacing.lg),
                                widget.footer!,
                              ],
                              Padding(
                                padding: const EdgeInsets.only(top: AppSpacing.md),
                                child: Text(
                                  l10n.authDemoHint,
                                  textAlign: TextAlign.center,
                                  style: text.labelSmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleBack extends StatelessWidget {
  const _CircleBack({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white.withValues(alpha: .18),
    shape: const CircleBorder(),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: const SizedBox(
        width: 40,
        height: 40,
        child: Icon(Icons.arrow_back_rounded, color: AppColors.bannerInk, size: 20),
      ),
    ),
  );
}

/// "── OR ──"
class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    return Row(
      children: [
        Expanded(child: Divider(color: c.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Text(l10n.authOr, style: Theme.of(context).textTheme.labelSmall),
        ),
        Expanded(child: Divider(color: c.border)),
      ],
    );
  }
}

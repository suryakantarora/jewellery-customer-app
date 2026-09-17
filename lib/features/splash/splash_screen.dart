import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/motion/motion.dart';
import '../../core/router/app_routes.dart';
import '../../core/session/session_provider.dart';
import '../../core/tenant/tenant_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_art.dart';
import '../../shared/widgets/banner_ground.dart';

/// Tenant-branded splash on the jeweller's ground: facets art breathing
/// behind a brand mark that rises into place while its gold rule draws
/// itself. Shown as the first route and again as an overlay while a tenant
/// reload (shop code) is in flight.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key, this.tenant, this.standalone = true});

  /// When embedded as a reload overlay the last-known tenant is passed in so
  /// the brand never flickers to nothing.
  final TenantConfig? tenant;

  /// As a route, the splash navigates on after a short beat; as an overlay
  /// it simply sits there.
  final bool standalone;

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breath = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  );

  @override
  void initState() {
    super.initState();
    if (widget.standalone) {
      Future<void>.delayed(const Duration(milliseconds: 1100), () {
        if (!mounted) return;
        if (!ref.read(seenTourProvider)) {
          context.go(AppRoutes.tutorial);
        } else if (ref.read(sessionProvider).valueOrNull == null) {
          context.go(AppRoutes.welcome);
        } else {
          context.go(AppRoutes.home);
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!AppMotion.reduced(context) && !_breath.isAnimating) {
      _breath.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _breath.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final tenant = widget.tenant;
    final duration = AppMotion.of(context, AppMotion.slower);

    return Scaffold(
      body: BannerGround(
        filigreeSize: 260,
        filigreeAlignment: Alignment.topRight,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // A second, mirrored filigree anchors the opposite corner.
            Positioned(
              left: -60,
              bottom: -50,
              child: Transform.rotate(
                angle: 3.14159,
                child: Opacity(
                  opacity: c.isDark ? .30 : .40,
                  child: AppArt.filigreeCorner(color: c.bannerGold, size: 220),
                ),
              ),
            ),
            Center(
              child: AnimatedBuilder(
                animation: _breath,
                builder: (context, child) => Transform.scale(
                  scale: .96 + .06 * Curves.easeInOut.transform(_breath.value),
                  child: Opacity(
                    opacity:
                        (c.isDark ? .55 : .70) +
                        .25 * Curves.easeInOut.transform(_breath.value),
                    child: child,
                  ),
                ),
                child: AppArt.facets(color: c.bannerGold, size: 380),
              ),
            ),
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: duration,
                curve: AppMotion.easeOut,
                builder: (context, v, child) => Opacity(
                  opacity: v,
                  child: Transform.translate(
                    offset: Offset(0, 14 * (1 - v)),
                    child: child,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tenant?.brandMark ?? '',
                      style: text.displayLarge!.copyWith(
                        color: c.bannerInk,
                        letterSpacing: AppType.tracking(
                          AppType.xxxxl,
                          AppType.trackWider,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _DrawnRule(color: c.bannerGold, duration: duration),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      tenant == null
                          ? l10n.splashPreparing
                          : l10n.splashTagline(tenant.tagline),
                      style: text.labelMedium!.copyWith(
                        color: c.bannerInkSoft,
                        letterSpacing: AppType.tracking(
                          AppType.sm,
                          AppType.trackWider,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: AppSpacing.xxl,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: c.bannerGold.withValues(alpha: .8),
                    ),
                  ),
                  if (tenant != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      tenant.brandName.toUpperCase(),
                      style: text.labelSmall!.copyWith(
                        color: c.bannerInkFaint,
                        letterSpacing: AppType.tracking(
                          AppType.xxs,
                          AppType.trackWidest,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A gold rule that grows from the centre to 56px.
class _DrawnRule extends StatelessWidget {
  const _DrawnRule({required this.color, required this.duration});

  final Color color;
  final Duration duration;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 56),
    duration: duration * 1.3,
    curve: AppMotion.easeOut,
    builder: (context, w, _) => Container(
      width: w,
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0),
            color,
            color.withValues(alpha: 0),
          ],
        ),
      ),
    ),
  );
}

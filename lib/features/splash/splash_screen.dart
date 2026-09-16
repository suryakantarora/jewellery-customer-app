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
import '../../shared/widgets/gold_rule.dart';

/// Tenant-branded splash. Shown as the first route and again as an overlay
/// while a tenant reload (shop code) is in flight.
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

class _SplashScreenState extends ConsumerState<SplashScreen> {
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
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final tenant = widget.tenant;
    final duration = AppMotion.of(context, AppMotion.slower);

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: c.bannerGround,
          gradient: c.bannerGradient,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: .92, end: 1),
                  duration: duration,
                  curve: AppMotion.easeOut,
                  builder: (context, v, child) =>
                      Transform.scale(scale: v, child: child),
                  child: AppArt.facets(color: c.accent, size: 360),
                ),
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
                    offset: Offset(0, 12 * (1 - v)),
                    child: child,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tenant?.brandMark ?? '',
                      style: text.displayLarge!.copyWith(
                        color: AppColors.bannerInk,
                        letterSpacing: AppType.tracking(
                          AppType.xxxxl,
                          AppType.trackWider,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    GoldRule(width: 48, color: c.accent),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      tenant == null
                          ? l10n.splashPreparing
                          : l10n.splashTagline(tenant.tagline),
                      style: text.labelMedium!.copyWith(
                        color: AppColors.bannerInkSoft,
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
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: c.accent.withValues(alpha: .7),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

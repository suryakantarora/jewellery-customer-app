import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/locale_provider.dart';
import '../../core/media/app_image.dart';
import '../../core/motion/motion.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../data/models/banner.dart' as model;
import '../../shared/widgets/eyebrow.dart';
import '../../shared/widgets/scrim.dart';

/// `pvj-hero`: autoplay (6 s) snapping banner carousel with staggered copy
/// and a dot pager. Adjacent moves animate, far jumps are instant.
class HeroCarousel extends ConsumerStatefulWidget {
  const HeroCarousel({super.key, required this.banners, this.height = 320});

  final List<model.Banner> banners;
  final double height;

  @override
  ConsumerState<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends ConsumerState<HeroCarousel> {
  final _controller = PageController();
  Timer? _autoplay;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _restart();
  }

  void _restart() {
    _autoplay?.cancel();
    if (widget.banners.length < 2) return;
    _autoplay = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!mounted || !_controller.hasClients) return;
      _go((_index + 1) % widget.banners.length);
    });
  }

  void _go(int target) {
    final far = (target - _index).abs() > 1;
    if (far || AppMotion.reduced(context)) {
      _controller.jumpToPage(target);
    } else {
      unawaited(
        _controller.animateToPage(
          target,
          duration: AppMotion.slow,
          curve: AppMotion.easeOut,
        ),
      );
    }
  }

  @override
  void dispose() {
    _autoplay?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          Listener(
            onPointerDown: (_) => _autoplay?.cancel(),
            onPointerUp: (_) => _restart(),
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.banners.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (context, i) =>
                  _HeroSlide(banner: widget.banners[i], active: i == _index),
            ),
          ),
          if (widget.banners.length > 1)
            Positioned(
              left: 0,
              right: 0,
              bottom: AppSpacing.sm,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < widget.banners.length; i++)
                    GestureDetector(
                      onTap: () => _go(i),
                      child: AnimatedContainer(
                        duration: AppMotion.of(context, AppMotion.normal),
                        curve: AppMotion.easeOut,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: i == _index ? 20 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: i == _index ? c.accent : AppColors.bannerInkFaint,
                          borderRadius: AppRadius.circular(AppRadius.pill),
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

class _HeroSlide extends ConsumerWidget {
  const _HeroSlide({required this.banner, required this.active});

  final model.Banner banner;
  final bool active;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final text = Theme.of(context).textTheme;
    Widget copy(int index, Widget child) => AnimatedOpacity(
      opacity: active ? 1 : 0,
      duration: AppMotion.of(context, AppMotion.slow),
      child: AnimatedSlide(
        offset: active ? Offset.zero : const Offset(0, .15),
        duration: AppMotion.of(context, AppMotion.slow + Duration(milliseconds: 80 * index)),
        curve: AppMotion.easeOut,
        child: child,
      ),
    );
    return Stack(
      fit: StackFit.expand,
      children: [
        AppImage(banner.image),
        const Scrim(stops: [.2, 1], strength: 1.3),
        Positioned(
          left: AppLayout.gutter,
          right: AppLayout.gutter,
          bottom: AppSpacing.xl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              copy(0, Eyebrow(banner.eyebrow.resolve(locale))),
              const SizedBox(height: AppSpacing.xxs),
              copy(
                1,
                Text(
                  banner.title.resolve(locale),
                  style: text.displayMedium!.copyWith(color: AppColors.bannerInk),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              copy(
                2,
                Text(
                  banner.subtitle.resolve(locale),
                  style: text.bodyMedium!.copyWith(color: AppColors.bannerInkSoft),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              copy(
                3,
                FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    minimumSize: const Size(0, 40),
                  ),
                  onPressed: () => context.push(banner.link),
                  child: Text(banner.cta.resolve(locale)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

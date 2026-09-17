import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/widgets/skeleton.dart';
import '../config/data_mode.dart';
import '../providers.dart';
import '../theme/app_colors.dart';
import 'image_ref.dart';

/// Resolves a `key://` ref to a URL. In demo mode there is no file server, so
/// keys render the error fallback rather than attempting a request.
final imageKeyResolverProvider = Provider<Uri? Function(String key)>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config.dataMode != DataMode.api) return (_) => null;
  return (key) => Uri.parse(
    '${config.apiRoot}/public/files',
  ).replace(queryParameters: {'key': key});
});

/// Renders any [ImageRef] with a shimmer placeholder and a quiet fallback.
class AppImage extends ConsumerWidget {
  const AppImage(
    this.image, {
    super.key,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.alignment = Alignment.center,
  });

  final ImageRef image;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Alignment alignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Widget child = switch (image) {
      AssetImageRef(:final assetPath) when assetPath.endsWith('.svg') =>
        SvgPicture.asset(
          assetPath,
          fit: fit,
          width: width,
          height: height,
          alignment: alignment,
        ),
      AssetImageRef(:final assetPath) => Image.asset(
        assetPath,
        fit: fit,
        width: width,
        height: height,
        alignment: alignment,
        errorBuilder: (_, __, ___) => _Fallback(width: width, height: height),
      ),
      UrlImageRef(:final uri) => _network(uri),
      KeyImageRef(:final storageKey) => switch (ref.watch(
        imageKeyResolverProvider,
      )(storageKey)) {
        final uri? => _network(uri),
        null => _Fallback(width: width, height: height),
      },
      NoImageRef() => _Fallback(width: width, height: height),
    };

    if (borderRadius == null) return child;
    return ClipRRect(borderRadius: borderRadius!, child: child);
  }

  Widget _network(Uri uri) => CachedNetworkImage(
    imageUrl: uri.toString(),
    fit: fit,
    width: width,
    height: height,
    alignment: alignment,
    placeholder: (_, __) => Skeleton(width: width, height: height, radius: 0),
    errorWidget: (_, __, ___) => _Fallback(width: width, height: height),
  );
}

class _Fallback extends StatelessWidget {
  const _Fallback({this.width, this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: width,
      height: height,
      color: c.surface2,
      alignment: Alignment.center,
      child: Icon(Icons.diamond_outlined, color: c.textMuted, size: 28),
    );
  }
}

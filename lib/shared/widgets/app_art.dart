import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Bundled SVG art, recoloured per tenant with a colour filter. The files
/// are drawn in a single flat ink so `srcIn` tints every stroke.
class AppArt extends StatelessWidget {
  const AppArt.filigreeCorner({super.key, required this.color, this.size = 160})
    : asset = 'assets/art/filigree-corner.svg';

  const AppArt.facets({super.key, required this.color, this.size = 320})
    : asset = 'assets/art/facets.svg';

  /// A 10:1 hairline flourish; [size] is its width.
  const AppArt.flourish({super.key, required this.color, this.size = 120})
    : asset = 'assets/art/flourish.svg';

  final String asset;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    asset,
    width: size,
    height: asset.endsWith('flourish.svg') ? size / 10 : size,
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
  );
}

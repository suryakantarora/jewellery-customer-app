import 'package:flutter/material.dart';

import '../../core/theme/tokens.dart';
import '../../data/models/catalogue_item.dart';
import 'product_card.dart';
import 'product_skeletons.dart';
import 'staggered_reveal.dart';

/// A horizontal, snapping rail of product cards.
class ProductRailView extends StatelessWidget {
  const ProductRailView({super.key, required this.items, required this.gutter});

  final List<CatalogueItem> items;
  final double gutter;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: ProductRail.height(context),
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: gutter),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
      itemBuilder: (context, i) => StaggeredReveal(
        index: i,
        child: ProductCard(item: items[i], width: ProductRail.cardWidth),
      ),
    ),
  );
}

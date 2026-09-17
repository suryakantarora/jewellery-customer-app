import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format/formatters_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../data/repositories/repositories.dart';
import '../../data/repository_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_chip.dart';
import '../../shared/widgets/app_sheet.dart';
import '../../shared/widgets/eyebrow.dart';

/// Facet vocabulary the catalogue knows (matches the ERP master data).
abstract final class Facets {
  static const metals = ['Gold', 'White Gold', 'Rose Gold', 'Platinum', 'Silver', 'Diamond'];
  static const purities = ['925', '14K', '18K', '22K', '24K', 'PT950', 'VVS1', 'VVS2', 'VS1', 'VS2', 'SI1'];
  static const stones = ['Diamond', 'Ruby', 'Emerald', 'Sapphire', 'Pearl', 'Tourmaline', 'None'];
  static const ratings = [4.5, 4.0, 3.5];
  static const priceStep = 50000;
}

/// The filter bottom sheet: price range, metal / purity / stone / rating
/// chips, in-stock toggle; draft state with a live result recount on Apply.
Future<CatalogueQuery?> showFilterSheet(
  BuildContext context, {
  required CatalogueQuery query,
  required PriceBounds bounds,
}) => showAppSheet<CatalogueQuery>(
  context,
  builder: (_) => _FilterSheet(initial: query, bounds: bounds),
);

class _FilterSheet extends ConsumerStatefulWidget {
  const _FilterSheet({required this.initial, required this.bounds});

  final CatalogueQuery initial;
  final PriceBounds bounds;

  @override
  ConsumerState<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<_FilterSheet> {
  late CatalogueQuery _draft = widget.initial;
  late RangeValues _range = RangeValues(
    (widget.initial.minPrice ?? widget.bounds.min).toDouble(),
    (widget.initial.maxPrice ?? widget.bounds.max).toDouble(),
  );

  bool get _hasRange => widget.bounds.max > widget.bounds.min;

  void _toggle(List<String> current, String value, CatalogueQuery Function(List<String>) apply) {
    final next = current.contains(value)
        ? current.where((v) => v != value).toList()
        : [...current, value];
    setState(() => _draft = apply(next));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final money = ref.watch(moneyFormatterProvider);
    final count = ref.watch(catalogueListProvider(_draft));

    Widget group(String title, List<Widget> chips) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow(title),
          const SizedBox(height: AppSpacing.xs),
          Wrap(spacing: AppSpacing.xs, runSpacing: AppSpacing.xs, children: chips),
        ],
      ),
    );

    return AppSheetScaffold(
      title: l10n.filterTitle,
      trailing: TextButton(
        onPressed: () => setState(() {
          _draft = widget.initial.cleared();
          _range = RangeValues(widget.bounds.min.toDouble(), widget.bounds.max.toDouble());
        }),
        child: Text(l10n.filterClearAll),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppLayout.gutter, AppSpacing.md, AppLayout.gutter, AppSpacing.md),
        children: [
          if (_hasRange) ...[
            Eyebrow(l10n.filterPrice),
            const SizedBox(height: AppSpacing.xxs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(money.format(_range.start), style: text.titleSmall),
                Text(money.format(_range.end), style: text.titleSmall),
              ],
            ),
            RangeSlider(
              values: _range,
              min: widget.bounds.min.toDouble(),
              max: widget.bounds.max.toDouble(),
              divisions: ((widget.bounds.max - widget.bounds.min) / Facets.priceStep)
                  .ceil()
                  .clamp(1, 400),
              activeColor: c.primary,
              inactiveColor: c.border,
              onChanged: (v) => setState(() {
                _range = v;
                final atBounds =
                    v.start <= widget.bounds.min && v.end >= widget.bounds.max;
                _draft = atBounds
                    ? _draft.copyWith(clearPrice: true)
                    : _draft.copyWith(minPrice: v.start.round(), maxPrice: v.end.round());
              }),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          group(l10n.filterMetal, [
            for (final m in Facets.metals)
              AppChip(
                label: m,
                active: _draft.metals.contains(m),
                onTap: () => _toggle(_draft.metals, m, (v) => _draft.copyWith(metals: v)),
              ),
          ]),
          group(l10n.filterPurity, [
            for (final p in Facets.purities)
              AppChip(
                label: p == '925' ? l10n.purity925 : p,
                active: _draft.purities.contains(p),
                onTap: () => _toggle(_draft.purities, p, (v) => _draft.copyWith(purities: v)),
              ),
          ]),
          group(l10n.filterStone, [
            for (final s in Facets.stones)
              AppChip(
                label: s == 'None' ? l10n.stoneNone : s,
                active: _draft.stones.contains(s),
                onTap: () => _toggle(_draft.stones, s, (v) => _draft.copyWith(stones: v)),
              ),
          ]),
          group(l10n.filterRating, [
            for (final r in Facets.ratings)
              AppChip(
                label: l10n.filterRatingUp(r.toString()),
                leading: const Icon(Icons.star_rounded),
                active: _draft.minRating == r,
                onTap: () => setState(
                  () => _draft = _draft.minRating == r
                      ? _draft.copyWith(clearRating: true)
                      : _draft.copyWith(minRating: r),
                ),
              ),
          ]),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.filterInStock, style: text.titleMedium),
            subtitle: Text(l10n.filterInStockSub, style: text.bodySmall),
            value: _draft.inStockOnly,
            onChanged: (v) => setState(() => _draft = _draft.copyWith(inStockOnly: v)),
          ),
        ],
      ),
      footer: FilledButton(
        onPressed: () => Navigator.of(context).pop(_draft),
        child: Text(
          count.maybeWhen(
            data: (items) => l10n.filterShowResults(items.length),
            orElse: () => l10n.filterApply,
          ),
        ),
      ),
    );
  }
}

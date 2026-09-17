import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/locale_provider.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/layout/responsive_grid.dart';
import '../../core/media/app_image.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../data/models/catalogue_item.dart';
import '../../data/repositories/repositories.dart';
import '../../data/repository_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_chip.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/eyebrow.dart';
import '../../shared/widgets/press_scale.dart';
import '../../shared/widgets/price_text.dart';
import '../../shared/widgets/scrim.dart';
import '../../shared/widgets/skeleton.dart';
import '../../shared/widgets/staggered_reveal.dart';
import '../shell/fino_header.dart';
import 'recent_searches_provider.dart';

/// Search (survey: SearchPage): 220 ms debounce, list rows, idle state with
/// recent + suggested chips and a category grid.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key, this.initialQuery});

  final String? initialQuery;

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  static const suggested = ['Solitaire', 'Bridal', 'Diamond', 'Rose Gold', '22K', 'Pearl'];

  late final _controller = TextEditingController(text: widget.initialQuery ?? '');
  Timer? _debounce;
  String _term = '';
  bool _searching = false;
  List<CatalogueItem> _results = const [];
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    if ((widget.initialQuery ?? '').isNotEmpty) _run(widget.initialQuery!);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    final term = value.trim();
    if (term.isEmpty) {
      setState(() {
        _term = '';
        _results = const [];
        _searching = false;
      });
      return;
    }
    if (term == _term) return;
    _debounce = Timer(const Duration(milliseconds: 220), () => _run(term));
  }

  Future<void> _run(String term) async {
    setState(() {
      _term = term;
      _searching = true;
      _failed = false;
    });
    try {
      final items = await ref
          .read(catalogueRepositoryProvider)
          .list(CatalogueQuery(search: term));
      if (!mounted || _term != term) return;
      setState(() {
        _results = items;
        _searching = false;
      });
      unawaited(ref.read(recentSearchesProvider.notifier).add(term));
    } on Object {
      if (!mounted || _term != term) return;
      setState(() {
        _failed = true;
        _searching = false;
      });
    }
  }

  void _use(String term) {
    _controller.text = term;
    _controller.selection = TextSelection.collapsed(offset: term.length);
    _run(term);
  }

  void _clear() {
    _controller.clear();
    _onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final gutter = Breakpoints.gutter(context);

    return Scaffold(
      appBar: FinoHeader.page(title: l10n.searchTitle),
      body: ContentWidth(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(gutter, AppSpacing.md, gutter, AppSpacing.xs),
              child: TextField(
                controller: _controller,
                autofocus: widget.initialQuery == null,
                textInputAction: TextInputAction.search,
                onChanged: _onChanged,
                onSubmitted: (v) => v.trim().isEmpty ? null : _run(v.trim()),
                decoration: InputDecoration(
                  hintText: l10n.searchHint,
                  prefixIcon: Icon(Icons.search_rounded, color: c.textSecondary),
                  suffixIcon: _controller.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close_rounded),
                          tooltip: l10n.searchClear,
                          onPressed: _clear,
                        ),
                ),
              ),
            ),
            Expanded(
              child: _term.isEmpty
                  ? _Idle(
                      gutter: gutter,
                      suggested: suggested,
                      onPick: _use,
                    )
                  : _searching
                  ? ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: gutter, vertical: AppSpacing.sm),
                      itemCount: 6,
                      itemBuilder: (_, __) => const Padding(
                        padding: EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Row(
                          children: [
                            Skeleton(width: 64, height: 64, radius: AppRadius.sm),
                            SizedBox(width: AppSpacing.sm),
                            Expanded(child: SkeletonLines(lines: 3)),
                          ],
                        ),
                      ),
                    )
                  : _failed
                  ? EmptyState(
                      icon: Icons.error_outline,
                      title: l10n.errorTitle,
                      body: l10n.errorGeneric,
                      primaryLabel: l10n.retry,
                      onPrimary: () => _run(_term),
                    )
                  : _results.isEmpty
                  ? EmptyState(
                      icon: Icons.search_off_rounded,
                      title: l10n.searchNoResultsTitle(_term),
                      body: l10n.searchNoResultsBody,
                      primaryLabel: l10n.searchClear,
                      onPrimary: _clear,
                      secondaryLabel: l10n.actionContinueShopping,
                      onSecondary: () => context.go(AppRoutes.home),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: gutter, vertical: AppSpacing.sm),
                      itemCount: _results.length + 1,
                      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
                      itemBuilder: (context, i) {
                        if (i == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
                            child: Text(
                              l10n.searchResultCount(_results.length),
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          );
                        }
                        final item = _results[i - 1];
                        return StaggeredReveal(index: i - 1, child: _ResultRow(item: item));
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.item});

  final CatalogueItem item;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return PressScale(
      onTap: () => context.push(AppRoutes.productPath(item.id)),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xs),
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: AppRadius.circular(AppRadius.md),
          border: Border.all(color: c.border),
        ),
        child: Row(
          children: [
            AppImage(
              item.heroImage,
              width: 64,
              height: 64,
              borderRadius: AppRadius.circular(AppRadius.sm),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.productName, style: text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text('${item.purityName} · ${item.categoryName}', style: text.labelSmall),
                  const SizedBox(height: 2),
                  PriceText(item.price, original: item.retail.originalPrice, compact: true),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: c.textMuted),
          ],
        ),
      ),
    );
  }
}

class _Idle extends ConsumerWidget {
  const _Idle({required this.gutter, required this.suggested, required this.onPick});

  final double gutter;
  final List<String> suggested;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final locale = ref.watch(localeProvider);
    final recent = ref.watch(recentSearchesProvider);
    final categories = ref.watch(categoriesProvider);
    final text = Theme.of(context).textTheme;
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: gutter, vertical: AppSpacing.sm),
      children: [
        if (recent.isNotEmpty) ...[
          Row(
            children: [
              Expanded(child: Eyebrow(l10n.searchRecent)),
              TextButton(
                onPressed: () => ref.read(recentSearchesProvider.notifier).clear(),
                child: Text(l10n.searchClear),
              ),
            ],
          ),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final r in recent)
                AppChip(label: r, leading: const Icon(Icons.history_rounded), onTap: () => onPick(r)),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        Eyebrow(l10n.searchSuggested),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [for (final s in suggested) AppChip(label: s, onTap: () => onPick(s))],
        ),
        const SizedBox(height: AppSpacing.lg),
        Eyebrow(l10n.searchBrowse),
        const SizedBox(height: AppSpacing.sm),
        categories.when(
          loading: () => ResponsiveGrid(
            itemCount: 4,
            childAspectRatio: 1.6,
            itemBuilder: (_, __) => const Skeleton(height: double.infinity, radius: AppRadius.md),
          ),
          error: (_, __) => const SizedBox.shrink(),
          data: (list) => ResponsiveGrid(
            itemCount: list.length,
            childAspectRatio: 1.6,
            itemBuilder: (context, i) => PressScale(
              onTap: () => context.push(AppRoutes.categoryPath(list[i].id)),
              child: ClipRRect(
                borderRadius: AppRadius.circular(AppRadius.md),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AppImage(list[i].image),
                    const Scrim(),
                    Positioned(
                      left: AppSpacing.sm,
                      bottom: AppSpacing.xs,
                      child: Text(
                        list[i].name.resolve(locale),
                        style: text.titleSmall!.copyWith(color: AppColors.photoInk),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

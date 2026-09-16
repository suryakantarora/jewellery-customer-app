import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/layout/breakpoints.dart';
import '../../core/media/app_image.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../data/models/catalogue_item.dart';
import '../../data/repositories/repositories.dart';
import '../../data/repository_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_toast.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/heart_button.dart';
import '../../shared/widgets/price_text.dart';
import '../../shared/widgets/skeleton.dart';
import '../../shared/widgets/staggered_reveal.dart';
import '../shell/fino_header.dart';

/// Lookbook (survey: ListMasterPage): the whole catalogue as rows; swipe
/// left hides a row for this visit.
class LookbookScreen extends ConsumerStatefulWidget {
  const LookbookScreen({super.key});

  @override
  ConsumerState<LookbookScreen> createState() => _LookbookScreenState();
}

class _LookbookScreenState extends ConsumerState<LookbookScreen> {
  final _hidden = <String>{};

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final gutter = Breakpoints.gutter(context);
    const query = CatalogueQuery(sort: CatalogueSort.newest);
    final items = ref.watch(catalogueListProvider(query));

    return Scaffold(
      appBar: FinoHeader.page(title: l10n.lookbookTitle),
      body: ContentWidth(
        child: items.when(
          loading: () => ListView.builder(
            padding: EdgeInsets.all(gutter),
            itemCount: 8,
            itemBuilder: (_, __) => const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  Skeleton(width: 72, height: 72, radius: AppRadius.sm),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(child: SkeletonLines(lines: 3)),
                ],
              ),
            ),
          ),
          error: (_, __) => ErrorState(onRetry: () => ref.invalidate(catalogueListProvider(query))),
          data: (list) {
            final visible = list.where((i) => !_hidden.contains(i.id)).toList();
            if (visible.isEmpty) {
              return EmptyState(
                title: l10n.lookbookEmptyTitle,
                body: l10n.lookbookEmptyBody,
                primaryLabel: l10n.lookbookRestore,
                onPrimary: () => setState(_hidden.clear),
              );
            }
            return ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: gutter, vertical: AppSpacing.md),
              itemCount: visible.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
              itemBuilder: (context, i) {
                final item = visible[i];
                return StaggeredReveal(
                  key: ValueKey(item.id),
                  index: i,
                  child: Dismissible(
                    key: ValueKey('d-${item.id}'),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) {
                      setState(() => _hidden.add(item.id));
                      showToast(context, l10n.lookbookHidden(item.productName));
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.danger,
                        borderRadius: AppRadius.circular(AppRadius.md),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.visibility_off_outlined, color: Colors.white, size: 20),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            l10n.lookbookHide,
                            style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    child: _Row(item: item),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.item});

  final CatalogueItem item;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return Material(
      color: c.card,
      borderRadius: AppRadius.circular(AppRadius.md),
      child: InkWell(
        borderRadius: AppRadius.circular(AppRadius.md),
        onTap: () => context.push(AppRoutes.productPath(item.id)),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xs),
          decoration: BoxDecoration(
            borderRadius: AppRadius.circular(AppRadius.md),
            border: Border.all(color: c.border),
          ),
          child: Row(
            children: [
              AppImage(item.heroImage, width: 72, height: 72, borderRadius: AppRadius.circular(AppRadius.sm)),
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
              HeartButton(productId: item.id, onSurface: true),
              const SizedBox(width: AppSpacing.xxs),
            ],
          ),
        ),
      ),
    );
  }
}

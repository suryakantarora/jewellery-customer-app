import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/layout/breakpoints.dart';
import '../../core/session/session_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../data/models/commerce.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_badge.dart';
import '../../shared/widgets/app_panel.dart';
import '../../shared/widgets/app_toast.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/skeleton.dart';
import '../../shared/widgets/staggered_reveal.dart';
import '../auth/auth_gate.dart';
import '../shell/fino_header.dart';
import 'address_editor.dart';
import 'addresses_provider.dart';

/// Address book (survey: AddressesPage): cards with set-default / edit /
/// delete, add button, editor sheet, empty state.
class AddressesScreen extends ConsumerWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final gutter = Breakpoints.gutter(context);
    final signedIn = ref.watch(isSignedInProvider);
    final addresses = ref.watch(addressesProvider);

    return Scaffold(
      appBar: FinoHeader.page(title: l10n.addressesTitle),
      floatingActionButton: signedIn
          ? FloatingActionButton.extended(
              onPressed: () => showAddressEditor(context),
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.addressAdd),
            )
          : null,
      body: !signedIn
          ? const SignInPrompt()
          : ContentWidth(
              child: addresses.when(
                loading: () => ListView(
                  padding: EdgeInsets.all(gutter),
                  children: const [
                    Skeleton(height: 120, radius: AppRadius.md),
                    SizedBox(height: AppSpacing.sm),
                    Skeleton(height: 120, radius: AppRadius.md),
                  ],
                ),
                error: (_, __) => ErrorState(onRetry: () => ref.invalidate(addressesProvider)),
                data: (list) => list.isEmpty
                    ? EmptyState(
                        icon: Icons.location_on_outlined,
                        title: l10n.addressesEmptyTitle,
                        body: l10n.addressesEmptyBody,
                        primaryLabel: l10n.addressAdd,
                        onPrimary: () => showAddressEditor(context),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.fromLTRB(gutter, AppSpacing.md, gutter, 96),
                        itemCount: list.length,
                        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, i) => StaggeredReveal(
                          key: ValueKey(list[i].id),
                          index: i,
                          child: _AddressCard(address: list[i]),
                        ),
                      ),
              ),
            ),
    );
  }
}

class _AddressCard extends ConsumerWidget {
  const _AddressCard({required this.address});

  final Address address;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return AppPanel(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: c.accentSoft, shape: BoxShape.circle),
                child: Icon(addressLabelIcon(address.label), size: 16, color: c.accent),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(child: Text(addressLabelText(l10n, address.label), style: text.titleMedium)),
              if (address.isDefault) AppBadge(l10n.addressDefault, tone: BadgeTone.ghost),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(address.name, style: text.titleSmall),
          Text(address.line1, style: text.bodyMedium),
          Text('${address.city} ${address.postcode}', style: text.bodyMedium),
          Text(address.phone, style: text.bodySmall),
          Divider(color: c.border, height: AppSpacing.lg),
          Row(
            children: [
              if (!address.isDefault)
                TextButton(
                  onPressed: () async {
                    await ref.read(addressesProvider.notifier).setDefault(address.id);
                    if (context.mounted) showToast(context, l10n.addressDefaultSet, icon: Icons.check_rounded);
                  },
                  child: Text(l10n.addressSetDefault),
                ),
              TextButton(
                onPressed: () => showAddressEditor(context, existing: address),
                child: Text(l10n.actionEdit),
              ),
              const Spacer(),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: AppColors.danger),
                onPressed: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(l10n.addressDeleteTitle),
                      content: Text(l10n.addressDeleteBody),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.actionCancel)),
                        TextButton(
                          style: TextButton.styleFrom(foregroundColor: AppColors.danger),
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Text(l10n.actionDelete),
                        ),
                      ],
                    ),
                  );
                  if (ok == true) {
                    await ref.read(addressesProvider.notifier).delete(address.id);
                    if (context.mounted) showToast(context, l10n.addressDeleted);
                  }
                },
                child: Text(l10n.actionDelete),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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
import 'addresses_provider.dart';

IconData paymentKindIcon(PaymentKind kind) => switch (kind) {
  PaymentKind.card => Icons.credit_card_rounded,
  PaymentKind.wallet => Icons.phone_android_rounded,
  PaymentKind.cod => Icons.payments_outlined,
};

/// Saved payment methods (survey: PaymentMethodsPage): set default / remove;
/// adding is a demo toast until a processor exists.
class PaymentMethodsScreen extends ConsumerWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final gutter = Breakpoints.gutter(context);
    final signedIn = ref.watch(isSignedInProvider);
    final methods = ref.watch(paymentMethodsProvider);

    return Scaffold(
      appBar: FinoHeader.page(title: l10n.paymentMethodsTitle),
      body: !signedIn
          ? const SignInPrompt()
          : ContentWidth(
              child: methods.when(
                loading: () => ListView(
                  padding: EdgeInsets.all(gutter),
                  children: const [
                    Skeleton(height: 72, radius: AppRadius.md),
                    SizedBox(height: AppSpacing.sm),
                    Skeleton(height: 72, radius: AppRadius.md),
                  ],
                ),
                error: (_, __) => ErrorState(onRetry: () => ref.invalidate(paymentMethodsProvider)),
                data: (list) => ListView(
                  padding: EdgeInsets.fromLTRB(gutter, AppSpacing.md, gutter, AppSpacing.xl),
                  children: [
                    if (list.isEmpty)
                      EmptyState(icon: Icons.credit_card_off_outlined, title: l10n.paymentEmptyTitle),
                    for (var i = 0; i < list.length; i++)
                      StaggeredReveal(
                        key: ValueKey(list[i].id),
                        index: i,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: AppPanel(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(color: c.surface2, borderRadius: AppRadius.circular(AppRadius.sm)),
                                  child: Icon(paymentKindIcon(list[i].kind), color: c.textSecondary),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(list[i].label, style: text.titleMedium),
                                          if (list[i].isDefault) ...[
                                            const SizedBox(width: AppSpacing.xs),
                                            AppBadge(l10n.addressDefault, tone: BadgeTone.ghost),
                                          ],
                                        ],
                                      ),
                                      if (list[i].detail.isNotEmpty)
                                        Text(
                                          list[i].detail,
                                          style: text.bodySmall!.copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
                                        ),
                                    ],
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  icon: Icon(Icons.more_vert_rounded, color: c.textMuted),
                                  onSelected: (v) async {
                                    if (v == 'default') {
                                      await ref.read(paymentMethodsProvider.notifier).setDefault(list[i].id);
                                      if (context.mounted) showToast(context, l10n.paymentDefaultSet, icon: Icons.check_rounded);
                                    } else {
                                      await ref.read(paymentMethodsProvider.notifier).remove(list[i].id);
                                      if (context.mounted) showToast(context, l10n.paymentRemoved);
                                    }
                                  },
                                  itemBuilder: (_) => [
                                    if (!list[i].isDefault)
                                      PopupMenuItem(value: 'default', child: Text(l10n.addressSetDefault)),
                                    PopupMenuItem(
                                      value: 'remove',
                                      child: Text(l10n.actionRemove, style: const TextStyle(color: AppColors.danger)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.xs),
                    OutlinedButton.icon(
                      onPressed: () => showToast(context, l10n.paymentAddDemo),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: Text(l10n.paymentAdd),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(l10n.paymentSecureNote, style: text.labelSmall, textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
    );
  }
}

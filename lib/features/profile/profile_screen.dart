import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/tenant/tenant_provider.dart';
import '../../core/theme/tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/empty_state.dart';
import '../shell/fino_header.dart';

/// C1 placeholder — the account experience lands in C2/C6.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final tenant = ref.watch(tenantProvider).valueOrNull;
    return Scaffold(
      appBar: FinoHeader.page(title: l10n.profileTitle),
      body: Padding(
        padding: const EdgeInsets.only(bottom: AppLayout.tabBarHeight),
        child: EmptyState(
          icon: Icons.person_outline_rounded,
          title: l10n.profileWelcome(tenant?.brandName ?? ''),
          body: '${l10n.profileSignInHint}\n${l10n.profileComingSoon}',
        ),
      ),
    );
  }
}

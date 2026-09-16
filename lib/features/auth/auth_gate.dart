import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../../core/session/session_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/empty_state.dart';

/// True when a customer is signed in. Otherwise runs the phone + OTP flow on
/// top of the current screen and resolves true once it completes, so the
/// caller can simply carry on (e.g. push checkout).
Future<bool> ensureSignedIn(BuildContext context, WidgetRef ref) async {
  if (ref.read(isSignedInProvider)) return true;
  final ok = await context.push<bool>(AppRoutes.authPhone);
  return ok == true && ref.read(isSignedInProvider);
}

/// Empty state shown to guests on customer-only screens.
class SignInPrompt extends ConsumerWidget {
  const SignInPrompt({super.key, this.body, this.onSignedIn});

  final String? body;
  final VoidCallback? onSignedIn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    return EmptyState(
      icon: Icons.phone_iphone_rounded,
      title: l10n.authPromptTitle,
      body: body ?? l10n.authPromptBody,
      primaryLabel: l10n.authSignInWithPhone,
      onPrimary: () async {
        if (await ensureSignedIn(context, ref)) onSignedIn?.call();
      },
      secondaryLabel: l10n.actionContinueShopping,
      onSecondary: () => context.go(AppRoutes.home),
    );
  }
}

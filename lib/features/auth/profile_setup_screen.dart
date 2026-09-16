import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/locale_provider.dart';
import '../../core/router/app_routes.dart';
import '../../core/session/session_provider.dart';
import '../../core/theme/tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_chip.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/app_toast.dart';
import '../../shared/widgets/eyebrow.dart';
import 'auth_scaffold.dart';

/// Step 3, first sign-in only: name, optional email, preferred language.
class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key, this.fromWelcome = false});

  final bool fromWelcome;

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  String? _nameError;
  String? _emailError;
  bool _busy = false;

  static final _emailRe = RegExp(r'^\S+@\S+\.\S+$');

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppL10n.of(context);
    final name = _name.text.trim();
    final email = _email.text.trim();
    setState(() {
      _nameError = name.length < 2 ? l10n.authNameRequired : null;
      _emailError = email.isNotEmpty && !_emailRe.hasMatch(email)
          ? l10n.authEmailInvalid
          : null;
    });
    if (_nameError != null || _emailError != null) return;
    final account = ref.read(accountProvider);
    if (account == null) return;
    setState(() => _busy = true);
    await ref
        .read(sessionProvider.notifier)
        .updateProfile(account.copyWith(name: name, email: email.isEmpty ? null : email));
    if (!mounted) return;
    showToast(context, l10n.authWelcomeNew(name), icon: Icons.check_rounded);
    if (widget.fromWelcome) {
      context.go(AppRoutes.home);
    } else {
      context.pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final locale = ref.watch(localeProvider);
    final offered = ref.watch(offeredLocalesProvider);
    return AuthScaffold(
      title: l10n.authProfileTitle,
      subtitle: l10n.authProfileSubtitle,
      children: [
        AppTextField(
          label: l10n.authNameLabel,
          icon: Icons.person_outline_rounded,
          controller: _name,
          error: _nameError,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.name],
        ),
        const SizedBox(height: AppSpacing.sm),
        AppTextField(
          label: l10n.authEmailLabel,
          hint: l10n.authOptional,
          icon: Icons.mail_outline_rounded,
          controller: _email,
          error: _emailError,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.email],
          onSubmitted: (_) => _save(),
        ),
        const SizedBox(height: AppSpacing.md),
        Eyebrow(l10n.settingsLanguage),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          children: [
            for (final l in offered)
              AppChip(
                label: localeNativeNames[l.languageCode] ?? l.languageCode,
                active: l == locale,
                onTap: () => ref.read(localeProvider.notifier).set(l),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        FilledButton(
          onPressed: _busy ? null : _save,
          child: _busy
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(l10n.authFinish),
        ),
      ],
    );
  }
}

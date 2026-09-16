import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../../core/session/session_provider.dart';
import '../../core/tenant/tenant_provider.dart';
import '../../core/theme/tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/app_toast.dart';
import 'auth_scaffold.dart';
import 'otp_screen.dart';

/// Step 1 of sign-in: the mobile number. Sends an OTP and hands over to
/// [OtpScreen]. `fromWelcome` decides where success lands.
class PhoneScreen extends ConsumerStatefulWidget {
  const PhoneScreen({super.key, this.fromWelcome = false});

  final bool fromWelcome;

  @override
  ConsumerState<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends ConsumerState<PhoneScreen> {
  final _phone = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  String get _digits => _phone.text.replaceAll(RegExp(r'\D'), '');

  Future<void> _send() async {
    final l10n = AppL10n.of(context);
    if (_digits.length < 8) {
      setState(() => _error = l10n.authPhoneInvalid);
      return;
    }
    setState(() {
      _error = null;
      _busy = true;
    });
    final code = ref.read(tenantProvider).requireValue.phoneCountryCode;
    final full = '$code ${_formatLocal(_digits)}';
    try {
      final challenge = await ref.read(sessionProvider.notifier).requestOtp(full);
      if (!mounted) return;
      final ok = await context.push<bool>(
        AppRoutes.authOtp,
        extra: OtpArgs(challenge: challenge, fromWelcome: widget.fromWelcome),
      );
      if (!mounted) return;
      if (ok == true && !widget.fromWelcome) context.pop(true);
    } on Object {
      if (mounted) showToast(context, l10n.errorGeneric);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  static String _formatLocal(String d) {
    if (d.length <= 2) return d;
    final buf = StringBuffer(d.substring(0, 2));
    for (var i = 2; i < d.length; i += 4) {
      buf
        ..write(' ')
        ..write(d.substring(i, (i + 4).clamp(0, d.length)));
    }
    return buf.toString();
  }

  Future<void> _guest() async {
    await ref.read(sessionProvider.notifier).continueAsGuest();
    if (!mounted) return;
    if (widget.fromWelcome) {
      context.go(AppRoutes.home);
    } else {
      context.pop(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final code = ref.watch(tenantProvider).valueOrNull?.phoneCountryCode ?? '';
    return AuthScaffold(
      title: l10n.authPhoneTitle,
      subtitle: l10n.authPhoneSubtitle,
      footer: Text(
        l10n.authTerms,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      children: [
        AppTextField(
          label: l10n.authPhoneLabel,
          hint: '20 5555 0142',
          icon: Icons.phone_iphone_rounded,
          prefixText: '$code ',
          controller: _phone,
          error: _error,
          autofocus: true,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.telephoneNumberNational],
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d ]')),
            LengthLimitingTextInputFormatter(14),
          ],
          onChanged: (_) {
            if (_error != null) setState(() => _error = null);
          },
          onSubmitted: (_) => _send(),
        ),
        const SizedBox(height: AppSpacing.md),
        FilledButton(
          onPressed: _busy ? null : _send,
          child: _busy
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(l10n.authSendCode),
        ),
        const SizedBox(height: AppSpacing.md),
        const OrDivider(),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton(onPressed: _busy ? null : _guest, child: Text(l10n.authContinueAsGuest)),
      ],
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/motion/motion.dart';
import '../../core/router/app_routes.dart';
import '../../core/session/session_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../data/models/commerce.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_toast.dart';
import 'auth_scaffold.dart';

/// What the phone screen hands to the OTP route through `extra`.
class OtpArgs {
  const OtpArgs({required this.challenge, this.fromWelcome = false});
  final OtpChallenge challenge;
  final bool fromWelcome;
}

/// Step 2: six-digit code with a hidden field, auto-verify on the sixth
/// digit, resend countdown, shake on rejection.
class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key, required this.challenge, this.fromWelcome = false});

  final OtpChallenge challenge;
  final bool fromWelcome;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen>
    with SingleTickerProviderStateMixin {
  static const length = 6;

  final _code = TextEditingController();
  final _focus = FocusNode();
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );
  Timer? _timer;
  late int _secondsLeft = widget.challenge.resendAfter.inSeconds;
  bool _busy = false;
  bool _rejected = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _code.addListener(_onChanged);
  }

  void _startCountdown() {
    _timer?.cancel();
    _secondsLeft = widget.challenge.resendAfter.inSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _secondsLeft = (_secondsLeft - 1).clamp(0, 999));
      if (_secondsLeft == 0) t.cancel();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _code.dispose();
    _focus.dispose();
    _shake.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (_rejected) setState(() => _rejected = false);
    if (_code.text.length == length && !_busy) {
      unawaited(_verify());
    } else {
      setState(() {});
    }
  }

  Future<void> _verify() async {
    final l10n = AppL10n.of(context);
    setState(() => _busy = true);
    try {
      final session = await ref
          .read(sessionProvider.notifier)
          .verifyOtp(widget.challenge.phone, _code.text);
      if (!mounted) return;
      final account = session.account;
      if (account != null && account.needsProfile) {
        final done = await context.push<bool>(
          AppRoutes.authProfile,
          extra: widget.fromWelcome,
        );
        if (!mounted) return;
        if (done == true && !widget.fromWelcome) context.pop(true);
        return;
      }
      showToast(context, l10n.authWelcomeBack(account?.name ?? ''), icon: Icons.check_rounded);
      if (widget.fromWelcome) {
        context.go(AppRoutes.home);
      } else {
        context.pop(true);
      }
    } on OtpRejectedException {
      if (!mounted) return;
      setState(() => _rejected = true);
      unawaited(_shake.forward(from: 0));
      unawaited(HapticFeedback.mediumImpact());
      _code.clear();
    } on Object {
      if (mounted) showToast(context, l10n.errorGeneric);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resend() async {
    final l10n = AppL10n.of(context);
    await ref.read(sessionProvider.notifier).requestOtp(widget.challenge.phone);
    if (!mounted) return;
    showToast(context, l10n.authCodeResent, icon: Icons.sms_outlined);
    setState(_startCountdown);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final digits = _code.text;

    return AuthScaffold(
      title: l10n.authOtpTitle,
      subtitle: l10n.authOtpSubtitle(widget.challenge.phone),
      children: [
        GestureDetector(
          onTap: () => _focus.requestFocus(),
          child: Stack(
            children: [
              // The real input, invisible; the boxes below mirror it.
              Opacity(
                opacity: 0,
                child: SizedBox(
                  height: 1,
                  child: TextField(
                    controller: _code,
                    focusNode: _focus,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    autofillHints: const [AutofillHints.oneTimeCode],
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(length),
                    ],
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _shake,
                builder: (context, child) {
                  final t = _shake.value;
                  final dx = t == 0 || t == 1
                      ? 0.0
                      : 8 * (1 - t) * ((t * 6).floor().isEven ? 1 : -1);
                  return Transform.translate(offset: Offset(dx, 0), child: child);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (var i = 0; i < length; i++)
                      AnimatedContainer(
                        duration: AppMotion.of(context, AppMotion.fast),
                        width: 44,
                        height: 54,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: c.surface,
                          borderRadius: AppRadius.circular(AppRadius.sm),
                          border: Border.all(
                            color: _rejected
                                ? AppColors.danger
                                : i == digits.length && _focus.hasFocus
                                ? c.primary
                                : c.borderStrong,
                            width: i == digits.length && !_rejected ? 1.5 : 1,
                          ),
                        ),
                        child: Text(
                          i < digits.length ? digits[i] : '',
                          style: text.headlineMedium,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AnimatedSwitcher(
          duration: AppMotion.of(context, AppMotion.fast),
          child: _rejected
              ? Text(
                  l10n.authOtpWrong,
                  key: const ValueKey('wrong'),
                  style: text.bodySmall!.copyWith(color: AppColors.danger),
                )
              : Text(
                  l10n.authOtpDemoHint,
                  key: const ValueKey('hint'),
                  style: text.bodySmall,
                ),
        ),
        const SizedBox(height: AppSpacing.lg),
        FilledButton(
          onPressed: _busy || digits.length < length ? null : _verify,
          child: _busy
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(l10n.authVerify),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: _secondsLeft > 0 ? null : _resend,
              child: Text(
                _secondsLeft > 0
                    ? l10n.authResendIn(_secondsLeft)
                    : l10n.authResend,
              ),
            ),
            TextButton(
              onPressed: () => context.pop(false),
              child: Text(l10n.authChangeNumber),
            ),
          ],
        ),
      ],
    );
  }
}

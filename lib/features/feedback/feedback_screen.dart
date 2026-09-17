import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/layout/breakpoints.dart';
import '../../core/motion/motion.dart';
import '../../core/router/app_routes.dart';
import '../../core/session/session_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../data/repositories/repositories.dart';
import '../../data/repository_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/animated_tick.dart';
import '../../shared/widgets/app_chip.dart';
import '../../shared/widgets/app_panel.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/eyebrow.dart';
import '../../shared/widgets/press_scale.dart';
import '../shell/fino_header.dart';

/// Feedback (survey: FeedbackPage): mood toggle, topic chips, message with
/// counter, email, follow-up switch, Send (1100 ms busy) → confirmation
/// with a ticket number.
class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  static const maxLength = 500;
  static const minLength = 10;

  var _happy = true;
  String? _topic;
  final _message = TextEditingController();
  late final _email = TextEditingController(
    text: ref.read(accountProvider)?.email ?? '',
  );
  var _followUp = false;
  var _busy = false;
  String? _ticket;
  String? _error;

  @override
  void dispose() {
    _message.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final l10n = AppL10n.of(context);
    if (_message.text.trim().length < minLength) {
      setState(() => _error = l10n.feedbackTooShort(minLength));
      return;
    }
    setState(() {
      _error = null;
      _busy = true;
    });
    final ticket = await ref
        .read(feedbackRepositoryProvider)
        .submit(
          FeedbackDraft(
            happy: _happy,
            topic: _topic ?? '',
            message: _message.text.trim(),
            email: _email.text.trim().isEmpty ? null : _email.text.trim(),
            followUp: _followUp,
          ),
        );
    if (!mounted) return;
    setState(() {
      _busy = false;
      _ticket = ticket;
    });
  }

  void _reset() => setState(() {
    _ticket = null;
    _message.clear();
    _topic = null;
    _happy = true;
    _followUp = false;
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final gutter = Breakpoints.gutter(context);
    return Scaffold(
      appBar: FinoHeader.page(title: l10n.settingsFeedback),
      body: ContentWidth(
        child: AnimatedSwitcher(
          duration: AppMotion.of(context, AppMotion.normal),
          child: _ticket == null
              ? _form(context, gutter)
              : _done(context, gutter),
        ),
      ),
    );
  }

  Widget _form(BuildContext context, double gutter) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final topics = [
      l10n.feedbackTopicApp,
      l10n.feedbackTopicRange,
      l10n.feedbackTopicPricing,
      l10n.feedbackTopicDelivery,
      l10n.feedbackTopicStore,
      l10n.feedbackTopicOther,
    ];
    return ListView(
      key: const ValueKey('form'),
      padding: EdgeInsets.symmetric(
        horizontal: gutter,
        vertical: AppSpacing.lg,
      ),
      children: [
        Eyebrow(l10n.feedbackEyebrow),
        const SizedBox(height: AppSpacing.xxs),
        Text(l10n.feedbackTitle, style: text.displaySmall),
        const SizedBox(height: AppSpacing.xxs),
        Text(l10n.feedbackIntro, style: text.bodyMedium),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            for (final (happy, icon, label) in [
              (true, Icons.sentiment_satisfied_alt_rounded, l10n.feedbackHappy),
              (false, Icons.sentiment_dissatisfied_rounded, l10n.feedbackSad),
            ]) ...[
              Expanded(
                child: PressScale(
                  onTap: () => setState(() => _happy = happy),
                  child: AnimatedContainer(
                    duration: AppMotion.of(context, AppMotion.normal),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: _happy == happy ? c.accentSoft : c.card,
                      borderRadius: AppRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: _happy == happy ? c.accent : c.border,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          icon,
                          size: 32,
                          color: _happy == happy ? c.accent : c.textMuted,
                        ),
                        const SizedBox(height: 4),
                        Text(label, style: text.labelLarge),
                      ],
                    ),
                  ),
                ),
              ),
              if (happy) const SizedBox(width: AppSpacing.sm),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Eyebrow(l10n.feedbackTopic),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final t in topics)
              AppChip(
                label: t,
                active: _topic == t,
                onTap: () => setState(() => _topic = t),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        AppPanel(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            AppTextField(
              label: l10n.feedbackMessage,
              controller: _message,
              maxLines: 5,
              error: _error,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (_) => setState(() {}),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '${_message.text.length.clamp(0, maxLength)} / $maxLength',
                  style: text.labelSmall!.copyWith(
                    color: _message.text.length > maxLength
                        ? AppColors.danger
                        : c.textMuted,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            AppTextField(
              label: l10n.contactEmail,
              controller: _email,
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: _followUp,
              onChanged: (v) => setState(() => _followUp = v),
              title: Text(l10n.feedbackFollowUp, style: text.bodyMedium),
            ),
            const SizedBox(height: AppSpacing.xs),
            FilledButton(
              onPressed: _busy || _message.text.length > maxLength
                  ? null
                  : _send,
              child: _busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(l10n.contactSend),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }

  Widget _done(BuildContext context, double gutter) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return ListView(
      key: const ValueKey('done'),
      padding: EdgeInsets.symmetric(
        horizontal: gutter,
        vertical: AppSpacing.xxl,
      ),
      children: [
        const Center(child: AnimatedTick()),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.feedbackThanksTitle,
          style: text.displaySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.feedbackThanksBody,
          style: text.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: c.accentSoft,
              borderRadius: AppRadius.circular(AppRadius.pill),
            ),
            child: Text(
              l10n.feedbackTicket(_ticket!),
              style: text.labelLarge!.copyWith(
                color: c.accent,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        FilledButton(
          onPressed: () => context.pop(),
          child: Text(l10n.feedbackBack),
        ),
        const SizedBox(height: AppSpacing.xs),
        OutlinedButton(onPressed: _reset, child: Text(l10n.feedbackAnother)),
        const SizedBox(height: AppSpacing.xs),
        TextButton(
          onPressed: () => context.pushReplacement(AppRoutes.rateUs),
          child: Text(l10n.feedbackRate),
        ),
      ],
    );
  }
}

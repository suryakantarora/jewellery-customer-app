import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format/formatters_provider.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/motion/motion.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_chip.dart';
import '../shell/fino_header.dart';
import 'support_flow.dart';
import 'support_provider.dart';

/// Support chat (survey: SupportPage): bot / user / agent bubbles with a
/// rise-in, system lines, a three-dot typing indicator, and a contextual
/// composer: option chips while scripted, a text field once an agent joins.
class SupportScreen extends ConsumerStatefulWidget {
  const SupportScreen({super.key});

  @override
  ConsumerState<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends ConsumerState<SupportScreen> {
  final _scroll = ScrollController();
  final _input = TextEditingController();

  @override
  void dispose() {
    _scroll.dispose();
    _input.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: AppMotion.of(context, AppMotion.normal),
        curve: AppMotion.easeOut,
      );
    });
  }

  String _text(AppL10n l10n, SupportMessage m) => switch (m.author) {
    SupportAuthor.bot => SupportFlow.nodes[m.nodeId]?.reply(l10n) ?? m.text,
    SupportAuthor.system => switch (m.text) {
      'connecting' => l10n.supportConnecting,
      'joined' => l10n.supportAgentJoined(SupportController.agentName),
      _ => m.text,
    },
    SupportAuthor.agent => switch (m.text) {
      'greeting' => l10n.supportAgentGreeting(SupportController.agentName),
      'ack' => l10n.supportAgentAck,
      _ => m.text,
    },
    SupportAuthor.user => m.text,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final thread = ref.watch(supportProvider);
    final gutter = Breakpoints.gutter(context);
    ref.listen(supportProvider, (_, __) => _scrollToEnd());

    final node = thread.nodeId == null
        ? null
        : SupportFlow.nodes[thread.nodeId];
    final link = node?.link;

    return Scaffold(
      appBar: FinoHeader.page(title: l10n.supportTitle),
      body: ContentWidth(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                controller: _scroll,
                padding: EdgeInsets.symmetric(
                  horizontal: gutter,
                  vertical: AppSpacing.md,
                ),
                children: [
                  for (final m in thread.messages)
                    _Bubble(
                      key: ValueKey(m.at.microsecondsSinceEpoch),
                      author: m.author,
                      text: _text(l10n, m),
                      time: ref.read(dateFormatterProvider).time(m.at),
                    ),
                  if (thread.typing) const _Typing(),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                gutter,
                AppSpacing.sm,
                gutter,
                AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: c.surface,
                border: Border(top: BorderSide(color: c.border)),
              ),
              child: SafeArea(
                top: false,
                child: thread.agentJoined
                    ? Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _input,
                              textInputAction: TextInputAction.send,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                hintText: l10n.supportComposerHint,
                              ),
                              onSubmitted: (_) => _send(),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          IconButton.filled(
                            tooltip: l10n.contactSend,
                            onPressed: _send,
                            icon: const Icon(Icons.send_rounded, size: 18),
                          ),
                        ],
                      )
                    : node == null
                    ? Text(l10n.supportWaiting, style: text.bodySmall)
                    : Wrap(
                        spacing: AppSpacing.xs,
                        runSpacing: AppSpacing.xs,
                        children: [
                          if (link != null)
                            AppChip(
                              label: l10n.supportOpenLink,
                              leading: const Icon(
                                Icons.open_in_new_rounded,
                                size: 14,
                              ),
                              active: true,
                              onTap: () => context.push(link),
                            ),
                          for (final o in node.options)
                            AppChip(
                              label: o.label(l10n),
                              onTap: () => ref
                                  .read(supportProvider.notifier)
                                  .choose(o, o.label(l10n)),
                            ),
                          if (thread.messages.length > 1)
                            AppChip(
                              label: l10n.supportRestart,
                              leading: const Icon(
                                Icons.refresh_rounded,
                                size: 14,
                              ),
                              onTap: () =>
                                  ref.read(supportProvider.notifier).reset(),
                            ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _send() {
    ref.read(supportProvider.notifier).send(_input.text);
    _input.clear();
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({
    super.key,
    required this.author,
    required this.text,
    required this.time,
  });

  final SupportAuthor author;
  final String text;
  final String time;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final styles = Theme.of(context).textTheme;
    if (author == SupportAuthor.system) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Center(
          child: Text(
            text,
            style: styles.labelSmall,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    final mine = author == SupportAuthor.user;
    final avatar = switch (author) {
      SupportAuthor.bot => Icons.auto_awesome_rounded,
      SupportAuthor.agent => Icons.person_rounded,
      _ => null,
    };
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppMotion.of(context, AppMotion.normal),
      curve: AppMotion.easeOut,
      builder: (context, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(
          offset: Offset(0, 8 * (1 - v)),
          child: child,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: mine
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (avatar != null) ...[
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: c.accentSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(avatar, size: 14, color: c.accent),
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
            Flexible(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 320),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: mine ? c.primary : c.card,
                  border: mine ? null : Border.all(color: c.border),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(AppRadius.md),
                    topRight: const Radius.circular(AppRadius.md),
                    bottomLeft: Radius.circular(
                      mine ? AppRadius.md : AppRadius.xs,
                    ),
                    bottomRight: Radius.circular(
                      mine ? AppRadius.xs : AppRadius.md,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: styles.bodyMedium!.copyWith(
                        color: mine ? Colors.white : c.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      time,
                      style: styles.labelSmall!.copyWith(
                        color: mine
                            ? Colors.white.withValues(alpha: .7)
                            : c.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// `blink`: three dots fading in turn.
class _Typing extends StatefulWidget {
  const _Typing();

  @override
  State<_Typing> createState() => _TypingState();
}

class _TypingState extends State<_Typing> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!AppMotion.reduced(context) && !_c.isAnimating) _c.repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: c.card,
            border: Border.all(color: c.border),
            borderRadius: AppRadius.circular(AppRadius.md),
          ),
          child: AnimatedBuilder(
            animation: _c,
            builder: (context, _) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < 3; i++)
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: c.textMuted.withValues(
                        alpha:
                            .3 +
                            .7 *
                                (((_c.value * 3 - i) % 3).clamp(0, 1) < .5
                                    ? 1
                                    : 0),
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

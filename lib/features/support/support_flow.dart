import '../../l10n/app_localizations.dart';

/// One node of the scripted support tree (survey `support-flow.ts`).
class SupportNode {
  const SupportNode({
    required this.id,
    required this.reply,
    this.options = const [],
    this.link,
  });

  final String id;

  /// The bot's message when this node is reached.
  final String Function(AppL10n) reply;
  final List<SupportOption> options;

  /// A route the node offers to open ("Open my orders").
  final String? link;
}

class SupportOption {
  const SupportOption({required this.label, required this.next});
  final String Function(AppL10n) label;
  final String next;
}

/// root → Track my order / Returns & exchange / Care & sizing / Payments &
/// offers; each leaf offers "That helped" or "Talk to a live agent".
abstract final class SupportFlow {
  static const rootId = 'root';
  static const agentId = 'agent';
  static const helpedId = 'helped';

  static final nodes = <String, SupportNode>{
    rootId: SupportNode(
      id: rootId,
      reply: (l) => l.supportRoot,
      options: [
        SupportOption(label: (l) => l.supportOptTrack, next: 'track'),
        SupportOption(label: (l) => l.supportOptReturns, next: 'returns'),
        SupportOption(label: (l) => l.supportOptCare, next: 'care'),
        SupportOption(label: (l) => l.supportOptPayments, next: 'payments'),
      ],
    ),
    'track': SupportNode(
      id: 'track',
      reply: (l) => l.supportTrack,
      link: '/orders',
      options: _leaf,
    ),
    'returns': SupportNode(
      id: 'returns',
      reply: (l) => l.supportReturns,
      link: '/policy/return',
      options: _leaf,
    ),
    'care': SupportNode(
      id: 'care',
      reply: (l) => l.supportCare,
      link: '/size-guide?kind=ring',
      options: _leaf,
    ),
    'payments': SupportNode(
      id: 'payments',
      reply: (l) => l.supportPayments,
      link: '/offers',
      options: _leaf,
    ),
    helpedId: SupportNode(
      id: helpedId,
      reply: (l) => l.supportHelped,
      options: [SupportOption(label: (l) => l.supportOptMore, next: rootId)],
    ),
  };

  static final _leaf = [
    SupportOption(label: (l) => l.supportOptHelped, next: helpedId),
    SupportOption(label: (l) => l.supportOptAgent, next: agentId),
    SupportOption(label: (l) => l.supportOptMore, next: rootId),
  ];
}

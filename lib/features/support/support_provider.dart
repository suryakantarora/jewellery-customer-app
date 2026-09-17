import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/storage/storage_keys.dart';
import 'support_flow.dart';

enum SupportAuthor { bot, user, agent, system }

class SupportMessage {
  const SupportMessage({
    required this.author,
    required this.text,
    required this.at,
    this.nodeId,
  });

  final SupportAuthor author;

  /// For bot replies this is the node id (rendered through l10n); for
  /// everything else the literal text.
  final String text;
  final DateTime at;
  final String? nodeId;

  Map<String, dynamic> toJson() => {
    'author': author.name,
    'text': text,
    'at': at.toIso8601String(),
    'nodeId': nodeId,
  };

  factory SupportMessage.fromJson(Map<String, dynamic> json) => SupportMessage(
    author: SupportAuthor.values.byName(json['author'] as String),
    text: json['text'] as String,
    at: DateTime.tryParse(json['at'] as String? ?? '') ?? DateTime.now(),
    nodeId: json['nodeId'] as String?,
  );
}

class SupportThread {
  const SupportThread({
    required this.messages,
    required this.nodeId,
    this.typing = false,
    this.agentJoined = false,
  });

  final List<SupportMessage> messages;

  /// The node whose options the composer shows (null while an agent chats).
  final String? nodeId;
  final bool typing;
  final bool agentJoined;

  SupportThread copyWith({
    List<SupportMessage>? messages,
    String? nodeId,
    bool clearNode = false,
    bool? typing,
    bool? agentJoined,
  }) => SupportThread(
    messages: messages ?? this.messages,
    nodeId: clearNode ? null : (nodeId ?? this.nodeId),
    typing: typing ?? this.typing,
    agentJoined: agentJoined ?? this.agentJoined,
  );
}

/// The scripted chat (survey: SupportPage). The transcript is persisted so
/// leaving the page keeps the thread; an agent "Meera" joins 2200 ms after
/// escalation and echoes a canned reply to each message.
class SupportController extends Notifier<SupportThread> {
  static const agentName = 'Meera';
  static const agentDelay = Duration(milliseconds: 2200);
  static const botDelay = Duration(milliseconds: 700);

  Timer? _timer;

  @override
  SupportThread build() {
    ref.onDispose(() => _timer?.cancel());
    final raw = ref
        .read(localStoreProvider)
        .getString(StorageKeys.supportThread);
    if (raw != null) {
      try {
        final json = jsonDecode(raw) as Map<String, dynamic>;
        return SupportThread(
          messages: (json['messages'] as List)
              .map((e) => SupportMessage.fromJson(e as Map<String, dynamic>))
              .toList(),
          nodeId: json['nodeId'] as String?,
          agentJoined: json['agentJoined'] as bool? ?? false,
        );
      } on Object {
        // Fall through to a fresh thread.
      }
    }
    return SupportThread(
      messages: [
        SupportMessage(
          author: SupportAuthor.bot,
          text: SupportFlow.rootId,
          nodeId: SupportFlow.rootId,
          at: DateTime.now(),
        ),
      ],
      nodeId: SupportFlow.rootId,
    );
  }

  Future<void> _persist() => ref
      .read(localStoreProvider)
      .setString(
        StorageKeys.supportThread,
        jsonEncode({
          'messages': state.messages.map((m) => m.toJson()).toList(),
          'nodeId': state.nodeId,
          'agentJoined': state.agentJoined,
        }),
      );

  void _append(SupportMessage m) {
    state = state.copyWith(messages: [...state.messages, m]);
  }

  /// The user picks one of the current node's options.
  void choose(SupportOption option, String label) {
    _append(
      SupportMessage(
        author: SupportAuthor.user,
        text: label,
        at: DateTime.now(),
      ),
    );
    if (option.next == SupportFlow.agentId) {
      _escalate();
      return;
    }
    state = state.copyWith(typing: true, clearNode: true);
    _timer?.cancel();
    _timer = Timer(botDelay, () {
      _append(
        SupportMessage(
          author: SupportAuthor.bot,
          text: option.next,
          nodeId: option.next,
          at: DateTime.now(),
        ),
      );
      state = state.copyWith(typing: false, nodeId: option.next);
      _persist();
    });
  }

  void _escalate() {
    _append(
      SupportMessage(
        author: SupportAuthor.system,
        text: 'connecting',
        at: DateTime.now(),
      ),
    );
    state = state.copyWith(typing: true, clearNode: true);
    _timer?.cancel();
    _timer = Timer(agentDelay, () {
      _append(
        SupportMessage(
          author: SupportAuthor.system,
          text: 'joined',
          at: DateTime.now(),
        ),
      );
      _append(
        SupportMessage(
          author: SupportAuthor.agent,
          text: 'greeting',
          at: DateTime.now(),
        ),
      );
      state = state.copyWith(typing: false, agentJoined: true);
      _persist();
    });
  }

  /// Free text once an agent has joined.
  void send(String text) {
    if (text.trim().isEmpty) return;
    _append(
      SupportMessage(
        author: SupportAuthor.user,
        text: text.trim(),
        at: DateTime.now(),
      ),
    );
    state = state.copyWith(typing: true);
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 1400), () {
      _append(
        SupportMessage(
          author: SupportAuthor.agent,
          text: 'ack',
          at: DateTime.now(),
        ),
      );
      state = state.copyWith(typing: false);
      _persist();
    });
  }

  Future<void> reset() async {
    _timer?.cancel();
    await ref.read(localStoreProvider).remove(StorageKeys.supportThread);
    ref.invalidateSelf();
  }
}

final supportProvider = NotifierProvider<SupportController, SupportThread>(
  SupportController.new,
);

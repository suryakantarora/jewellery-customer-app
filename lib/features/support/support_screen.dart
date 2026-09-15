import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/widgets/empty_state.dart';
import '../shell/fino_header.dart';

/// Placeholder target for the raised FAB; the scripted chat arrives in C8.
class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    return Scaffold(
      appBar: FinoHeader.page(title: l10n.supportTitle),
      body: EmptyState(
        icon: Icons.chat_bubble_outline_rounded,
        title: l10n.supportPlaceholderTitle,
        body: l10n.supportPlaceholderBody,
      ),
    );
  }
}

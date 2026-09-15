import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/widgets/empty_state.dart';
import 'fino_header.dart';

/// Stands in for routes whose screens land in later phases, so every link
/// in the drawer and header already resolves.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    return Scaffold(
      appBar: FinoHeader.page(title: title),
      body: EmptyState(title: l10n.emptyTitle, body: l10n.emptyBody),
    );
  }
}

import 'package:flutter/material.dart';

import '../../core/theme/tokens.dart';

/// `.pvj-toast`: a short floating notice above the tab bar.
void showToast(BuildContext context, String message, {IconData? icon}) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 1800),
        margin: const EdgeInsets.fromLTRB(
          AppLayout.gutter,
          0,
          AppLayout.gutter,
          AppLayout.tabBarHeight + AppSpacing.md,
        ),
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: Theme.of(context).colorScheme.surface),
              const SizedBox(width: AppSpacing.xs),
            ],
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
}

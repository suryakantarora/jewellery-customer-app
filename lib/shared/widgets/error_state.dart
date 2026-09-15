import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../l10n/app_localizations.dart';

/// "Something went wrong" + retry. Never surfaces technical text — the
/// error object is deliberately not accepted here.
class ErrorState extends StatelessWidget {
  const ErrorState({super.key, this.onRetry, this.body});

  final VoidCallback? onRetry;
  final String? body;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: c.primary.withValues(alpha: .08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.error_outline, size: 30, color: c.primary),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.errorTitle,
              style: text.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              body ?? l10n.errorGeneric,
              style: text.bodyMedium!.copyWith(color: c.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton(onPressed: onRetry, child: Text(l10n.retry)),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/layout/breakpoints.dart';
import '../../core/providers.dart';
import '../../core/tenant/tenant_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../l10n/app_localizations.dart';
import '../shell/fino_header.dart';

/// Dev-only: changes the tenant key at runtime and reloads the tenant config.
class ShopCodeScreen extends ConsumerStatefulWidget {
  const ShopCodeScreen({super.key});

  @override
  ConsumerState<ShopCodeScreen> createState() => _ShopCodeScreenState();
}

class _ShopCodeScreenState extends ConsumerState<ShopCodeScreen> {
  late final TextEditingController _controller = TextEditingController(
    text: ref.read(tenantKeyProvider),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _apply(String value) async {
    final l10n = AppL10n.of(context);
    final messenger = ScaffoldMessenger.of(context);
    await ref.read(tenantKeyProvider.notifier).set(value);
    // Changing the key rebuilds tenantProvider through its watch; reload
    // explicitly too so an unchanged key still refreshes.
    await ref.read(tenantProvider.notifier).reload();
    if (!mounted) return;
    _controller.text = ref.read(tenantKeyProvider);
    messenger.showSnackBar(SnackBar(content: Text(l10n.shopCodeApplied)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final current = ref.watch(tenantKeyProvider);
    final defaultKey = ref.watch(appConfigProvider).tenantKey;
    final gutter = Breakpoints.gutter(context);

    return Scaffold(
      appBar: FinoHeader.page(title: l10n.shopCodeTitle),
      body: ContentWidth(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: gutter, vertical: AppSpacing.lg),
          children: [
            Text(
              l10n.shopCodeIntro,
              style: text.bodyMedium!.copyWith(color: c.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _controller,
              autocorrect: false,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: l10n.shopCodeLabel,
                hintText: l10n.shopCodeHint,
                prefixIcon: const Icon(Icons.storefront_outlined),
              ),
              onSubmitted: _apply,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.shopCodeCurrent(current), style: text.labelSmall),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: () => _apply(_controller.text),
              child: Text(l10n.shopCodeApply),
            ),
            if (current != defaultKey) ...[
              const SizedBox(height: AppSpacing.xs),
              TextButton(
                onPressed: () => _apply(defaultKey),
                child: Text(l10n.shopCodeReset),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

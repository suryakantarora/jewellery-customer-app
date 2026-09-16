import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/session/session_provider.dart';
import '../../core/theme/tokens.dart';
import '../../data/models/commerce.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_chip.dart';
import '../../shared/widgets/app_sheet.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/eyebrow.dart';
import 'addresses_provider.dart';

IconData addressLabelIcon(AddressLabel label) => switch (label) {
  AddressLabel.home => Icons.home_outlined,
  AddressLabel.work => Icons.work_outline_rounded,
  AddressLabel.other => Icons.place_outlined,
};

String addressLabelText(AppL10n l10n, AddressLabel label) => switch (label) {
  AddressLabel.home => l10n.addressLabelHome,
  AddressLabel.work => l10n.addressLabelWork,
  AddressLabel.other => l10n.addressLabelOther,
};

/// The address editor bottom sheet (breakpoint .92): label chips, fields,
/// "make default" toggle, Save. Returns true when saved.
Future<bool> showAddressEditor(BuildContext context, {Address? existing}) async {
  final saved = await showAppSheet<bool>(
    context,
    heightFactor: .92,
    builder: (_) => _AddressEditor(existing: existing),
  );
  return saved == true;
}

class _AddressEditor extends ConsumerStatefulWidget {
  const _AddressEditor({this.existing});

  final Address? existing;

  @override
  ConsumerState<_AddressEditor> createState() => _AddressEditorState();
}

class _AddressEditorState extends ConsumerState<_AddressEditor> {
  late AddressLabel _label = widget.existing?.label ?? AddressLabel.home;
  late final _name = TextEditingController(
    text: widget.existing?.name ?? ref.read(accountProvider)?.name ?? '',
  );
  late final _phone = TextEditingController(
    text: widget.existing?.phone ?? ref.read(accountProvider)?.phone ?? '',
  );
  late final _line1 = TextEditingController(text: widget.existing?.line1 ?? '');
  late final _city = TextEditingController(text: widget.existing?.city ?? '');
  late final _postcode = TextEditingController(text: widget.existing?.postcode ?? '');
  late bool _default = widget.existing?.isDefault ?? false;
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    for (final c in [_name, _phone, _line1, _city, _postcode]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppL10n.of(context);
    if ([_name, _phone, _line1, _city].any((c) => c.text.trim().isEmpty)) {
      setState(() => _error = l10n.checkoutAddressIncomplete);
      return;
    }
    setState(() => _busy = true);
    await ref.read(addressesProvider.notifier).save(
      Address(
        id: widget.existing?.id ?? '',
        label: _label,
        name: _name.text.trim(),
        phone: _phone.text.trim(),
        line1: _line1.text.trim(),
        city: _city.text.trim(),
        postcode: _postcode.text.trim(),
        isDefault: _default,
      ),
    );
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final text = Theme.of(context).textTheme;
    return AppSheetScaffold(
      title: widget.existing == null ? l10n.addressAdd : l10n.addressEdit,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppLayout.gutter, AppSpacing.sm, AppLayout.gutter, AppSpacing.md),
        children: [
          Eyebrow(l10n.addressLabel),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            children: [
              for (final l in AddressLabel.values)
                AppChip(
                  label: addressLabelText(l10n, l),
                  leading: Icon(addressLabelIcon(l)),
                  active: _label == l,
                  onTap: () => setState(() => _label = l),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(label: l10n.addressName, icon: Icons.person_outline_rounded, controller: _name, textCapitalization: TextCapitalization.words),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(label: l10n.addressPhone, icon: Icons.phone_outlined, controller: _phone, keyboardType: TextInputType.phone),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(label: l10n.addressLine1, icon: Icons.home_outlined, controller: _line1, textCapitalization: TextCapitalization.sentences),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(flex: 3, child: AppTextField(label: l10n.addressCity, controller: _city, textCapitalization: TextCapitalization.words)),
              const SizedBox(width: AppSpacing.xs),
              Expanded(flex: 2, child: AppTextField(label: l10n.addressPostcode, controller: _postcode, keyboardType: TextInputType.number)),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.addressMakeDefault, style: text.titleMedium),
            value: _default,
            onChanged: (v) => setState(() => _default = v),
          ),
          if (_error != null)
            Text(_error!, style: text.bodySmall!.copyWith(color: Theme.of(context).colorScheme.error)),
        ],
      ),
      footer: FilledButton(
        onPressed: _busy ? null : _save,
        child: Text(l10n.actionSave),
      ),
    );
  }
}

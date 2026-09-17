import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/motion/motion.dart';
import '../../core/session/session_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/animated_tick.dart';
import '../../shared/widgets/app_sheet.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/press_scale.dart';

/// The bespoke commission request (survey: ItemCreatePage): a reference
/// photo from the camera or gallery, name, budget, brief → 1100 ms busy →
/// tick. Opened from the lookbook's "+".
Future<void> showCommissionSheet(BuildContext context) => showAppSheet<void>(
  context,
  heightFactor: .92,
  builder: (_) => const _CommissionSheet(),
);

class _CommissionSheet extends ConsumerStatefulWidget {
  const _CommissionSheet();

  @override
  ConsumerState<_CommissionSheet> createState() => _CommissionSheetState();
}

class _CommissionSheetState extends ConsumerState<_CommissionSheet> {
  late final _name = TextEditingController(
    text: ref.read(accountProvider)?.name ?? '',
  );
  final _budget = TextEditingController();
  final _brief = TextEditingController();
  final _picker = ImagePicker();
  XFile? _photo;
  String? _nameError;
  var _busy = false;
  var _done = false;

  @override
  void dispose() {
    _name.dispose();
    _budget.dispose();
    _brief.dispose();
    super.dispose();
  }

  Future<void> _pick(ImageSource source) async {
    try {
      final file = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (file != null && mounted) setState(() => _photo = file);
    } on Object {
      // Permission declined or no camera: the form still submits without a photo.
    }
  }

  Future<void> _submit() async {
    final l10n = AppL10n.of(context);
    if (_name.text.trim().isEmpty) {
      setState(() => _nameError = l10n.commissionNameRequired);
      return;
    }
    setState(() {
      _nameError = null;
      _busy = true;
    });
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;
    setState(() {
      _busy = false;
      _done = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    if (_done) {
      return AppSheetScaffold(
        title: l10n.commissionTitle,
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AnimatedTick(),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.commissionDoneTitle,
                style: text.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.commissionDoneBody,
                style: text.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.actionDone),
              ),
            ],
          ),
        ),
      );
    }
    return AppSheetScaffold(
      title: l10n.commissionTitle,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.commissionIntro, style: text.bodyMedium),
            const SizedBox(height: AppSpacing.md),
            PressScale(
              onTap: () => _pick(ImageSource.gallery),
              child: AnimatedContainer(
                duration: AppMotion.of(context, AppMotion.normal),
                height: 150,
                decoration: BoxDecoration(
                  color: c.surface2,
                  borderRadius: AppRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: _photo == null ? c.borderStrong : c.accent,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: _photo == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 32,
                            color: c.textMuted,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.commissionPhotoHint,
                            style: text.labelMedium,
                          ),
                        ],
                      )
                    : Image.file(File(_photo!.path), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () => _pick(ImageSource.camera),
                  icon: const Icon(Icons.photo_camera_outlined, size: 18),
                  label: Text(l10n.commissionCamera),
                ),
                TextButton.icon(
                  onPressed: () => _pick(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_outlined, size: 18),
                  label: Text(l10n.commissionGallery),
                ),
                if (_photo != null)
                  TextButton(
                    onPressed: () => setState(() => _photo = null),
                    child: Text(l10n.actionRemove),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: l10n.addressName,
              controller: _name,
              icon: Icons.person_outline_rounded,
              error: _nameError,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: l10n.commissionBudget,
              controller: _budget,
              icon: Icons.payments_outlined,
              keyboardType: TextInputType.number,
              hint: '₭',
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: l10n.commissionBrief,
              controller: _brief,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
            ),
          ],
        ),
      ),
      footer: FilledButton(
        onPressed: _busy ? null : _submit,
        child: _busy
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(l10n.commissionSend),
      ),
    );
  }
}

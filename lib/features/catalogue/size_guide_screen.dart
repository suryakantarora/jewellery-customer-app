import 'package:flutter/material.dart';

import '../../core/layout/breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../data/models/retail_attributes.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_panel.dart';
import '../../shared/widgets/segmented_control.dart';
import '../../shared/widgets/staggered_reveal.dart';
import '../shell/fino_header.dart';
import 'size_charts.dart';

/// Size guide (survey: SizeGuidePage): Ring / Bangle / Length segments,
/// measure-at-home steps, tables, tip and resize note.
class SizeGuideScreen extends StatefulWidget {
  const SizeGuideScreen({super.key, this.kind = SizeKind.ring});

  final SizeKind kind;

  @override
  State<SizeGuideScreen> createState() => _SizeGuideScreenState();
}

class _SizeGuideScreenState extends State<SizeGuideScreen> {
  static const _kinds = [SizeKind.ring, SizeKind.bangle, SizeKind.length];
  late int _index = _kinds.indexOf(widget.kind).clamp(0, 2);

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final gutter = Breakpoints.gutter(context);
    final kind = _kinds[_index];

    final steps = switch (kind) {
      SizeKind.ring => [l10n.sizeRingStep1, l10n.sizeRingStep2, l10n.sizeRingStep3],
      SizeKind.bangle => [l10n.sizeBangleStep1, l10n.sizeBangleStep2],
      _ => <String>[],
    };

    return Scaffold(
      appBar: FinoHeader.page(title: l10n.sizeGuideTitle),
      body: ContentWidth(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: gutter, vertical: AppSpacing.lg),
          children: [
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(color: c.accentSoft, shape: BoxShape.circle),
                child: Icon(Icons.straighten_rounded, color: c.accent, size: 28),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.sizeGuideHeading, style: text.displaySmall, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.sizeGuideSub,
              style: text.bodyMedium!.copyWith(color: c.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            SegmentedControl(
              labels: [l10n.sizeKindRing, l10n.sizeKindBangle, l10n.sizeKindLength],
              index: _index,
              onChanged: (i) => setState(() => _index = i),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (steps.isNotEmpty) ...[
              Text(l10n.sizeHowToMeasure, style: text.headlineSmall),
              const SizedBox(height: AppSpacing.sm),
              for (var i = 0; i < steps.length; i++)
                StaggeredReveal(
                  key: ValueKey('$kind-$i'),
                  index: i,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: c.primary, shape: BoxShape.circle),
                          child: Text(
                            '${i + 1}',
                            style: text.labelLarge!.copyWith(color: Colors.white, letterSpacing: 0),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(child: Text(steps[i], style: text.bodyMedium)),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: AppSpacing.md),
            ],
            Text(l10n.sizeChart, style: text.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            AppPanel(
              child: switch (kind) {
                SizeKind.ring => _Table(
                  headers: [l10n.sizeUs, l10n.sizeUk, l10n.sizeDiameterMm, l10n.sizeCircumferenceMm],
                  rows: [
                    for (final r in ringSizes)
                      [r.us, r.uk, r.diameterMm.toStringAsFixed(1), r.circumferenceMm.toStringAsFixed(1)],
                  ],
                ),
                SizeKind.bangle => _Table(
                  headers: [l10n.sizeSize, l10n.sizeDiameterIn, l10n.sizeCircumferenceMm, l10n.sizeFits],
                  rows: [
                    for (final r in bangleSizes)
                      [r.size, r.diameterIn, '${r.circumferenceMm}', _fits(l10n, r.fitsKey)],
                  ],
                ),
                _ => _Table(
                  headers: [l10n.sizeSize, l10n.sizeLengthCm, l10n.sizeSits],
                  rows: [
                    for (final r in lengthSizes) [r.size, '${r.cm}', _sits(l10n, r.sitsKey)],
                  ],
                ),
              },
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: c.accentSoft.withValues(alpha: c.isDark ? 1 : .6),
                borderRadius: AppRadius.circular(AppRadius.md),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lightbulb_outline_rounded, color: c.accent, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text(l10n.sizeTip, style: text.bodySmall)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.sizeResizeNote, style: text.labelSmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  static String _fits(AppL10n l10n, String key) => switch (key) {
    'xs' => l10n.sizeFitsXs,
    's' => l10n.sizeFitsS,
    'm' => l10n.sizeFitsM,
    'l' => l10n.sizeFitsL,
    _ => l10n.sizeFitsXl,
  };

  static String _sits(AppL10n l10n, String key) => switch (key) {
    'choker' => l10n.sizeSitsChoker,
    'princess' => l10n.sizeSitsPrincess,
    'matinee' => l10n.sizeSitsMatinee,
    'matineeLow' => l10n.sizeSitsMatineeLow,
    _ => l10n.sizeSitsOpera,
  };
}

class _Table extends StatelessWidget {
  const _Table({required this.headers, required this.rows});

  final List<String> headers;
  final List<List<String>> rows;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return Table(
      columnWidths: {
        for (var i = 0; i < headers.length; i++)
          i: i == headers.length - 1 && headers.length == 3
              ? const FlexColumnWidth(2.4)
              : const FlexColumnWidth(),
      },
      border: TableBorder(horizontalInside: BorderSide(color: c.border)),
      children: [
        TableRow(
          decoration: BoxDecoration(color: c.surface2),
          children: [
            for (final h in headers)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                child: Text(h.toUpperCase(), style: text.labelMedium!.copyWith(color: c.textSecondary)),
              ),
          ],
        ),
        for (final r in rows)
          TableRow(
            children: [
              for (var i = 0; i < r.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                  child: Text(
                    r[i],
                    style: i == 0 ? text.titleSmall : text.bodySmall!.copyWith(color: c.text),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

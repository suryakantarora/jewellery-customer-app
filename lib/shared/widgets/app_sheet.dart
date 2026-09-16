import 'package:flutter/material.dart';

import '../../core/layout/breakpoints.dart';
import '../../core/motion/motion.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';

/// The survey's modal rise: from below with a slight overshoot (420 ms,
/// cubic-bezier(.32,.72,0,1)), backdrop fade; reverse at 280 ms.
Future<T?> showAppSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  double heightFactor = .9,
  bool scrollable = true,
}) {
  final reduced = AppMotion.reduced(context);
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: context.colors.scrim,
    transitionDuration: reduced ? Duration.zero : const Duration(milliseconds: 420),
    pageBuilder: (context, _, __) => _SheetFrame(
      heightFactor: heightFactor,
      child: Builder(builder: builder),
    ),
    transitionBuilder: (context, animation, _, child) {
      final rise = CurvedAnimation(
        parent: animation,
        curve: const Cubic(.32, .72, 0, 1),
        reverseCurve: Curves.easeIn,
      );
      return SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: Offset.zero).animate(rise),
        child: ScaleTransition(
          scale: Tween(begin: .96, end: 1.0).animate(rise),
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      );
    },
  );
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.child, required this.heightFactor});

  final Widget child;
  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final size = MediaQuery.sizeOf(context);
    final wide = !Breakpoints.isPhone(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: size.height * heightFactor,
          maxWidth: wide ? 560 : double.infinity,
        ),
        child: Material(
          color: c.surface,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: c.borderStrong,
                    borderRadius: AppRadius.circular(AppRadius.pill),
                  ),
                ),
              ),
              Flexible(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

/// Standard sheet chrome: title row with close, body, optional footer.
class AppSheetScaffold extends StatelessWidget {
  const AppSheetScaffold({
    super.key,
    required this.title,
    required this.body,
    this.footer,
    this.trailing,
  });

  final String title;
  final Widget body;
  final Widget? footer;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppLayout.gutter,
            AppSpacing.xs,
            AppSpacing.xs,
            0,
          ),
          child: Row(
            children: [
              Expanded(child: Text(title, style: text.headlineSmall)),
              ?trailing,
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
        Flexible(child: body),
        if (footer != null)
          Container(
            padding: EdgeInsets.fromLTRB(
              AppLayout.gutter,
              AppSpacing.sm,
              AppLayout.gutter,
              AppSpacing.sm + MediaQuery.paddingOf(context).bottom,
            ),
            decoration: BoxDecoration(
              color: c.surface,
              border: Border(top: BorderSide(color: c.border)),
            ),
            child: footer,
          ),
      ],
    );
  }
}

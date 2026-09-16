import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';

/// −  n  + stepper, 1–[max].
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 9,
    this.compact = false,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final size = compact ? 28.0 : 36.0;
    Widget button(IconData icon, bool enabled, int next) => SizedBox(
      width: size,
      height: size,
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: compact ? 16 : 18,
        icon: Icon(icon),
        color: enabled ? c.text : c.textMuted,
        onPressed: enabled ? () => onChanged(next) : null,
      ),
    );
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: c.borderStrong),
        borderRadius: AppRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          button(Icons.remove_rounded, value > min, value - 1),
          SizedBox(
            width: compact ? 22 : 28,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          button(Icons.add_rounded, value < max, value + 1),
        ],
      ),
    );
  }
}

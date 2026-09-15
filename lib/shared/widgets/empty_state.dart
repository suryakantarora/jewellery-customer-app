import 'package:flutter/material.dart';

import '../../core/media/app_image.dart';
import '../../core/media/image_ref.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';

/// Icon or image, display title, body, primary + secondary actions.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    this.body,
    this.icon = Icons.diamond_outlined,
    this.image,
    this.primaryLabel,
    this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
  });

  final String title;
  final String? body;
  final IconData icon;
  final ImageRef? image;
  final String? primaryLabel;
  final VoidCallback? onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (image != null && !image!.isEmpty)
              AppImage(image!, width: 120, height: 120, fit: BoxFit.contain)
            else
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: c.surface2,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 30, color: c.textMuted),
              ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: text.headlineMedium,
              textAlign: TextAlign.center,
            ),
            if (body != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                body!,
                style: text.bodyMedium!.copyWith(color: c.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
            if (primaryLabel != null) ...[
              const SizedBox(height: AppSpacing.lg),
              FilledButton(onPressed: onPrimary, child: Text(primaryLabel!)),
            ],
            if (secondaryLabel != null) ...[
              const SizedBox(height: AppSpacing.xs),
              TextButton(onPressed: onSecondary, child: Text(secondaryLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

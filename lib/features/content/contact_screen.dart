import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/layout/breakpoints.dart';
import '../../core/media/app_image.dart';
import '../../core/media/image_ref.dart';
import '../../core/motion/motion.dart';
import '../../core/platform/launch.dart';
import '../../core/session/session_provider.dart';
import '../../core/tenant/tenant_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_panel.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/app_toast.dart';
import '../../shared/widgets/eyebrow.dart';
import '../../shared/widgets/scrim.dart';
import '../shell/fino_header.dart';

/// Contact (survey: ContactPage): banner card, channel list that dials /
/// opens WhatsApp / mails / maps (copying the value when the platform
/// declines), then a message form → toast.
class ContactScreen extends ConsumerStatefulWidget {
  const ContactScreen({super.key});

  @override
  ConsumerState<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends ConsumerState<ContactScreen> {
  late final _name = TextEditingController(
    text: ref.read(accountProvider)?.name ?? '',
  );
  late final _email = TextEditingController(
    text: ref.read(accountProvider)?.email ?? '',
  );
  final _message = TextEditingController();
  String? _messageError;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _open(Future<bool> Function() launch, String fallback) async {
    final l10n = AppL10n.of(context);
    if (await launch()) return;
    await Clipboard.setData(ClipboardData(text: fallback));
    if (mounted) {
      showToast(
        context,
        l10n.contactCopied(fallback),
        icon: Icons.copy_rounded,
      );
    }
  }

  void _send() {
    final l10n = AppL10n.of(context);
    if (_message.text.trim().length < 10) {
      setState(() => _messageError = l10n.contactMessageShort);
      return;
    }
    setState(() => _messageError = null);
    _message.clear();
    FocusScope.of(context).unfocus();
    showToast(context, l10n.contactSent, icon: Icons.check_rounded);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final tenant = ref.watch(tenantProvider).valueOrNull;
    final contact = tenant?.contact;
    final gutter = Breakpoints.gutter(context);

    final channels = <(IconData, String, String?, Future<bool> Function())>[
      (
        Icons.call_outlined,
        l10n.contactCall,
        contact?.phone,
        () => Launch.phone(contact!.phone!),
      ),
      (
        Icons.chat_outlined,
        l10n.contactWhatsapp,
        contact?.whatsapp,
        () => Launch.whatsapp(contact!.whatsapp!),
      ),
      (
        Icons.mail_outline_rounded,
        l10n.contactEmail,
        contact?.email,
        () => Launch.email(contact!.email!),
      ),
      (
        Icons.storefront_outlined,
        l10n.contactStore,
        contact?.storeAddress,
        () => Launch.maps(17.9646, 102.6114, label: contact!.storeAddress),
      ),
    ];

    return Scaffold(
      appBar: FinoHeader.page(title: l10n.drawerContact),
      body: ContentWidth(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: gutter,
            vertical: AppSpacing.lg,
          ),
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: AppMotion.of(context, AppMotion.slow),
              curve: AppMotion.easeOut,
              builder: (context, v, child) => Opacity(
                opacity: v,
                child: Transform.translate(
                  offset: Offset(0, 12 * (1 - v)),
                  child: child,
                ),
              ),
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: AppRadius.circular(AppRadius.lg),
                  boxShadow: AppShadows.md(c.shadow),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const AppImage(
                      ImageRef.asset('images/banners/home-img-3.jpg'),
                    ),
                    const Scrim(stops: [0, 1], strength: 1.3),
                    Positioned(
                      left: AppSpacing.md,
                      right: AppSpacing.md,
                      bottom: AppSpacing.md,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Eyebrow(tenant?.brandName ?? '', color: c.accent),
                          Text(
                            l10n.contactHeadline,
                            style: text.headlineLarge!.copyWith(
                              color: AppColors.photoInk,
                            ),
                          ),
                          if (contact?.hours != null)
                            Text(
                              contact!.hours!,
                              style: text.bodySmall!.copyWith(
                                color: AppColors.photoInkSoft,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Eyebrow(l10n.contactChannels),
            const SizedBox(height: AppSpacing.sm),
            AppPanel(
              children: [
                for (final ch in channels)
                  if (ch.$3 != null)
                    ListTile(
                      leading: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: c.accentSoft,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(ch.$1, size: 18, color: c.accent),
                      ),
                      title: Text(ch.$2),
                      subtitle: Text(ch.$3!),
                      trailing: Icon(
                        Icons.open_in_new_rounded,
                        size: 18,
                        color: c.textMuted,
                      ),
                      onTap: () => _open(ch.$4, ch.$3!),
                    ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Eyebrow(l10n.contactMessageTitle),
            const SizedBox(height: AppSpacing.sm),
            AppPanel(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                AppTextField(
                  label: l10n.addressName,
                  controller: _name,
                  icon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(
                  label: l10n.contactEmail,
                  controller: _email,
                  icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(
                  label: l10n.contactMessage,
                  controller: _message,
                  maxLines: 4,
                  error: _messageError,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: AppSpacing.md),
                FilledButton(onPressed: _send, child: Text(l10n.contactSend)),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

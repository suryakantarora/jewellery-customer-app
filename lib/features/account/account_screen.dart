import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format/formatters_provider.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/media/app_image.dart';
import '../../core/media/image_ref.dart';
import '../../core/motion/motion.dart';
import '../../core/router/app_routes.dart';
import '../../core/session/session_provider.dart';
import '../../core/tenant/tenant_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../data/models/commerce.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_badge.dart';
import '../../shared/widgets/app_panel.dart';
import '../../shared/widgets/app_sheet.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/app_toast.dart';
import '../../shared/widgets/press_scale.dart';
import '../../shared/widgets/skeleton.dart';
import '../../shared/widgets/staggered_reveal.dart';
import '../../shared/widgets/status_pill.dart';
import '../auth/auth_gate.dart';
import '../cart/cart_provider.dart';
import '../orders/order_timeline.dart';
import '../orders/orders_provider.dart';
import '../wishlist/wishlist_provider.dart';
import 'addresses_provider.dart';

/// Profile tab (survey: AccountPage): banner with avatar + tier, stats row,
/// recent orders rail, menu list, sign out. Guests see a sign-in banner.
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final gutter = Breakpoints.gutter(context);
    final account = ref.watch(accountProvider);
    final tenant = ref.watch(tenantProvider).valueOrNull;
    final orders = ref.watch(ordersProvider);
    final wishlistCount = ref.watch(wishlistCountProvider);
    final addressCount = ref.watch(addressesProvider).valueOrNull?.length ?? 0;
    final dates = ref.watch(dateFormatterProvider);

    Future<void> signOut() async {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.accountSignOutTitle),
          content: Text(l10n.accountSignOutBody),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.actionCancel)),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: AppColors.danger),
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l10n.drawerSignOut),
            ),
          ],
        ),
      );
      if (ok != true) return;
      await ref.read(cartProvider.notifier).clear();
      await ref.read(sessionProvider.notifier).signOut();
      if (context.mounted) context.go(AppRoutes.welcome);
    }

    return Scaffold(
      body: ContentWidth(
        child: ListView(
          padding: const EdgeInsets.only(bottom: AppLayout.tabBarHeight + AppSpacing.lg),
          children: [
            _Banner(account: account, brand: tenant?.brandName ?? ''),
            const SizedBox(height: AppSpacing.md),
            if (account == null) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: gutter),
                child: AppPanel(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.authPromptTitle, style: text.headlineSmall),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(l10n.authPromptBody, style: text.bodySmall),
                      const SizedBox(height: AppSpacing.sm),
                      FilledButton.icon(
                        onPressed: () => ensureSignedIn(context, ref),
                        icon: const Icon(Icons.phone_iphone_rounded, size: 18),
                        label: Text(l10n.authSignInWithPhone),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: gutter),
                child: Row(
                  children: [
                    for (final s in [
                      (l10n.accountStatOrders, orders.valueOrNull?.length ?? 0, AppRoutes.orders),
                      (l10n.accountStatWishlist, wishlistCount, AppRoutes.wishlist),
                      (l10n.accountStatAddresses, addressCount, AppRoutes.addresses),
                    ])
                      Expanded(
                        child: PressScale(
                          onTap: () => context.push(s.$3),
                          child: AppPanel(
                            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                            child: Column(
                              children: [
                                Text('${s.$2}', style: text.headlineMedium),
                                Text(s.$1, style: text.labelSmall),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ].expand((w) sync* {
                    yield w;
                    yield const SizedBox(width: AppSpacing.xs);
                  }).toList()
                    ..removeLast(),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: gutter),
                child: Row(
                  children: [
                    Expanded(child: Text(l10n.accountRecentOrders, style: text.headlineSmall)),
                    TextButton(onPressed: () => context.push(AppRoutes.orders), child: Text(l10n.actionSeeAll)),
                  ],
                ),
              ),
              SizedBox(
                height: 118,
                child: orders.when(
                  loading: () => ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: gutter),
                    itemCount: 2,
                    separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
                    itemBuilder: (_, __) => const Skeleton(width: 220, height: 118, radius: AppRadius.md),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (list) => list.isEmpty
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: gutter),
                          child: Text(l10n.ordersEmptyBody, style: text.bodySmall),
                        )
                      : ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: gutter),
                          itemCount: list.length.clamp(0, 3),
                          separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
                          itemBuilder: (context, i) => StaggeredReveal(
                            index: i,
                            child: _RecentOrder(order: list[i], dateLabel: dates.short(list[i].date)),
                          ),
                        ),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: gutter),
              child: AppPanel(
                children: [
                  for (final m in [
                    (Icons.inventory_2_outlined, l10n.drawerOrders, null, AppRoutes.orders),
                    (Icons.favorite_border_rounded, l10n.actionWishlist, l10n.piecesCount(wishlistCount), AppRoutes.wishlist),
                    (Icons.location_on_outlined, l10n.addressesTitle, account == null ? null : l10n.accountAddressCount(addressCount), AppRoutes.addresses),
                    (Icons.credit_card_rounded, l10n.paymentMethodsTitle, null, AppRoutes.paymentMethods),
                    (Icons.settings_outlined, l10n.drawerSettings, null, AppRoutes.settings),
                  ])
                    ListTile(
                      leading: Icon(m.$1),
                      title: Text(m.$2),
                      subtitle: m.$3 == null ? null : Text(m.$3!),
                      trailing: Icon(Icons.chevron_right_rounded, color: c.textMuted),
                      onTap: () => m.$4 == AppRoutes.settings ? context.go(m.$4) : context.push(m.$4),
                    ),
                ],
              ),
            ),
            if (account != null) ...[
              const SizedBox(height: AppSpacing.lg),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: gutter),
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    side: BorderSide(color: AppColors.danger.withValues(alpha: .4)),
                  ),
                  onPressed: signOut,
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: Text(l10n.drawerSignOut),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: gutter),
              child: Text(l10n.homeDemoNote, style: text.labelSmall, textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}

class _Banner extends ConsumerWidget {
  const _Banner({required this.account, required this.brand});

  final Account? account;
  final String brand;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final dates = ref.watch(dateFormatterProvider);
    final avatar = account?.avatar.isEmpty ?? true
        ? const ImageRef.asset('images/ui/avtr2.png')
        : account!.avatar;
    return Container(
      decoration: BoxDecoration(color: c.bannerGround, gradient: c.bannerGradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppLayout.gutter, AppSpacing.sm, AppLayout.gutter, AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    tooltip: l10n.actionMenu,
                    icon: const Icon(Icons.menu_rounded, color: AppColors.bannerInk),
                    onPressed: () => context.findRootAncestorStateOfType<ScaffoldState>()?.openDrawer(),
                  ),
                  Expanded(
                    child: Text(
                      l10n.profileTitle,
                      textAlign: TextAlign.center,
                      style: text.headlineSmall!.copyWith(color: AppColors.bannerInk),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: .8, end: 1),
                    duration: AppMotion.of(context, AppMotion.slow),
                    curve: AppMotion.spring,
                    builder: (context, v, child) => Transform.scale(scale: v, child: child),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 82,
                          height: 82,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: c.accent.withValues(alpha: .75), width: 2),
                          ),
                          child: ClipOval(child: AppImage(avatar)),
                        ),
                        if (account?.tier != null)
                          Positioned(
                            bottom: -6,
                            left: 0,
                            right: 0,
                            child: Center(child: AppBadge(account!.tier!, tone: BadgeTone.accent)),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account?.name ?? l10n.drawerGuest,
                          style: text.headlineMedium!.copyWith(color: AppColors.bannerInk),
                        ),
                        Text(
                          account?.phone ?? l10n.profileWelcome(brand),
                          style: text.bodySmall!.copyWith(color: AppColors.bannerInkSoft),
                        ),
                        if (account?.email != null)
                          Text(account!.email!, style: text.bodySmall!.copyWith(color: AppColors.bannerInkSoft)),
                        if (account?.memberSince != null)
                          Text(
                            l10n.accountMemberSince(dates.short(account!.memberSince!)),
                            style: text.labelSmall!.copyWith(color: AppColors.bannerInkFaint),
                          ),
                      ],
                    ),
                  ),
                  if (account != null)
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.bannerInk,
                        side: BorderSide(color: c.bannerHairline),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        minimumSize: const Size(0, 36),
                      ),
                      onPressed: () => showProfileEditor(context),
                      child: Text(l10n.actionEdit),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentOrder extends ConsumerWidget {
  const _RecentOrder({required this.order, required this.dateLabel});

  final Order order;
  final String dateLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final text = Theme.of(context).textTheme;
    final money = ref.watch(moneyFormatterProvider);
    final first = order.items.first;
    return PressScale(
      onTap: () => context.push(AppRoutes.orderPath(order.id)),
      child: SizedBox(
        width: 230,
        child: AppPanel(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: [
              AppImage(first.image, width: 56, height: 56, borderRadius: AppRadius.circular(AppRadius.sm)),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${order.id} · $dateLabel', style: text.labelSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(first.name, style: text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(money.format(order.total), style: text.bodySmall),
                    const SizedBox(height: 4),
                    StatusPill(orderStatusLabel(l10n, order.status), tone: orderStatusTone(order.status)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Edit name / email in a sheet.
Future<void> showProfileEditor(BuildContext context) => showAppSheet<void>(
  context,
  heightFactor: .6,
  builder: (_) => const _ProfileEditor(),
);

class _ProfileEditor extends ConsumerStatefulWidget {
  const _ProfileEditor();

  @override
  ConsumerState<_ProfileEditor> createState() => _ProfileEditorState();
}

class _ProfileEditorState extends ConsumerState<_ProfileEditor> {
  late final _name = TextEditingController(text: ref.read(accountProvider)?.name ?? '');
  late final _email = TextEditingController(text: ref.read(accountProvider)?.email ?? '');
  String? _nameError;
  String? _emailError;
  static final _emailRe = RegExp(r'^\S+@\S+\.\S+$');

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppL10n.of(context);
    final name = _name.text.trim();
    final email = _email.text.trim();
    setState(() {
      _nameError = name.length < 2 ? l10n.authNameRequired : null;
      _emailError = email.isNotEmpty && !_emailRe.hasMatch(email) ? l10n.authEmailInvalid : null;
    });
    if (_nameError != null || _emailError != null) return;
    final account = ref.read(accountProvider);
    if (account == null) return;
    await ref.read(sessionProvider.notifier).updateProfile(
      account.copyWith(name: name, email: email.isEmpty ? null : email),
    );
    if (!mounted) return;
    Navigator.of(context).pop();
    showToast(context, l10n.accountSaved, icon: Icons.check_rounded);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final account = ref.watch(accountProvider);
    return AppSheetScaffold(
      title: l10n.accountEditTitle,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppLayout.gutter, AppSpacing.sm, AppLayout.gutter, AppSpacing.md),
        children: [
          AppTextField(
            label: l10n.authNameLabel,
            icon: Icons.person_outline_rounded,
            controller: _name,
            error: _nameError,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            label: l10n.authEmailLabel,
            icon: Icons.mail_outline_rounded,
            controller: _email,
            error: _emailError,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            label: l10n.authPhoneLabel,
            icon: Icons.phone_iphone_rounded,
            controller: TextEditingController(text: account?.phone ?? ''),
            enabled: false,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(l10n.accountPhoneLocked, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
      footer: FilledButton(onPressed: _save, child: Text(l10n.actionSave)),
    );
  }
}

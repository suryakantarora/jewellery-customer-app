import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format/formatters_provider.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/motion/motion.dart';
import '../../core/network/app_exception.dart';
import '../../core/router/app_routes.dart';
import '../../core/session/session_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../data/models/commerce.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/animated_tick.dart';
import '../../shared/widgets/app_panel.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/app_toast.dart';
import '../../shared/widgets/eyebrow.dart';
import '../../shared/widgets/press_scale.dart';
import '../../shared/widgets/skeleton.dart';
import '../../shared/widgets/staggered_reveal.dart';
import '../account/address_editor.dart';
import '../account/addresses_provider.dart';
import '../cart/cart_provider.dart';
import '../cart/cart_screen.dart';
import '../orders/orders_provider.dart';
import '../shell/fino_header.dart';

/// Checkout (survey: CheckoutPage): progress rail with three numbered
/// nodes, Address → Payment → Review steps, a placing spinner and the
/// confirmation with an animated tick.
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

enum _Step { address, payment, review, placing, confirmed }

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  _Step _step = _Step.address;
  Address? _address;
  PaymentMethod? _payment;
  Order? _order;

  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _line1 = TextEditingController();
  final _city = TextEditingController();
  final _postcode = TextEditingController();
  String? _formError;

  @override
  void initState() {
    super.initState();
    final account = ref.read(accountProvider);
    if (account != null) {
      _name.text = account.name;
      _phone.text = account.phone;
    }
  }

  @override
  void dispose() {
    for (final c in [_name, _phone, _line1, _city, _postcode]) {
      c.dispose();
    }
    super.dispose();
  }

  void _fillFrom(Address a) {
    setState(() {
      _address = a;
      _name.text = a.name;
      _phone.text = a.phone;
      _line1.text = a.line1;
      _city.text = a.city;
      _postcode.text = a.postcode;
      _formError = null;
    });
  }

  Address? _addressFromForm() {
    if ([_name, _phone, _line1, _city].any((c) => c.text.trim().isEmpty)) return null;
    final base = _address;
    final same =
        base != null &&
        base.name == _name.text.trim() &&
        base.phone == _phone.text.trim() &&
        base.line1 == _line1.text.trim() &&
        base.city == _city.text.trim() &&
        base.postcode == _postcode.text.trim();
    if (same) return base;
    return Address(
      id: '',
      label: AddressLabel.other,
      name: _name.text.trim(),
      phone: _phone.text.trim(),
      line1: _line1.text.trim(),
      city: _city.text.trim(),
      postcode: _postcode.text.trim(),
      isDefault: false,
    );
  }

  Future<void> _next() async {
    final l10n = AppL10n.of(context);
    switch (_step) {
      case _Step.address:
        final a = _addressFromForm();
        if (a == null) {
          setState(() => _formError = l10n.checkoutAddressIncomplete);
          return;
        }
        if (a.id.isEmpty) {
          // Keep the new address for next time.
          await ref.read(addressesProvider.notifier).save(a);
          final saved = ref.read(addressesProvider).valueOrNull ?? const [];
          _address = saved.lastOrNull ?? a;
        } else {
          _address = a;
        }
        _payment ??= (ref.read(paymentMethodsProvider).valueOrNull ?? const [])
            .where((p) => p.isDefault)
            .firstOrNull;
        setState(() => _step = _Step.payment);
      case _Step.payment:
        if (_payment == null) return;
        setState(() => _step = _Step.review);
      case _Step.review:
        await _place();
      case _Step.placing:
      case _Step.confirmed:
        break;
    }
  }

  Future<void> _place() async {
    final l10n = AppL10n.of(context);
    final lines = ref.read(cartProvider).valueOrNull ?? const [];
    final totals = ref.read(cartTotalsProvider);
    final address = _address;
    final payment = _payment;
    if (lines.isEmpty || address == null || payment == null) return;
    setState(() => _step = _Step.placing);
    try {
      final order = await ref.read(ordersProvider.notifier).place(
        OrderDraft(
          lines: lines,
          address: address,
          payment: payment,
          subtotal: totals.subtotal,
          shipping: totals.shipping,
          tax: totals.tax,
          total: totals.total,
          offerCode: totals.offerIneligible ? null : totals.offer?.code,
        ),
      );
      await ref.read(cartProvider.notifier).clear();
      if (!mounted) return;
      setState(() {
        _order = order;
        _step = _Step.confirmed;
      });
    } on RejectedException catch (error) {
      // The backend's own sentence: a piece just sold, an offer expired.
      if (!mounted) return;
      setState(() => _step = _Step.review);
      showToast(context, error.message);
    } on Object {
      if (!mounted) return;
      setState(() => _step = _Step.review);
      showToast(context, l10n.errorGeneric);
    }
  }

  void _back() {
    switch (_step) {
      case _Step.payment:
        setState(() => _step = _Step.address);
      case _Step.review:
        setState(() => _step = _Step.payment);
      default:
        context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final money = ref.watch(moneyFormatterProvider);
    final gutter = Breakpoints.gutter(context);
    final totals = ref.watch(cartTotalsProvider);
    final lines = ref.watch(cartProvider).valueOrNull ?? const [];
    final stepIndex = switch (_step) {
      _Step.address => 0,
      _Step.payment => 1,
      _ => 2,
    };
    final terminal = _step == _Step.placing || _step == _Step.confirmed;

    return PopScope(
      canPop: _step == _Step.address || _step == _Step.confirmed,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _step != _Step.placing) _back();
      },
      child: Scaffold(
        appBar: FinoHeader.page(title: l10n.checkoutTitle),
        body: Column(
          children: [
            if (!terminal)
              Padding(
                padding: EdgeInsets.fromLTRB(gutter, AppSpacing.md, gutter, 0),
                child: _ProgressRail(
                  labels: [l10n.checkoutStepAddress, l10n.checkoutStepPayment, l10n.checkoutStepReview],
                  index: stepIndex,
                ),
              ),
            Expanded(
              child: ContentWidth(
                child: AnimatedSwitcher(
                  duration: AppMotion.of(context, AppMotion.normal),
                  switchInCurve: AppMotion.easeOut,
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position: Tween(begin: const Offset(.04, 0), end: Offset.zero).animate(anim),
                      child: child,
                    ),
                  ),
                  child: KeyedSubtree(
                    key: ValueKey(_step),
                    child: switch (_step) {
                      _Step.address => _addressStep(gutter),
                      _Step.payment => _paymentStep(gutter, totals),
                      _Step.review => _reviewStep(gutter, totals, lines),
                      _Step.placing => _placing(),
                      _Step.confirmed => _confirmed(gutter),
                    },
                  ),
                ),
              ),
            ),
            if (!terminal)
              Container(
                padding: EdgeInsets.fromLTRB(
                  gutter,
                  AppSpacing.sm,
                  gutter,
                  AppSpacing.sm + MediaQuery.paddingOf(context).bottom,
                ),
                decoration: BoxDecoration(
                  color: c.surface,
                  border: Border(top: BorderSide(color: c.border)),
                  boxShadow: AppShadows.md(c.shadow),
                ),
                child: ContentWidth(
                  child: Row(
                    children: [
                      OutlinedButton(onPressed: _back, child: Text(l10n.actionBack)),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: FilledButton(
                          onPressed: lines.isEmpty ? null : _next,
                          child: Text(switch (_step) {
                            _Step.address => l10n.checkoutContinuePayment,
                            _Step.payment => l10n.checkoutContinueReview,
                            _ => l10n.checkoutPlaceOrder(money.format(totals.total)),
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _addressStep(double gutter) {
    final l10n = AppL10n.of(context);
    final text = Theme.of(context).textTheme;
    final addresses = ref.watch(addressesProvider);
    return ListView(
      padding: EdgeInsets.fromLTRB(gutter, AppSpacing.lg, gutter, AppSpacing.xl),
      children: [
        Text(l10n.checkoutAddressTitle, style: text.headlineMedium),
        const SizedBox(height: AppSpacing.xxs),
        Text(l10n.checkoutAddressSub, style: text.bodySmall),
        const SizedBox(height: AppSpacing.md),
        addresses.when(
          loading: () => const Skeleton(height: 92, radius: AppRadius.md),
          error: (_, __) => const SizedBox.shrink(),
          data: (list) => list.isEmpty
              ? const SizedBox.shrink()
              : SizedBox(
                  height: 108,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
                    itemBuilder: (context, i) => StaggeredReveal(
                      index: i,
                      child: _SavedAddressCard(
                        address: list[i],
                        selected: _address?.id == list[i].id,
                        onTap: () => _fillFrom(list[i]),
                      ),
                    ),
                  ),
                ),
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
        if (_formError != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(_formError!, style: text.bodySmall!.copyWith(color: AppColors.danger)),
        ],
      ],
    );
  }

  Widget _paymentStep(double gutter, CartTotals totals) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final methods = ref.watch(paymentMethodsProvider);
    final kinds = [
      (PaymentKind.card, Icons.credit_card_rounded, l10n.paymentCard, l10n.paymentCardSub),
      (PaymentKind.wallet, Icons.phone_android_rounded, l10n.paymentWallet, l10n.paymentWalletSub),
      (PaymentKind.cod, Icons.payments_outlined, l10n.paymentCod, l10n.paymentCodSub),
    ];
    return ListView(
      padding: EdgeInsets.fromLTRB(gutter, AppSpacing.lg, gutter, AppSpacing.xl),
      children: [
        Text(l10n.checkoutPaymentTitle, style: text.headlineMedium),
        const SizedBox(height: AppSpacing.xxs),
        Text(l10n.checkoutPaymentSub, style: text.bodySmall),
        const SizedBox(height: AppSpacing.md),
        methods.when(
          loading: () => const Skeleton(height: 72, radius: AppRadius.md),
          error: (_, __) => const SizedBox.shrink(),
          data: (list) => Column(
            children: [
              for (var i = 0; i < kinds.length; i++)
                Builder(
                  builder: (context) {
                    final k = kinds[i];
                    final saved = list.where((m) => m.kind == k.$1).toList();
                    final method = saved.where((m) => m.isDefault).firstOrNull ??
                        saved.firstOrNull ??
                        PaymentMethod(id: 'new-${k.$1.name}', kind: k.$1, label: k.$3, detail: '', isDefault: false);
                    final selected = _payment?.kind == k.$1;
                    return StaggeredReveal(
                      index: i,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                        child: PressScale(
                          onTap: () => setState(() => _payment = method),
                          child: AnimatedContainer(
                            duration: AppMotion.of(context, AppMotion.fast),
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: c.card,
                              borderRadius: AppRadius.circular(AppRadius.md),
                              border: Border.all(color: selected ? c.primary : c.border, width: selected ? 1.5 : 1),
                            ),
                            child: Row(
                              children: [
                                Icon(k.$2, color: selected ? c.primary : c.textSecondary),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(k.$3, style: text.titleMedium),
                                      Text(
                                        method.detail.isEmpty ? k.$4 : '${method.label} · ${method.detail}',
                                        style: text.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                                  color: selected ? c.primary : c.textMuted,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Eyebrow(l10n.checkoutSummary),
        const SizedBox(height: AppSpacing.xs),
        AppPanel(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: OrderSummaryLines(totals: totals),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(l10n.checkoutDemoNote, style: text.labelSmall, textAlign: TextAlign.center),
      ],
    );
  }

  Widget _reviewStep(double gutter, CartTotals totals, List<CartLine> lines) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final money = ref.watch(moneyFormatterProvider);
    final address = _address;
    final payment = _payment;
    Widget card(IconData icon, String title, String body, VoidCallback onEdit) => AppPanel(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: c.accent),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: text.labelMedium!.copyWith(color: c.textSecondary)),
                const SizedBox(height: 2),
                Text(body, style: text.bodyMedium),
              ],
            ),
          ),
          TextButton(onPressed: onEdit, child: Text(l10n.actionEdit)),
        ],
      ),
    );
    return ListView(
      padding: EdgeInsets.fromLTRB(gutter, AppSpacing.lg, gutter, AppSpacing.xl),
      children: [
        Text(l10n.checkoutReviewTitle, style: text.headlineMedium),
        const SizedBox(height: AppSpacing.xxs),
        Text(l10n.checkoutReviewSub, style: text.bodySmall),
        const SizedBox(height: AppSpacing.md),
        if (address != null)
          card(
            Icons.location_on_outlined,
            l10n.checkoutDeliverTo,
            '${address.name}\n${address.oneLine}\n${address.phone}',
            () => setState(() => _step = _Step.address),
          ),
        const SizedBox(height: AppSpacing.xs),
        if (payment != null)
          card(
            Icons.credit_card_rounded,
            l10n.checkoutPayWith,
            payment.detail.isEmpty ? _kindLabel(l10n, payment.kind) : '${payment.label} · ${payment.detail}',
            () => setState(() => _step = _Step.payment),
          ),
        const SizedBox(height: AppSpacing.lg),
        Eyebrow(l10n.checkoutItems(lines.fold(0, (n, l) => n + l.quantity))),
        const SizedBox(height: AppSpacing.xs),
        AppPanel(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
          child: Column(
            children: [
              for (final l in lines)
                LineThumbRow(
                  image: l.product.heroImage,
                  name: l.product.productName,
                  meta: [
                    if (l.size != null) l10n.cartSize(l.size!),
                    l10n.cartQty(l.quantity),
                  ].join(' · '),
                  trailing: money.format(l.lineTotal),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppPanel(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: OrderSummaryLines(totals: totals),
        ),
      ],
    );
  }

  Widget _placing() {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(strokeWidth: 3, color: c.primary),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(l10n.checkoutPlacing, style: text.headlineSmall),
          const SizedBox(height: AppSpacing.xxs),
          Text(l10n.checkoutPlacingSub, style: text.bodySmall),
        ],
      ),
    );
  }

  Widget _confirmed(double gutter) {
    final l10n = AppL10n.of(context);
    final text = Theme.of(context).textTheme;
    final order = _order;
    return ListView(
      padding: EdgeInsets.fromLTRB(gutter, AppSpacing.xxl, gutter, AppSpacing.xl),
      children: [
        const Center(child: AnimatedTick()),
        const SizedBox(height: AppSpacing.lg),
        StaggeredReveal(
          index: 3,
          child: Column(
            children: [
              Text(l10n.checkoutConfirmedTitle, style: text.displaySmall, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.xs),
              if (order != null)
                Text(
                  order.id,
                  style: text.titleMedium!.copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: AppSpacing.sm),
              Text(l10n.checkoutConfirmedBody, style: text.bodyMedium, textAlign: TextAlign.center),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        StaggeredReveal(
          index: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton(
                onPressed: () {
                  context.go(AppRoutes.home);
                  context.push(order == null ? AppRoutes.orders : AppRoutes.orderPath(order.id));
                },
                child: Text(l10n.checkoutTrackOrder),
              ),
              const SizedBox(height: AppSpacing.xs),
              OutlinedButton(
                onPressed: () => context.go(AppRoutes.home),
                child: Text(l10n.actionContinueShopping),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static String _kindLabel(AppL10n l10n, PaymentKind kind) => switch (kind) {
    PaymentKind.card => l10n.paymentCard,
    PaymentKind.wallet => l10n.paymentWallet,
    PaymentKind.cod => l10n.paymentCod,
  };
}

class _ProgressRail extends StatelessWidget {
  const _ProgressRail({required this.labels, required this.index});

  final List<String> labels;
  final int index;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: ClipRRect(
                borderRadius: AppRadius.circular(AppRadius.pill),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: index / (labels.length - 1)),
                  duration: AppMotion.of(context, AppMotion.slow),
                  curve: AppMotion.easeOut,
                  builder: (context, v, _) => LinearProgressIndicator(value: v, minHeight: 2, color: c.primary),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var i = 0; i < labels.length; i++)
                  AnimatedContainer(
                    duration: AppMotion.of(context, AppMotion.normal),
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i <= index ? c.primary : c.surface,
                      border: Border.all(color: i <= index ? c.primary : c.borderStrong),
                    ),
                    child: i < index
                        ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                        : Text(
                            '${i + 1}',
                            style: text.labelLarge!.copyWith(
                              color: i <= index ? Colors.white : c.textMuted,
                              letterSpacing: 0,
                            ),
                          ),
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var i = 0; i < labels.length; i++)
              Text(
                labels[i],
                style: text.labelSmall!.copyWith(color: i == index ? c.text : c.textMuted),
              ),
          ],
        ),
      ],
    );
  }
}

class _SavedAddressCard extends StatelessWidget {
  const _SavedAddressCard({required this.address, required this.selected, required this.onTap});

  final Address address;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return PressScale(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppMotion.of(context, AppMotion.fast),
        width: 220,
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: AppRadius.circular(AppRadius.md),
          border: Border.all(color: selected ? c.primary : c.border, width: selected ? 1.5 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(addressLabelIcon(address.label), size: 16, color: c.accent),
                const SizedBox(width: 6),
                Expanded(child: Text(addressLabelText(l10n, address.label), style: text.labelMedium)),
                if (selected) Icon(Icons.check_circle_rounded, size: 16, color: c.primary),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(address.name, style: text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(address.oneLine, style: text.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

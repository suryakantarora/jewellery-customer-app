import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/content.dart';
import '../../data/repository_providers.dart';

/// Gold rates with the reference's live drift: every 5 s each row moves by
/// up to ±0.4% and remembers its delta so the table can flash it. The
/// clock lives in [GoldRateDriftDriver] (a widget), so it stops with the
/// screen that shows it.
class GoldRatesController extends AsyncNotifier<GoldRateSheet> {
  static const maxDrift = .004;

  final _random = Random();

  @override
  Future<GoldRateSheet> build() =>
      ref.watch(goldRateRepositoryProvider).current();

  void drift() {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(
      GoldRateSheet(
        updatedAt: DateTime.now(),
        rates: [
          for (final r in current.rates)
            () {
              final delta = (_random.nextDouble() * 2 - 1) * maxDrift;
              return r.copyWith(
                delta: delta,
                rates: r.rates.map(
                  (k, v) => MapEntry(k, _round(v * (1 + delta), k)),
                ),
              );
            }(),
        ],
      ),
    );
  }

  /// Kip stays whole; other currencies keep two decimals.
  static num _round(num v, String currency) =>
      currency == 'LAK' ? v.round() : (v * 100).round() / 100;

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(goldRateRepositoryProvider).current(),
    );
  }
}

final goldRatesProvider =
    AsyncNotifierProvider<GoldRatesController, GoldRateSheet>(
      GoldRatesController.new,
    );

/// The headline rate for the home ticker (22K, else the first row).
final headlineGoldRateProvider = Provider<GoldRate?>((ref) {
  final sheet = ref.watch(goldRatesProvider).valueOrNull;
  if (sheet == null || sheet.rates.isEmpty) return null;
  return sheet.byPurity('22K') ?? sheet.rates.first;
});

/// Ticks the drift every five seconds while mounted. Wrap any widget that
/// shows live rates in one of these.
class GoldRateDriftDriver extends ConsumerStatefulWidget {
  const GoldRateDriftDriver({super.key, required this.child});

  static const tick = Duration(seconds: 5);

  final Widget child;

  @override
  ConsumerState<GoldRateDriftDriver> createState() =>
      _GoldRateDriftDriverState();
}

class _GoldRateDriftDriverState extends ConsumerState<GoldRateDriftDriver> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      GoldRateDriftDriver.tick,
      (_) => ref.read(goldRatesProvider.notifier).drift(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/commerce.dart';
import '../config/data_mode.dart';
import '../../data/repository_providers.dart';
import '../providers.dart';
import '../storage/storage_keys.dart';

/// Who is using the app. `null` means nobody has chosen yet (first run):
/// the welcome screen is shown. Resolved before the first frame in `main()`.
class SessionController extends AsyncNotifier<CustomerSession?> {
  @override
  Future<CustomerSession?> build() {
    ref.listen(sessionExpiredProvider, (_, __) => _expire());
    return ref.watch(authRepositoryProvider).restore();
  }

  /// The backend no longer accepts the token: keep browsing as a guest.
  Future<void> _expire() async {
    if (state.valueOrNull?.isCustomer != true) return;
    await ref.read(authRepositoryProvider).signOut();
    state = AsyncData(await ref.read(authRepositoryProvider).continueAsGuest());
  }

  Future<OtpChallenge> requestOtp(String phone) =>
      ref.read(authRepositoryProvider).requestOtp(phone);

  /// Throws [OtpRejectedException] on a wrong code.
  Future<CustomerSession> verifyOtp(String phone, String code) async {
    final session = await ref.read(authRepositoryProvider).verifyOtp(phone, code);
    state = AsyncData(session);
    unawaited(_claimDevice());
    return session;
  }

  /// A push token obtained while browsing as a guest now belongs to someone.
  Future<void> _claimDevice() async {
    final pushToken = ref.read(localStoreProvider).getString(StorageKeys.pushToken);
    if (pushToken == null) return;
    try {
      await ref.read(notificationRepositoryProvider).registerDevice(
        token: pushToken,
        platform: defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android',
      );
    } on Object {
      // Registration is retried on the next launch.
    }
  }

  Future<void> continueAsGuest() async {
    state = AsyncData(await ref.read(authRepositoryProvider).continueAsGuest());
  }

  Future<void> updateProfile(Account account) async {
    state = AsyncData(await ref.read(authRepositoryProvider).updateProfile(account));
  }

  /// Demo mode empties the bag, as the reference app does. Against the backend
  /// the bag belongs to the account and stays there for the next sign-in; this
  /// handset just stops receiving the account's push messages.
  Future<void> signOut() async {
    if (ref.read(dataModeProvider) == DataMode.demo) {
      await ref.read(cartRepositoryProvider).save(const []);
    } else {
      final pushToken = ref.read(localStoreProvider).getString(StorageKeys.pushToken);
      if (pushToken != null) {
        try {
          await ref.read(notificationRepositoryProvider).unregisterDevice(pushToken);
        } on Object {
          // Offline sign-out still signs out; the backend drops dead tokens.
        }
      }
    }
    await ref.read(authRepositoryProvider).signOut();
    state = const AsyncData(CustomerSession.guest());
  }
}

final sessionProvider = AsyncNotifierProvider<SessionController, CustomerSession?>(
  SessionController.new,
);

/// The signed-in customer, or null for guests and the first run.
final accountProvider = Provider<Account?>(
  (ref) => ref.watch(sessionProvider).valueOrNull?.account,
);

/// Changes whenever a different person (or nobody) is signed in. The bag,
/// wishlist, orders, addresses, payment methods and inbox watch it, so they
/// reload on sign-in (merging what a guest had gathered) and on sign-out.
final sessionIdentityProvider = Provider<String?>(
  (ref) => ref.watch(accountProvider)?.id,
);

final isSignedInProvider = Provider<bool>(
  (ref) => ref.watch(accountProvider) != null,
);

/// Whether the first-run tour has been completed.
class SeenTourController extends Notifier<bool> {
  @override
  bool build() =>
      ref.read(localStoreProvider).getBool(StorageKeys.seenTour) ?? false;

  Future<void> markSeen() async {
    state = true;
    await ref.read(localStoreProvider).setBool(StorageKeys.seenTour, true);
  }
}

final seenTourProvider = NotifierProvider<SeenTourController, bool>(
  SeenTourController.new,
);

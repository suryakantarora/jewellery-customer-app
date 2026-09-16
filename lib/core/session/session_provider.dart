import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/commerce.dart';
import '../../data/repository_providers.dart';
import '../providers.dart';
import '../storage/storage_keys.dart';

/// Who is using the app. `null` means nobody has chosen yet (first run):
/// the welcome screen is shown. Resolved before the first frame in `main()`.
class SessionController extends AsyncNotifier<CustomerSession?> {
  @override
  Future<CustomerSession?> build() =>
      ref.watch(authRepositoryProvider).restore();

  Future<OtpChallenge> requestOtp(String phone) =>
      ref.read(authRepositoryProvider).requestOtp(phone);

  /// Throws [OtpRejectedException] on a wrong code.
  Future<CustomerSession> verifyOtp(String phone, String code) async {
    final session = await ref.read(authRepositoryProvider).verifyOtp(phone, code);
    state = AsyncData(session);
    return session;
  }

  Future<void> continueAsGuest() async {
    state = AsyncData(await ref.read(authRepositoryProvider).continueAsGuest());
  }

  Future<void> updateProfile(Account account) async {
    state = AsyncData(await ref.read(authRepositoryProvider).updateProfile(account));
  }

  Future<void> signOut() async {
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

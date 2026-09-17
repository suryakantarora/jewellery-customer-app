import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/content.dart';
import '../../data/repository_providers.dart';

/// The notification centre. Push delivery itself arrives with C10; the
/// device registration hook mirrors the staff app's
/// `PushRegistrationService` so the swap is one call.
class NotificationsController extends AsyncNotifier<List<AppNotification>> {
  @override
  Future<List<AppNotification>> build() =>
      ref.watch(notificationRepositoryProvider).list();

  Future<void> markRead(String id) async {
    final current = state.valueOrNull ?? const [];
    if (current.any((n) => n.id == id && n.read)) return;
    state = AsyncData([
      for (final n in current) n.id == id ? n.copyWith(read: true) : n,
    ]);
    await ref.read(notificationRepositoryProvider).markRead(id);
  }

  Future<void> markAllRead() async {
    state = AsyncData([
      for (final n in state.valueOrNull ?? const <AppNotification>[])
        n.copyWith(read: true),
    ]);
    await ref.read(notificationRepositoryProvider).markAllRead();
  }

  /// Called once a push token exists (C10). Safe to call in demo mode.
  Future<void> registerDevice(String token) => ref
      .read(notificationRepositoryProvider)
      .registerDevice(token: token, platform: _platform);

  static String get _platform {
    if (kIsWeb) return 'web';
    if (Platform.isIOS) return 'ios';
    if (Platform.isAndroid) return 'android';
    return Platform.operatingSystem;
  }
}

final notificationsProvider =
    AsyncNotifierProvider<NotificationsController, List<AppNotification>>(
      NotificationsController.new,
    );

final unreadNotificationsProvider = Provider<int>(
  (ref) => (ref.watch(notificationsProvider).valueOrNull ?? const [])
      .where((n) => !n.read)
      .length,
);

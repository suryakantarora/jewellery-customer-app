import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/storage/storage_keys.dart';

/// Recent search terms, most recent first, max 6, seeded like the reference.
class RecentSearchesController extends Notifier<List<String>> {
  static const maxItems = 6;
  static const seed = ['Solitaire', 'Bridal'];

  @override
  List<String> build() =>
      ref.read(localStoreProvider).getStringList(StorageKeys.recentSearches) ??
      seed;

  Future<void> add(String term) async {
    final t = term.trim();
    if (t.isEmpty) return;
    final next = [
      t,
      ...state.where((s) => s.toLowerCase() != t.toLowerCase()),
    ].take(maxItems).toList();
    state = next;
    await ref.read(localStoreProvider).setStringList(StorageKeys.recentSearches, next);
  }

  Future<void> clear() async {
    state = const [];
    await ref.read(localStoreProvider).setStringList(StorageKeys.recentSearches, const []);
  }
}

final recentSearchesProvider =
    NotifierProvider<RecentSearchesController, List<String>>(
      RecentSearchesController.new,
    );

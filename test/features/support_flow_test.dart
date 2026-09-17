import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jewellery_customer/core/providers.dart';
import 'package:jewellery_customer/core/storage/local_store.dart';
import 'package:jewellery_customer/features/support/support_flow.dart';
import 'package:jewellery_customer/features/support/support_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'scripted tree: option → bot reply; agent joins after 2200 ms; thread persists',
    () async {
      SharedPreferences.setMockInitialValues({});
      final local = await LocalStore.create();
      fakeAsync((async) {
        final container = ProviderContainer(
          overrides: [localStoreProvider.overrideWithValue(local)],
        );
        addTearDown(container.dispose);
        final notifier = container.read(supportProvider.notifier);

        expect(container.read(supportProvider).nodeId, SupportFlow.rootId);
        final track = SupportFlow.nodes[SupportFlow.rootId]!.options.first;
        notifier.choose(track, 'Track my order');
        expect(container.read(supportProvider).typing, isTrue);
        async.elapse(const Duration(milliseconds: 800));
        final thread = container.read(supportProvider);
        expect(thread.typing, isFalse);
        expect(thread.nodeId, 'track');
        expect(thread.messages.last.author, SupportAuthor.bot);
        expect(thread.messages.last.nodeId, 'track');

        final agent = SupportFlow.nodes['track']!.options.firstWhere(
          (o) => o.next == SupportFlow.agentId,
        );
        notifier.choose(agent, 'Talk to a live agent');
        expect(container.read(supportProvider).agentJoined, isFalse);
        async.elapse(const Duration(milliseconds: 2300));
        final joined = container.read(supportProvider);
        expect(joined.agentJoined, isTrue);
        expect(
          joined.messages.where((m) => m.author == SupportAuthor.system),
          hasLength(2),
        );
        expect(joined.messages.last.author, SupportAuthor.agent);

        notifier.send('Where is my parcel?');
        async.elapse(const Duration(milliseconds: 1500));
        expect(container.read(supportProvider).messages.last.text, 'ack');
        async.flushMicrotasks();

        // A fresh container restores the persisted transcript.
        final again = ProviderContainer(
          overrides: [localStoreProvider.overrideWithValue(local)],
        );
        addTearDown(again.dispose);
        final restored = again.read(supportProvider);
        expect(restored.agentJoined, isTrue);
        expect(restored.messages.length, joined.messages.length + 2);
      });
    },
  );
}

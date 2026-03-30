import 'package:flutter_backend_driven_ui/core/models/screen_contract.dart';
import 'package:flutter_backend_driven_ui/core/network/api_client.dart';
import 'package:flutter_backend_driven_ui/core/network/cached_api_client.dart';
import 'package:flutter_test/flutter_test.dart';

ScreenContract _contract(String screenId) {
  return ScreenContract(
    schemaVersion: '1.0',
    screen: Screen(
      id: screenId,
      title: 'T',
      root: const ComponentNode(type: 'column'),
    ),
  );
}

class _CountingApiClient extends ApiClient {
  int fetchCount = 0;
  ScreenContract Function(String screenId) builder;

  _CountingApiClient(this.builder);

  @override
  Future<ScreenContract> fetchScreen(String screenId) async {
    fetchCount++;
    return builder(screenId);
  }
}

void main() {
  group('CachedApiClient', () {
    test('delegates on cache miss', () async {
      final inner = _CountingApiClient(_contract);
      final cached = CachedApiClient(inner, ttl: const Duration(minutes: 5));
      final first = await cached.fetchScreen('a');
      expect(inner.fetchCount, 1);
      expect(first.screen.id, 'a');
    });

    test('returns cached value on hit without calling delegate', () async {
      final inner = _CountingApiClient(_contract);
      final cached = CachedApiClient(inner);
      final a1 = await cached.fetchScreen('x');
      final a2 = await cached.fetchScreen('x');
      expect(identical(a1, a2), isTrue);
      expect(inner.fetchCount, 1);
    });

    test('invalidate removes entry so next fetch delegates', () async {
      final inner = _CountingApiClient(_contract);
      final cached = CachedApiClient(inner);
      await cached.fetchScreen('p');
      expect(inner.fetchCount, 1);
      cached.invalidate('p');
      await cached.fetchScreen('p');
      expect(inner.fetchCount, 2);
    });

    test('invalidateAll clears cache', () async {
      final inner = _CountingApiClient(_contract);
      final cached = CachedApiClient(inner);
      await cached.fetchScreen('u');
      await cached.fetchScreen('v');
      expect(inner.fetchCount, 2);
      cached.invalidateAll();
      await cached.fetchScreen('u');
      expect(inner.fetchCount, 3);
    });

    test('expired entries are refetched', () async {
      final inner = _CountingApiClient(_contract);
      final cached = CachedApiClient(inner, ttl: const Duration(milliseconds: 1));
      await cached.fetchScreen('e');
      expect(inner.fetchCount, 1);
      await Future<void>.delayed(const Duration(milliseconds: 25));
      await cached.fetchScreen('e');
      expect(inner.fetchCount, 2);
    });
  });
}

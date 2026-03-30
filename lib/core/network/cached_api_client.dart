import '../models/screen_contract.dart';
import 'api_client.dart';

/// Caching wrapper around any [ApiClient]. Stores fetched contracts in
/// memory with a configurable TTL to avoid redundant network requests.
class CachedApiClient extends ApiClient {
  final ApiClient _delegate;
  final Duration ttl;
  final Map<String, _CacheEntry> _cache = {};

  CachedApiClient(this._delegate, {this.ttl = const Duration(minutes: 5)});

  @override
  Future<ScreenContract> fetchScreen(String screenId) async {
    final entry = _cache[screenId];
    if (entry != null && !entry.isExpired(ttl)) {
      return entry.contract;
    }

    final contract = await _delegate.fetchScreen(screenId);
    _cache[screenId] = _CacheEntry(contract);
    return contract;
  }

  void invalidate(String screenId) => _cache.remove(screenId);

  void invalidateAll() => _cache.clear();

  @override
  void dispose() {
    _cache.clear();
    _delegate.dispose();
  }
}

class _CacheEntry {
  final ScreenContract contract;
  final DateTime fetchedAt;

  _CacheEntry(this.contract) : fetchedAt = DateTime.now();

  bool isExpired(Duration ttl) =>
      DateTime.now().difference(fetchedAt) > ttl;
}

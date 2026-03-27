import '../models/screen_contract.dart';

/// Contract for fetching screen definitions.
///
/// Two implementations exist:
/// - [LocalApiClient] loads JSON from bundled assets (no server needed).
/// - [RemoteApiClient] fetches from an HTTP backend.
abstract class ApiClient {
  Future<ScreenContract> fetchScreen(String screenId);
  void dispose() {}
}

class ScreenNotFoundException implements Exception {
  final String screenId;
  const ScreenNotFoundException(this.screenId);

  @override
  String toString() => 'Screen not found: "$screenId"';
}

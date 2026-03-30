import 'dart:convert';
import 'dart:io';

import '../models/screen_contract.dart';
import 'api_client.dart';

/// Fetches screen contracts from a remote HTTP server.
///
/// The [baseUrl] should point to an endpoint that serves JSON contracts
/// at `{baseUrl}/{screenId}`.
class HttpApiClient extends ApiClient {
  final String baseUrl;
  final HttpClient _httpClient;
  final Duration timeout;

  HttpApiClient({
    required this.baseUrl,
    this.timeout = const Duration(seconds: 10),
  }) : _httpClient = HttpClient();

  @override
  Future<ScreenContract> fetchScreen(String screenId) async {
    final uri = Uri.parse('$baseUrl/$screenId');

    try {
      final request = await _httpClient.getUrl(uri).timeout(timeout);
      final response = await request.close().timeout(timeout);

      if (response.statusCode != 200) {
        throw ScreenNotFoundException(screenId);
      }

      final body = await response.transform(utf8.decoder).join();
      final json = jsonDecode(body) as Map<String, dynamic>;
      return ScreenContract.fromJson(json);
    } on SocketException {
      throw ScreenNotFoundException(screenId);
    }
  }

  @override
  void dispose() {
    _httpClient.close(force: true);
  }
}

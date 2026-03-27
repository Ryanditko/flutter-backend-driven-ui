import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/screen_contract.dart';
import 'api_client.dart';

/// Loads screen contracts from bundled JSON assets in `assets/screens/`.
///
/// No server required — the app is fully self-contained.
class LocalApiClient extends ApiClient {
  static const _basePath = 'assets/screens';

  @override
  Future<ScreenContract> fetchScreen(String screenId) async {
    try {
      final jsonString = await rootBundle.loadString('$_basePath/$screenId.json');
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return ScreenContract.fromJson(json);
    } catch (e) {
      throw ScreenNotFoundException(screenId);
    }
  }
}

import 'package:flutter_backend_driven_ui/core/models/screen_contract.dart';
import 'package:flutter_backend_driven_ui/core/network/api_client.dart';

class MockApiClient extends ApiClient {
  final Map<String, ScreenContract> _contracts = {};
  bool shouldThrow = false;

  void addContract(String id, ScreenContract contract) {
    _contracts[id] = contract;
  }

  @override
  Future<ScreenContract> fetchScreen(String screenId) async {
    if (shouldThrow) throw ScreenNotFoundException(screenId);
    final contract = _contracts[screenId];
    if (contract == null) throw ScreenNotFoundException(screenId);
    return contract;
  }

  @override
  void dispose() {}
}

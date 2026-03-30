import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_backend_driven_ui/core/models/screen_contract.dart';
import 'package:flutter_backend_driven_ui/core/network/api_client.dart';
import 'package:flutter_backend_driven_ui/presentation/dynamic_screen_page.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/json_fixtures.dart';
import '../helpers/mock_api_client.dart';

/// Keeps [fetchScreen] pending so [FutureBuilder] stays in loading state.
class _PendingApiClient extends ApiClient {
  final Completer<ScreenContract> _completer = Completer<ScreenContract>();

  @override
  Future<ScreenContract> fetchScreen(String screenId) => _completer.future;

  @override
  void dispose() {}
}

void main() {
  testWidgets('shows loading indicator while fetching', (tester) async {
    final client = _PendingApiClient();

    await tester.pumpWidget(
      MaterialApp(
        home: DynamicScreenPage(
          screenId: 'pending',
          apiClient: client,
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading...'), findsOneWidget);
  });

  testWidgets('shows error message when screen not found', (tester) async {
    final mockClient = MockApiClient();

    await tester.pumpWidget(
      MaterialApp(
        home: DynamicScreenPage(
          screenId: 'missing',
          apiClient: mockClient,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Failed to load screen'), findsOneWidget);
    expect(find.textContaining('Screen not found'), findsOneWidget);
  });

  testWidgets('renders screen title in AppBar after loading', (tester) async {
    final mockClient = MockApiClient();
    mockClient.addContract('test', minimalContract(title: 'My Loaded Screen'));

    await tester.pumpWidget(
      MaterialApp(
        home: DynamicScreenPage(
          screenId: 'test',
          apiClient: mockClient,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('My Loaded Screen'), findsOneWidget);
    expect(find.text('Hello'), findsOneWidget);
  });
}

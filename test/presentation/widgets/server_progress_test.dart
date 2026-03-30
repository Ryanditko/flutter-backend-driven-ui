import 'package:flutter/material.dart';
import 'package:flutter_backend_driven_ui/core/models/screen_contract.dart';
import 'package:flutter_backend_driven_ui/presentation/widgets/server_progress.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders LinearProgressIndicator by default', (tester) async {
    final node = ComponentNode(
      type: 'progress',
      props: const {},
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) =>
                buildServerProgress(node, context, (c) => const SizedBox()),
          ),
        ),
      ),
    );

    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('renders CircularProgressIndicator for circular variant',
      (tester) async {
    final node = ComponentNode(
      type: 'progress',
      props: const {
        'variant': 'circular',
      },
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) =>
                buildServerProgress(node, context, (c) => const SizedBox()),
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNothing);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_backend_driven_ui/core/models/screen_contract.dart';
import 'package:flutter_backend_driven_ui/presentation/widgets/server_divider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders Divider widget', (tester) async {
    final node = ComponentNode(
      type: 'divider',
      props: const {},
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) =>
                buildServerDivider(node, context, (c) => const SizedBox()),
          ),
        ),
      ),
    );

    expect(find.byType(Divider), findsOneWidget);
  });
}

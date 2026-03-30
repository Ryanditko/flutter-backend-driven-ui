import 'package:flutter/material.dart';
import 'package:flutter_backend_driven_ui/core/models/screen_contract.dart';
import 'package:flutter_backend_driven_ui/presentation/widgets/server_badge.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders Badge with label', (tester) async {
    final node = ComponentNode(
      type: 'badge',
      props: const {
        'label': '9',
      },
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) =>
                buildServerBadge(node, context, (c) => const SizedBox()),
          ),
        ),
      ),
    );

    expect(find.byType(Badge), findsOneWidget);
    expect(find.text('9'), findsOneWidget);
  });
}

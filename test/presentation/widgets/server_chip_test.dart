import 'package:flutter/material.dart';
import 'package:flutter_backend_driven_ui/core/models/screen_contract.dart';
import 'package:flutter_backend_driven_ui/presentation/widgets/server_chip.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders Chip with label', (tester) async {
    final node = ComponentNode(
      type: 'chip',
      props: const {
        'label': 'Design',
      },
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) =>
                buildServerChip(node, context, (c) => const SizedBox()),
          ),
        ),
      ),
    );

    expect(find.byType(Chip), findsOneWidget);
    expect(find.text('Design'), findsOneWidget);
  });

  testWidgets('renders outlined variant as OutlinedButton', (tester) async {
    final node = ComponentNode(
      type: 'chip',
      props: const {
        'label': 'Outlined tag',
        'outlined': true,
      },
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) =>
                buildServerChip(node, context, (c) => const SizedBox()),
          ),
        ),
      ),
    );

    expect(find.byType(OutlinedButton), findsOneWidget);
    expect(find.text('Outlined tag'), findsOneWidget);
  });
}

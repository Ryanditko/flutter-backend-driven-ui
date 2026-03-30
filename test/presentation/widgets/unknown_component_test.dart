import 'package:flutter/material.dart';
import 'package:flutter_backend_driven_ui/core/models/screen_contract.dart';
import 'package:flutter_backend_driven_ui/presentation/widgets/unknown_component.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows warning text with unknown type name', (tester) async {
    final node = ComponentNode(
      type: 'not_supported_yet',
      props: const {},
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => buildUnknownComponent(
              node,
              context,
              (c) => const SizedBox(),
            ),
          ),
        ),
      ),
    );

    expect(
      find.text('Unknown component: "not_supported_yet"'),
      findsOneWidget,
    );
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_backend_driven_ui/core/models/screen_contract.dart';
import 'package:flutter_backend_driven_ui/core/parser/component_parser.dart';
import 'package:flutter_backend_driven_ui/presentation/widgets/server_checkbox.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders CheckboxListTile with label', (tester) async {
    final node = ComponentNode(
      type: 'checkbox',
      id: 'terms',
      props: const {
        'label': 'I agree to the terms',
        'value': false,
      },
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => buildServerCheckbox(
              node,
              context,
              (c) => const SizedBox(),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(CheckboxListTile), findsOneWidget);
    expect(find.text('I agree to the terms'), findsOneWidget);
  });

  testWidgets('invokes onChanged with id and value string', (tester) async {
    String? seenId;
    String? seenValue;

    final InputChangeCallback onChanged = (id, value) {
      seenId = id;
      seenValue = value;
    };

    final node = ComponentNode(
      type: 'checkbox',
      id: 'cb1',
      props: const {
        'label': 'Check me',
        'value': false,
      },
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => buildServerCheckbox(
              node,
              context,
              (c) => const SizedBox(),
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    expect(seenId, 'cb1');
    expect(seenValue, 'true');
  });
}

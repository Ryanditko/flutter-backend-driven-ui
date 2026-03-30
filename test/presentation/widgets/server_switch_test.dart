import 'package:flutter/material.dart';
import 'package:flutter_backend_driven_ui/core/models/screen_contract.dart';
import 'package:flutter_backend_driven_ui/core/parser/component_parser.dart';
import 'package:flutter_backend_driven_ui/presentation/widgets/server_switch.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders SwitchListTile with label', (tester) async {
    final node = ComponentNode(
      type: 'switch',
      id: 'notifications',
      props: const {
        'label': 'Enable notifications',
        'value': false,
      },
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => buildServerSwitch(
              node,
              context,
              (c) => const SizedBox(),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(SwitchListTile), findsOneWidget);
    expect(find.text('Enable notifications'), findsOneWidget);
  });

  testWidgets('invokes onChanged with id and value string', (tester) async {
    String? seenId;
    String? seenValue;

    final InputChangeCallback onChanged = (id, value) {
      seenId = id;
      seenValue = value;
    };

    final node = ComponentNode(
      type: 'switch',
      id: 'toggle_id',
      props: const {
        'label': 'Toggle',
        'value': false,
      },
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => buildServerSwitch(
              node,
              context,
              (c) => const SizedBox(),
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(Switch));
    await tester.pump();

    expect(seenId, 'toggle_id');
    expect(seenValue, 'true');
  });
}

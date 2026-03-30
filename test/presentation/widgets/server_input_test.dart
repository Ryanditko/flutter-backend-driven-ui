import 'package:flutter/material.dart';
import 'package:flutter_backend_driven_ui/core/models/screen_contract.dart';
import 'package:flutter_backend_driven_ui/presentation/widgets/server_input.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders TextField with label and hint', (tester) async {
    final node = ComponentNode(
      type: 'input',
      id: 'email_field',
      props: const {
        'label': 'Email',
        'hint': 'you@example.com',
      },
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) =>
                buildServerInput(node, context, (c) => const SizedBox()),
          ),
        ),
      ),
    );

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.decoration?.labelText, 'Email');
    expect(field.decoration?.hintText, 'you@example.com');
  });

  testWidgets('onChanged callback receives field id and text', (tester) async {
    String? seenId;
    String? seenValue;

    final InputChangeCallback onChanged = (id, value) {
      seenId = id;
      seenValue = value;
    };

    final node = ComponentNode(
      type: 'input',
      id: 'username',
      props: const {
        'label': 'Username',
        'hint': '',
      },
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => buildServerInput(
              node,
              context,
              (c) => const SizedBox(),
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'alice');
    await tester.pump();

    expect(seenId, 'username');
    expect(seenValue, 'alice');
  });
}

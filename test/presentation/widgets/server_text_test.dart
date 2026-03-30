import 'package:flutter/material.dart';
import 'package:flutter_backend_driven_ui/core/models/screen_contract.dart';
import 'package:flutter_backend_driven_ui/presentation/widgets/server_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders content text', (tester) async {
    final node = ComponentNode(
      type: 'text',
      props: const {
        'content': 'Hello World',
      },
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) =>
                buildServerText(node, context, (c) => const SizedBox()),
          ),
        ),
      ),
    );

    expect(find.text('Hello World'), findsOneWidget);
  });

  testWidgets('applies fontSize, fontWeight, color from style', (tester) async {
    final node = ComponentNode(
      type: 'text',
      props: {
        'content': 'Styled',
        'style': {
          'fontSize': 20.0,
          'fontWeight': 'bold',
          'color': '#FF0000',
        },
      },
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) =>
                buildServerText(node, context, (c) => const SizedBox()),
          ),
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('Styled'));
    expect(text.style?.fontSize, 20);
    expect(text.style?.fontWeight, FontWeight.w700);
    expect(text.style?.color, const Color(0xFFFF0000));
  });
}

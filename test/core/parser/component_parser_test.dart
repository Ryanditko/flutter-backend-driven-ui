import 'package:flutter/material.dart';
import 'package:flutter_backend_driven_ui/core/expression/expression_context.dart';
import 'package:flutter_backend_driven_ui/core/models/screen_contract.dart';
import 'package:flutter_backend_driven_ui/core/parser/component_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('parses text node into Text widget', (tester) async {
    final node = ComponentNode(
      type: 'text',
      props: {'content': 'Hello'},
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ComponentParser().parse(node, context);
            },
          ),
        ),
      ),
    );

    expect(find.text('Hello'), findsOneWidget);
  });

  testWidgets('parses column with children', (tester) async {
    final node = ComponentNode(
      type: 'column',
      props: const {'crossAxisAlignment': 'stretch'},
      children: const [
        ComponentNode(
          type: 'text',
          props: {'content': 'A'},
        ),
        ComponentNode(
          type: 'text',
          props: {'content': 'B'},
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ComponentParser().parse(node, context);
            },
          ),
        ),
      ),
    );

    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
  });

  testWidgets('parses with expression interpolation', (tester) async {
    final parser = ComponentParser(
      expressionContext: ExpressionContext({'name': 'Jane'}),
    );
    final node = ComponentNode(
      type: 'text',
      props: {'content': 'Hello, {{name}}!'},
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return parser.parse(node, context);
            },
          ),
        ),
      ),
    );

    expect(find.text('Hello, Jane!'), findsOneWidget);
  });

  testWidgets('hidden node returns SizedBox.shrink', (tester) async {
    final node = ComponentNode(
      type: 'text',
      props: {'content': 'hidden'},
      visible: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ComponentParser().parse(node, context);
            },
          ),
        ),
      ),
    );

    expect(find.text('hidden'), findsNothing);
  });
}

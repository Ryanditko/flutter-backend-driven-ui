import 'package:flutter/material.dart';
import 'package:flutter_backend_driven_ui/core/models/screen_contract.dart';
import 'package:flutter_backend_driven_ui/presentation/widgets/server_tables.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget Function(BuildContext) builder) {
  return MaterialApp(
    home: Scaffold(body: Builder(builder: builder)),
  );
}

Widget _childBuilder(ComponentNode c) => Text(c.props['content'] as String? ?? 'cell');

void main() {
  testWidgets('buildServerTable renders Table with rows', (tester) async {
    final node = ComponentNode(
      type: 'table',
      children: [
        ComponentNode(
          type: 'tableRow',
          children: [
            const ComponentNode(type: 'text', props: {'content': 'A'}),
            const ComponentNode(type: 'text', props: {'content': 'B'}),
          ],
        ),
      ],
    );

    await tester.pumpWidget(_wrap((ctx) => buildServerTable(node, ctx, _childBuilder)));

    expect(find.byType(Table), findsOneWidget);
  });

  testWidgets('buildServerDataTable renders columns and rows', (tester) async {
    final node = ComponentNode(
      type: 'dataTable',
      props: {
        'columns': [
          {'label': 'Name'},
          {'label': 'Age', 'numeric': true},
        ],
        'rows': [
          {
            'cells': [
              {'value': 'Alice'},
              {'value': '30'},
            ],
          },
          {
            'cells': [
              {'value': 'Bob'},
              {'value': '25'},
            ],
          },
        ],
      },
    );

    await tester.pumpWidget(_wrap((ctx) => buildServerDataTable(node, ctx, _childBuilder)));

    expect(find.byType(DataTable), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Age'), findsOneWidget);
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Bob'), findsOneWidget);
  });
}

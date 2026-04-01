import 'package:flutter/material.dart';
import 'package:flutter_backend_driven_ui/core/models/screen_contract.dart';
import 'package:flutter_backend_driven_ui/presentation/widgets/server_text_variants.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget Function(BuildContext) builder) {
  return MaterialApp(
    home: Scaffold(body: Builder(builder: builder)),
  );
}

Widget _childBuilder(ComponentNode c) => const SizedBox();

void main() {
  testWidgets('buildServerSelectableText renders selectable content', (tester) async {
    final node = ComponentNode(
      type: 'selectableText',
      props: const {'content': 'Select me'},
    );

    await tester.pumpWidget(
        _wrap((ctx) => buildServerSelectableText(node, ctx, _childBuilder)));

    expect(find.text('Select me'), findsOneWidget);
    expect(find.byType(SelectableText), findsOneWidget);
  });

  testWidgets('buildServerRichText renders spans', (tester) async {
    final node = ComponentNode(
      type: 'richText',
      props: {
        'spans': [
          {'text': 'Hello ', 'fontWeight': 'bold'},
          {'text': 'World', 'color': '#FF0000'},
        ],
      },
    );

    await tester.pumpWidget(
        _wrap((ctx) => buildServerRichText(node, ctx, _childBuilder)));

    expect(find.byType(RichText), findsWidgets);
  });

  testWidgets('buildServerSelectableText has Semantics', (tester) async {
    final node = ComponentNode(
      type: 'selectableText',
      props: const {'content': 'Accessible'},
    );

    await tester.pumpWidget(
        _wrap((ctx) => buildServerSelectableText(node, ctx, _childBuilder)));

    expect(find.byType(Semantics), findsWidgets);
  });
}

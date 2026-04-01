import 'package:flutter/material.dart';
import 'package:flutter_backend_driven_ui/core/models/screen_contract.dart';
import 'package:flutter_backend_driven_ui/presentation/widgets/server_misc.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget Function(BuildContext) builder) {
  return MaterialApp(
    home: Scaffold(body: Builder(builder: builder)),
  );
}

Widget _childBuilder(ComponentNode c) => const SizedBox();

void main() {
  testWidgets('buildServerPlaceholder renders Placeholder widget', (tester) async {
    final node = ComponentNode(
      type: 'placeholder',
      props: const {'width': 200, 'height': 100},
    );

    await tester.pumpWidget(
        _wrap((ctx) => buildServerPlaceholder(node, ctx, _childBuilder)));

    expect(find.byType(Placeholder), findsOneWidget);
  });

  testWidgets('buildServerCircleAvatar renders with label', (tester) async {
    final node = ComponentNode(
      type: 'circleAvatar',
      props: const {'label': 'JD', 'radius': 24},
    );

    await tester.pumpWidget(
        _wrap((ctx) => buildServerCircleAvatar(node, ctx, _childBuilder)));

    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.text('JD'), findsOneWidget);
  });

  testWidgets('buildServerCircleAvatar renders with icon', (tester) async {
    final node = ComponentNode(
      type: 'circleAvatar',
      props: const {'icon': 'person', 'radius': 24},
    );

    await tester.pumpWidget(
        _wrap((ctx) => buildServerCircleAvatar(node, ctx, _childBuilder)));

    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
  });

  testWidgets('buildServerVerticalDivider renders', (tester) async {
    final node = ComponentNode(
      type: 'verticalDivider',
      props: const {'width': 16, 'thickness': 2},
    );

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Row(
          children: [
            Builder(
              builder: (ctx) => buildServerVerticalDivider(node, ctx, _childBuilder),
            ),
          ],
        ),
      ),
    ));

    expect(find.byType(VerticalDivider), findsOneWidget);
  });

  testWidgets('buildServerPlaceholder has Semantics', (tester) async {
    final node = ComponentNode(
      type: 'placeholder',
      props: const {'width': 100, 'height': 100},
    );

    await tester.pumpWidget(
        _wrap((ctx) => buildServerPlaceholder(node, ctx, _childBuilder)));

    expect(find.byType(Semantics), findsWidgets);
    expect(find.byType(Placeholder), findsOneWidget);
  });
}

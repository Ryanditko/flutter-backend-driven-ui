import 'package:flutter/material.dart';
import 'package:flutter_backend_driven_ui/core/models/screen_contract.dart';
import 'package:flutter_backend_driven_ui/presentation/widgets/server_interactives.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget Function(BuildContext) builder) {
  return MaterialApp(
    home: Scaffold(body: Builder(builder: builder)),
  );
}

Widget _childBuilder(ComponentNode c) => const Text('child');

void main() {
  testWidgets('buildServerInkWell renders child and responds to tap', (tester) async {
    final node = ComponentNode(
      type: 'inkWell',
      action: const ActionDef(type: 'snackbar', message: 'tapped'),
      children: [const ComponentNode(type: 'text', props: {'content': 'hi'})],
    );

    await tester.pumpWidget(_wrap((ctx) => buildServerInkWell(node, ctx, _childBuilder)));

    expect(find.text('child'), findsOneWidget);
    expect(find.byType(InkWell), findsOneWidget);

    await tester.tap(find.byType(InkWell));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('buildServerGestureDetector renders and fires action', (tester) async {
    final node = ComponentNode(
      type: 'gestureDetector',
      action: const ActionDef(type: 'snackbar', message: 'detected'),
      children: [const ComponentNode(type: 'text', props: {'content': 'hi'})],
    );

    await tester
        .pumpWidget(_wrap((ctx) => buildServerGestureDetector(node, ctx, _childBuilder)));

    await tester.tap(find.text('child'));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('buildServerTooltip renders with message', (tester) async {
    final node = ComponentNode(
      type: 'tooltip',
      props: const {'message': 'Help text'},
      children: [const ComponentNode(type: 'text', props: {'content': 'hi'})],
    );

    await tester.pumpWidget(_wrap((ctx) => buildServerTooltip(node, ctx, _childBuilder)));

    expect(find.byType(Tooltip), findsOneWidget);
  });

  testWidgets('buildServerInkWell has Semantics wrapper', (tester) async {
    final node = ComponentNode(
      type: 'inkWell',
      action: const ActionDef(type: 'snackbar', message: 'tap'),
      children: [const ComponentNode(type: 'text', props: {'content': 'hi'})],
    );

    await tester.pumpWidget(_wrap((ctx) => buildServerInkWell(node, ctx, _childBuilder)));

    expect(find.byType(Semantics), findsWidgets);
  });

  testWidgets('buildServerDismissible renders child with key', (tester) async {
    final node = ComponentNode(
      type: 'dismissible',
      id: 'item_1',
      children: [const ComponentNode(type: 'text', props: {'content': 'hi'})],
    );

    await tester
        .pumpWidget(_wrap((ctx) => buildServerDismissible(node, ctx, _childBuilder)));

    expect(find.byType(Dismissible), findsOneWidget);
    expect(find.text('child'), findsOneWidget);
  });
}

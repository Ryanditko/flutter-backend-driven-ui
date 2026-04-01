import 'package:flutter/material.dart';
import 'package:flutter_backend_driven_ui/core/models/screen_contract.dart';
import 'package:flutter_backend_driven_ui/presentation/widgets/server_layout_wrappers.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget Function(BuildContext) builder) {
  return MaterialApp(
    home: Scaffold(body: Builder(builder: builder)),
  );
}

Widget _childBuilder(ComponentNode c) => const Text('child');

void main() {
  testWidgets('buildServerCenter wraps child in Center', (tester) async {
    final node = ComponentNode(
      type: 'center',
      children: [const ComponentNode(type: 'text', props: {'content': 'hi'})],
    );

    await tester.pumpWidget(_wrap((ctx) => buildServerCenter(node, ctx, _childBuilder)));

    expect(find.byType(Center), findsOneWidget);
    expect(find.text('child'), findsOneWidget);
  });

  testWidgets('buildServerAlign uses alignment prop', (tester) async {
    final node = ComponentNode(
      type: 'align',
      props: const {'alignment': 'bottomRight'},
      children: [const ComponentNode(type: 'text', props: {'content': 'hi'})],
    );

    await tester.pumpWidget(_wrap((ctx) => buildServerAlign(node, ctx, _childBuilder)));

    final align = tester.widget<Align>(find.byType(Align));
    expect(align.alignment, Alignment.bottomRight);
  });

  testWidgets('buildServerPadding applies padding', (tester) async {
    final node = ComponentNode(
      type: 'padding',
      props: const {'padding': 16},
      children: [const ComponentNode(type: 'text', props: {'content': 'hi'})],
    );

    await tester.pumpWidget(_wrap((ctx) => buildServerPadding(node, ctx, _childBuilder)));

    final padding = tester.widget<Padding>(find.byType(Padding).first);
    expect(padding.padding, const EdgeInsets.all(16));
  });

  testWidgets('buildServerSizedBox applies width and height', (tester) async {
    final node = ComponentNode(
      type: 'sizedBox',
      props: const {'width': 100, 'height': 50},
    );

    await tester.pumpWidget(_wrap((ctx) => buildServerSizedBox(node, ctx, _childBuilder)));

    final box = tester.widget<SizedBox>(find.byType(SizedBox).first);
    expect(box.width, 100);
    expect(box.height, 50);
  });

  testWidgets('buildServerOpacity clamps opacity between 0 and 1', (tester) async {
    final node = ComponentNode(
      type: 'opacity',
      props: const {'opacity': 0.5},
      children: [const ComponentNode(type: 'text', props: {'content': 'hi'})],
    );

    await tester.pumpWidget(_wrap((ctx) => buildServerOpacity(node, ctx, _childBuilder)));

    final opacity = tester.widget<Opacity>(find.byType(Opacity));
    expect(opacity.opacity, 0.5);
  });

  testWidgets('buildServerClipRRect applies borderRadius', (tester) async {
    final node = ComponentNode(
      type: 'clipRRect',
      props: const {'borderRadius': 12},
      children: [const ComponentNode(type: 'text', props: {'content': 'hi'})],
    );

    await tester.pumpWidget(_wrap((ctx) => buildServerClipRRect(node, ctx, _childBuilder)));

    expect(find.byType(ClipRRect), findsOneWidget);
  });

  testWidgets('buildServerSafeArea passes inset flags', (tester) async {
    final node = ComponentNode(
      type: 'safeArea',
      props: const {'top': true, 'bottom': false},
      children: [const ComponentNode(type: 'text', props: {'content': 'hi'})],
    );

    await tester.pumpWidget(_wrap((ctx) => buildServerSafeArea(node, ctx, _childBuilder)));

    final safeArea = tester.widget<SafeArea>(find.byType(SafeArea));
    expect(safeArea.top, true);
    expect(safeArea.bottom, false);
  });

  testWidgets('buildServerRotatedBox applies quarterTurns', (tester) async {
    final node = ComponentNode(
      type: 'rotatedBox',
      props: const {'quarterTurns': 2},
      children: [const ComponentNode(type: 'text', props: {'content': 'hi'})],
    );

    await tester.pumpWidget(_wrap((ctx) => buildServerRotatedBox(node, ctx, _childBuilder)));

    final rotated = tester.widget<RotatedBox>(find.byType(RotatedBox));
    expect(rotated.quarterTurns, 2);
  });

  testWidgets('buildServerIgnorePointer renders with child', (tester) async {
    final node = ComponentNode(
      type: 'ignorePointer',
      props: const {'ignoring': true},
      children: [const ComponentNode(type: 'text', props: {'content': 'hi'})],
    );

    await tester.pumpWidget(_wrap((ctx) => buildServerIgnorePointer(node, ctx, _childBuilder)));

    expect(find.byType(IgnorePointer), findsWidgets);
    expect(find.text('child'), findsOneWidget);
  });

  testWidgets('buildServerOffstage renders', (tester) async {
    final node = ComponentNode(
      type: 'offstage',
      props: const {'offstage': false},
      children: [const ComponentNode(type: 'text', props: {'content': 'hi'})],
    );

    await tester.pumpWidget(_wrap((ctx) => buildServerOffstage(node, ctx, _childBuilder)));

    expect(find.text('child'), findsOneWidget);
  });
}

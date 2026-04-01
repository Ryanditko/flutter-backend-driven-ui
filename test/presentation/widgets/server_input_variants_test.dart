import 'package:flutter/material.dart';
import 'package:flutter_backend_driven_ui/core/models/screen_contract.dart';
import 'package:flutter_backend_driven_ui/presentation/widgets/server_input_variants.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget Function(BuildContext) builder) {
  return MaterialApp(
    home: Scaffold(body: Builder(builder: builder)),
  );
}

Widget _childBuilder(ComponentNode c) => const SizedBox();

void main() {
  testWidgets('buildServerSlider renders Slider widget', (tester) async {
    final node = ComponentNode(
      type: 'slider',
      id: 'volume',
      props: const {'value': 0.5, 'min': 0, 'max': 1},
    );

    await tester.pumpWidget(_wrap((ctx) => buildServerSlider(
          node, ctx, _childBuilder,
        )));

    expect(find.byType(Slider), findsOneWidget);

    final slider = tester.widget<Slider>(find.byType(Slider));
    expect(slider.value, 0.5);
    expect(slider.min, 0);
    expect(slider.max, 1);
  });

  testWidgets('buildServerSlider clamps initial value to min/max', (tester) async {
    final node = ComponentNode(
      type: 'slider',
      id: 's1',
      props: const {'value': 5, 'min': 0, 'max': 1},
    );

    await tester.pumpWidget(_wrap((ctx) => buildServerSlider(
          node, ctx, _childBuilder,
        )));

    final slider = tester.widget<Slider>(find.byType(Slider));
    expect(slider.value, 1.0);
  });

  testWidgets('buildServerRadio renders Radio widget', (tester) async {
    final node = ComponentNode(
      type: 'radio',
      id: 'r1',
      props: const {'value': 'a', 'groupValue': 'a'},
    );

    await tester.pumpWidget(_wrap((ctx) => buildServerRadio(
          node, ctx, _childBuilder,
        )));

    expect(find.byType(Radio<String>), findsOneWidget);
  });
}

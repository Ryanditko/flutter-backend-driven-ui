import 'package:flutter/material.dart';
import 'package:flutter_backend_driven_ui/core/models/screen_contract.dart';
import 'package:flutter_backend_driven_ui/presentation/widgets/server_icon.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('resolveIcon maps known icon name', (tester) async {
    expect(resolveIcon('home'), Icons.home);
  });

  testWidgets('resolveIcon falls back for unknown name', (tester) async {
    expect(resolveIcon('totally_unknown_icon_xyz'), Icons.help_outline);
  });

  testWidgets('applies size and color from props', (tester) async {
    final node = ComponentNode(
      type: 'icon',
      props: {
        'name': 'star',
        'size': 40.0,
        'color': '#0000FF',
      },
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) =>
                buildServerIcon(node, context, (c) => const SizedBox()),
          ),
        ),
      ),
    );

    final icon = tester.widget<Icon>(find.byType(Icon));
    expect(icon.icon, Icons.star);
    expect(icon.size, 40);
    expect(icon.color, const Color(0xFF0000FF));
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_backend_driven_ui/core/models/screen_contract.dart';
import 'package:flutter_backend_driven_ui/presentation/widgets/server_button.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders label text', (tester) async {
    final node = ComponentNode(
      type: 'button',
      props: const {
        'label': 'Submit',
      },
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) =>
                buildServerButton(node, context, (c) => const SizedBox()),
          ),
        ),
      ),
    );

    expect(find.text('Submit'), findsOneWidget);
  });

  testWidgets('applies backgroundColor via style', (tester) async {
    final node = ComponentNode(
      type: 'button',
      props: {
        'label': 'Go',
        'style': {
          'backgroundColor': '#00FF00',
        },
      },
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) =>
                buildServerButton(node, context, (c) => const SizedBox()),
          ),
        ),
      ),
    );

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    final bg = button.style?.backgroundColor?.resolve(<WidgetState>{});
    expect(bg, const Color(0xFF00FF00));
  });

  testWidgets('tap triggers snackbar action', (tester) async {
    final node = ComponentNode(
      type: 'button',
      props: const {
        'label': 'Tap me',
      },
      action: const ActionDef(type: 'snackbar', message: 'Hello from server'),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) =>
                buildServerButton(node, context, (c) => const SizedBox()),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Tap me'));
    await tester.pumpAndSettle();

    expect(find.text('Hello from server'), findsOneWidget);
  });
}

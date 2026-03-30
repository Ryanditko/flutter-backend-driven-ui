import 'package:flutter/material.dart';
import 'package:flutter_backend_driven_ui/playground/playground_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders playground with editor and preview areas',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: PlaygroundPage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('JSON Contract'), findsOneWidget);
    expect(find.text('Preview'), findsOneWidget);
  });

  testWidgets('shows New button', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PlaygroundPage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('New'), findsOneWidget);
  });

  testWidgets('shows screen selector dropdown', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PlaygroundPage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(DropdownButton<String>), findsOneWidget);
    expect(find.text('Load a screen...'), findsOneWidget);
  });
}

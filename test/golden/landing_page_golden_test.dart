import 'package:flutter/material.dart';
import 'package:flutter_backend_driven_ui/presentation/landing_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('landing page golden', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: const LandingPage(),
        onGenerateRoute: (settings) =>
            MaterialPageRoute<void>(builder: (_) => const Scaffold()),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(LandingPage),
      matchesGoldenFile('landing_page.png'),
    );
  });
}

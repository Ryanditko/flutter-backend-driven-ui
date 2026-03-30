import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_backend_driven_ui/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app navigation: landing -> home -> profile -> back',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(const BdcApp());
    await tester.pumpAndSettle();

    expect(find.text('Server-Driven UI'), findsOneWidget);
    expect(find.text('App Demo'), findsOneWidget);

    await tester.tap(find.text('App Demo'));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Welcome to Server-Driven UI'), findsOneWidget);

    await tester.tap(find.text('View Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Jane Doe'), findsOneWidget);

    await tester.tap(find.text('Back to Home'));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
  });
}

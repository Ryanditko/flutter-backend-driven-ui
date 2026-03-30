import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_backend_driven_ui/main.dart';

void main() {
  testWidgets('App starts and shows landing page', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const BdcApp());
    expect(find.text('Server-Driven UI'), findsOneWidget);
  });
}

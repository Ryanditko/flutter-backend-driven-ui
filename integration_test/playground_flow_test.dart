import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_backend_driven_ui/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('playground flow: landing -> playground -> edit JSON',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(const BdcApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Playground'));
    await tester.pumpAndSettle();

    expect(find.text('Playground'), findsWidgets);

    expect(find.byType(TextField), findsWidgets);

    expect(find.text('New'), findsOneWidget);
  });
}

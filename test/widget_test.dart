import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_backend_driven_ui/main.dart';

void main() {
  testWidgets('App starts and shows loading state', (WidgetTester tester) async {
    await tester.pumpWidget(const BdcApp());
    expect(find.text('Loading...'), findsOneWidget);
  });
}

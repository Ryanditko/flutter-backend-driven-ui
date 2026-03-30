import 'package:flutter/material.dart';
import 'package:flutter_backend_driven_ui/presentation/landing_page.dart';
import 'package:flutter_test/flutter_test.dart';

class _RecordingNavigatorObserver extends NavigatorObserver {
  int pushCount = 0;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushCount++;
  }
}

/// Default test viewport is too short; [LandingPage] column needs more height.
void _bindTallSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('renders Server-Driven UI title', (tester) async {
    _bindTallSurface(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: const LandingPage(),
        onGenerateRoute: (settings) =>
            MaterialPageRoute<void>(builder: (_) => const Scaffold()),
      ),
    );

    expect(find.text('Server-Driven UI'), findsOneWidget);
  });

  testWidgets('renders App Demo and Playground mode cards', (tester) async {
    _bindTallSurface(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: const LandingPage(),
        onGenerateRoute: (settings) =>
            MaterialPageRoute<void>(builder: (_) => const Scaffold()),
      ),
    );

    expect(find.text('App Demo'), findsOneWidget);
    expect(find.text('Playground'), findsOneWidget);
  });

  testWidgets('tapping App Demo card triggers Navigator push', (tester) async {
    _bindTallSurface(tester);
    final observer = _RecordingNavigatorObserver();
    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [observer],
        home: const LandingPage(),
        onGenerateRoute: (settings) =>
            MaterialPageRoute<void>(builder: (_) => const Scaffold()),
      ),
    );

    await tester.tap(find.text('App Demo'));
    await tester.pumpAndSettle();

    expect(observer.pushCount, greaterThan(0));
  });

  testWidgets('renders version chip v1.0', (tester) async {
    _bindTallSurface(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: const LandingPage(),
        onGenerateRoute: (settings) =>
            MaterialPageRoute<void>(builder: (_) => const Scaffold()),
      ),
    );

    expect(find.text('v1.0'), findsOneWidget);
  });

  testWidgets('renders footer Built with Flutter + Material Design 3',
      (tester) async {
    _bindTallSurface(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: const LandingPage(),
        onGenerateRoute: (settings) =>
            MaterialPageRoute<void>(builder: (_) => const Scaffold()),
      ),
    );

    expect(
      find.text('Built with Flutter + Material Design 3'),
      findsOneWidget,
    );
  });
}

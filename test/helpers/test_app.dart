import 'package:flutter/material.dart';
import 'package:flutter_backend_driven_ui/core/theme/app_colors.dart';

Widget buildTestApp({required Widget child, NavigatorObserver? observer}) {
  return MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        secondary: AppColors.accent,
      ),
      useMaterial3: true,
    ),
    home: child,
    navigatorObservers: observer != null ? [observer] : [],
  );
}

Widget buildTestScaffold({required Widget body}) {
  return buildTestApp(
    child: Scaffold(body: body),
  );
}

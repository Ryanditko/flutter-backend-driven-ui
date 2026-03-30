import 'package:flutter/material.dart';

import 'core/network/api_client.dart';
import 'core/network/local_api_client.dart';
import 'core/theme/app_colors.dart';
import 'playground/playground_page.dart';
import 'presentation/dynamic_screen_page.dart';
import 'presentation/landing_page.dart';

void main() {
  runApp(const BdcApp());
}

class BdcApp extends StatefulWidget {
  const BdcApp({super.key});

  @override
  State<BdcApp> createState() => _BdcAppState();
}

class _BdcAppState extends State<BdcApp> {
  late final ApiClient _apiClient;

  @override
  void initState() {
    super.initState();
    _apiClient = LocalApiClient();
  }

  @override
  void dispose() {
    _apiClient.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Server-Driven UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          secondary: AppColors.accent,
        ),
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name ?? '');

        if (uri.path == '/') {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const LandingPage(),
          );
        }

        if (uri.path == '/playground') {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const PlaygroundPage(),
          );
        }

        if (uri.pathSegments.length == 2 &&
            uri.pathSegments.first == 'screen') {
          final screenId = uri.pathSegments[1];
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => DynamicScreenPage(
              screenId: screenId,
              apiClient: _apiClient,
            ),
          );
        }

        return MaterialPageRoute(
          builder: (_) => const LandingPage(),
        );
      },
    );
  }
}

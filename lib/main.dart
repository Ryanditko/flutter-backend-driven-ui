import 'package:flutter/material.dart';

import 'core/network/api_client.dart';
import 'core/network/local_api_client.dart';
import 'presentation/dynamic_screen_page.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6200EE)),
        useMaterial3: true,
      ),
      initialRoute: '/screen/home',
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name ?? '');

        if (uri.pathSegments.length == 2 && uri.pathSegments.first == 'screen') {
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
          builder: (_) => DynamicScreenPage(
            screenId: 'home',
            apiClient: _apiClient,
          ),
        );
      },
    );
  }
}

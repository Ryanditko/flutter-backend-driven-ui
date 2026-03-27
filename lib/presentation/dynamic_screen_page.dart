import 'package:flutter/material.dart';

import '../core/models/screen_contract.dart';
import '../core/network/api_client.dart';
import '../core/parser/component_parser.dart';
import 'widgets/server_button.dart';

/// A page that fetches a screen contract by [screenId] and renders
/// the widget tree dynamically. Handles loading, error and retry states.
class DynamicScreenPage extends StatefulWidget {
  final String screenId;
  final ApiClient apiClient;

  const DynamicScreenPage({
    super.key,
    required this.screenId,
    required this.apiClient,
  });

  @override
  State<DynamicScreenPage> createState() => _DynamicScreenPageState();
}

class _DynamicScreenPageState extends InputCollectorState<DynamicScreenPage> {
  late Future<ScreenContract> _future;
  final Map<String, String> _inputValues = {};

  @override
  void initState() {
    super.initState();
    _future = widget.apiClient.fetchScreen(widget.screenId);
  }

  void _retry() {
    setState(() {
      _inputValues.clear();
      _future = widget.apiClient.fetchScreen(widget.screenId);
    });
  }

  @override
  Map<String, String> collectValues() => Map.unmodifiable(_inputValues);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ScreenContract>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Loading...')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load screen "${widget.screenId}"',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _retry,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final contract = snapshot.data!;
        final parser = ComponentParser(
          onInputChanged: (id, value) => _inputValues[id] = value,
        );

        return Scaffold(
          appBar: AppBar(title: Text(contract.screen.title)),
          body: SafeArea(
            child: SingleChildScrollView(
              child: parser.parse(contract.screen.root, context),
            ),
          ),
        );
      },
    );
  }
}

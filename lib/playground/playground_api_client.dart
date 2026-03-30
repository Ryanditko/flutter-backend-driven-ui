import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../core/models/screen_contract.dart';

/// Client tailored for the playground: parses raw JSON strings into
/// [ScreenContract] and loads existing screen assets for editing.
class PlaygroundApiClient {
  static const _basePath = 'assets/screens';

  static const availableScreens = [
    'home',
    'profile',
    'form',
    'components_showcase',
    'expressions_demo',
    'theme_demo',
  ];

  ScreenContract parseContract(String jsonString) {
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return ScreenContract.fromJson(json);
  }

  Future<String> loadScreenJson(String screenId) async {
    return rootBundle.loadString('$_basePath/$screenId.json');
  }

  String get templateJson => const JsonEncoder.withIndent('  ').convert({
        'schemaVersion': '1.0',
        'screen': {
          'id': 'playground',
          'title': 'Playground Screen',
          'root': {
            'type': 'column',
            'props': {
              'crossAxisAlignment': 'stretch',
              'padding': {'top': 24, 'left': 24, 'right': 24, 'bottom': 24},
            },
            'children': [
              {
                'type': 'text',
                'props': {
                  'content': 'Hello from Playground!',
                  'style': {'fontSize': 24, 'fontWeight': 'bold'},
                },
              },
              {
                'type': 'spacer',
                'props': {'height': 16},
              },
              {
                'type': 'button',
                'props': {
                  'label': 'Tap me',
                  'style': {
                    'backgroundColor': '#820AD1',
                    'textColor': '#FFFFFF',
                  },
                },
                'action': {'type': 'snackbar', 'message': 'It works!'},
              },
            ],
          },
        },
      });
}

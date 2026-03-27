import 'package:flutter/material.dart';

import '../../core/models/screen_contract.dart';

Widget buildServerButton(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final label = node.props['label'] as String? ?? '';
  final rawStyle = node.props['style'] as Map<String, dynamic>?;
  final style = rawStyle != null ? ButtonStyleModel.fromJson(rawStyle) : null;

  final bgColor = _parseColor(style?.backgroundColor) ?? Theme.of(context).colorScheme.primary;
  final textColor = _parseColor(style?.textColor) ?? Colors.white;
  final radius = style?.borderRadius ?? 8.0;

  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      onPressed: () => _handleAction(context, node.action),
      child: Text(label, style: const TextStyle(fontSize: 16)),
    ),
  );
}

void _handleAction(BuildContext context, ActionDef? action) {
  if (action == null) return;

  switch (action.type) {
    case 'navigate':
      if (action.targetScreenId != null) {
        Navigator.of(context).pushNamed('/screen/${action.targetScreenId}');
      }
    case 'snackbar':
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(action.message ?? '')),
      );
    case 'submit':
      _handleSubmit(context);
    default:
      debugPrint('Unknown action type: ${action.type}');
  }
}

Color? _parseColor(String? hex) {
  if (hex == null || hex.isEmpty) return null;
  final raw = hex.replaceFirst('#', '');
  if (raw.length == 6) return Color(int.parse('FF$raw', radix: 16));
  if (raw.length == 8) return Color(int.parse(raw, radix: 16));
  return null;
}

void _handleSubmit(BuildContext context) {
  final formState = _findInputCollector(context);
  if (formState != null) {
    final values = formState.collectValues();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Submitted: $values')),
    );
  }
}

InputCollectorState? _findInputCollector(BuildContext context) {
  return context.findAncestorStateOfType<InputCollectorState>();
}

/// Mixin-free state interface that [DynamicScreenPage] will implement
/// so buttons can collect input field values.
abstract class InputCollectorState<T extends StatefulWidget> extends State<T> {
  Map<String, String> collectValues();
}

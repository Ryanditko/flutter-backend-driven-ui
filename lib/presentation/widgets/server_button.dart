import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      onPressed: () => handleAction(context, node.action),
      child: Text(label, style: const TextStyle(fontSize: 16)),
    ),
  );
}

/// Interprets an [ActionDef] and performs the corresponding side-effect.
///
/// Exposed as a top-level function so other interactive components (chips,
/// switches, etc.) can reuse the same action handling.
void handleAction(BuildContext context, ActionDef? action) {
  if (action == null) return;

  switch (action.type) {
    case 'navigate':
      if (action.targetScreenId != null) {
        Navigator.of(context).pushNamed('/screen/${action.targetScreenId}');
      }
    case 'goBack':
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
    case 'snackbar':
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(action.message ?? '')),
      );
    case 'submit':
      _handleSubmit(context);
    case 'copyToClipboard':
      final text = action.message ?? '';
      Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied to clipboard')),
      );
    case 'openUrl':
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Open URL: ${action.message ?? ''}')),
      );
    case 'showDialog':
      showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(action.targetScreenId ?? 'Alert'),
          content: Text(action.message ?? ''),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
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

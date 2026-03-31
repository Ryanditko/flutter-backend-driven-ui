import 'package:flutter/material.dart';

import '../../core/models/screen_contract.dart';
import '../../core/parser/component_parser.dart';
import '../../core/utils/color_utils.dart';

/// A server-driven dropdown selector.
///
/// ```json
/// {
///   "type": "dropdown",
///   "id": "country",
///   "props": {
///     "label": "Select country",
///     "options": [
///       { "value": "br", "label": "Brazil" },
///       { "value": "us", "label": "United States" }
///     ],
///     "hint": "Choose one...",
///     "filled": true
///   }
/// }
/// ```
class ServerDropdown extends StatefulWidget {
  final ComponentNode node;
  final InputChangeCallback? onChanged;

  const ServerDropdown({super.key, required this.node, this.onChanged});

  @override
  State<ServerDropdown> createState() => _ServerDropdownState();
}

class _ServerDropdownState extends State<ServerDropdown> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.node.props['value'] as String?;
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.node.props['label'] as String?;
    final hint = widget.node.props['hint'] as String?;
    final filled = widget.node.props['filled'] as bool? ?? false;
    final iconColor = parseHexColor(widget.node.props['iconColor'] as String?);
    final options = (widget.node.props['options'] as List<dynamic>?)
            ?.cast<Map<String, dynamic>>() ??
        [];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: DropdownButtonFormField<String>(
        initialValue: _selected,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: filled,
          border: const OutlineInputBorder(),
        ),
        iconEnabledColor: iconColor,
        items: options.map((o) {
          final optVal = o['value'] as String? ?? '';
          final text = o['label'] as String? ?? optVal;
          return DropdownMenuItem(value: optVal, child: Text(text));
        }).toList(),
        onChanged: (v) {
          setState(() => _selected = v);
          if (v != null && widget.node.id != null) {
            widget.onChanged?.call(widget.node.id!, v);
          }
        },
      ),
    );
  }
}

Widget buildServerDropdown(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild, {
  InputChangeCallback? onChanged,
}) {
  return ServerDropdown(node: node, onChanged: onChanged);
}

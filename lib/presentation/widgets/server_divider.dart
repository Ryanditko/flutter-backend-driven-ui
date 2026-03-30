import 'package:flutter/material.dart';

import '../../core/models/screen_contract.dart';

Widget buildServerDivider(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final height = (node.props['height'] as num?)?.toDouble();
  final thickness = (node.props['thickness'] as num?)?.toDouble() ?? 1;
  final color = _parseColor(node.props['color'] as String?);
  final indent = (node.props['indent'] as num?)?.toDouble() ?? 0;
  final endIndent = (node.props['endIndent'] as num?)?.toDouble() ?? 0;

  return Divider(
    height: height,
    thickness: thickness,
    color: color,
    indent: indent,
    endIndent: endIndent,
  );
}

Color? _parseColor(String? hex) {
  if (hex == null || hex.isEmpty) return null;
  final raw = hex.replaceFirst('#', '');
  if (raw.length == 6) return Color(int.parse('FF$raw', radix: 16));
  if (raw.length == 8) return Color(int.parse(raw, radix: 16));
  return null;
}

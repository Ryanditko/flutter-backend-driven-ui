import 'package:flutter/material.dart';

import '../../core/models/screen_contract.dart';
import '../../core/utils/color_utils.dart';

Widget buildServerDivider(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final height = (node.props['height'] as num?)?.toDouble();
  final thickness = (node.props['thickness'] as num?)?.toDouble() ?? 1;
  final color = parseHexColor(node.props['color'] as String?);
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

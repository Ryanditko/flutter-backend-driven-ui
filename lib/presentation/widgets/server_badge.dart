import 'package:flutter/material.dart';

import '../../core/models/screen_contract.dart';
import '../../core/utils/color_utils.dart';

Widget buildServerBadge(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final label = node.props['label'] as String?;
  final bgColor = parseHexColor(node.props['backgroundColor'] as String?);
  final textColor = parseHexColor(node.props['textColor'] as String?);
  final isSmall = node.props['small'] as bool? ?? false;

  final child = node.children.isNotEmpty ? buildChild(node.children.first) : const SizedBox.shrink();

  if (isSmall) {
    return Badge(backgroundColor: bgColor, child: child);
  }

  return Badge(
    label: label != null
        ? Text(label, style: TextStyle(color: textColor ?? Colors.white, fontSize: 11))
        : null,
    backgroundColor: bgColor,
    child: child,
  );
}

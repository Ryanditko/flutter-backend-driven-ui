import 'package:flutter/material.dart';

import '../../core/models/screen_contract.dart';
import '../../core/utils/color_utils.dart';

Widget buildServerProgress(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final variant = node.props['variant'] as String? ?? 'linear';
  final value = (node.props['value'] as num?)?.toDouble();
  final color = parseHexColor(node.props['color'] as String?);
  final trackColor = parseHexColor(node.props['trackColor'] as String?);
  final strokeWidth = (node.props['strokeWidth'] as num?)?.toDouble() ?? 4;
  final size = (node.props['size'] as num?)?.toDouble();

  if (variant == 'circular') {
    Widget indicator = CircularProgressIndicator(
      value: value,
      color: color,
      backgroundColor: trackColor,
      strokeWidth: strokeWidth,
    );

    if (size != null) {
      indicator = SizedBox(width: size, height: size, child: indicator);
    }

    return Center(child: indicator);
  }

  return LinearProgressIndicator(
    value: value,
    color: color,
    backgroundColor: trackColor,
    minHeight: strokeWidth,
  );
}

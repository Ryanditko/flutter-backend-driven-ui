import 'package:flutter/material.dart';

import '../../core/models/screen_contract.dart';
import '../../core/utils/color_utils.dart';

Widget buildServerText(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final content = node.props['content'] as String? ?? '';
  final rawStyle = node.props['style'] as Map<String, dynamic>?;
  final style = rawStyle != null ? TextStyleModel.fromJson(rawStyle) : null;

  return Text(
    content,
    textAlign: _parseTextAlign(style?.textAlign),
    style: TextStyle(
      fontSize: style?.fontSize,
      fontWeight: _parseFontWeight(style?.fontWeight),
      color: parseHexColor(style?.color),
    ),
  );
}

FontWeight? _parseFontWeight(String? w) {
  return switch (w) {
    'bold' || 'w700' => FontWeight.w700,
    'w100' => FontWeight.w100,
    'w200' => FontWeight.w200,
    'w300' => FontWeight.w300,
    'w400' || 'normal' => FontWeight.w400,
    'w500' => FontWeight.w500,
    'w600' => FontWeight.w600,
    'w800' => FontWeight.w800,
    'w900' => FontWeight.w900,
    _ => null,
  };
}

TextAlign? _parseTextAlign(String? a) {
  return switch (a) {
    'center' => TextAlign.center,
    'right' => TextAlign.right,
    'left' => TextAlign.left,
    _ => null,
  };
}

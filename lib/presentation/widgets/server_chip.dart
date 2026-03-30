import 'package:flutter/material.dart';

import '../../core/models/screen_contract.dart';
import '../../core/utils/color_utils.dart';

Widget buildServerChip(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final label = node.props['label'] as String? ?? '';
  final avatar = node.props['avatar'] as String?;
  final bgColor = parseHexColor(node.props['backgroundColor'] as String?);
  final textColor = parseHexColor(node.props['textColor'] as String?);
  final outlined = node.props['outlined'] as bool? ?? false;

  if (outlined) {
    return OutlinedButton(
      onPressed: node.action != null ? () {} : null,
      style: OutlinedButton.styleFrom(
        foregroundColor: textColor,
        side: bgColor != null ? BorderSide(color: bgColor) : null,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(label),
    );
  }

  return Chip(
    avatar: avatar != null
        ? CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Text(avatar, style: const TextStyle(fontSize: 14)),
          )
        : null,
    label: Text(label),
    backgroundColor: bgColor,
    labelStyle: textColor != null ? TextStyle(color: textColor) : null,
  );
}

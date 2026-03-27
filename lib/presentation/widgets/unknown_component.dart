import 'package:flutter/material.dart';

import '../../core/models/screen_contract.dart';

Widget buildUnknownComponent(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  return Container(
    padding: const EdgeInsets.all(8),
    margin: const EdgeInsets.symmetric(vertical: 4),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.orange.shade300),
      borderRadius: BorderRadius.circular(4),
      color: Colors.orange.shade50,
    ),
    child: Row(
      children: [
        Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Unknown component: "${node.type}"',
            style: TextStyle(color: Colors.orange.shade900, fontSize: 12),
          ),
        ),
      ],
    ),
  );
}

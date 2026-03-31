import 'package:flutter/material.dart';

import '../../core/layout/breakpoints.dart';
import '../../core/models/screen_contract.dart';

/// Picks a different child layout depending on the current breakpoint.
///
/// JSON contract example:
/// ```json
/// {
///   "type": "responsive",
///   "props": {
///     "compact": 0,   // index into children
///     "medium": 1,
///     "expanded": 2
///   },
///   "children": [ ... ]
/// }
/// ```
Widget buildServerResponsive(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final bp = currentBreakpoint(context);

  final compactIdx = (node.props['compact'] as num?)?.toInt() ?? 0;
  final mediumIdx = (node.props['medium'] as num?)?.toInt();
  final expandedIdx = (node.props['expanded'] as num?)?.toInt();

  final int idx;
  switch (bp) {
    case Breakpoint.expanded:
      idx = expandedIdx ?? mediumIdx ?? compactIdx;
    case Breakpoint.medium:
      idx = mediumIdx ?? compactIdx;
    case Breakpoint.compact:
      idx = compactIdx;
  }

  if (idx < 0 || idx >= node.children.length) {
    return const SizedBox.shrink();
  }

  return buildChild(node.children[idx]);
}

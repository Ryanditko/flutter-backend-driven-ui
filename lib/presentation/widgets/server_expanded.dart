import 'package:flutter/material.dart';

import '../../core/models/screen_contract.dart';

/// Wraps its first child in an [Expanded] widget.
///
/// Must be a direct child of a `row` or `column`.
Widget buildServerExpanded(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final flex = (node.props['flex'] as num?)?.toInt() ?? 1;

  final child = node.children.isNotEmpty
      ? buildChild(node.children.first)
      : const SizedBox.shrink();

  return Expanded(flex: flex, child: child);
}

/// Wraps its first child in a [Flexible] widget.
Widget buildServerFlexible(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final flex = (node.props['flex'] as num?)?.toInt() ?? 1;
  final fit = (node.props['fit'] as String?) == 'tight'
      ? FlexFit.tight
      : FlexFit.loose;

  final child = node.children.isNotEmpty
      ? buildChild(node.children.first)
      : const SizedBox.shrink();

  return Flexible(flex: flex, fit: fit, child: child);
}

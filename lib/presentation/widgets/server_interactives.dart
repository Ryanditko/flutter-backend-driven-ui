import 'package:flutter/material.dart';

import '../../core/models/screen_contract.dart';
import '../../core/utils/color_utils.dart';
import '../../core/utils/parsing_utils.dart';
import 'server_button.dart';

Widget buildServerInkWell(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final borderRadius = parseBorderRadius(node.props['borderRadius']);
  final splashColor = parseHexColor(node.props['splashColor'] as String?);
  final highlightColor = parseHexColor(node.props['highlightColor'] as String?);

  return Semantics(
    button: node.action != null,
    child: InkWell(
      onTap: node.action != null ? () => handleAction(context, node.action) : null,
      borderRadius: borderRadius,
      splashColor: splashColor,
      highlightColor: highlightColor,
      child: buildSingleChild(node, buildChild),
    ),
  );
}

Widget buildServerGestureDetector(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  return Semantics(
    button: node.action != null,
    child: GestureDetector(
      onTap: node.action != null ? () => handleAction(context, node.action) : null,
      behavior: _parseHitTestBehavior(node.props['behavior'] as String?),
      child: buildSingleChild(node, buildChild),
    ),
  );
}

Widget buildServerTooltip(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final message = node.props['message'] as String? ?? '';
  final preferBelow = node.props['preferBelow'] as bool? ?? true;
  final verticalOffset = (node.props['verticalOffset'] as num?)?.toDouble();
  final showDuration = node.props['showDuration'] != null
      ? parseDuration(node.props['showDuration'])
      : null;

  return Tooltip(
    message: message,
    preferBelow: preferBelow,
    verticalOffset: verticalOffset,
    showDuration: showDuration,
    child: buildSingleChild(node, buildChild),
  );
}

Widget buildServerDismissible(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final key = node.id ?? UniqueKey().toString();
  final direction = _parseDismissDirection(node.props['direction'] as String?);
  final bgColor = parseHexColor(node.props['backgroundColor'] as String?);

  return Dismissible(
    key: ValueKey(key),
    direction: direction,
    background: bgColor != null ? ColoredBox(color: bgColor) : null,
    onDismissed: node.action != null ? (_) => handleAction(context, node.action) : null,
    child: buildSingleChild(node, buildChild),
  );
}

Widget buildServerDraggable(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final data = node.props['data'] as String? ?? '';
  final axis = node.props['axis'] != null ? parseAxis(node.props['axis'] as String?) : null;

  final child = buildSingleChild(node, buildChild);

  return Draggable<String>(
    data: data,
    axis: axis,
    feedback: Opacity(opacity: 0.7, child: Material(child: child)),
    childWhenDragging: Opacity(opacity: 0.3, child: child),
    child: child,
  );
}

Widget buildServerLongPressDraggable(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final data = node.props['data'] as String? ?? '';

  final child = buildSingleChild(node, buildChild);

  return LongPressDraggable<String>(
    data: data,
    feedback: Opacity(opacity: 0.7, child: Material(child: child)),
    childWhenDragging: Opacity(opacity: 0.3, child: child),
    child: child,
  );
}

HitTestBehavior _parseHitTestBehavior(String? value) {
  return switch (value) {
    'opaque' => HitTestBehavior.opaque,
    'translucent' => HitTestBehavior.translucent,
    'deferToChild' => HitTestBehavior.deferToChild,
    _ => HitTestBehavior.opaque,
  };
}

DismissDirection _parseDismissDirection(String? value) {
  return switch (value) {
    'horizontal' => DismissDirection.horizontal,
    'vertical' => DismissDirection.vertical,
    'endToStart' => DismissDirection.endToStart,
    'startToEnd' => DismissDirection.startToEnd,
    'up' => DismissDirection.up,
    'down' => DismissDirection.down,
    _ => DismissDirection.horizontal,
  };
}

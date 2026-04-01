import 'package:flutter/material.dart';

import '../../core/models/screen_contract.dart';
import '../../core/utils/color_utils.dart';
import '../../core/utils/parsing_utils.dart';

Widget buildServerAnimatedContainer(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final duration = parseDuration(node.props['duration']);
  final curve = parseCurve(node.props['curve'] as String?);
  final padding = parsePadding(node.props['padding']);
  final width = (node.props['width'] as num?)?.toDouble();
  final height = (node.props['height'] as num?)?.toDouble();
  final color = parseHexColor(node.props['color'] as String?);
  final alignment = parseAlignment(node.props['alignment'] as String?);
  final decoration = node.props['decoration'] != null
      ? parseBoxDecoration(node.props['decoration'] as Map<String, dynamic>?)
      : null;

  return AnimatedContainer(
    duration: duration,
    curve: curve,
    padding: padding,
    width: width,
    height: height,
    color: decoration == null ? color : null,
    decoration: decoration,
    alignment: alignment,
    child: buildSingleChild(node, buildChild),
  );
}

Widget buildServerAnimatedOpacity(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final opacity = (node.props['opacity'] as num?)?.toDouble() ?? 1.0;
  final duration = parseDuration(node.props['duration']);
  final curve = parseCurve(node.props['curve'] as String?);

  return AnimatedOpacity(
    opacity: opacity.clamp(0.0, 1.0),
    duration: duration,
    curve: curve,
    child: buildSingleChild(node, buildChild),
  );
}

Widget buildServerAnimatedCrossFade(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final showFirst = node.props['showFirst'] as bool? ?? true;
  final duration = parseDuration(node.props['duration']);

  final first = node.children.isNotEmpty ? buildChild(node.children[0]) : const SizedBox.shrink();
  final second =
      node.children.length > 1 ? buildChild(node.children[1]) : const SizedBox.shrink();

  return AnimatedCrossFade(
    firstChild: first,
    secondChild: second,
    crossFadeState: showFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    duration: duration,
  );
}

Widget buildServerAnimatedSwitcher(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final duration = parseDuration(node.props['duration']);

  return AnimatedSwitcher(
    duration: duration,
    child: buildSingleChild(node, buildChild),
  );
}

Widget buildServerAnimatedAlign(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final alignment = parseAlignment(node.props['alignment'] as String?);
  final duration = parseDuration(node.props['duration']);
  final curve = parseCurve(node.props['curve'] as String?);

  return AnimatedAlign(
    alignment: alignment,
    duration: duration,
    curve: curve,
    child: buildSingleChild(node, buildChild),
  );
}

Widget buildServerAnimatedPadding(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final padding = parsePadding(node.props['padding']) ?? EdgeInsets.zero;
  final duration = parseDuration(node.props['duration']);
  final curve = parseCurve(node.props['curve'] as String?);

  return AnimatedPadding(
    padding: padding,
    duration: duration,
    curve: curve,
    child: buildSingleChild(node, buildChild),
  );
}

Widget buildServerAnimatedPositioned(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final top = (node.props['top'] as num?)?.toDouble();
  final bottom = (node.props['bottom'] as num?)?.toDouble();
  final left = (node.props['left'] as num?)?.toDouble();
  final right = (node.props['right'] as num?)?.toDouble();
  final width = (node.props['width'] as num?)?.toDouble();
  final height = (node.props['height'] as num?)?.toDouble();
  final duration = parseDuration(node.props['duration']);
  final curve = parseCurve(node.props['curve'] as String?);

  return AnimatedPositioned(
    top: top,
    bottom: bottom,
    left: left,
    right: right,
    width: width,
    height: height,
    duration: duration,
    curve: curve,
    child: buildSingleChild(node, buildChild),
  );
}

Widget buildServerAnimatedSize(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final duration = parseDuration(node.props['duration']);
  final curve = parseCurve(node.props['curve'] as String?);
  final alignment = parseAlignment(node.props['alignment'] as String?);

  return AnimatedSize(
    duration: duration,
    curve: curve,
    alignment: alignment,
    child: buildSingleChild(node, buildChild),
  );
}

Widget buildServerFadeTransition(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final opacity = (node.props['opacity'] as num?)?.toDouble() ?? 1.0;
  final duration = parseDuration(node.props['duration']);
  final curve = parseCurve(node.props['curve'] as String?);

  return TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: opacity.clamp(0.0, 1.0)),
    duration: duration,
    curve: curve,
    builder: (context, value, child) => Opacity(opacity: value, child: child),
    child: buildSingleChild(node, buildChild),
  );
}

import 'package:flutter/material.dart';

import '../../core/models/screen_contract.dart';
import '../../core/utils/color_utils.dart';
import '../../core/utils/parsing_utils.dart';
import 'server_icon.dart' show resolveIcon;

Widget buildServerPlaceholder(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final color = parseHexColor(node.props['color'] as String?) ?? const Color(0xFF455A64);
  final strokeWidth = (node.props['strokeWidth'] as num?)?.toDouble() ?? 2;
  final width = (node.props['width'] as num?)?.toDouble() ?? 400;
  final height = (node.props['height'] as num?)?.toDouble() ?? 400;

  return Semantics(
    label: 'Placeholder',
    child: SizedBox(
      width: width,
      height: height,
      child: Placeholder(color: color, strokeWidth: strokeWidth),
    ),
  );
}

Widget buildServerCircleAvatar(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final radius = (node.props['radius'] as num?)?.toDouble();
  final bgColor = parseHexColor(node.props['backgroundColor'] as String?);
  final fgColor = parseHexColor(node.props['foregroundColor'] as String?);
  final imageUrl = node.props['imageUrl'] as String?;
  final label = node.props['label'] as String?;
  final icon = node.props['icon'] as String?;

  return Semantics(
    label: label ?? 'Avatar',
    image: imageUrl != null,
    child: CircleAvatar(
      radius: radius,
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
      child: imageUrl == null
          ? (label != null
              ? Text(label)
              : icon != null
                  ? Icon(resolveIcon(icon))
                  : null)
          : null,
    ),
  );
}

Widget buildServerCard(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final elevation = (node.props['elevation'] as num?)?.toDouble() ?? 1;
  final color = parseHexColor(node.props['color'] as String?);
  final shadowColor = parseHexColor(node.props['shadowColor'] as String?);
  final surfaceTintColor = parseHexColor(node.props['surfaceTintColor'] as String?);
  final borderRadius = parseBorderRadius(node.props['borderRadius']) ?? BorderRadius.circular(12);
  final padding = parsePadding(node.props['padding']);
  final margin = parsePadding(node.props['margin']);

  return Card(
    elevation: elevation,
    color: color,
    shadowColor: shadowColor,
    surfaceTintColor: surfaceTintColor,
    margin: margin,
    shape: RoundedRectangleBorder(borderRadius: borderRadius),
    child: Padding(
      padding: padding ?? EdgeInsets.zero,
      child: node.children.isNotEmpty
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: buildAllChildren(node, buildChild),
            )
          : const SizedBox.shrink(),
    ),
  );
}

Widget buildServerVerticalDivider(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final width = (node.props['width'] as num?)?.toDouble();
  final thickness = (node.props['thickness'] as num?)?.toDouble();
  final color = parseHexColor(node.props['color'] as String?);
  final indent = (node.props['indent'] as num?)?.toDouble();
  final endIndent = (node.props['endIndent'] as num?)?.toDouble();

  return VerticalDivider(
    width: width,
    thickness: thickness,
    color: color,
    indent: indent,
    endIndent: endIndent,
  );
}

Widget buildServerPopupMenuButton(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final icon = node.props['icon'] as String?;
  final tooltip = node.props['tooltip'] as String?;
  final items = (node.props['items'] as List<dynamic>?)?.map((item) {
        final m = item as Map<String, dynamic>;
        return PopupMenuItem<String>(
          value: m['value'] as String? ?? '',
          child: Text(m['label'] as String? ?? ''),
        );
      }).toList() ??
      [];

  return PopupMenuButton<String>(
    icon: icon != null ? Icon(resolveIcon(icon)) : null,
    tooltip: tooltip,
    itemBuilder: (_) => items,
    onSelected: (_) {},
  );
}

Widget buildServerSearchBar(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final hintText = node.props['hintText'] as String? ?? 'Search...';
  final padding = parsePadding(node.props['padding']);
  final elevation = (node.props['elevation'] as num?)?.toDouble();
  final leadingIcon = node.props['leadingIcon'] as String?;

  return SearchBar(
    hintText: hintText,
    padding: padding != null ? WidgetStatePropertyAll(padding) : null,
    elevation: elevation != null ? WidgetStatePropertyAll(elevation) : null,
    leading: leadingIcon != null ? Icon(resolveIcon(leadingIcon)) : const Icon(Icons.search),
  );
}

Widget buildServerLinearProgressIndicator(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final value = (node.props['value'] as num?)?.toDouble();
  final color = parseHexColor(node.props['color'] as String?);
  final bgColor = parseHexColor(node.props['backgroundColor'] as String?);
  final minHeight = (node.props['minHeight'] as num?)?.toDouble();
  final borderRadius = parseBorderRadius(node.props['borderRadius']);

  return LinearProgressIndicator(
    value: value,
    color: color,
    backgroundColor: bgColor,
    minHeight: minHeight,
    borderRadius: borderRadius,
  );
}

Widget buildServerCircularProgressIndicator(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final value = (node.props['value'] as num?)?.toDouble();
  final color = parseHexColor(node.props['color'] as String?);
  final bgColor = parseHexColor(node.props['backgroundColor'] as String?);
  final strokeWidth = (node.props['strokeWidth'] as num?)?.toDouble() ?? 4;

  return CircularProgressIndicator(
    value: value,
    color: color,
    backgroundColor: bgColor,
    strokeWidth: strokeWidth,
  );
}

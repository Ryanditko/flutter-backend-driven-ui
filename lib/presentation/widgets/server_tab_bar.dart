import 'package:flutter/material.dart';

import '../../core/models/screen_contract.dart';
import '../../core/utils/color_utils.dart';

/// A server-driven tab bar with child content per tab.
///
/// ```json
/// {
///   "type": "tabBar",
///   "props": {
///     "tabs": ["Overview", "Details", "Reviews"],
///     "indicatorColor": "#820AD1"
///   },
///   "children": [ ... one per tab ... ]
/// }
/// ```
class ServerTabBar extends StatefulWidget {
  final ComponentNode node;
  final Widget Function(ComponentNode) buildChild;

  const ServerTabBar({
    super.key,
    required this.node,
    required this.buildChild,
  });

  @override
  State<ServerTabBar> createState() => _ServerTabBarState();
}

class _ServerTabBarState extends State<ServerTabBar>
    with TickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    final tabLabels = _tabLabels;
    _controller = TabController(length: tabLabels.length, vsync: this);
  }

  List<String> get _tabLabels =>
      (widget.node.props['tabs'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
      [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabLabels = _tabLabels;
    final indicatorColor =
        parseHexColor(widget.node.props['indicatorColor'] as String?);
    final labelColor =
        parseHexColor(widget.node.props['labelColor'] as String?);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TabBar(
          controller: _controller,
          indicatorColor: indicatorColor,
          labelColor: labelColor,
          tabs: tabLabels.map((t) => Tab(text: t)).toList(),
          onTap: (_) => setState(() {}),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          child: IndexedStack(
            index: _controller.index,
            children: [
              for (var i = 0; i < widget.node.children.length; i++)
                widget.buildChild(widget.node.children[i]),
            ],
          ),
        ),
      ],
    );
  }
}

Widget buildServerTabBar(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  return ServerTabBar(node: node, buildChild: buildChild);
}

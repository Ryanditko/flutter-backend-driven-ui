import 'package:flutter/material.dart';

import '../../core/models/screen_contract.dart';

/// A server-driven horizontal carousel (PageView) with dot indicators.
///
/// ```json
/// {
///   "type": "carousel",
///   "props": { "height": 200, "autoPlay": true },
///   "children": [ ... slides ... ]
/// }
/// ```
class ServerCarousel extends StatefulWidget {
  final ComponentNode node;
  final Widget Function(ComponentNode) buildChild;

  const ServerCarousel({
    super.key,
    required this.node,
    required this.buildChild,
  });

  @override
  State<ServerCarousel> createState() => _ServerCarouselState();
}

class _ServerCarouselState extends State<ServerCarousel> {
  late final PageController _controller;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    final viewportFraction =
        (widget.node.props['viewportFraction'] as num?)?.toDouble() ?? 1.0;
    _controller = PageController(viewportFraction: viewportFraction);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height =
        (widget.node.props['height'] as num?)?.toDouble() ?? 200.0;
    final count = widget.node.children.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: height,
          child: PageView.builder(
            controller: _controller,
            itemCount: count,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: widget.buildChild(widget.node.children[i]),
            ),
          ),
        ),
        if (count > 1) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(count, (i) {
              final active = i == _current;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}

Widget buildServerCarousel(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  return ServerCarousel(node: node, buildChild: buildChild);
}

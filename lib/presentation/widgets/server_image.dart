import 'package:flutter/material.dart';

import '../../core/models/screen_contract.dart';

Widget buildServerImage(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final url = node.props['url'] as String? ?? '';
  final width = (node.props['width'] as num?)?.toDouble();
  final height = (node.props['height'] as num?)?.toDouble();
  final borderRadius = (node.props['borderRadius'] as num?)?.toDouble() ?? 0;
  final fit = _parseBoxFit(node.props['fit'] as String?);

  Widget image = Image.network(
    url,
    width: width,
    height: height,
    fit: fit,
    loadingBuilder: (context, child, progress) {
      if (progress == null) return child;
      return SizedBox(
        width: width,
        height: height,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    },
    errorBuilder: (context, error, stack) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey.shade200,
        child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
      );
    },
  );

  if (borderRadius > 0) {
    image = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: image,
    );
  }

  return image;
}

BoxFit _parseBoxFit(String? value) {
  return switch (value) {
    'cover' => BoxFit.cover,
    'contain' => BoxFit.contain,
    'fill' => BoxFit.fill,
    'fitWidth' => BoxFit.fitWidth,
    'fitHeight' => BoxFit.fitHeight,
    'none' => BoxFit.none,
    _ => BoxFit.cover,
  };
}

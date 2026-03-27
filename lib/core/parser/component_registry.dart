import 'package:flutter/material.dart';

import '../models/screen_contract.dart';

/// Signature for a function that builds a widget from a [ComponentNode].
///
/// The [buildChildren] callback lets layout builders recursively
/// render their child nodes.
typedef ComponentBuilder = Widget Function(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChildren,
);

/// Central registry mapping component type strings to builder functions.
///
/// Adding a new component is a single `register()` call — the parser
/// doesn't need to change.
class ComponentRegistry {
  final Map<String, ComponentBuilder> _builders = {};

  void register(String type, ComponentBuilder builder) {
    _builders[type] = builder;
  }

  ComponentBuilder? getBuilder(String type) => _builders[type];

  bool hasBuilder(String type) => _builders.containsKey(type);
}

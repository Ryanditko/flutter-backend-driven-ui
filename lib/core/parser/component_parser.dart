import 'package:flutter/material.dart';

import '../expression/expression_context.dart';
import '../expression/template_engine.dart';
import '../models/screen_contract.dart';
import '../utils/color_utils.dart';
import 'component_registry.dart';
import '../../presentation/widgets/server_badge.dart';
import '../../presentation/widgets/server_button.dart';
import '../../presentation/widgets/server_carousel.dart';
import '../../presentation/widgets/server_checkbox.dart';
import '../../presentation/widgets/server_chip.dart';
import '../../presentation/widgets/server_divider.dart';
import '../../presentation/widgets/server_dropdown.dart';
import '../../presentation/widgets/server_expanded.dart';
import '../../presentation/widgets/server_icon.dart';
import '../../presentation/widgets/server_image.dart';
import '../../presentation/widgets/server_input.dart';
import '../../presentation/widgets/server_progress.dart';
import '../../presentation/widgets/server_responsive.dart';
import '../../presentation/widgets/server_switch.dart';
import '../../presentation/widgets/server_tab_bar.dart';
import '../../presentation/widgets/server_text.dart';
import '../../presentation/widgets/unknown_component.dart';

/// Callback signature for input field changes.
typedef InputChangeCallback = void Function(String id, String value);

/// Recursively converts a [ComponentNode] tree into a Flutter widget tree.
///
/// Layout nodes (column, row, container, listView, card, stack, wrap) process
/// their children; leaf nodes render directly.
///
/// When an [ExpressionContext] is provided, template strings in `props` are
/// interpolated and the `visible` property on each node is evaluated.
class ComponentParser {
  final ComponentRegistry _registry;
  final InputChangeCallback? onInputChanged;
  final ExpressionContext expressionContext;

  ComponentParser({
    this.onInputChanged,
    ExpressionContext? expressionContext,
  })  : expressionContext = expressionContext ?? const ExpressionContext(),
        _registry = ComponentRegistry() {
    _registerDefaults();
  }

  void _registerDefaults() {
    // Layout
    _registry.register('column', _buildColumn);
    _registry.register('row', _buildRow);
    _registry.register('container', _buildContainer);
    _registry.register('card', _buildCard);
    _registry.register('listView', _buildListView);
    _registry.register('stack', _buildStack);
    _registry.register('positioned', _buildPositioned);
    _registry.register('wrap', _buildWrap);
    _registry.register('spacer', _buildSpacer);
    _registry.register('responsive', buildServerResponsive);
    _registry.register('expanded', buildServerExpanded);
    _registry.register('flexible', buildServerFlexible);

    // Leaf
    _registry.register('text', buildServerText);
    _registry.register('button', buildServerButton);
    _registry.register('image', buildServerImage);
    _registry.register('input', _buildInput);
    _registry.register('divider', buildServerDivider);
    _registry.register('icon', buildServerIcon);
    _registry.register('chip', buildServerChip);
    _registry.register('progress', buildServerProgress);
    _registry.register('badge', buildServerBadge);

    // Interactive / composite
    _registry.register('switch', _buildSwitch);
    _registry.register('checkbox', _buildCheckbox);
    _registry.register('dropdown', _buildDropdown);
    _registry.register('tabBar', buildServerTabBar);
    _registry.register('carousel', buildServerCarousel);
  }

  Widget parse(ComponentNode node, BuildContext context) {
    if (!TemplateEngine.evaluateVisibility(node.visible, expressionContext)) {
      return const SizedBox.shrink();
    }

    final resolved = _interpolateProps(node);

    final builder = _registry.getBuilder(resolved.type);
    if (builder != null) {
      return builder(resolved, context, (child) => parse(child, context));
    }
    return buildUnknownComponent(resolved, context, (child) => parse(child, context));
  }

  /// Walks through [props] and interpolates any string value that
  /// contains `{{…}}` placeholders.
  ComponentNode _interpolateProps(ComponentNode node) {
    if (expressionContext.isEmpty) return node;

    final newProps = _deepInterpolate(node.props);
    if (identical(newProps, node.props)) return node;

    return ComponentNode(
      type: node.type,
      id: node.id,
      props: newProps,
      children: node.children,
      action: node.action,
      visible: node.visible,
    );
  }

  Map<String, dynamic> _deepInterpolate(Map<String, dynamic> map) {
    var changed = false;
    final result = <String, dynamic>{};

    for (final entry in map.entries) {
      final value = entry.value;
      if (value is String && value.contains('{{')) {
        final interpolated = TemplateEngine.interpolate(value, expressionContext);
        result[entry.key] = interpolated;
        if (interpolated != value) changed = true;
      } else if (value is Map<String, dynamic>) {
        final nested = _deepInterpolate(value);
        result[entry.key] = nested;
        if (!identical(nested, value)) changed = true;
      } else {
        result[entry.key] = value;
      }
    }

    return changed ? result : map;
  }

  // -------------------------------------------------------------------------
  // Layout builders
  // -------------------------------------------------------------------------

  Widget _buildColumn(
    ComponentNode node,
    BuildContext context,
    Widget Function(ComponentNode) buildChild,
  ) {
    final mainAxis = _parseMainAxisAlignment(node.props['mainAxisAlignment'] as String?);
    final crossAxis = _parseCrossAxisAlignment(node.props['crossAxisAlignment'] as String?);
    final padding = _parsePadding(node.props['padding']);

    Widget column = Column(
      mainAxisAlignment: mainAxis,
      crossAxisAlignment: crossAxis,
      mainAxisSize: MainAxisSize.min,
      children: node.children.map(buildChild).toList(),
    );

    if (padding != null) {
      column = Padding(padding: padding, child: column);
    }
    return column;
  }

  Widget _buildRow(
    ComponentNode node,
    BuildContext context,
    Widget Function(ComponentNode) buildChild,
  ) {
    final mainAxis = _parseMainAxisAlignment(node.props['mainAxisAlignment'] as String?);
    final crossAxis = _parseCrossAxisAlignment(node.props['crossAxisAlignment'] as String?);
    final padding = _parsePadding(node.props['padding']);

    Widget row = Row(
      mainAxisAlignment: mainAxis,
      crossAxisAlignment: crossAxis,
      children: node.children.map(buildChild).toList(),
    );

    if (padding != null) {
      row = Padding(padding: padding, child: row);
    }
    return row;
  }

  Widget _buildContainer(
    ComponentNode node,
    BuildContext context,
    Widget Function(ComponentNode) buildChild,
  ) {
    final padding = _parsePadding(node.props['padding']);
    final bgColor = parseHexColor(node.props['backgroundColor'] as String?);

    return Container(
      padding: padding,
      color: bgColor,
      child: node.children.isNotEmpty
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: node.children.map(buildChild).toList(),
            )
          : null,
    );
  }

  Widget _buildCard(
    ComponentNode node,
    BuildContext context,
    Widget Function(ComponentNode) buildChild,
  ) {
    final padding = _parsePadding(node.props['padding']);
    final elevation = (node.props['elevation'] as num?)?.toDouble() ?? 1;

    return Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: node.children.isNotEmpty
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: node.children.map(buildChild).toList(),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildListView(
    ComponentNode node,
    BuildContext context,
    Widget Function(ComponentNode) buildChild,
  ) {
    final padding = _parsePadding(node.props['padding']);

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: padding,
      children: node.children.map(buildChild).toList(),
    );
  }

  Widget _buildStack(
    ComponentNode node,
    BuildContext context,
    Widget Function(ComponentNode) buildChild,
  ) {
    final alignment = _parseAlignment(node.props['alignment'] as String?);
    final fit = (node.props['fit'] as String?) == 'expand'
        ? StackFit.expand
        : StackFit.loose;

    return Stack(
      alignment: alignment,
      fit: fit,
      children: node.children.map(buildChild).toList(),
    );
  }

  Widget _buildPositioned(
    ComponentNode node,
    BuildContext context,
    Widget Function(ComponentNode) buildChild,
  ) {
    final top = (node.props['top'] as num?)?.toDouble();
    final bottom = (node.props['bottom'] as num?)?.toDouble();
    final left = (node.props['left'] as num?)?.toDouble();
    final right = (node.props['right'] as num?)?.toDouble();

    final child = node.children.isNotEmpty
        ? buildChild(node.children.first)
        : const SizedBox.shrink();

    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: child,
    );
  }

  Widget _buildWrap(
    ComponentNode node,
    BuildContext context,
    Widget Function(ComponentNode) buildChild,
  ) {
    final spacing = (node.props['spacing'] as num?)?.toDouble() ?? 8;
    final runSpacing = (node.props['runSpacing'] as num?)?.toDouble() ?? 8;
    final alignment = _parseWrapAlignment(node.props['alignment'] as String?);
    final padding = _parsePadding(node.props['padding']);

    Widget wrap = Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      alignment: alignment,
      children: node.children.map(buildChild).toList(),
    );

    if (padding != null) {
      wrap = Padding(padding: padding, child: wrap);
    }
    return wrap;
  }

  Widget _buildSpacer(
    ComponentNode node,
    BuildContext context,
    Widget Function(ComponentNode) buildChild,
  ) {
    final height = (node.props['height'] as num?)?.toDouble() ?? 16;
    final width = (node.props['width'] as num?)?.toDouble();

    return SizedBox(height: height, width: width);
  }

  Widget _buildInput(
    ComponentNode node,
    BuildContext context,
    Widget Function(ComponentNode) buildChild,
  ) {
    return buildServerInput(node, context, buildChild, onChanged: onInputChanged);
  }

  Widget _buildSwitch(
    ComponentNode node,
    BuildContext context,
    Widget Function(ComponentNode) buildChild,
  ) {
    return buildServerSwitch(node, context, buildChild, onChanged: onInputChanged);
  }

  Widget _buildCheckbox(
    ComponentNode node,
    BuildContext context,
    Widget Function(ComponentNode) buildChild,
  ) {
    return buildServerCheckbox(node, context, buildChild, onChanged: onInputChanged);
  }

  Widget _buildDropdown(
    ComponentNode node,
    BuildContext context,
    Widget Function(ComponentNode) buildChild,
  ) {
    return buildServerDropdown(node, context, buildChild, onChanged: onInputChanged);
  }

  // -------------------------------------------------------------------------
  // Parsing helpers
  // -------------------------------------------------------------------------

  static MainAxisAlignment _parseMainAxisAlignment(String? value) {
    return switch (value) {
      'center' => MainAxisAlignment.center,
      'start' => MainAxisAlignment.start,
      'end' => MainAxisAlignment.end,
      'spaceBetween' => MainAxisAlignment.spaceBetween,
      'spaceAround' => MainAxisAlignment.spaceAround,
      'spaceEvenly' => MainAxisAlignment.spaceEvenly,
      _ => MainAxisAlignment.start,
    };
  }

  static CrossAxisAlignment _parseCrossAxisAlignment(String? value) {
    return switch (value) {
      'center' => CrossAxisAlignment.center,
      'start' => CrossAxisAlignment.start,
      'end' => CrossAxisAlignment.end,
      'stretch' => CrossAxisAlignment.stretch,
      _ => CrossAxisAlignment.start,
    };
  }

  static EdgeInsets? _parsePadding(dynamic raw) {
    if (raw == null) return null;
    if (raw is Map<String, dynamic>) {
      final model = EdgeInsetsModel.fromJson(raw);
      return EdgeInsets.fromLTRB(model.left, model.top, model.right, model.bottom);
    }
    if (raw is num) {
      return EdgeInsets.all(raw.toDouble());
    }
    return null;
  }

  static AlignmentGeometry _parseAlignment(String? value) {
    return switch (value) {
      'topLeft' => Alignment.topLeft,
      'topCenter' => Alignment.topCenter,
      'topRight' => Alignment.topRight,
      'centerLeft' => Alignment.centerLeft,
      'center' => Alignment.center,
      'centerRight' => Alignment.centerRight,
      'bottomLeft' => Alignment.bottomLeft,
      'bottomCenter' => Alignment.bottomCenter,
      'bottomRight' => Alignment.bottomRight,
      _ => AlignmentDirectional.topStart,
    };
  }

  static WrapAlignment _parseWrapAlignment(String? value) {
    return switch (value) {
      'start' => WrapAlignment.start,
      'center' => WrapAlignment.center,
      'end' => WrapAlignment.end,
      'spaceBetween' => WrapAlignment.spaceBetween,
      'spaceAround' => WrapAlignment.spaceAround,
      'spaceEvenly' => WrapAlignment.spaceEvenly,
      _ => WrapAlignment.start,
    };
  }
}

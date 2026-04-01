import 'package:flutter/material.dart';

import '../../core/models/screen_contract.dart';
import '../../core/utils/color_utils.dart';

Widget buildServerSlider(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild, {
  void Function(String id, String value)? onChanged,
}) {
  final value = (node.props['value'] as num?)?.toDouble() ?? 0;
  final min = (node.props['min'] as num?)?.toDouble() ?? 0;
  final max = (node.props['max'] as num?)?.toDouble() ?? 1;
  final divisions = (node.props['divisions'] as num?)?.toInt();
  final label = node.props['label'] as String?;
  final activeColor = parseHexColor(node.props['activeColor'] as String?);
  final inactiveColor = parseHexColor(node.props['inactiveColor'] as String?);

  return _SliderWidget(
    nodeId: node.id,
    initialValue: value,
    min: min,
    max: max,
    divisions: divisions,
    label: label,
    activeColor: activeColor,
    inactiveColor: inactiveColor,
    onChanged: onChanged,
  );
}

class _SliderWidget extends StatefulWidget {
  final String? nodeId;
  final double initialValue;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final Color? activeColor;
  final Color? inactiveColor;
  final void Function(String id, String value)? onChanged;

  const _SliderWidget({
    required this.nodeId,
    required this.initialValue,
    required this.min,
    required this.max,
    this.divisions,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.onChanged,
  });

  @override
  State<_SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<_SliderWidget> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue.clamp(widget.min, widget.max);
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _value,
      min: widget.min,
      max: widget.max,
      divisions: widget.divisions,
      label: widget.label ?? _value.toStringAsFixed(1),
      activeColor: widget.activeColor,
      inactiveColor: widget.inactiveColor,
      onChanged: (v) {
        setState(() => _value = v);
        if (widget.nodeId != null) {
          widget.onChanged?.call(widget.nodeId!, v.toString());
        }
      },
    );
  }
}

Widget buildServerRangeSlider(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild, {
  void Function(String id, String value)? onChanged,
}) {
  final start = (node.props['start'] as num?)?.toDouble() ?? 0;
  final end = (node.props['end'] as num?)?.toDouble() ?? 1;
  final min = (node.props['min'] as num?)?.toDouble() ?? 0;
  final max = (node.props['max'] as num?)?.toDouble() ?? 1;
  final divisions = (node.props['divisions'] as num?)?.toInt();
  final activeColor = parseHexColor(node.props['activeColor'] as String?);
  final inactiveColor = parseHexColor(node.props['inactiveColor'] as String?);

  return _RangeSliderWidget(
    nodeId: node.id,
    initialStart: start,
    initialEnd: end,
    min: min,
    max: max,
    divisions: divisions,
    activeColor: activeColor,
    inactiveColor: inactiveColor,
    onChanged: onChanged,
  );
}

class _RangeSliderWidget extends StatefulWidget {
  final String? nodeId;
  final double initialStart;
  final double initialEnd;
  final double min;
  final double max;
  final int? divisions;
  final Color? activeColor;
  final Color? inactiveColor;
  final void Function(String id, String value)? onChanged;

  const _RangeSliderWidget({
    required this.nodeId,
    required this.initialStart,
    required this.initialEnd,
    required this.min,
    required this.max,
    this.divisions,
    this.activeColor,
    this.inactiveColor,
    this.onChanged,
  });

  @override
  State<_RangeSliderWidget> createState() => _RangeSliderWidgetState();
}

class _RangeSliderWidgetState extends State<_RangeSliderWidget> {
  late RangeValues _values;

  @override
  void initState() {
    super.initState();
    _values = RangeValues(widget.initialStart, widget.initialEnd);
  }

  @override
  Widget build(BuildContext context) {
    return RangeSlider(
      values: _values,
      min: widget.min,
      max: widget.max,
      divisions: widget.divisions,
      activeColor: widget.activeColor,
      inactiveColor: widget.inactiveColor,
      onChanged: (v) {
        setState(() => _values = v);
        if (widget.nodeId != null) {
          widget.onChanged?.call(widget.nodeId!, '${v.start},${v.end}');
        }
      },
    );
  }
}

Widget buildServerRadio(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild, {
  void Function(String id, String value)? onChanged,
}) {
  final value = node.props['value'] as String? ?? '';
  final groupValue = node.props['groupValue'] as String? ?? '';

  return _RadioWidget(
    nodeId: node.id,
    value: value,
    groupValue: groupValue,
    onChanged: onChanged,
  );
}

class _RadioWidget extends StatefulWidget {
  final String? nodeId;
  final String value;
  final String groupValue;
  final void Function(String id, String value)? onChanged;

  const _RadioWidget({
    required this.nodeId,
    required this.value,
    required this.groupValue,
    this.onChanged,
  });

  @override
  State<_RadioWidget> createState() => _RadioWidgetState();
}

class _RadioWidgetState extends State<_RadioWidget> {
  late String _groupValue;

  @override
  void initState() {
    super.initState();
    _groupValue = widget.groupValue;
  }

  @override
  Widget build(BuildContext context) {
    return RadioGroup<String>(
      groupValue: _groupValue,
      onChanged: (v) {
        setState(() => _groupValue = v ?? '');
        if (widget.nodeId != null) {
          widget.onChanged?.call(widget.nodeId!, v ?? '');
        }
      },
      child: Radio<String>(value: widget.value),
    );
  }
}

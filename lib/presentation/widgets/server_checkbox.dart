import 'package:flutter/material.dart';

import '../../core/models/screen_contract.dart';
import '../../core/parser/component_parser.dart';

Widget buildServerCheckbox(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild, {
  InputChangeCallback? onChanged,
}) {
  return _ServerCheckbox(
    id: node.id ?? '',
    label: node.props['label'] as String? ?? '',
    subtitle: node.props['subtitle'] as String?,
    initialValue: node.props['value'] as bool? ?? false,
    onChanged: onChanged,
  );
}

class _ServerCheckbox extends StatefulWidget {
  final String id;
  final String label;
  final String? subtitle;
  final bool initialValue;
  final InputChangeCallback? onChanged;

  const _ServerCheckbox({
    required this.id,
    required this.label,
    this.subtitle,
    required this.initialValue,
    this.onChanged,
  });

  @override
  State<_ServerCheckbox> createState() => _ServerCheckboxState();
}

class _ServerCheckboxState extends State<_ServerCheckbox> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.label),
      subtitle: widget.subtitle != null ? Text(widget.subtitle!) : null,
      value: _value,
      onChanged: (v) {
        setState(() => _value = v ?? false);
        widget.onChanged?.call(widget.id, (v ?? false).toString());
      },
    );
  }
}

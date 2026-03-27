import 'package:flutter/material.dart';

import '../../core/models/screen_contract.dart';

typedef InputChangeCallback = void Function(String id, String value);

Widget buildServerInput(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild, {
  InputChangeCallback? onChanged,
}) {
  final label = node.props['label'] as String? ?? '';
  final hint = node.props['hint'] as String? ?? '';
  final maxLines = (node.props['maxLines'] as num?)?.toInt() ?? 1;
  final keyboardType = _parseKeyboardType(node.props['keyboardType'] as String?);

  return _ServerInputField(
    id: node.id ?? '',
    label: label,
    hint: hint,
    maxLines: maxLines,
    keyboardType: keyboardType,
    onChanged: onChanged,
  );
}

class _ServerInputField extends StatelessWidget {
  final String id;
  final String label;
  final String hint;
  final int maxLines;
  final TextInputType keyboardType;
  final InputChangeCallback? onChanged;

  const _ServerInputField({
    required this.id,
    required this.label,
    required this.hint,
    required this.maxLines,
    required this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
      onChanged: (value) => onChanged?.call(id, value),
    );
  }
}

TextInputType _parseKeyboardType(String? value) {
  return switch (value) {
    'emailAddress' => TextInputType.emailAddress,
    'number' => TextInputType.number,
    'phone' => TextInputType.phone,
    'multiline' => TextInputType.multiline,
    'url' => TextInputType.url,
    _ => TextInputType.text,
  };
}

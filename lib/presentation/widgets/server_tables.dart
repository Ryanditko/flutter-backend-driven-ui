import 'package:flutter/material.dart';

import '../../core/models/screen_contract.dart';
import '../../core/utils/color_utils.dart';
import '../../core/utils/parsing_utils.dart';

Widget buildServerTable(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final defaultVerticalAlignment =
      parseTableCellVerticalAlignment(node.props['defaultVerticalAlignment'] as String?);
  final border = _parseTableBorder(node.props['border'] as Map<String, dynamic>?);

  final rows = node.children.map((rowNode) {
    final cells = rowNode.children.map((cellNode) {
      return TableCell(child: buildChild(cellNode));
    }).toList();
    return TableRow(children: cells);
  }).toList();

  return Table(
    defaultVerticalAlignment: defaultVerticalAlignment,
    border: border,
    children: rows,
  );
}

Widget buildServerDataTable(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final sortColumnIndex = (node.props['sortColumnIndex'] as num?)?.toInt();
  final sortAscending = node.props['sortAscending'] as bool? ?? true;
  final showCheckboxColumn = node.props['showCheckboxColumn'] as bool? ?? false;
  final headingRowColor = parseHexColor(node.props['headingRowColor'] as String?);
  final columnSpacing = (node.props['columnSpacing'] as num?)?.toDouble();
  final horizontalMargin = (node.props['horizontalMargin'] as num?)?.toDouble();

  final columnDefs = (node.props['columns'] as List<dynamic>?)?.map((c) {
        final col = c as Map<String, dynamic>;
        return DataColumn(
          label: Text(
            col['label'] as String? ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          numeric: col['numeric'] as bool? ?? false,
          tooltip: col['tooltip'] as String?,
        );
      }).toList() ??
      [];

  final rowDefs = (node.props['rows'] as List<dynamic>?)?.map((r) {
        final row = r as Map<String, dynamic>;
        final cells = (row['cells'] as List<dynamic>?)?.map((cell) {
              final cellMap = cell as Map<String, dynamic>;
              return DataCell(
                Text(cellMap['value']?.toString() ?? ''),
              );
            }).toList() ??
            [];
        return DataRow(
          cells: cells,
          selected: row['selected'] as bool? ?? false,
        );
      }).toList() ??
      [];

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: DataTable(
      columns: columnDefs,
      rows: rowDefs,
      sortColumnIndex: sortColumnIndex,
      sortAscending: sortAscending,
      showCheckboxColumn: showCheckboxColumn,
      headingRowColor: headingRowColor != null ? WidgetStatePropertyAll(headingRowColor) : null,
      columnSpacing: columnSpacing,
      horizontalMargin: horizontalMargin,
    ),
  );
}

Widget buildServerTableRow(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  return Row(
    children: buildAllChildren(node, buildChild),
  );
}

Widget buildServerTableCell(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  final padding = parsePadding(node.props['padding']);

  final child = buildSingleChild(node, buildChild);
  return padding != null ? Padding(padding: padding, child: child) : child;
}

TableBorder? _parseTableBorder(Map<String, dynamic>? raw) {
  if (raw == null) return null;
  final color = parseHexColor(raw['color'] as String?) ?? Colors.grey;
  final width = (raw['width'] as num?)?.toDouble() ?? 1;
  final style = (raw['style'] as String?) == 'none' ? BorderStyle.none : BorderStyle.solid;
  return TableBorder.all(color: color, width: width, style: style);
}

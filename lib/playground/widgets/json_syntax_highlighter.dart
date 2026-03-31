import 'package:flutter/material.dart';

/// VS Code dark-theme inspired colors for JSON syntax highlighting.
abstract final class _JsonColors {
  static const key = Color(0xFF9CDCFE);
  static const stringVal = Color(0xFFCE9178);
  static const number = Color(0xFFB5CEA8);
  static const bool_ = Color(0xFF569CD6);
  static const null_ = Color(0xFF569CD6);
  static const brace = Color(0xFFD4D4D4);
  static const normal = Color(0xFFD4D4D4);
}

/// Tokenises a JSON string and returns a list of coloured [TextSpan]s
/// suitable for a [RichText] / [Text.rich] widget.
///
/// Performance: single-pass regex split, no AST parsing. Handles
/// strings, numbers, booleans, null and structural characters.
class JsonSyntaxHighlighter {
  JsonSyntaxHighlighter._();

  static final _tokenPattern = RegExp(
    r'("(?:[^"\\]|\\.)*")\s*:'    // key followed by colon
    r'|("(?:[^"\\]|\\.)*")'       // string value
    r'|(-?\d+(?:\.\d+)?(?:[eE][+-]?\d+)?)' // number
    r'|\b(true|false)\b'          // boolean
    r'|\b(null)\b'                // null
    r'|([{}[\],:])',              // structural characters
  );

  static List<TextSpan> highlight(String source) {
    final spans = <TextSpan>[];
    var lastEnd = 0;

    for (final match in _tokenPattern.allMatches(source)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(
          text: source.substring(lastEnd, match.start),
          style: const TextStyle(color: _JsonColors.normal),
        ));
      }

      final String text = match[0]!;
      Color color;

      if (match[1] != null) {
        // key: includes the quote-delimited key; colon is part of lookahead
        color = _JsonColors.key;
      } else if (match[2] != null) {
        color = _JsonColors.stringVal;
      } else if (match[3] != null) {
        color = _JsonColors.number;
      } else if (match[4] != null) {
        color = _JsonColors.bool_;
      } else if (match[5] != null) {
        color = _JsonColors.null_;
      } else {
        color = _JsonColors.brace;
      }

      spans.add(TextSpan(
        text: text,
        style: TextStyle(color: color),
      ));

      lastEnd = match.end;
    }

    if (lastEnd < source.length) {
      spans.add(TextSpan(
        text: source.substring(lastEnd),
        style: const TextStyle(color: _JsonColors.normal),
      ));
    }

    return spans;
  }
}

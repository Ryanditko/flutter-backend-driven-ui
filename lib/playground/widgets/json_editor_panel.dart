import 'package:flutter/material.dart';

import 'json_syntax_highlighter.dart';

/// Dark-themed JSON editor with real-time syntax highlighting.
///
/// Uses a transparent [TextField] overlaid on a [CustomPaint] layer that
/// renders the highlighted text. This avoids fighting with
/// [TextEditingController] while keeping standard cursor / selection UX.
class JsonEditorPanel extends StatefulWidget {
  final TextEditingController controller;

  const JsonEditorPanel({super.key, required this.controller});

  @override
  State<JsonEditorPanel> createState() => _JsonEditorPanelState();
}

class _JsonEditorPanelState extends State<JsonEditorPanel> {
  final _scrollController = ScrollController();
  late final _LineNumberNotifier _lineNotifier;

  @override
  void initState() {
    super.initState();
    _lineNotifier = _LineNumberNotifier(widget.controller);
    widget.controller.addListener(_onChanged);
  }

  void _onChanged() => _lineNotifier.refresh();

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    _lineNotifier.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  static const _monoStyle = TextStyle(
    fontFamily: 'monospace',
    fontSize: 13,
    color: Colors.transparent,
    height: 1.6,
  );

  static const _lineNumStyle = TextStyle(
    fontFamily: 'monospace',
    fontSize: 13,
    color: Color(0xFF858585),
    height: 1.6,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1E1E1E),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Line numbers gutter
          ValueListenableBuilder<int>(
            valueListenable: _lineNotifier,
            builder: (_, lineCount, _) {
              return Container(
                width: 48,
                padding: const EdgeInsets.only(top: 16, right: 8),
                alignment: Alignment.topRight,
                child: Text(
                  List.generate(lineCount, (i) => '${i + 1}').join('\n'),
                  style: _lineNumStyle,
                  textAlign: TextAlign.right,
                ),
              );
            },
          ),
          Container(width: 1, color: const Color(0xFF333333)),
          Expanded(
            child: Stack(
              children: [
                // Highlighted layer (behind)
                Positioned.fill(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    child: ValueListenableBuilder<int>(
                      valueListenable: _lineNotifier,
                      builder: (_, _, _) {
                        return Text.rich(
                          TextSpan(
                            children: JsonSyntaxHighlighter.highlight(
                              widget.controller.text,
                            ),
                          ),
                          style: _monoStyle.copyWith(
                            color: const Color(0xFFD4D4D4),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Editable layer (transparent text, real cursor)
                Positioned.fill(
                  child: TextField(
                    controller: widget.controller,
                    scrollController: _scrollController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: _monoStyle,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(16),
                      border: InputBorder.none,
                      hintText: 'Paste or type your JSON contract here...',
                      hintStyle: TextStyle(color: Color(0xFF555555)),
                    ),
                    cursorColor: const Color(0xFF569CD6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Lightweight notifier that tracks line count changes to rebuild
/// line-number gutter and syntax-highlight overlay.
class _LineNumberNotifier extends ValueNotifier<int> {
  final TextEditingController _controller;

  _LineNumberNotifier(this._controller)
      : super(_countLines(_controller.text));

  void refresh() {
    value = _countLines(_controller.text);
  }

  static int _countLines(String text) =>
      '\n'.allMatches(text).length + 1;
}

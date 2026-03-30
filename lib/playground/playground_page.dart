import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../core/models/screen_contract.dart';
import '../core/validator/contract_validator.dart';
import 'playground_api_client.dart';
import 'widgets/json_editor_panel.dart';
import 'widgets/preview_panel.dart';
import 'widgets/screen_selector.dart';

/// Main playground page: a responsive split-view with a JSON editor on
/// the left and a live preview on the right. On narrow screens it falls
/// back to a tab layout.
class PlaygroundPage extends StatefulWidget {
  const PlaygroundPage({super.key});

  @override
  State<PlaygroundPage> createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends State<PlaygroundPage> {
  final _editorController = TextEditingController();
  final _client = PlaygroundApiClient();

  final _validator = ContractValidator();

  ScreenContract? _contract;
  String? _error;
  List<String> _warnings = [];
  String? _selectedScreen;
  Timer? _debounce;
  bool _autoRender = true;

  @override
  void initState() {
    super.initState();
    _editorController.addListener(_onEditorChanged);
    _loadTemplate();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _editorController.removeListener(_onEditorChanged);
    _editorController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  void _loadTemplate() {
    _editorController.text = _client.templateJson;
    _selectedScreen = null;
    _parseAndRender();
  }

  void _onEditorChanged() {
    if (!_autoRender) return;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), _parseAndRender);
  }

  void _parseAndRender() {
    final text = _editorController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _contract = null;
        _error = null;
      });
      return;
    }

    try {
      final contract = _client.parseContract(text);
      final issues = _validator.validate(contract);
      setState(() {
        _contract = contract;
        _error = null;
        _warnings = issues;
      });
    } catch (e) {
      setState(() {
        _contract = null;
        _error = e.toString();
        _warnings = [];
      });
    }
  }

  Future<void> _loadScreen(String? screenId) async {
    if (screenId == null) return;
    try {
      final json = await _client.loadScreenJson(screenId);
      _editorController.text = json;
      setState(() => _selectedScreen = screenId);
      _parseAndRender();
    } catch (e) {
      setState(() => _error = 'Failed to load screen: $e');
    }
  }

  void _formatJson() {
    try {
      final decoded = jsonDecode(_editorController.text);
      _editorController.text =
          const JsonEncoder.withIndent('  ').convert(decoded);
    } catch (_) {}
  }

  void _clearEditor() {
    _editorController.clear();
    setState(() {
      _contract = null;
      _error = null;
      _selectedScreen = null;
    });
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playground'),
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Auto-render',
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Switch(
                value: _autoRender,
                onChanged: (v) => setState(() => _autoRender = v),
              ),
            ],
          ),
          if (!_autoRender)
            IconButton(
              onPressed: _parseAndRender,
              icon: const Icon(Icons.play_arrow),
              tooltip: 'Render',
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _buildToolbar(context),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) return _buildSplitView();
                return _buildTabView();
              },
            ),
          ),
          _buildStatusBar(),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          ScreenSelector(
            availableScreens: PlaygroundApiClient.availableScreens,
            selectedScreen: _selectedScreen,
            onScreenSelected: _loadScreen,
            onNewPressed: _loadTemplate,
          ),
          const Spacer(),
          IconButton(
            onPressed: _formatJson,
            icon: const Icon(Icons.format_align_left),
            tooltip: 'Format JSON',
          ),
          IconButton(
            onPressed: _clearEditor,
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear',
          ),
        ],
      ),
    );
  }

  // ---- Split (wide) --------------------------------------------------------

  Widget _buildSplitView() {
    return Row(
      children: [
        Expanded(child: _buildEditorSection()),
        VerticalDivider(width: 1, color: Colors.grey.shade300),
        Expanded(child: _buildPreviewSection()),
      ],
    );
  }

  // ---- Tabs (narrow) -------------------------------------------------------

  Widget _buildTabView() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(tabs: [
            Tab(icon: Icon(Icons.code), text: 'Editor'),
            Tab(icon: Icon(Icons.preview), text: 'Preview'),
          ]),
          Expanded(
            child: TabBarView(children: [
              _buildEditorSection(),
              _buildPreviewSection(),
            ]),
          ),
        ],
      ),
    );
  }

  // ---- Sections ------------------------------------------------------------

  Widget _buildEditorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          color: const Color(0xFF252526),
          child: const Text(
            'JSON Contract',
            style: TextStyle(
              color: Color(0xFF9D9D9D),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: JsonEditorPanel(controller: _editorController)),
      ],
    );
  }

  Widget _buildPreviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          child: Text(
            'Preview',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: PreviewPanel(contract: _contract, error: _error),
        ),
      ],
    );
  }

  // ---- Status bar ----------------------------------------------------------

  Widget _buildStatusBar() {
    final lineCount = '\n'.allMatches(_editorController.text).length + 1;
    final charCount = _editorController.text.length;
    final isValid = _contract != null && _error == null;
    final hasWarnings = _warnings.isNotEmpty;

    final Color barColor;
    if (_error != null) {
      barColor = Colors.red.shade700;
    } else if (hasWarnings) {
      barColor = Colors.orange.shade800;
    } else if (isValid) {
      barColor = const Color(0xFF007ACC);
    } else {
      barColor = Colors.grey.shade700;
    }

    final String statusLabel;
    if (_error != null) {
      statusLabel = 'Invalid JSON';
    } else if (hasWarnings) {
      statusLabel = '${_warnings.length} warning${_warnings.length > 1 ? 's' : ''}';
    } else if (isValid) {
      statusLabel = 'Valid contract';
    } else {
      statusLabel = 'Empty';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: barColor,
      child: Row(
        children: [
          Icon(
            _error != null
                ? Icons.error
                : (hasWarnings ? Icons.warning_amber : (isValid ? Icons.check_circle : Icons.circle_outlined)),
            size: 14,
            color: Colors.white70,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              statusLabel,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            'Lines: $lineCount  |  Chars: $charCount',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../core/models/screen_contract.dart';
import '../../core/parser/component_parser.dart';
import '../../presentation/widgets/server_button.dart';

/// Renders a [ScreenContract] through the same engine the real app uses,
/// wrapped in a device-frame style container. Shows placeholder states
/// when the contract is null or invalid.
class PreviewPanel extends StatefulWidget {
  final ScreenContract? contract;
  final String? error;

  const PreviewPanel({super.key, this.contract, this.error});

  @override
  State<PreviewPanel> createState() => _PreviewPanelState();
}

class _PreviewPanelState extends InputCollectorState<PreviewPanel> {
  final Map<String, String> _inputValues = {};

  @override
  Map<String, String> collectValues() => Map.unmodifiable(_inputValues);

  @override
  Widget build(BuildContext context) {
    if (widget.error != null) return _buildError(context, widget.error!);
    if (widget.contract == null) return _buildEmpty(context);
    return _buildPreview(context, widget.contract!);
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.phone_android, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Enter a JSON contract to see the preview',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              'Invalid Contract',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(color: Colors.red.shade500, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview(BuildContext context, ScreenContract contract) {
    final parser = ComponentParser(
      onInputChanged: (id, value) => _inputValues[id] = value,
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Theme.of(context).colorScheme.primary,
            child: Text(
              contract.screen.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: parser.parse(contract.screen.root, context),
            ),
          ),
        ],
      ),
    );
  }
}
